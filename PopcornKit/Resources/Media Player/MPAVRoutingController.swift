

import Foundation

/**
 Local representation of private `MPAVRoutingController class` used to discover AirPlay devices. 
 
 - Important: Many of these functions/variables may be `nil` as the `MPAVRoutingController class` is not documented and therefore, functions are not depricated like normal API's; Instead they are just removed.
 */
@objc public protocol MPAVRoutingController {

    /// The delegate for recieving `MediaPlayer.framework` notifications.
    @objc optional var delegate: MPAVRoutingControllerDelegate { get }

    /**
     Setter method for the `MPAVRoutingControllerDelegate` protocol.

     - Parameter delegate:  The object that wishes to recieve delegate notifications.
     */
    @objc optional func setDelegate(_ delegate: MPAVRoutingControllerDelegate?)

    /// Array of available AirPlay routes.
    @objc optional var availableRoutes: [MPAVRoute] { get }

    /// The category the route falls under.
    @objc optional var category: String { get }

    /**
     Setter method for the `MPAVRoutingControllerDelegate` protocol.

     - Parameter delegate:  The object that wishes to recieve delegate notifications.
     */
    @objc optional func setCategory(_ category: String)

    /// The discovery mode of the device.
    @objc optional var discoveryMode: Int { get } // TODO: Create enum correspoding to this

    /**
     Setter method for the discovery mode variable.

     - Parameter rawValue:  The rawValue from the `DiscoveryMode` enum.
    */
    @objc optional func setDiscoveryMode(_ rawValue: Int)

    /// The type of the screen currently being mirrored to.
    @objc optional var externalScreenType: Int { get } // TODO: Create enum correspoding to this

    /// The name of the controller
    @objc optional var name: String { get }

    /**
     Setter method for the name variable.

     - Parameter name: The new name of the controller.
    */
    @objc optional func setName(_ name: String)

    /// The route that is currently being connected to.
    @objc optional var pendingPickedRoute: MPAVRoute { get }

    /// The current route that the device is mirroring to.
    @objc optional var pickedRoute: MPAVRoute { get }

    /**
     Clear the currently cached routes, if any.
    */
    @objc optional func clearCachedRoutes()

    /**
     Scan for new AirPlay devices.

     - Parameter completion: The completion handler for the request.
    */
    @objc optional func fetchAvailableRoutesWithCompletionHandler(_ completion: ([MPAVRoute]) -> Void)

    /**
     The video route for the correspoding route. Will return `nil` if the route is an audio only device.

     - Parameter route: The route that the video route is to be fetched for.
    */
    @objc optional func videoRouteForRoute(_ route: MPAVRoute) -> MPAVRoute?

    /**
     Automatically select and connect to the best route based upon connection status.

     - Returns: If a route was found and connected to.
    */
    @objc @discardableResult optional func pickBestDeviceRoute() -> Bool

    /**
     Automatically select and connect to the first handset route found.

     - Returns: If a handset route was found and connected to.
    */
    @objc @discardableResult optional func pickHandsetRoute() -> Bool

    /**
     Connect to a route.

     - Parameter route: The route to be connected to.

     - Returns: If the route was successfully connected to.
    */
    @objc @discardableResult optional func pickRoute(_ route: MPAVRoute) -> Bool

    /**
     Connect to a route that is password protected.

     - Parameter route:         The route to be connected to.
     - Parameter password:      The password for the route.

     - Returns: If the password was correct and the route was successfully connected to.
    */
    @objc @discardableResult optional func pickRoute(_ route: MPAVRoute, withPassword password: String) -> Bool

    /**
     Automatically select and connect to the first speaker route found.

     - Returns: If a speaker route was found and connected to.
    */
    @objc @discardableResult optional func pickSpeakerRoute() -> Bool

    /**
     Disconnect from the video route of the AirPlay route. Audio route will still stay connected.

     - Parameter completion: Completion handler called upon request completion. Contains an optional error value indicating the requests status.
    */
    @objc optional func unpickAirPlayScreenRouteWithCompletion(_ completion: (NSError?) -> Void)

    /**
     Searches for routes that are not handsets or generic speakers.

     - Returns: If routes are available that do not fall under the handsets or generic speakers category.
    */
    @objc optional func routeOtherThanHandsetAndSpeakerAvailable() -> Bool

    /**
     Searches for routes that are not handsets.

     - Returns: If routes are available that do not fall under the handsets category.
    */
    @objc optional func routeOtherThanHandsetAvailable() -> Bool

    /**
     Searches for routes that are speakers.

      - Returns: If the route that the device currently connected to is a speaker.
    */
    @objc optional func speakerRouteIsPicked() -> Bool

    /**
     Searches for routes that are wireless displays.
     
      - Returns: If the route that the device currently connected to is a wireless display - eg. AppleTV.
    */
    @objc optional func wirelessDisplayRouteIsPicked() -> Bool

    /**
     Searches for routes that are AirPlay recievers.

      - Returns: If the route that the device currently connected to is an AirPlay reciever.
    */
    @objc optional func receiverRouteIsPicked() -> Bool

    /**
     Searches for routes that are handsets.

      - Returns: If the route that the device currently connected to is a handset.
    */
    @objc optional func handsetRouteIsPicked() -> Bool

}

extension NSObject: MPAVRoutingController, MPAudioDeviceController, MPAVRoute, MPAVBatteryLevel {}
