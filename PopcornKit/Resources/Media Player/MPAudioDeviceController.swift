

import Foundation

public protocol MPAudioDeviceController {
    
    var routeDiscoveryEnabled: Bool { get set }
    func routeDescriptionAtIndex(_ index: Int) -> [String: AnyObject]
    
}
