import XCTest
import ChessToolkit
@testable import PorkyEngine

class SimpleEvaluatorTests: XCTestCase {
  
  var sut: SimpleEvaluator!
  
  override func setUp() {
    sut = SimpleEvaluator()
  }
  
  func testEvaluateDefaultPosition_ShouldReturnZero() {
    let position = CTPosition()
    
    let value = sut.evaluate(position: position)
    XCTAssert(value == 0)
  }
  
  static var allTests : [(String, (SimpleEvaluatorTests) -> () throws -> Void)] {
    return [
      ("testEvaluateDefaultPosition_ShouldReturnZero", testEvaluateDefaultPosition_ShouldReturnZero),
    ]
  }
  
}
