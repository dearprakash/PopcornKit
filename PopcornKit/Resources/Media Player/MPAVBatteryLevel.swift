

import Foundation

public protocol MPAVBatteryLevel {
    
    var casePercentage: NSNumber { get }
    var leftPercentage: NSNumber { get }
    var rightPercentage: NSNumber { get }
    var singlePercentage: NSNumber { get }
    
}
