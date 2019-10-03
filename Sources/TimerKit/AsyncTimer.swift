

import Foundation
import Log


/// The timer can be used to execute periodically provided block on any queue (main, private).
/// It can work allows scheduling resume, suspend and restart operations in future (at specific date, or after given elapsed time)
/// It also supports loop mode, in which it will restart after a given interval
/// It can be in 2 states - running and suspended
public class AsyncTimer: AsyncTimerP {
    
    public internal(set) var state: TimerState = .suspended
    
    /// Frequency of executing the handler
    /// Interval is in seconds (rounded to milliseconds)
    public internal(set) var interval: Double
    
    /// Delay interval for each resume operation
    /// Interval is in seconds (rounded to milliseconds)
    public internal(set) var startDelay: Double
    
    /// Time elapsed since timer was (re)started
    /// Interval is in seconds (rounded to milliseconds)
    public var elapsedTime: Double = 0.0
    
    public weak var observer: AsyncTimerObserverP?
    
    //MARK: autostop
    
    /// When set - suspends timer when elapsed time reaches this value (and this setting is the reset to nil)
    /// Time is in seconds (rounded to milliseconds)
    public internal(set) var autoStopOnElapsedTime: Double?
    
    /// When set timer works in loop mode, by restarting when the elapsedTime reaches the value of loopInterval
    /// Interval is in seconds (rounded to milliseconds)
    public internal(set) var loopInterval: Double?
    
    /// Sets timer to work in loop mode, by restarting when the elapsedTime reaches the value of loopInterval
    /// - parameter elapsedTime: time interval in seconds (rounded to milliseconds)
    /// - Important: autoStop settings have higher priority, so if loop interval is shorter autoStop will activate first
    public func setLoopInterval(_ interval: Double) {
        loopInterval = interval
    }
    
    /// When set - suspends timer when this date is reached (and this setting is the reset to nil)
    /// Interval is in seconds (rounded to milliseconds)
    public internal(set) var autoStopOnDate: Date?
    
    
    //MARK: private vars
    
    var _timer: DispatchSourceTimer
    
    /// used for internal restart logic
    fileprivate var shouldRestart = false
    
    
    //MARK: init
    
    /// Inits timer ready to resume with given interval, startDelay and handler
    /// - parameter interval: frequency of executing the handler, in seconds (rounded to milliseconds)
    /// - parameter startDelay: delay interval of start, in seconds (rounded to milliseconds)
    public init(interval: Double,
                startDelay: Double? = nil,
                _ queue: DispatchQueue = .main ,
                _ handler: @escaping AsyncTimerBlock) {
        
        self.interval = interval
        if let delay = startDelay,
            Self.isValid(interval: delay) {
            self.startDelay = delay
        } else {
            self.startDelay = 0
        }
        _timer = DispatchSource.makeTimerSource(queue: queue)
        
        setHandler(handler)
        setTimeInterval(interval, startDelay: startDelay)
    }
    
    
    //MARK: resume
    
    /// Resumes currently suspended timer with given paramaters
    /// - parameter interval: frequency of executing the handler, in seconds (rounded to milliseconds)
    /// - parameter startDelay: startDelay, in seconds (rounded to milliseconds)
    /// - Returns: true if succeeded
    @discardableResult
    public func resume(interval: Double? = nil,
                       after startDelay: Double? = nil,
                       _ handler: (AsyncTimerBlock)? = nil) -> Bool {
        guard state == .suspended  else {
            L.error("Failed to resume, already running")
            return false
        }
        if let handler1 = handler {
            setHandler(handler1)
        }
        if let interval1 = interval {
            setTimeInterval(interval1, startDelay:startDelay)
        }
        // it's undefined to call resume() more times than suspend(), which would result in a negative suspension count.
        // see https://developer.apple.com/documentation/dispatch/dispatchobject/1452929-resume
        _timer.resume()
        state = .running
        return true
    }
    
    
    /// Resumes timer, if it's suspended
    /// - parameter delayInterval: delayInterval, in seconds (rounded to milliseconds)
    /// - Returns: true if succeeded
    @discardableResult
    public func resume(after delayInterval: Double) -> Bool {
        guard state == .suspended  else {
            L.error("Failed to resume, already running")
            return false
        }
        setTimeInterval(interval, startDelay:delayInterval)
        // will resume after delay
        
        return resume()
    }
    
    
    /// Schedules resuming timer when this date is reached, if it's suspended
    /// - Returns: true if succeeded
    /// - Important: If the given date is in the past - timer will not start
    @discardableResult
    public func resume(on date: Date) -> Bool {
        guard isValid(futureDate: date) else {
            L.error("Failed to resume, invalid future date provided, \(date)")
            return false
        }
        let period = date.timeIntervalSince(Date())
        return resume(after: period)
    }
    
    
    /// Schedules resuming timer when elapsed time reaches this value, if it's suspended
    /// - parameter elapsedTime: elapsedTime, in seconds (rounded to milliseconds)
    /// - Returns: true if succeeded
    @discardableResult
    public func resume(on elapsedTime: Double) -> Bool {
        guard isValid(futureElapsedTime: elapsedTime) else {
            L.error("Failed to resume, invalid elapsedTime provided, \(elapsedTime)")
            return false
        }
        let period = elapsedTime - self.elapsedTime
        return resume(after: period)
    }
    
    
    //MARK: suspend
    
    /// Suspends timer if it's running
    /// - Returns: true if succeeded
    @discardableResult
    public func suspend() -> Bool {
        guard state == .running else {
            L.error("Failed to suspend, already suspended")
            return false
        }
        _timer.suspend()
        state = .suspended
        return true
    }
    
    
    /// Schedules suspending timer when this date is reached
    /// - parameter interval: frequency of executing the handler, in seconds (rounded to milliseconds)
    /// - Returns: true if succeeded
    ///  - Important: if the given date is in the past - timer will never start
    @discardableResult
    public func suspend(on date: Date) -> Bool {
        guard state == .running else {
            L.error("Failed to suspend, already suspended")
            return false
        }
        guard isValid(futureDate: date) else {
            L.error("Failed to suspend, invalid future date provided, \(date)")
            return false
        }
        autoStopOnDate = date
        return true
    }
    
    
    /// Suspends timer if it's running, after given interval
    /// - parameter delayInterval: delayInterval, in seconds (rounded to milliseconds)
    /// - Returns: true if succeeded
    /// - Important: this setting is reset on restart and the first time the condition is satisfied
    @discardableResult
    public func suspend(after delayInterval: Double) -> Bool {
        guard Self.isValid(interval: delayInterval) else {
            L.error("Failed to suspend, invalid delayInterval provided, \(delayInterval)")
            return false
        }
        return suspend(on: Date().advanced(by: delayInterval))
    }
    
    /// Schedules suspending timer when elapsed time reaches this value, if it's running
    /// - parameter elapsedTime: elapsed time interval in seconds (rounded to milliseconds)
    /// - Returns: true if succeeded
    @discardableResult
    public func suspend(on elapsedTime: Double) -> Bool {
        guard state == .running else {
            L.error("Failed to suspend, already suspended")
            return false
        }
        guard isValid(futureElapsedTime: elapsedTime) else {
            L.error("Failed to suspend, invalid elapsedTime provided, \(elapsedTime)")
                return false
        }
        autoStopOnElapsedTime = elapsedTime
        return true
    }
    
    
    //MARK: restart
    
    /// Suspends currently running timer and starts again
    /// If interval or handler not given - reuses the last used ones
    /// - parameter interval: frequency of executing the handler, in seconds (rounded to milliseconds)
    /// - parameter startDelay: startDelay, in seconds (rounded to milliseconds)
    /// - Returns: true if succeeded
    @discardableResult
    public func restart(interval: Double? = nil,
                        startDelay: Double? = nil,
                        _ handler: (AsyncTimerBlock)? = nil) -> Bool {
        if let interval = interval {
            if !Self.isValid(interval: interval) {
                L.error("Failed to restart, invalid interval provided, \(elapsedTime)")
                return false
            }
        }
        if let startDelay = startDelay {
            if !Self.isValid(interval: startDelay) {
                L.error("Failed to restart, invalid startDelay provided, \(startDelay)")
                return false
            }
        }
        // suspend if running
        suspend()
        elapsedTime = 0
        return resume(interval: interval, after: startDelay, handler)
    }
    
    
    /// Schedules restarting timer when this date is reached
    /// - Returns: true if succeeded
    /// - Important: if the given date is in the past - timer will never start
    public func restart(on date: Date) -> Bool {
        guard isValid(futureDate: date) else {
            L.error("Failed to restart, invalid futureDate provided, \(date)")
            return false
        }
        suspend(on: date)
        shouldRestart = true
        return true
    }
    
    /// Schedules restarting timer when elapsed time reaches this value
    /// - parameter elapsedTime: elapsedTime, in seconds (rounded to milliseconds)
    /// - Returns: true if succeeded
    public func restart(on elapsedTime: Double) -> Bool {
        guard isValid(futureElapsedTime: elapsedTime) else {
            L.error("Failed to restart, invalid elapsedTime provided, \(elapsedTime)")
            return false
        }
        suspend(on: elapsedTime)
        shouldRestart = true
        return true
    }
    
    /// Schedules restarting timer after given interval (in seconds)
    /// - parameter interval: delay interval, in seconds (rounded to milliseconds)
    /// - Returns: true if succeeded
    public func restart(after interval: Double) -> Bool {
        guard Self.isValid(interval: interval) else {
            L.error("Failed to restart, invalid interval provided, \(interval)")
            return false
        }
        return restart(on: Date().advanced(by: interval))
    }
    
    //MARK: loop
    
    /// Starts running timer in loop mode with given interval
    /// Timer must be in suspended state to run in loop mode
    /// - Returns: true if succeeded
    @discardableResult
    public func loop(interval: Double) -> Bool {
        guard state == .suspended  else {
            L.error("Failed to loop, timer must be suspended first")
            return false
        }
        guard Self.isValid(interval: interval) else {
            L.error("Failed to loop, invalid interval provided, \(interval)")
            return false
        }
        setLoopInterval(interval)
        return resume()
    }
    
    //MARK:
    
    /// Sets handler for this timer on main queue
    public func setHandler(_ handler: @escaping AsyncTimerBlock) {
        _setHandler(handler)
    }
    
    /// Sets handler for this timer on given queue
    public func setHandler(_ handler: @escaping AsyncTimerBlock,
                           _ queue: DispatchQueue) {
        _setHandler(handler, queue)
    }
    
    /// Sets handler for this timer, on main queue
    func _setHandler<T: AsyncTimer>(_ handler: @escaping (T) -> Void) {
        _timer.setEventHandler { [weak self] in
            
            guard let slf = self as? T else {
                return
            }
            slf.elapsedTime += slf.interval
            
            // autoStopOnDateSatisfied
            if let date = slf.autoStopOnDate,
                Date() >= date {
                
                // reset
                slf.shouldRestart = false
                slf.autoStopOnDate = nil
                
                slf.observer?.didAutoStopRunning()
                slf.suspend()
                return
            }
            
            // autoStopOnElapsedTimeSatisfied
            if let elapsedTime = slf.autoStopOnElapsedTime,
                slf.elapsedTime >= elapsedTime {
                
                // reset
                slf.shouldRestart = false
                slf.autoStopOnElapsedTime = nil
                
                slf.observer?.didAutoStopRunning()
                slf.suspend()
                return
            }
            
            // loop
            if let loopInterval1 = slf.loopInterval,
                slf.elapsedTime >= loopInterval1 {
                slf.restart()
                return
            }
            handler(slf)
        }
    }
    
    /// Sets handler for this timer on given queue
    func _setHandler<T: AsyncTimer>(_ handler: @escaping (T) -> Void,
                                    _ queue: DispatchQueue) {
        _timer = DispatchSource.makeTimerSource(queue: queue)
        // restoring interval and startDelay after resetting timer
        setTimeInterval(interval, startDelay: startDelay)
        _setHandler(handler)
    }
    
    /// If startDelay is not nil will delay start by given number of seconds.
    /// - parameter interval: frequency of executing the handler, in seconds (rounded to milliseconds)
    /// - parameter startDelay: startDelay, in seconds (rounded to milliseconds)
    /// - Returns: true if succeeded
    @discardableResult
    public func setTimeInterval(_ interval: Double,
                                startDelay: Double? = nil) -> Bool {
        guard Self.isValid(interval: interval) else {
            L.error("Failed to setTimeInterval, invalid interval provided, \(interval)")
            return false
        }
        if let startDelay = startDelay,
            !Self.isValid(interval: interval) {
            L.error("Failed to setTimeInterval, invalid startDelay provided, \(startDelay)")
            return false
        }
        
        let delay: DispatchTimeInterval
        
        if let startDelay = startDelay {
            self.startDelay = startDelay
            delay = (startDelay + interval).milliseconds
        } else {
            delay = interval.milliseconds
        }
        
        self.interval = interval
        _timer.schedule(deadline: .now() + delay, repeating: interval.milliseconds)
        return true
    }
    
    /// Sets startDelay interval, which will delay each resume operation by a given number of seconds
    /// - parameter delayInterval: time interval for delay of start in seconds (rounded to milliseconds)
    /// - Returns: true if succeeded
    @discardableResult
    public func delayStart(by delayInterval: Double) -> Bool {
        guard Self.isValid(interval: delayInterval) else {
            L.error("Failed to delayStart, invalid delayInterval provided, \(delayInterval)")
            return false
        }
        self.startDelay = delayInterval
        let d = (delayInterval + interval).milliseconds
        _timer.schedule(deadline: .now() + d,
                        repeating: interval.milliseconds)
        return true
    }
    
    /// Suspends timer if it's running, and resets settings (loop, autoStop, restart)
    public func resetSettings() {
        // suspend if running
        suspend()
        autoStopOnElapsedTime = nil
        autoStopOnDate = nil
        loopInterval = nil
        shouldRestart = false
    }
    
    //MARK: deinit
    
    deinit {
        cancel()
    }
    
    /// cancels timer, cannot start again
    /// does not reset currentTime
    fileprivate func cancel() {
        ///It is a programmer error to release an object that is currently suspended, because suspension implies that there is still work to be done. Therefore, always balance calls to this method with a corresponding call to resume() before disposing of the object. The behavior when releasing the last reference to a dispatch object while it is in a suspended state is undefined.
        // source https://developer.apple.com/documentation/dispatch/dispatchobject/1452801-suspend
        
        if state == .suspended {
            _timer.resume()
        }
        //??
        //_timer.setEventHandler(handler: nil)
        _timer.cancel()
    }
    
    //MARK: validation
    
    static func isValid(interval: Double) -> Bool {
        return interval > 0
    }
    
    func isValid(futureElapsedTime: Double) -> Bool {
        return elapsedTime > self.elapsedTime
    }
    func isValid(futureDate: Date) -> Bool {
        //TODO: also check that it's not too far away? - 1 month max?
        return futureDate > Date()
    }
}


extension Double {
    
    var milliseconds: DispatchTimeInterval {
        return .milliseconds(Int(self * 1000))
    }
}
