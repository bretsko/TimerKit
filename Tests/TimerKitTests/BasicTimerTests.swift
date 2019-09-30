import XCTest
@testable import TimerKit



final class BasicTimerTests: XCTestCase {
    
    func test1() {
        
        let exp = expectation(description: "")
        
        var count = 0
        let timer = BasicTimer(interval: 1.0) { _ in
            count += 1
            if count == 2 {
                exp.fulfill()
            }
        }
        timer.resume()
        self.waitForExpectations(timeout: 2.1, handler: nil)
    }

    
    //    func testAsyncExeccutor() {
    //        
    //        let exp = expectation(description: "")
    //        
    //        let timer = AsyncExeccutor(1.0) { _ in
    //            print("timer fire")
    //            expectation.fulfill()
    //        }
    //        timer.fire()
    //        self.waitForExpectations(timeout: 1.1, handler: nil)
    //    }
    
    //    static var allTests = [
    //         ("testExample", testExample),
    //     ]
}
