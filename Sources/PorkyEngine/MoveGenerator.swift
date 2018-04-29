//
//  MoveGenerator.swift
//  PorkyEngine
//
//  Created by Thorsten Klusemann on 29.04.18.
//

import Foundation
import ChessToolkit

public protocol MoveGenerator {
  
  func generateAllMovesForSide(_ side: CTSide) -> [CTMove]
  func generateCapturingMovesForSide(_ side: CTSide) -> [CTMove]
  
}

public class DefaultMoveGenerator: MoveGenerator {
  
  let position: CTPosition
  
  public init(position: CTPosition) {
    self.position = position
  }
  
  public func generateAllMovesForSide(_ side: CTSide) -> [CTMove] {
    return position.moveGenerator.generateAllMovesForSide(side)
  }
  
  public func generateCapturingMovesForSide(_ side: CTSide) -> [CTMove] {
    return position.moveGenerator.generateCapturingMovesForSide(side)
  }
  
}
