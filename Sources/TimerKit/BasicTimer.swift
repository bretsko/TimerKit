

import Foundation



open class BasicTimer: BasicTimerP {
    
    public internal(set) var state: TimerState = .suspended
    
    /// frequency of executing the handler
    public internal(set) var interval: Double
    
    fileprivate var _timer: DispatchSourceTimer
    
    /// time elapsed since timer was (re)started
    public var elapsedTime: Double = 0.0
    
    
    //MARK: autostop
    
    /// when set - suspends timer if this date is reached
    /// if the given date is in the past - timer will not start
    public var autoStopOnDate: Date?
    
    /// when set - suspends timer elapsed time reaches this value
    public var autoStopOnElapsedTime: Double?
    
    
    //MARK: init
    
    public typealias BasicTimerBlock = (BasicTimer) -> Void
    
    
    
    /// interval is a frequency of executing the handler,
    /// counted in seconds (rounded to milliseconds)
    /// if delayStart is not nil will delay start by given number of seconds
    public init(interval: Double,
                delayStart: Double? = nil,
                _ queue: DispatchQueue = .main ,
                _ handler: @escaping BasicTimerBlock) {
        
        self.interval = interval
        _timer = DispatchSource.makeTimerSource(queue: queue)
        
        setHandler(handler)
        setTimeInterval(interval, delayStart: delayStart)
    }
    
    //MARK: funcs
    
    // it is undefined to call resume() more times than suspend(), which would result in a negative suspension count.
    // see https://developer.apple.com/documentation/dispatch/dispatchobject/1452929-resume
    /// resumes timer if it's suspended
    /// returns true if succeeded
    @discardableResult
    public func resume() -> Bool {
        if state == .suspended  {
            _timer.resume()
            state = .running
            return true
        }
        return false
    }
    
    /// suspends timer if it's running
    /// returns true if succeeded
    @discardableResult
    public func suspend() -> Bool {
        if state == .suspended {
            _timer.suspend()
            state = .suspended
            return true
        }
        return false
    }
    
    /// suspends currently running timer and starts again
    /// if interval or handler not given - reuses the last used ones
    public func restart(interval: Double? = nil,
                        delayStart: Double? = nil,
                        _ handler: (BasicTimerBlock)? = nil) {
        // suspend if running
        suspend()
        elapsedTime = 0
        if let handler1 = handler {
            setHandler(handler1)
        }
        if let interval1 = interval {
            setTimeInterval(interval1, delayStart:delayStart)
        }
        resume()
    }
    
    /// cancels timer, cannot start again
    /// does not reset currentTime
    public func cancel() {
        ///It is a programmer error to release an object that is currently suspended, because suspension implies that there is still work to be done. Therefore, always balance calls to this method with a corresponding call to resume() before disposing of the object. The behavior when releasing the last reference to a dispatch object while it is in a suspended state is undefined.
        // source https://developer.apple.com/documentation/dispatch/dispatchobject/1452801-suspend
        
        if state == .suspended {
            _timer.resume()
        }
        //??
        //_timer.setEventHandler(handler: nil)
        _timer.cancel()
    }
    
    //MARK:
    
    /// set handler for this timer
    public func setHandler<T: BasicTimerP>(_ handler: @escaping (T) -> Void) {
        _timer.setEventHandler { [weak self] in
            
            guard let slf = self as? T else {
                return
            }
            slf.elapsedTime += slf.interval
            
            // autoStopOnDateSatisfied
            if let date = slf.autoStopOnDate,
                Date() >= date {
                slf.suspend()
                return
            }
            
            // autoStopOnElapsedTimeSatisfied
            if let elapsedTime = slf.autoStopOnElapsedTime,
                slf.elapsedTime >= elapsedTime {
                slf.suspend()
                return
            }
            
            handler(slf)
        }
    }
    
    /// interval is in seconds (rounded to milliseconds)
    /// if delayStart is not nil will delay start by given number of seconds
    public func setTimeInterval(_ interval: Double,
                                delayStart: Double? = nil) {
        self.interval = interval
        
        if let delay = delayStart {
            _timer.schedule(deadline: .now() + delay.milliseconds + interval.milliseconds, repeating: interval)
        } else {
            _timer.schedule(deadline: .now() + interval.milliseconds, repeating: interval)
        }
    }
    
    deinit {
        cancel()
    }
}



extension Double {
    
    var milliseconds: DispatchTimeInterval {
        return .milliseconds(Int(self * 1000))
    }
}
