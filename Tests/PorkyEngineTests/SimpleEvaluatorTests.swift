import XCTest
import ChessToolkit
@testable import PorkyEngine

class SimpleEvaluatorTests: XCTestCase {
  
  var sut: SimpleEvaluator!
  
  override func setUp() {
    sut = SimpleEvaluator()
  }
  
  func testEvaluateDefaultPosition_ShouldReturn0() {
    let position = CTPosition()
    
    let value = sut.evaluate(position: position)
    XCTAssertTrue(value == 0)
  }
  
  func testEvaluatePositionAfter_1e4_ShouldReturn6() {
    let position = CTPosition()
    position.makeMove(from: .e2, to: .e4)
    
    let value = sut.evaluate(position: position)
    XCTAssertTrue(value == 6)
  }
  
  func testEvaluatePositionAfter_1e4e5_ShouldReturn0() {
    let position = CTPosition()
    position.makeMove(from: .e2, to: .e4)
    position.makeMove(from: .e7, to: .e5)

    let value = sut.evaluate(position: position)
    XCTAssertTrue(value == 0)
  }
  
  func testEvaluatePositionAfter_1e4e5_2Nf3_ShouldReturn3() {
    let position = CTPosition()
    position.makeMove(from: .e2, to: .e4)
    position.makeMove(from: .e7, to: .e5)
    position.makeMove(from: .g1, to: .f3)
    
    let value = sut.evaluate(position: position)
    XCTAssertTrue(value == 3)
  }
  
  func testEvaluatePositionAfter_1e4d5_2ed5_ShouldReturn108() {
    let position = CTPosition()
    position.makeMove(from: .e2, to: .e4)
    position.makeMove(from: .d7, to: .d5)
    position.makeMove(from: .e4, to: .d5)
    
    let value = sut.evaluate(position: position)
    XCTAssertTrue(value == 108)
  }

  func testEvaluatePositionAfter_1e4d5_2Nf3de4_ShouldReturnMinus105() {
    let position = CTPosition()
    position.makeMove(from: .e2, to: .e4)
    position.makeMove(from: .d7, to: .d5)
    position.makeMove(from: .g1, to: .f3)
    position.makeMove(from: .d5, to: .e4)
    
    let value = sut.evaluate(position: position)
    XCTAssertTrue(value == -105)
  }

  static var allTests : [(String, (SimpleEvaluatorTests) -> () throws -> Void)] {
    return [
      ("testEvaluateDefaultPosition_ShouldReturn0", testEvaluateDefaultPosition_ShouldReturn0),
      ("testEvaluatePositionAfter_1e4_ShouldReturn6", testEvaluatePositionAfter_1e4_ShouldReturn6),
      ("testEvaluatePositionAfter_1e4e5_ShouldReturn0", testEvaluatePositionAfter_1e4e5_ShouldReturn0),
      ("testEvaluatePositionAfter_1e4e5_2Nf3_ShouldReturn3", testEvaluatePositionAfter_1e4e5_2Nf3_ShouldReturn3),
      ("testEvaluatePositionAfter_1e4d5_2ed5_ShouldReturn108", testEvaluatePositionAfter_1e4d5_2ed5_ShouldReturn108),
      ("testEvaluatePositionAfter_1e4d5_2Nf3de4_ShouldReturnMinus105", testEvaluatePositionAfter_1e4d5_2Nf3de4_ShouldReturnMinus105)
    ]
  }
  
}
