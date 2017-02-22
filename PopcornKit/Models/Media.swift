

import Foundation
import ObjectMapper

/// Generic media protocol.
public protocol Media: Mappable {
    var title: String { get }
    var id: String { get }
    var tmdbId: Int? { get set }
    var slug: String { get }
    
    var summary: String { get }
    
    var smallBackgroundImage: String? { get }
    var mediumBackgroundImage: String? { get }
    var largeBackgroundImage: String? { get set }
    var smallCoverImage: String? { get }
    var mediumCoverImage: String? { get }
    var largeCoverImage: String? { get set }
    
    /// Will be empty if Media is Show.
    var subtitles: [Subtitle] { get set }
    
    /// Will be empty if Media is Show.
    var torrents: [Torrent] { get set }
    
    /// Will return `false` if Media is Show.
    var isWatched: Bool { get set }
    
    /// Will return `false` if Media is Episode.
    var isAddedToWatchlist: Bool { get set }
    
    init(title: String, id: String, tmdbId: Int?, slug: String, summary: String, torrents: [Torrent], subtitles: [Subtitle], largeBackgroundImage: String?, largeCoverImage: String?)
}

// MARK: - Optional vars

extension Media {
    public var subtitles: [Subtitle] { get { return [] } set {} }
    public var torrents: [Torrent] { get { return [] } set {} }
    
    public var isWatched: Bool { get { return false } set {} }
    
    public var isAddedToWatchlist: Bool { get { return false } set {} }
    
    public var smallCoverImage: String? { return nil }
    public var mediumCoverImage: String? { return nil }
    public var largeCoverImage: String? { get{ return nil } set {} }
}

extension String {
    public var isAmazonUrl: Bool {
        return contains("https://images-na.ssl-images-amazon.com/images/")
    }
}

open class StringTransform: TransformType {
    public typealias Object = String
    public typealias JSON = Int
    
    public init() {}
    
    open func transformFromJSON(_ value: Any?) -> String? {
        if let int = value as? Int {
            return String(int)
        }
        
        return nil
    }
    
    open func transformToJSON(_ value: String?) -> Int? {
        if let string = value {
            return Int(string)
        }
        return nil
    }
}
