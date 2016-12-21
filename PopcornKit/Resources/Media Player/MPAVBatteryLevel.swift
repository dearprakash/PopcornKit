

import Foundation

/**
 Local representation of private `MPAVBatteryLevel class` used to track the battery life of AirPlay devices.
 
 - Important: Many of these variables may be `nil` as the `MPAVBatteryLevel class` is not documented and therefore, functions are not depricated like normal API's; Instead they are just removed.
 */
@objc public protocol MPAVBatteryLevel {

    /// Battery percentage for iPhone Case
    @objc optional var casePercentage: NSNumber { get }
    
    /// Battery percentage for ...
    @objc optional var leftPercentage: NSNumber { get }
    
    /// Battery percentage for ...
    @objc optional var rightPercentage: NSNumber { get }
    
    /// Battery percentage for ...
    @objc optional var singlePercentage: NSNumber { get }

}
