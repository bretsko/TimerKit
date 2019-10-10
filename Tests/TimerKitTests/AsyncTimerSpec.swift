
//import XCTest
import Quick
@testable import TimerKit


class AsyncTimerSpec: QuickSpec {
    
    override func spec() {
        
        describe("AsyncTimer") {
            
            it("execs handler with given interval") {
                var count = 0
                let timer = AsyncTimer(interval: 0.2) { _ in
                    count += 1
                }
                timer.resume()
                
                expect(count).toEventually(equal(2), timeout: 0.5, pollInterval: 0.1)
            }
            
            //TODO: positive and negative, diff params
            // diff queues - main, backgroud
            it("when handler block is reset - execs the new handler") {
                
                var count = 0
                let timer = AsyncTimer(interval: 0.2) { _ in
                    count += 1
                }
                timer.setHandler{ _ in
                    count += 2
                }
                timer.resume()
                
                expect(count).toEventually(equal(4), timeout: 0.5, pollInterval: 0.1)
            }
            
            //TODO: positive and negative, diff params
            it("when interval is reset - execs with a new interval") {
                
                var count = 0
                let timer = AsyncTimer(interval: 0.4) { _ in
                    count += 1
                }
                timer.setTimeInterval(0.2, startDelay: nil)
                timer.resume()
                
                expect(count).toEventually(equal(2), timeout: 0.5, pollInterval: 0.1)
            }
            
            //TODO: positive and negative, diff params
            it("when startDelay is set - execs with a startDelay") {

                //TODO: set startDelay - check that it works

                var count = 0
                let timer = AsyncTimer(interval: 0.2, startDelay: 0.2) { _ in
                    count += 1
                }
                timer.resume()

                expect(count).toEventually(equal(2), timeout: 0.5, pollInterval: 0.1)
            }

//            //TODO: positive and negative, diff params
//            it("when interval and startDelay are reset - execs with given startDelay and interval") {
//
//                //TODO: reset interval and startDelay - check
//
//                var count = 0
//                let timer = AsyncTimer(interval: 0.2) { _ in
//                    count += 1
//                }
//                timer.resume()
//
//                expect(count).toEventually(equal(2), timeout: 2.1, pollInterval: 0.1)
//            }
//
//            //TODO: positive and negative, diff params
//            it("when loopInterval is set - execs with given loopInterval") {
//
//                //TODO: set loopInterval, expect to loop with interval
//                var count = 0
//                let timer = AsyncTimer(interval: 0.2) { _ in
//                    count += 1
//                }
//                timer.resume()
//
//                expect(count).toEventually(equal(2), timeout: 2.1, pollInterval: 0.1)
//            }
//
//            //TODO: positive and negative
//            it("resumes - at date, after delay, after delayTime") {
//
//                //TODO: resume, expect to resume
//                var count = 0
//                let timer = AsyncTimer(interval: 0.2) { _ in
//                    count += 1
//                }
//                timer.resume()
//
//                expect(count).toEventually(equal(2), timeout: 2.1, pollInterval: 0.1)
//            }
//
//            //TODO: positive and negative
//            it("suspends - at date, after delay, after delayTime") {
//
//                //TODO: suspend, expect to suspend
//                var count = 0
//                let timer = AsyncTimer(interval: 0.2) { _ in
//                    count += 1
//                }
//                timer.resume()
//
//                expect(count).toEventually(equal(2), timeout: 2.1, pollInterval: 0.1)
//            }
//
//            //TODO: positive and negative
//            it("restarts - at date, after delay, after delayTime") {
//
//                //TODO: restart, expect to restart
//                var count = 0
//                let timer = AsyncTimer(interval: 0.2) { _ in
//                    count += 1
//                }
//                timer.resume()
//
//                expect(count).toEventually(equal(2), timeout: 2.1, pollInterval: 0.1)
//            }
//
//            //TODO: positive and negative
//            it("autoStops - at date, on elapsedTime, after delay, after delayTime") {
//
//                //TODO: set autoStop, expect to autoStop
//                var count = 0
//                let timer = AsyncTimer(interval: 0.2) { _ in
//                    count += 1
//                }
//                timer.resume()
//
//                expect(count).toEventually(equal(2), timeout: 2.1, pollInterval: 0.1)
//            }
//
//            //TODO: positive and negative
//            it("resets settings") {
//                var count = 0
//                //TODO: setup some settings, then reset and check
//                let timer = AsyncTimer(interval: 0.2) { _ in
//                    count += 1
//                }
//                timer.resume()
//
//                expect(count).toEventually(equal(2), timeout: 2.1, pollInterval: 0.1)
//            }
//
//            //TODO: positive and negative
//            // test diff queues -
//            it("can exec on diff queues, main, backgroud, switch queues") {
//                var count = 0
//                let timer = AsyncTimer(interval: 0.2) { _ in
//                    count += 1
//                }
//                timer.resume()
//
//                expect(count).toEventually(equal(2), timeout: 2.1, pollInterval: 0.1)
//            }
            
            //TODO: positive and negative, diff params
            //describe("Observer receives all callbacks") {}
            
            //TODO: positive and negative, diff params
            //            it("inits") {
            //                let timer = AsyncTimer(interval: 0.2, {
            //
            //                }
            //            }
        }
    }
}
