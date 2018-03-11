//
//  PVTable.swift
//  PorkyEngine
//
//  Created by Thorsten Klusemann on 11.04.17.
//
//

import Foundation
import ChessToolkit

struct PVEntry {
  let move: CTMove
  let score: Int
  let followUp: UInt64?
}

class PVTable {

  static let shared = PVTable()

  var currentLineStartHash: UInt64?

  var _dictionary: [UInt64:PVEntry] = [:]

  internal init() {

  }

  func store(key: UInt64, move: CTMove, score: Int, followUp: UInt64) {
    let entry = PVEntry(move: move, score: score, followUp: followUp)
    _dictionary[key] = entry
  }
  
  func probe(key: UInt64) -> (move: CTMove, score: Int, followUp: UInt64?)? {
    guard let entry = _dictionary[key] else { return nil }
    return (move: entry.move, score: entry.score, followUp: entry.followUp)
  }
  
}

extension PVTable: CustomStringConvertible {
  var description: String {
    guard let startHash = currentLineStartHash else { return "--" }

    var result = ""
    var hash: UInt64? = startHash

    while hash != nil {
      if let h = hash, let entry = _dictionary[h] {
        result += "\(entry.move.toNotation(.short)) (\(entry.score)) "
        hash = entry.followUp
      } else {
        hash = nil
      }
    }

    return result
  }
}
