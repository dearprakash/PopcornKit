

import Foundation

/**
 Local representation of private `MPAudioDeviceController class` used to discover Audio-only AirPlay devices.
 
 - Important: Many of these variables/functions may be `nil` as the `MPAudioDeviceController class` is not documented and therefore, functions are not depricated like normal API's; Instead they are just removed.
 */
@objc public protocol MPAudioDeviceController {
    
    /// If the current device is searching for AirPlay devices. This must be enabled or AirPlay devices will not show up.
    @objc optional var routeDiscoveryEnabled: Bool { get }
    
    /**
     Setter method for `routeDiscoveryEnabled` variable.
     
     - Parameter enabled:   Pass `true` to start discovery process and `false` to stop.
     */
    @objc optional func setRouteDiscoveryEnabled(_ enabled: Bool)
    
    /**
     Fetch detailed information about a route based upon it's index in the available routes array.
     
     - Parameter index: The position of the route in the available routes array.
     
     - Returns: Dictionary with detailed, useful information about the specified route.
     */
    @objc optional func routeDescriptionAtIndex(_ index: Int) -> [String: Any]
    
}
