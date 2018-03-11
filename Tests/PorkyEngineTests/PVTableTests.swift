//
//  PVTableTests.swift
//  PorkyEngineTests
//
//  Created by Thorsten Klusemann on 11.03.18.
//

import Foundation
import XCTest
import ChessToolkit
@testable import PorkyEngine

final class PVTableTests: XCTestCase {
  
  var sut: PVTable!
  
  override func setUp() {
    sut = PVTable()
  }
  
  func testStoreAMove_DescriptionIsCorrect() {
    let position = CTPosition()
    let move = CTMoveBuilder.build(position, from: .a2, to: .a4)
    
    sut.currentLineStartHash = position.hashKey
    sut.store(key: position.hashKey, move: move, score: 200, followUp: 0)
    
    XCTAssertEqual(sut.description, "a4 (200) ")
  }
  
  func testStoreAMove_ProbeGivesCorrectResult() {
    let position = CTPosition()
    let move = CTMoveBuilder.build(position, from: .a2, to: .a4)
    
    sut.currentLineStartHash = position.hashKey
    sut.store(key: position.hashKey, move: move, score: 200, followUp: 0)
    
    let result = sut.probe(key: position.hashKey)
    
    XCTAssertEqual(result!.move, move)
    XCTAssertEqual(result!.score, 200)
    XCTAssertEqual(result!.followUp, 0)
  }
  
}
