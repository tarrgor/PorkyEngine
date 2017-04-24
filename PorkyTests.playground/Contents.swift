//: Playground - noun: a place where people can play

import Foundation
import ChessToolkit
import PorkyEngine

extension CTPiece {
  static var allPieces: [CTPiece] = [
    .whitePawn, .whiteKnight, .whiteBishop, .whiteRook, .whiteQueen, .whiteKing,
    .blackPawn, .blackKnight, .blackBishop, .blackRook, .blackQueen, .blackKing
  ]
}

extension UInt64 {
  static func random() -> UInt64 {
    return (UInt64(arc4random()) << 32) | UInt64(arc4random())
  }
}

class HashUtils {
  
  static let shared = HashUtils()
  
  fileprivate let _squares = CTSquare.allSquares
  fileprivate let _pieces = CTPiece.allPieces
  
  fileprivate var _pieceHashKeys: [[UInt64]] = []
  fileprivate let _sideHashKeys: [UInt64] = [UInt64.random(), UInt64.random()]
  
  private init() {
    for _ in _squares {
      let pieces = getRandomNumbersForPieces()
      _pieceHashKeys.append(pieces)
    }
  }
  
  func hash(for piece: CTPiece, on square: CTSquare) -> UInt64? {
    guard let sqIdx = _squares.index(of: square) else { return nil }
    guard let pcIdx = _pieces.index(of: piece) else { return nil }
    return _pieceHashKeys[sqIdx][pcIdx]
  }
  
  func hash(for side: CTSide) -> UInt64 {
    return _sideHashKeys[side == .white ? 0 : 1]
  }
  
  private func getRandomNumbersForPieces() -> [UInt64] {
    var result: [UInt64] = []
    for _ in _pieces {
      result.append(UInt64.random())
    }
    return result
  }
  
}









