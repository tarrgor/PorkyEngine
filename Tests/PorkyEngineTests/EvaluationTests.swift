import XCTest
@testable import PorkyEngine

class EvaluationTests: XCTestCase {
  
  func testEvaluate() {
    let position = CTPosition()
    
    let value = position.evaluate()
    print("Value: \(value)")
    XCTAssert(value == 0)
  }
  
  static var allTests : [(String, (EvaluationTests) -> () throws -> Void)] {
    return [
      ("testEvaluate", testEvaluate),
    ]
  }
  
}
