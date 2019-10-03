
import Foundation


public protocol AsyncTimerObserverP: class {
    
    func didStartRunning()

    func didStopRunning()
    
    /// because of autoStop condition
    func didAutoStopRunning()
}

public extension AsyncTimerObserverP  {
    
    func didStartRunning() {}

    func didStopRunning() {}
    
    /// because of autoStop condition
    func didAutoStopRunning() {}
}
