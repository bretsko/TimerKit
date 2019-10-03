//import XCTest
//@testable import TimerKit
//
//
//
//final class ThrottlingTimerTests: XCTestCase {
//    
//    func testDebounce() {
//        
//        let exp = expectation(description: "")
//        
//        var count = 0
//        let timer = ThrottlingTimer(interval: 1.0) { _ in
//            
//            ThrottlingTimer.debounce(with: 1.5, identifier: "not pass") { [weak exp] in
//                //even testDebounce success. the internal timer won't stop.
//                //it will cause another test method fail
//                //I think XCTest framework should not call fail if XCFail is not in other test method
//                if exp != nil {
//                    XCTFail("should not pass")
//                }
//            }
//            
//            ThrottlingTimer.debounce(with: 0.5, identifier:  "pass") {
//                count += 1
//                if count == 4 {
//                    exp.fulfill()
//                }
//            }
//        }
//        timer.resume()
//        self.waitForExpectations(timeout: 5, handler: nil)
//    }
//    
//    func testThrottle() {
//        
//        let exp = expectation(description: "")
//        
//        var count = 0
//        var temp = 0
//        let timer = ThrottlingTimer(interval: 0.1) { _ in
//            ThrottlingTimer.throttle(with: 1.0,
//                                     identifier: "throttle") {
//                                        count += 1
//                                        if count > 3 {
//                                            XCTFail("should not pass")
//                                        }
//                                        print(count)
//            }
//            temp += 1
//            //print("temp: \(temp)")
//            if temp == 30 {
//                exp.fulfill()
//            }
//        }
//        timer.resume()
//        self.waitForExpectations(timeout: 3.2, handler: nil)
//    }
//    
//    func testRescheduleRepeating() {
//        
//        let exp = expectation(description: "")
//        
//        var count = 0
//        let timer = ThrottlingTimer(interval: 1.0) { timer in
//            count += 1
//            //print(Date())
//            if count == 3 {
//                timer.setTimeInterval(3.0)
//            }
//            if count == 4 {
//                exp.fulfill()
//            }
//        }
//        timer.resume()
//        self.waitForExpectations(timeout: 6.1, handler: nil)
//    }
//
//    
//    //    static var allTests = [
//    //         ("testExample", testExample),
//    //     ]
//}
