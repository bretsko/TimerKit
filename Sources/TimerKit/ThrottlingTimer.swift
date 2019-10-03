//
//
//import Foundation
//
//
//public final class ThrottlingTimer: AsyncTimer {
//    
//    private static var workItems = [String : DispatchWorkItem]()
//    
//    /// the handler will be called after interval you specified
//    /// calling again in the interval cancels the previous call
//    static func debounce(with interval: Double,
//                         identifier: String,
//                         _ queue: DispatchQueue = .main ,
//                         _ handler: @escaping () -> Void) {
//        
//        //if already exist
//        if let item = workItems[identifier] {
//            item.cancel()
//        }
//        
//        let item = DispatchWorkItem {
//            handler()
//            workItems.removeValue(forKey: identifier)
//        }
//        workItems[identifier] = item
//        queue.asyncAfter(deadline: .now() + interval.milliseconds, execute: item);
//    }
//    
//    /// the handler will be called after interval you specified
//    /// it is invalid to call again in the interval
//    static func throttle(with interval: Double,
//                         identifier: String,
//                         _ queue: DispatchQueue = .main ,
//                         _ handler: @escaping () -> Void ) {
//        
//        //if already exist
//        guard workItems[identifier] == nil else {
//            return
//        }
//        
//        let item = DispatchWorkItem {
//            handler()
//            workItems.removeValue(forKey: identifier)
//        }
//        workItems[identifier] = item
//        queue.asyncAfter(deadline: .now() + interval.milliseconds, execute: item)
//    }
//    
//    static func cancelThrottlingTimer(with identifier: String) {
//        if let item = workItems[identifier] {
//            item.cancel()
//            workItems.removeValue(forKey: identifier)
//        }
//    }
//}
//
