//
//  SearcherTests.swift
//  PorkyEngineTests
//
//  Created by Thorsten Klusemann on 20.03.18.
//

import Foundation
import XCTest
import ChessToolkit
@testable import PorkyEngine

final class SearcherTests: XCTestCase {
  
  func testQuiescence_OnlyKings_AlphaStaysTheSame() {
    let position = CTPosition.init(fen: "8/4k3/8/8/8/8/3K4/8 w - - 0 1")
    let searcher = Searcher.init(position: position, evaluator: SimpleEvaluator.init(), pvTable: DefaultPVTable.init())
    
    let result = searcher.quiescence(side: .white, alpha: 0, beta: 0)
    
    XCTAssertTrue(result == 0)
  }
  
  func testQuiescence_OnlyKings_AlphaStaysTheSame2() {
    let position = CTPosition.init(fen: "8/4k3/8/8/8/8/3K4/8 w - - 0 1")
    let searcher = Searcher.init(position: position, evaluator: SimpleEvaluator.init(), pvTable: DefaultPVTable.init())
    
    let result = searcher.quiescence(side: .white, alpha: 100, beta: -100)
    
    XCTAssertTrue(result == -100)
  }
  
}
