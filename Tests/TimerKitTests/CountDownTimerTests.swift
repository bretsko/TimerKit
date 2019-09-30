import XCTest
@testable import TimerKit



final class CountDownTimerTests: XCTestCase {
    
    
    func test1() {
        
        let exp = expectation(description: "")
                
        let timer = CountDownTimer(interval: 0.1, times: 10) { timer in
            //print(timer.leftTimes)
            if timer.leftTimes == 0 {
                exp.fulfill()
            }
        }
        timer.resume()
        self.waitForExpectations(timeout: 1.2, handler: nil)
    }
    

    //    static var allTests = [
    //         ("testExample", testExample),
    //     ]
}
