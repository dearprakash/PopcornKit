

import Foundation
import ObjectMapper

/**
  Struct for managing subtitle objects.
 */
public struct Subtitle: Equatable {
    /// Language string of the subtitle. Eg. English.
    public var language: String!
    /// Link to the subtitle zip.
    public var link: String!
    /// Two letter ISO language code of the subtitle eg. en.
    public var ISO639: String!
    
    public init(language: String, link: String, ISO639: String) {
        self.language = language
        self.link = link
        self.ISO639 = ISO639
    }
}

public func ==(lhs: Subtitle, rhs: Subtitle) -> Bool {
    return lhs.link == rhs.link
}
