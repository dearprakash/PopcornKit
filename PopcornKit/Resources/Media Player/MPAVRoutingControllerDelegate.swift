

import Foundation

public protocol MPAVRoutingControllerDelegate: class {
    func routingController(_ controller: MPAVRoutingController, didFailToPickRouteWithError error: NSError)
    func routingController(_ controller: MPAVRoutingController, pickedRouteDidChange newRoute: MPAVRoute)
    func routingControllerAvailableRoutesDidChange(_ controller: MPAVRoutingController)
    func routingControllerDidPauseFromActiveRouteChange(_ controller: MPAVRoutingController)
    func routingControllerExternalScreenTypeDidChange(_ controller: MPAVRoutingController)
}

// Optional functions
extension MPAVRoutingControllerDelegate {
    public func routingController(_ controller: MPAVRoutingController, didFailToPickRouteWithError error: NSError) {}
    public func routingController(_ controller: MPAVRoutingController, pickedRouteDidChange newRoute: MPAVRoute) {}
    public func routingControllerAvailableRoutesDidChange(_ controller: MPAVRoutingController) {}
    public func routingControllerDidPauseFromActiveRouteChange(_ controller: MPAVRoutingController) {}
    public func routingControllerExternalScreenTypeDidChange(_ controller: MPAVRoutingController) {}
}
