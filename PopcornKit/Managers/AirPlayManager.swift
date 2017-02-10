

import Foundation
import MediaPlayer


public enum TableViewUpdates {
    case reload
    case insert
    case delete
}

public protocol AirPlayManagerDelegate: class {
    func updateTableView(dataSource newDataSource: [Any], updateType: TableViewUpdates, indexPaths: [IndexPath]?)
}

open class AirPlayManager: NSObject, MPAVRoutingControllerDelegate {
    
    public var dataSourceArray = [MPAVRoute]()
    public weak var delegate: AirPlayManagerDelegate?
    
    public let routingController = MPAVRoutingController()
    public let audioDeviceController = MPAudioDeviceController()
    
    public override init() {
        super.init()
        audioDeviceController.routeDiscoveryEnabled = true
        routingController.delegate = self
        updateRoutes()
    }
    
    public func updateRoutes() {
        routingController.fetchAvailableRoutes { (routes) in
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
                    if !routes.contains(where: { $0.routeUID == route.routeUID }) // If the new array doesn't contain an object in the old array it must have been removed
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
    
    public func didSelectRoute(_ selectedRoute: MPAVRoute) {
        routingController.pick(selectedRoute)
    }
    
    // MARK: - MPAVRoutingControllerDelegate
    
    public func routingControllerAvailableRoutesDidChange(_ controller: MPAVRoutingController) {
        updateRoutes()
    }
    
    public func routingController(_ controller: MPAVRoutingController, pickedRouteDidChange newRoute: MPAVRoute) {
        updateRoutes()
    }
}
