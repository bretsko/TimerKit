

import Foundation


public class CountDownTimer: AsyncTimer {

    /// number of times set to fire initially
    public internal(set) var totalTimes: Int
    
    /// number of times left to fire
    public internal(set) var leftTimes: Int
    
    
    //MARK: init
    
    public typealias CountDownTimerBlock = (CountDownTimer) -> Void
    
    /// interval is a frequency of executing the handler,
    /// counted in seconds (rounded to milliseconds)
    public init(interval: Double,
                startDelay: Double? = nil,
                times: Int,
                _ queue: DispatchQueue = .main,
                _ handler: @escaping CountDownTimerBlock) {
        
        self.totalTimes = times
        self.leftTimes = times
        super.init(interval: interval,
                   startDelay: startDelay, queue, { _ in })
        
        setHandler{_ in }
    }
    
   
    
    public override func setHandler(_ handler: @escaping CountDownTimerBlock) {
        _setHandler(handler)
    }
    
    public override func setHandler(_ handler: @escaping CountDownTimerBlock,
                           _ queue: DispatchQueue) {
        
        _setHandler(handler, queue)
    }
    
    
    /// set handler for this timer
    override func _setHandler<T: CountDownTimer>(_ handler: @escaping (T) -> Void) {
        
//        _timer.setHandler { [weak self] _ in
//            guard let slf = self as? T else {
//                return
//            }
//            if slf.leftTimes > 0 {
//                slf.leftTimes -= 1
//                handler(slf)
//            } else {
//                slf.suspend()
//            }
//        }
    }
    
    override func _setHandler<T: CountDownTimer>(_ handler: @escaping (T) -> Void, _ queue: DispatchQueue) {
        
//        _timer = DispatchSource.makeTimerSource(queue: queue)
//        // restoring interval and startDelay
//        setTimeInterval(interval, startDelay: startDelay)
//        setHandler(handler)
    }
    
    
    /// set handler for this timer
//    open override func setHandler<T: CountDownTimer>(_ queue: DispatchQueue,
//                                                     _ handler: @escaping (T) -> Void) {
//        
//        super.setHandler { [weak self] _ in
//            guard let slf = self as? T else {
//                return
//            }
//            if slf.leftTimes > 0 {
//                slf.leftTimes -= 1
//                handler(slf)
//            } else {
//                slf.suspend()
//            }
//        }
//    }
    
    /// suspends currently running timer and starts again
    /// if interval or handler not given - reuses the last used ones
    public func restart(with times: Int? = nil,
                         interval: Double? = nil,
                         startDelay: Double? = nil,
                        _ handler: (CountDownTimerBlock)? = nil) {
        // suspend if running
        suspend()
        if let handler1 = handler {
            setHandler(handler1)
        }
        if let interval1 = interval {
            setTimeInterval(interval1, startDelay:startDelay)
        }
        if let times1 = times {
            self.totalTimes = times1
        }
        self.leftTimes = totalTimes
        resume()
    }
    
    /// number of times elapsed since start = num times handler executed
    public var elapsedTimes: Int {
        return totalTimes - leftTimes
    }
}
