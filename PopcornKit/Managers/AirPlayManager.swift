

import Foundation
import MediaPlayer


public enum TableViewUpdates {
    case reload
    case insert
    case delete
}

public protocol ConnectDevicesProtocol: class {
    func updateTableView(dataSource newDataSource: [AnyObject], updateType: TableViewUpdates, indexPaths: [IndexPath]?)
    func didConnectToDevice(deviceIsChromecast chromecast: Bool)
}

open class AirPlayManager: NSObject {
    
    public var dataSourceArray = [MPAVRouteProtocol]()
    public weak var delegate: ConnectDevicesProtocol?
    
    public let MPAudioDeviceControllerClass: NSObject.Type =  NSClassFromString("MPAudioDeviceController") as! NSObject.Type
    public let MPAVRoutingControllerClass: NSObject.Type = NSClassFromString("MPAVRoutingController") as! NSObject.Type
    public var routingController: MPAVRoutingControllerProtocol
    public var audioDeviceController: MPAudioDeviceControllerProtocol
    
    public override init() {
        routingController = MPAVRoutingControllerClass.init() as MPAVRoutingControllerProtocol
        audioDeviceController = MPAudioDeviceControllerClass.init() as MPAudioDeviceControllerProtocol
        super.init()
        audioDeviceController.setRouteDiscoveryEnabled!(true)
        routingController.setDelegate!(self)
        updateAirPlayDevices()
        NotificationCenter.default.addObserver(self, selector: #selector(updateAirPlayDevices), name: NSNotification.Name.MPVolumeViewWirelessRouteActiveDidChange, object: nil)
    }
    
    public func mirrorChanged(_ sender: UISwitch, selectedRoute: MPAVRouteProtocol) {
        if sender.isOn {
            routingController.pickRoute!(selectedRoute.wirelessDisplayRoute!())
        } else {
            routingController.pickRoute!(selectedRoute)
        }
    }
    
    public func updateAirPlayDevices() {
        routingController.fetchAvailableRoutesWithCompletionHandler! { (routes) in
            if routes.count > self.dataSourceArray.count {
                var indexPaths = [IndexPath]()
                for index in self.dataSourceArray.count..<routes.count {
                    indexPaths.append(IndexPath(row: index, section: 0))
                }
                self.dataSourceArray = routes
                self.delegate?.updateTableView(dataSource: self.dataSourceArray, updateType: .insert, indexPaths: indexPaths)
            } else if routes.count < self.dataSourceArray.count {
                var indexPaths = [IndexPath]()
                for (index, route) in self.dataSourceArray.enumerated() {
                    if !routes.contains(where: { $0.routeUID!() == route.routeUID!() }) // If the new array doesn't contain an object in the old array it must have been removed
                    {
                        indexPaths.append(IndexPath(row: index, section: 0))
                    }
                }
                self.dataSourceArray = routes
                self.delegate?.updateTableView(dataSource: self.dataSourceArray, updateType: .delete, indexPaths: indexPaths)
            } else {
                self.dataSourceArray = routes
                self.delegate?.updateTableView(dataSource: self.dataSourceArray, updateType: .reload, indexPaths: nil)
            }
        }
    }
    
    public func airPlayItemImage(_ row: Int) -> UIImage {
        if let dict = self.audioDeviceController.routeDescriptionAtIndex!(row)["AirPlayPortExtendedInfo"] as? [String: AnyObject], let routeType = dict["model"] as? String {
            if routeType.contains("AppleTV") {
                return UIImage(named: "AirTV")!
            } else {
                return UIImage(named: "AirSpeaker")!
            }
        } else {
            return UIImage(named: "AirAudio")!
        }
    }
    
    public func didSelectRoute(_ selectedRoute: MPAVRouteProtocol) {
        self.routingController.pickRoute!(selectedRoute)
    }
    
    // MARK: - MPAVRoutingControllerDelegate
    
    public func routingControllerAvailableRoutesDidChange(_ controller: MPAVRoutingControllerProtocol) {
        updateAirPlayDevices()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        audioDeviceController.setRouteDiscoveryEnabled!(false)
    }
}

// MARK: - MPProtocols

@objc public protocol MPAVRoutingControllerProtocol {
    @objc optional func availableRoutes() -> NSArray
    @objc optional func discoveryMode() -> Int
    @objc optional func fetchAvailableRoutesWithCompletionHandler(_ completion: (_ routes: [MPAVRouteProtocol]) -> Void)
    @objc optional func name() -> AnyObject
    @objc optional func pickRoute(_ route: MPAVRouteProtocol) -> Bool
    @objc optional func pickRoute(_ route: MPAVRouteProtocol, withPassword: String) -> Bool
    @objc optional func videoRouteForRoute(_ route: MPAVRouteProtocol) -> MPAVRouteProtocol
    @objc optional func clearCachedRoutes()
    @objc optional func setDelegate(_ delegate: NSObject)
}

@objc public protocol MPAVRouteProtocol {
    @objc optional func routeName() -> String
    @objc optional func routeSubtype() -> Int
    @objc optional func routeType() -> Int
    @objc optional func requiresPassword() -> Bool
    @objc optional func routeUID() -> String
    @objc optional func isPicked() -> Bool
    @objc optional func passwordType() -> Int
    @objc optional func wirelessDisplayRoute() -> MPAVRouteProtocol
}

@objc public protocol MPAudioDeviceControllerProtocol {
    @objc optional func setRouteDiscoveryEnabled(_ enabled: Bool)
    @objc optional func routeDescriptionAtIndex(_ index: Int) -> [String: AnyObject]
}

extension NSObject: MPAVRoutingControllerProtocol, MPAVRouteProtocol, MPAudioDeviceControllerProtocol {}
