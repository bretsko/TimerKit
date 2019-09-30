

import Foundation


open class CountDownTimer: BasicTimer {

    /// number of times set to fire initially
    public internal(set) var totalTimes: Int
    
    /// number of times left to fire
    public internal(set) var leftTimes: Int
    
    
    //MARK: init
    
    public typealias CountDownTimerBlock = (CountDownTimer) -> Void
    
    /// interval is a frequency of executing the handler,
    /// counted in seconds (rounded to milliseconds)
    public init(interval: Double,
                delayStart: Double? = nil,
                times: Int,
                _ queue: DispatchQueue = .main,
                _ handler: @escaping CountDownTimerBlock) {
        
        self.totalTimes = times
        self.leftTimes = times
        super.init(interval: interval,
                   delayStart: delayStart, queue, { _ in })
        
        setHandler { (timer: CountDownTimer) in
            if timer.leftTimes > 0 {
                timer.leftTimes -= 1
                handler(timer)
            } else {
                timer.suspend()
            }
        }
    }
    
    /// suspends currently running timer and starts again
    /// if interval or handler not given - reuses the last used ones
    public func restart(with times: Int? = nil,
                         interval: Double? = nil,
                         delayStart: Double? = nil,
                        _ handler: (CountDownTimerBlock)? = nil) {
        // suspend if running
        suspend()
        if let handler1 = handler {
            setHandler(handler1)
        }
        if let interval1 = interval {
            setTimeInterval(interval1, delayStart:delayStart)
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
