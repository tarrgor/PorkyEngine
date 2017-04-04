//
//  Searcher.swift
//  PorkyEngine
//
//  Created by Thorsten Klusemann on 03.04.17.
//
//

import Foundation
import ChessToolkit

public final class Searcher {
  
  let position: CTPosition
  let maxDepth: Int = 3
  var foundMove: CTMove?
  
  public init(position: CTPosition) {
    self.position = position
  }
  
  public func search() -> Int {
    let value = alphaBeta(side: position.sideToMove, depth: maxDepth, alpha: -99999, beta: 99999)
    print("Final Move: \(foundMove != nil ? foundMove!.toNotation(.long) : "None"), Value: \(value)")
    return value
  }
  
  private func alphaBeta(side: CTSide, depth: Int, alpha: Int, beta: Int) -> Int {
    // generate all possible moves and then pre-sort them for faster alpha/beta search
    let moves = position.moveGenerator.generateAllMovesForSide(side).sorted { move1, move2 in
      return move1.evaluate() >= move2.evaluate()
    }
    
    // if end of search depth reached, return current evaluation
    if (depth == 0 || moves.count == 0) {
      return side == .white ? position.evaluate() : -position.evaluate()
    }
  
    // search best move
    var maxValue = alpha
    for move in moves {
      guard position.makeMove(from: move.from, to: move.to) else { fatalError() }
      let value = -alphaBeta(side: side.opposite(), depth: depth - 1, alpha: -beta, beta: -maxValue)
      guard position.takeBackMove() else { fatalError() }
      if value > maxValue {
        maxValue = value
        if maxValue >= beta {
          break
        }
        if depth == maxDepth {
          foundMove = move
        }
      }
    }
    return maxValue
  }
}

extension CTSide {
  func opposite() -> CTSide {
    return self == .white ? .black : .white
  }
}
