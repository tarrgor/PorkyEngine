//
//  Evaluation.swift
//  PorkyEngine
//
//  Created by Thorsten Klusemann on 26.03.17.
//
//

import Foundation
import ChessToolkit

protocol Evaluatable {
  func evaluate() -> Int
}

extension CTSquare: Evaluatable {
  
  func evaluate() -> Int {
    switch self {
      case .d4, .e4, .d5, .e5:
        return 8
      case .c3, .c4, .d3, .e3, .f3, .f4, .f5, .f6, .e6, .d6, .c6, .c5:
        return 4
      case .b2, .c2, .d2, .e2, .f2, .g2, .g3, .g4, .g5, .g6, .g7, .f7, .e7, .d7, .c7, .b7, .b6, .b5, .b4, .b3:
        return 2
      default:
        return 1
    }
  }
  
}

extension CTPiece: Evaluatable {
  
  func evaluate() -> Int {
    switch self {
    case .whitePawn:
      return 100
    case .whiteRook:
      return 500
    case .whiteQueen:
      return 900
    case .whiteBishop:
      return 330
    case .whiteKnight:
      return 300
    case .blackPawn:
      return -100
    case .blackRook:
      return -500
    case .blackQueen:
      return -900
    case .blackBishop:
      return -330
    case .blackKnight:
      return -300
    default:
      return 0
    }
  }
  
}

extension CTPosition: Evaluatable {
  
  public func evaluate() -> Int {
    var value = 0
    
    for square in CTSquare.allSquares {
      let piece = pieceAt(square)
      let pieceValue = piece.evaluate()
      if piece != .empty {
        let squareValue = square.evaluate()
        let valueToAdd = ((piece.side() == .white ? squareValue : -squareValue) + pieceValue)
//      print("\(square.toString()): \(squareValue), Adding \(valueToAdd)")
        value += valueToAdd
      }
    }

    return value
  }
  
}

/// Move evaluation is only for pre-sorting moves in the
/// move list at the beginning of each search iteration
extension CTMove: Evaluatable {
  
  /// The piece evaluation is used for the engine only and therefore only returns positive values
  func evaluate() -> Int {
    var result = 0
    let captureVal = abs(captured.evaluate())
    let pieceVal = 900 - abs(piece.evaluate())
    if captureVal > 0 { result = captureVal + pieceVal }
    return result
  }
  
}





