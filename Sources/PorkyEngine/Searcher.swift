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
    let value = maximize(depth: maxDepth, alpha: Int.min, beta: Int.max)
    print("Final Move: \(foundMove != nil ? foundMove!.toNotation(.long) : "None"), Value: \(value)")
    return value
  }
  
  private func maximize(depth: Int, alpha: Int, beta: Int) -> Int {
    let moves = position.moveGenerator.generateAllMovesForSide(position.sideToMove)
    if (depth == 0 || moves.count == 0) {
      return position.evaluate()
    }
    
    // pre-sort moves for faster alpha/beta search
    let sortedMoves = moves.sorted { (move1, move2) -> Bool in
      return move1.evaluate() >= move2.evaluate()
    }
    
    var maxValue = alpha
    for move in sortedMoves {
      guard position.makeMove(from: move.from, to: move.to) else { fatalError() }
      let value = minimize(depth: depth - 1, alpha: maxValue, beta: beta)
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
  
  private func minimize(depth: Int, alpha: Int, beta: Int) -> Int {
    let moves = position.moveGenerator.generateAllMovesForSide(position.sideToMove)
    if (depth == 0 || moves.count == 0) {
      return position.evaluate()
    }

    // pre-sort moves for faster alpha/beta search
    let sortedMoves = moves.sorted { (move1, move2) -> Bool in
      return move1.evaluate() >= move2.evaluate()
    }

    var minValue = beta
    for move in sortedMoves {
      guard position.makeMove(from: move.from, to: move.to) else { fatalError() }
      let value = maximize(depth: depth - 1, alpha: alpha, beta: minValue)
      guard position.takeBackMove() else { fatalError() }
      if value < minValue {
        minValue = value
        if minValue <= alpha {
          break
        }
      }
    }
    return minValue
  }
}
