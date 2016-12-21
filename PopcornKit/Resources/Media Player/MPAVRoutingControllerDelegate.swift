

import Foundation

/**
 This protocol can provide information about AirPlay connection status.
 
 - Important: Many of these functions may not be called as the `MPAVRoutingControllerDelegate protocol` is not documented and therefore, functions are not depricated like normal API's; Instead they are just removed.
 */
@objc public protocol MPAVRoutingControllerDelegate: class {
    
    /**
     Called when a route that a user selected to connect to was unavailable for connection or the user canceled the request.
     
     - Parameter controller:    The controller managing the route that was to be connected to.
     - Parameter error:         Reason why the route failed to connect.
     */
    @objc optional func routingController(_ controller: MPAVRoutingController, didFailToPickRouteWithError error: NSError)
    
    /**
     Called when a route that a user selected to connect to was successfully connected to.
     
     - Parameter controller:            The controller managing the route that was connected to.
     - Parameter newRoute:              The route that was connected to.
     */
    @objc optional func routingController(_ controller: MPAVRoutingController, pickedRouteDidChange newRoute: MPAVRoute)
    
    /**
     Called when the available AirPlay devices changes.
     
     - Parameter controller:    The controller managing the available routes.
     */
    @objc optional func routingControllerAvailableRoutesDidChange(_ controller: MPAVRoutingController)
    
    /**
     Called when the route controller loses focus while connecting; eg. When the selected route has a password and an alert controller is presented over-top of the route controller.
     
     - Parameter controller:    The controller managing the available routes.
     */
    @objc optional func routingControllerDidPauseFromActiveRouteChange(_ controller: MPAVRoutingController)
    
    /**
     Called when the device starts or stops mirroring to a route.
     
     - Parameter controller:    The controller managing the route.
     */
    @objc optional func routingControllerExternalScreenTypeDidChange(_ controller: MPAVRoutingController)
}
