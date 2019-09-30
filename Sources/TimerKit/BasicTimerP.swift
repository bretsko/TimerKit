
import Foundation

public enum TimerState {
    case running
    case suspended
}

public protocol BasicTimerP: class {
    
    var state: TimerState {get}
    
    /// time elapsed since timer was (re)started
    var elapsedTime: Double {get set}
    
    /// frequency of executing the handler
    var interval: Double {get}
    
    
    /// when set - suspends timer if this date is reached
    /// if the given date is in the past - timer will not start
    var autoStopOnDate: Date? {get set}
    
    /// when set - suspends timer elapsed time reaches this value
    var autoStopOnElapsedTime: Double? {get set}
    
    
    /// resumes timer if it's suspended
    /// returns true if succeeded
    @discardableResult
    func resume() -> Bool
    
    /// suspends timer if it's running
    /// returns true if succeeded
    @discardableResult
    func suspend() -> Bool
    
    /// cancels timer, cannot start again
    /// does not reset elapsedTime
    func cancel()
    
    /// interval is in seconds (rounded to milliseconds)
    /// if delayStart is not nil will delay start by given number of seconds
    func setTimeInterval(_ interval: Double, delayStart: Double?)
}

