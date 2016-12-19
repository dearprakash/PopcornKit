

import Foundation

public protocol MPAVRoutingController {
    
    weak var delegate: MPAVRoutingControllerDelegate? { get set }
    
    var availableRoutes: [MPAVRoute] { get }
    var category: String { get set }
    var discoveryMode: Int { get set } // TODO: Create enum correspoding to this
    var externalScreenType: Int { get } // TODO: Create enum correspoding to this
    var name: String { get set }
    var pendingPickedRoute: MPAVRoute? { get }
    var pickedRoute: MPAVRoute? { get }
    var volumeControlIsAvailable: Bool { get }
    
    func clearCachedRoutes()
    func fetchAvailableRoutesWithCompletionHandler(_ completion: ([MPAVRoute]) -> Void)
    func videoRouteForRoute(_ route: MPAVRoute) -> MPAVRoute?
    
    @discardableResult func pickBestDeviceRoute() -> Bool
    @discardableResult func pickHandsetRoute() -> Bool
    @discardableResult func pickRoute(_ route: MPAVRoute) -> Bool
    @discardableResult func pickRoute(_ route: MPAVRoute, withPassword password: String) -> Bool
    @discardableResult func pickSpeakerRoute() -> Bool
    func unpickAirPlayScreenRouteWithCompletion(_ completion: (Any) -> Void) // TODO: Correct type for object
    
    
    func routeOtherThanHandsetAndSpeakerAvailable() -> Bool
    func routeOtherThanHandsetAvailable() -> Bool
    
    func speakerRouteIsPicked() -> Bool
    func wirelessDisplayRouteIsPicked() -> Bool
    func receiverRouteIsPicked() -> Bool
    func handsetRouteIsPicked() -> Bool
    
}
