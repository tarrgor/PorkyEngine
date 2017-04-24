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
}

class PVTable {
  
  var _dictionary: [UInt64:PVEntry] = [:]
  
  func store(key: UInt64, move: CTMove, score: Int) {
    let entry = PVEntry(move: move, score: score)
    _dictionary[key] = entry
  }
  
  func probe(key: UInt64) -> (move: CTMove, score: Int)? {
    guard let entry = _dictionary[key] else { return nil }
    return (move: entry.move, score: entry.score)
  }
  
}
