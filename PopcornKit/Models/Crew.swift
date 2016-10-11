

import Foundation
import ObjectMapper

/**
 Struct for managing crew objects.
 */
public struct Crew: Person, Equatable {

    /// Name of the person.
    public let name: String
    /// Their job on set.
    public let job: String
    /// The group they were part of.
    public var roleType: Role
    /// Imdb id of the person.
    public let imdbId: String
    
    /// If headshot image is available, it is returned with size 1000*1500.
    public var largeImage: String?
    /// If headshot image is available, it is returned with size 600*900.
    public var mediumImage: String?
    /// If headshot image is available, it is returned with size 300*450.
    public var smallImage: String?
    
    
    public init?(map: Map) {
        do { self = try Crew(map) }
        catch { return nil }
    }
    
    private init(_ map: Map) throws {
        self.name = try map.value("person.name")
        self.job = try map.value("job")
        self.largeImage = try? map.value("person.images.headshot.full")
        self.mediumImage = try? map.value("person.images.headshot.medium")
        self.smallImage = try? map.value("person.images.headshot.thumb")
        self.imdbId = try map.value("person.ids.imdb")
        self.roleType = (try? map.value("roleType")) ?? .unknown // Will only not be `nil` if object is mapped from JSON array, otherwise this is set in `TraktManager` object.
    }
    
    public mutating func mapping(map: Map) {
        switch map.mappingType {
        case .fromJSON:
            if let crew = Crew(map: map) {
                self = crew
            }
        case .toJSON:
            roleType >>> map["roleType"]
            imdbId >>> map["person.ids.imdb"]
            smallImage >>> map["person.images.headshot.thumb"]
            mediumImage >>> map["person.images.headshot.medium"]
            largeImage >>> map["person.images.headshot.full"]
            job >>> map["job"]
            name >>> map["person.name"]
        }
    }

}

public func ==(rhs: Crew, lhs: Crew) -> Bool {
    return rhs.imdbId == lhs.imdbId
}

public enum Role: String {
    case artist = "art"
    case cameraman = "camera"
    case designer = "costume & make-up"
    case director = "directing"
    case other = "crew"
    case producer = "production"
    case soundEngineer = "sound"
    case writer = "writing"
    case unknown = "unknown"
}