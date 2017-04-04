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
    let rowAndColumn = self.toRowAndColumn()
    let rowCenterDistance = rowAndColumn.row > 3 ? 7 - rowAndColumn.row : rowAndColumn.row
    let colCenterDistance = rowAndColumn.column > 3 ? 7 - rowAndColumn.column : rowAndColumn.column
    return rowCenterDistance * 3 + colCenterDistance * 3
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
        value += (piece.side() == .white ? squareValue : -squareValue) + pieceValue
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





