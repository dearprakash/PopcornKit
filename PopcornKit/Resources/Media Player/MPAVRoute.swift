

import Foundation

/**
 Local representation of private `MPAVRoute class` used to describe AirPlay devices.
 
 - Important: Many of these variables/functions may be `nil` as the `MPAVRoute class` is not documented and therefore, functions are not depricated like normal API's; Instead they are just removed.
 */
@objc public protocol MPAVRoute {
    
    /// If the route is a pair of `Apple AirPods`.
    @objc optional var isAirpodsRoute: Bool { get }
    
    /// If the route is a pair of `Beats Solo` headphones.
    @objc optional var isBeatsSoloRoute: Bool { get }
    
    /// If the route is a pair of `Beats X` earphones.
    @objc optional var isBeatsXRoute: Bool { get }
    
    /// If the route is a pair of `Beats Powerbeats` earphones.
    @objc optional var isPowerbeatsRoute: Bool { get }
    
    /// If the route is a device, ie. an iPhone, iPad, iPod or an Apple TV.
    @objc optional var isDeviceRoute: Bool { get }
    
    /// If the route has an option to mirror the devices display to it, a corresponding route will be returned, otherwise `nil`.
    @objc optional var wirelessDisplayRoute: MPAVRoute { get }
    
    /**
     Setter method for the `wirelessDisplayRoute` property.
     
     - Parameter route: Set the `wirelessDisplayRoute` property to a custom route.
     */
    @objc optional func setWirelessDisplayRoute(_ route: MPAVRoute)
    
    /// Detailed information about the route.
    @objc optional var avRouteDescription: [String: Any] { get }
    
    /// An array of...
    @objc optional var auxiliaryDevices: [Any] { get } // TODO: Explicitly mark type of array.
    
    /// The battery life of the route.
    @objc optional var batteryLevel: MPAVBatteryLevel { get }
    
    /// If the `wirelessDisplayRoute` is selected.
    @objc optional var displayIsPicked: Bool { get }
    
    /// If the route is picked.
    @objc optional var isPicked: Bool { get }
    
    /**
     Setter method for the `isPicked` value.
     
     - Parameter picked: Pass `true` to connect to the current route, and `false` to disconnect from the current route, if connected to.
     */
    @objc optional func setPicked(_ picked: Bool)
    
    /// If the route is...
    @objc optional var isPickedOnPairedDevice: Bool { get }
    
    /// If audio or video is playing on the route.
    @objc optional var isPlayingOnPairedDevice: Bool { get }
    
    /// The type of the routes `wirelessDisplayRoute` property.
    @objc optional var displayRouteType: Int { get } // TODO: Create enum correspoding to this
    
    /**
     Setter method for the `displayRouteType` enum.
     
     - Parameter rawValue:  The rawValue of the `displayRouteType` enum.
     */
    @objc optional func setDisplayRouteType(rawValue: Int)
    
    /// The type of the password on the current route.
    @objc optional var passwordType: Int { get } // TODO: Create enum correspoding to this
    
    /// The type of the...
    @objc optional var pickableRouteType: Int { get } // TODO: Create enum correspoding to this
    
    /// The type of the route.
    @objc optional var routeType: Int { get } // TODO: Create enum correspoding to this
    
    /// The subtype of the route.
    @objc optional var routeSubtype: Int { get } // TODO: Create enum correspoding to this
    
    /// If the route requires a password to be connected to.
    @objc optional var requiresPassword: Bool { get }
    
    /// The name of the route
    @objc optional var routeName: String { get }
    
    /**
     Setter method for the `routeName` property.
     
     - Parameter name:  Set the `routeName` property to a custom string.
     */
    @objc optional func setRouteName(_ name: String)
    
    /// A unique id for the current route (it's MAC address).
    @objc optional var routeUID: String { get }
    
    /// The stock image for the route.
    @objc optional var routeImage: UIImage { get }
}
