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
  public var maxDepth: Int = 5

  let position: CTPosition
  let evaluator: Evaluator
  let generator: MoveGenerator
  let config: SearchConfig
  
  var foundMove: CTMove?
  var cutoffs: Int = 0

  var pvTable: Hashtable
  
  public init(position: CTPosition, evaluator: Evaluator, pvTable: Hashtable, generator: MoveGenerator, config: SearchConfig = SearchConfig()) {
    self.position = position
    self.evaluator = evaluator
    self.pvTable = pvTable
    self.generator = generator
    self.config = config
  }

  @discardableResult
  public func search() -> CTMove? {
    // reset node count
    nodeCount = 0

    // reset start position for iterating pv table
    pvTable.currentLineStartHash = position.hashKey

    // search with time measurement
    let start = Date().timeIntervalSince1970
    alphaBeta(side: position.sideToMove, depth: maxDepth, alpha: -99999, beta: 99999)
    let end = Date().timeIntervalSince1970

    // output the result of the search
    print("Final Line: \(pvTable)")
    print("\(nodeCount) nodes visited.")
    print("Needed \(end - start), \(Double(nodeCount) / (end - start)) nodes/s, \(cutoffs) cutoffs.")
    return foundMove
  }

  @discardableResult
  func alphaBeta(side: CTSide, depth: Int, alpha: Int, beta: Int) -> Int {
    // best move in this node
    var bestMove: CTMove?
    var followUp: UInt64 = 0

    // increase node count
    nodeCount += 1

    // generate all possible moves and then pre-sort them for faster alpha/beta search
    let moves = generator.generateAllMovesForSide(side).sorted { move1, move2 in
      return move1.evaluate() >= move2.evaluate()
    }
    
    // if end of search depth reached, return current evaluation
    if depth == 0 || moves.count == 0 {
      if config.quiescenceEnabled {
        // Quiescence search
        return quiescence(side: side.opposite(), alpha: alpha, beta: beta)
      } else {
        return side == .white ? evaluator.evaluate(position: position) : -evaluator.evaluate(position: position)
      }
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
        pvTable.store(key: position.hashKey, move: bestMove, score: maxValue, followUp: followUp)
      }
    }

    return maxValue
  }

  func quiescence(side: CTSide, alpha: Int, beta: Int) -> Int {
    // increase node count
    nodeCount += 1

    var newAlpha = alpha
    let standPat = evaluator.evaluate(position: position)

    if standPat >= beta {
      return beta
    }
    if alpha < standPat {
      newAlpha = standPat
    }

    let moves = generator.generateCapturingMovesForSide(side)
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
