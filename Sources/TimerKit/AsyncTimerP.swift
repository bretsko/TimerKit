
import Foundation

public enum TimerState {
    case running
    case suspended
}

public protocol AsyncTimerP: class {
    typealias AsyncTimerBlock = (AsyncTimer) -> Void
    
//    var state: TimerState {get}
//
//    /// time elapsed since timer was (re)started
//    /// can be manually adjusted
//    var elapsedTime: Double {get set}
//
//    /// frequency of executing the handler
//    var interval: Double {get}
//
//
//    /// when set - works in loop mode, by starting again timer when elapsed time reaches loopInterval
//    var loopInterval: Double? {get}
//
//    /// sets timer to work in loop mode, by restarting when the elapsedTime reaches this value
//    func setLoopInterval(_ interval: Double)
//
//
//
//    /// when set - suspends timer when elapsed time reaches this value
//    /// this setting is reset the first time the condition is satisfied
//    var autoStopOnElapsedTime: Double? {get}
//
//    /// when set - suspends timer if this date is reached
//    /// this setting is reset the first time the condition is satisfied
//    var autoStopOnDate: Date? {get}
//
//
//    /// resumes timer if it's suspended
//    /// returns true if succeeded
//    @discardableResult
//    func resume(after interval: Double?) -> Bool
//
//    /// suspends timer if it's running, after given interval (if any)
//    /// returns true if succeeded
//    @discardableResult
//    func suspend(after interval: Double?) -> Bool
//
//    func restart(interval: Double?,
//                 startDelay: Double?,
//                 _ handler: (AsyncTimerBlock)?)
//
//    /// suspends timer (if running) and resets settings (loop, autoStop)
//    func resetSettings()
//
//    /// sets frequency with which timer will execute the provided handler
//    /// interval is in seconds (rounded to milliseconds)
//    /// if startDelay is not nil will delay start by given number of seconds
//    func setTimeInterval(_ interval: Double, startDelay: Double?)
//
//    /// delayInterval is in seconds (rounded to milliseconds)
//    /// sets startDelay interval, which delays each resume operation by given number of seconds
//    func delayStart(by delayInterval: Double)
//
//    /// delegate
//    var observer: AsyncTimerObserverP? {get set}
}




