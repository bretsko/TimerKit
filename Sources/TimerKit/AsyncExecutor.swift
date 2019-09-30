//
//
//import Foundation
//
//
////TODO:
//public class AsyncExecutor {
//    
//    //MARK: private
//    
//    private let _timer: DispatchSourceTimer
//    
//    //MARK: init
//    
//    /// interval - delay before executing the handler
//    /// interval is in seconds (rounded to milliseconds)
//    public init(_ interval: Double,
//                _ queue: DispatchQueue = .main ,
//                _ handler: @escaping (AsyncExeccutor) -> Void) {
//        
//        _timer = DispatchSource.makeTimerSource(queue: queue)
//        _timer.setEventHandler { [weak self] in
//            if let strongSelf = self {
//                handler(strongSelf)
//            }
//        }
//        
//        _timer.schedule(deadline: .now() + interval.milliseconds)
//    }
//    
//    //MARK: funcs
//    
//    // it is undefined to call resume() more times than suspend(), which would result in a negative suspension count.
//    // see https://developer.apple.com/documentation/dispatch/dispatchobject/1452929-resume
//    /// executes the handler once
//    /// returns true if succeeded
//    @discardableResult
//    public func fire() -> Bool {
//        //if state == .suspended  {
//        _timer.resume()
//        //  state = .running
//        return true
//        //}
//        // return false
//    }
//    
//    //    /// suspends timer if it's running
//    //    /// returns true if succeeded
//    //    @discardableResult
//    //    public func suspend() -> Bool {
//    //        if state == .suspended {
//    //            _timer.suspend()
//    //            state = .suspended
//    //            return true
//    //        }
//    //        return false
//    //    }
//    //
//    //
//    //    /// cancels timer, cannot start again
//    //    public func cancel() {
//    //        ///It is a programmer error to release an object that is currently suspended, because suspension implies that there is still work to be done. Therefore, always balance calls to this method with a corresponding call to resume() before disposing of the object. The behavior when releasing the last reference to a dispatch object while it is in a suspended state is undefined.
//    //        // source https://developer.apple.com/documentation/dispatch/dispatchobject/1452801-suspend
//    //
//    //        if state == .suspended {
//    //            _timer.resume()
//    //        }
//    //        _timer.setEventHandler(handler: nil)
//    //        _timer.cancel()
//    //    }
//    //
//    //    //MARK:
//    
//    public func setHandler(_ handler: @escaping (AsyncExeccutor) -> Void) {
//        _timer.setEventHandler { [weak self] in
//            if let strongSelf = self {
//                handler(strongSelf)
//            }
//        }
//    }
//    
//    deinit {
//        _timer.cancel()
//    }
//}
//
//
