//
//  PVTable.swift
//  PorkyEngine
//
//  Created by Thorsten Klusemann on 11.04.17.
//
//

import Foundation
import ChessToolkit

public protocol Hashtable: CustomStringConvertible {
  var currentLineStartHash: UInt64? { get set }

  func store(key: UInt64, move: CTMove, score: Int, followUp: UInt64)
  func probe(key: UInt64) -> (move: CTMove, score: Int, followUp: UInt64?)?
}

struct PVEntry {
  let move: CTMove
  let score: Int
  let followUp: UInt64?
}

public class DefaultPVTable: Hashtable {

  public var currentLineStartHash: UInt64?

  var _dictionary: [UInt64:PVEntry] = [:]

  public init() { }

  public func store(key: UInt64, move: CTMove, score: Int, followUp: UInt64) {
    let entry = PVEntry(move: move, score: score, followUp: followUp)
    _dictionary[key] = entry
  }
  
  public func probe(key: UInt64) -> (move: CTMove, score: Int, followUp: UInt64?)? {
    guard let entry = _dictionary[key] else { return nil }
    return (move: entry.move, score: entry.score, followUp: entry.followUp)
  }
  
}

extension DefaultPVTable: CustomStringConvertible {
  public var description: String {
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
