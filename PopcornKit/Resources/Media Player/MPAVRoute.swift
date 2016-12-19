

import Foundation


public protocol MPAVRoute {
    
    var airpodsRoute: Bool { get }
    var beatsSoloRoute: Bool { get }
    var beatsXRoute: Bool { get }
    var powerbeatsRoute: Bool { get }
    var isDeviceRoute: Bool { get }
    var wirelessDisplayRoute: MPAVRoute? { get }
    
    var auxiliaryDevices: NSArray { get } // TODO: Explicitly mark type of array.
    var batteryLevel: MPAVBatteryLevel { get }
    
    var displayIsPicked: Bool { get }
    var picked: Bool { get }
    var pickedOnPairedDevice: Bool { get }
    var playingOnPairedDevice: Bool { get }
    
    var displayRouteType: Int { get } // TODO: Create enum correspoding to this
    var passwordType: Int { get } // TODO: Create enum correspoding to this
    var pickableRouteType: Int { get } // TODO: Create enum correspoding to this
    var routeSubtype: Int { get } // TODO: Create enum correspoding to this
    var routeType: Int { get } // TODO: Create enum correspoding to this
    
    var requiresPassword: Bool { get }
    var routeName: String { get }
    var routeUID: String { get }
    var routeImage: UIImage? { get }
    
    func setDisplayRouteType(rawValue: Int)
    func setPicked(_ picked: Bool)
    func setRouteName(_ name: String)
    func setWirelessDisplayRoute(_ route: MPAVRoute)
}

extension MPAVRoute {
    public var routeImage: UIImage? {
        // TODO: Once enum has been found do the shit
        return UIImage(named: "")
    }
}
