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

  public var nodeCount: Int = 0

  let position: CTPosition
  let maxDepth: Int = 3
  var foundMove: CTMove?
  var cutoffs: Int = 0

  public init(position: CTPosition) {
    self.position = position
  }

  @discardableResult
  public func search() -> CTMove? {
    // reset node count
    nodeCount = 0

    // reset start position for iterating pv table
    PVTable.shared.currentLineStartHash = position.hashKey

    // search with time measurement
    let start = Date().timeIntervalSince1970
    alphaBeta(side: position.sideToMove, depth: maxDepth, alpha: -99999, beta: 99999)
    let end = Date().timeIntervalSince1970

    // output the result of the search
    print("Final Line: \(PVTable.shared)")
    print("\(nodeCount) nodes visited.")
    print("Needed \(end - start), \(Double(nodeCount) / (end - start)) nodes/s, \(cutoffs) cutoffs.")
    return foundMove
  }

  @discardableResult
  private func alphaBeta(side: CTSide, depth: Int, alpha: Int, beta: Int) -> Int {
    // best move in this node
    var bestMove: CTMove?
    var followUp: UInt64 = 0

    // increase node count
    nodeCount += 1

    // generate all possible moves and then pre-sort them for faster alpha/beta search
    let moves = position.moveGenerator.generateAllMovesForSide(side).sorted { move1, move2 in
      return move1.evaluate() >= move2.evaluate()
    }
    
    // if end of search depth reached, return current evaluation
    if (depth == 0 || moves.count == 0) {
      // Quiescence search
      return quiescence(side: side.opposite(), alpha: alpha, beta: beta)
    }
  
    // search best move
    var maxValue = alpha
    for move in moves {
      guard position.makeMove(from: move.from, to: move.to) else { fatalError() }
      let tempFollowUp = position.hashKey
      let value = -alphaBeta(side: side.opposite(), depth: depth - 1, alpha: -beta, beta: -maxValue)
      guard position.takeBackMove() else { fatalError() }
      if value > maxValue {
        maxValue = value
        bestMove = move
        followUp = tempFollowUp
        if maxValue >= beta {
          cutoffs += 1
          break
        }
        if depth == maxDepth {
          foundMove = move
        }
      }
    }

    // if alpha has changed, store PV move
    if alpha != maxValue {
      if let bestMove = bestMove {
        PVTable.shared.store(key: position.hashKey, move: bestMove, score: maxValue, followUp: followUp)
      }
    }

    return maxValue
  }

  private func quiescence(side: CTSide, alpha: Int, beta: Int) -> Int {
    // increase node count
    nodeCount += 1

    var newAlpha = alpha
    let standPat = position.evaluate()

    if standPat >= beta {
      return beta
    }
    if alpha < standPat {
      newAlpha = standPat
    }

    let moves = position.moveGenerator.generateCapturingMovesForSide(side)
    for move in moves {
      guard position.makeMove(from: move.from, to: move.to) else { continue }
      let value = -quiescence(side: side.opposite(), alpha: -beta, beta: -newAlpha)
      guard position.takeBackMove() else { fatalError() }

      if value > newAlpha {
        if value >= beta {
          return beta
        }
        newAlpha = value
      }
    }
    return newAlpha
  }
}

extension CTSide {
  func opposite() -> CTSide {
    return self == .white ? .black : .white
  }
}
