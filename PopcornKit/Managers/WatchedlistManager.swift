
import Foundation
import ObjectMapper

private struct Static {
    static var episodeInstance: WatchedlistManager<Episode>? = nil
    static var movieInstance: WatchedlistManager<Movie>? = nil
    static var showInstance: WatchedlistManager<Show>? = nil
}

typealias jsonDict = [String: [String: Any]]

/// Class for managing a users watch history. **Only available for movies, and episodes**.
open class WatchedlistManager<N: Media & Hashable> {
    
    private let currentType: Trakt.MediaType
    
    /// Creates new instance of WatchedlistManager class with type of Episodes.
    public class var episode: WatchedlistManager<Episode> {
        DispatchQueue.once(token: "EpisodeWatchedlist") {
            Static.episodeInstance = WatchedlistManager<Episode>()
        }
        return Static.episodeInstance!
    }
    
    /// Creates new instance of WatchedlistManager class with type of Shows.
    public class var show: WatchedlistManager<Show> {
        DispatchQueue.once(token: "ShowWatchedlist") {
            Static.showInstance = WatchedlistManager<Show>()
        }
        return Static.showInstance!
    }
    
    /// Creates new instance of WatchlistManager class with type of Movies.
    public class var movie: WatchedlistManager<Movie> {
        DispatchQueue.once(token: "MovieWatchedlist") {
            Static.movieInstance = WatchedlistManager<Movie>()
        }
        return Static.movieInstance!
    }
    
    public init(){
        switch N.self {
        case is Movie.Type:
            currentType = .movies
        case is Episode.Type:
            currentType = .episodes
        case is Show.Type:
            currentType = .shows
        default:
            currentType = .movies
        }
    }
    
    /** 
     Toggles a users watched status on the passed in media id and syncs with Trakt if available.
     
     - Parameter media: The media to add or remove.
     */
    open func toggle(_ media: N) {
        isAdded(media) ? remove(media): add(media)
    }
    
    /**
     Adds movie or episode to watchedlist and syncs with Trakt if available.
     
     - Parameter media: The media to add.
     */
    open func add(_ media: N) {
        TraktManager.shared.scrobble(media.id, progress: 1, type: currentType, status: .finished)
        var array = UserDefaults.standard.object(forKey: "\(currentType.rawValue)Watchedlist") as? jsonArray ?? jsonArray()
        array.append(Mapper<N>().toJSON(media))
        UserDefaults.standard.set(array, forKey: "\(currentType.rawValue)Watchedlist")
    }
    
    /**
     Removes movie or episode from a users watchedlist and syncs with Trakt if available.
     
     - Parameter id: The imdbId for movie or tvdbId for episode.
     */
    open func remove(_ media: N) {
        TraktManager.shared.remove(media.id, fromWatchedlistOfType: currentType)
        if var array = UserDefaults.standard.object(forKey: "\(currentType.rawValue)Watchedlist") as? jsonArray,
            let map = Mapper<N>().mapArray(JSONArray: array),
            let index = map.index(where: { $0.id == media.id }) {
            array.remove(at: index)
            UserDefaults.standard.set(array, forKey: "\(currentType.rawValue)Watchedlist")
        }
    }
    
    /**
     Checks if movie or episode is in the watchedlist.
     
     - Parameter id: The imdbId for movie or tvdbId for episode.
     
     - Returns: Boolean indicating if movie or episode is in watchedlist.
     */
    open func isAdded(_ media: N) -> Bool {
        if let array = UserDefaults.standard.object(forKey: "\(currentType.rawValue)Watchedlist") as? jsonArray,
            let map = Mapper<N>().mapArray(JSONArray: array) {
            return map.contains(where: {$0.id == media.id})
        }
        return false
    }
    
    /**
     Gets watchedlist locally first and then from Trakt.
     
     - Parameter completion: Called if local watchedlist was updated from trakt.
     
     - Returns: Locally stored watchedlist (may be out of date if user has authenticated with trakt).
     */
    @discardableResult open func getWatched(completion: (([N]) -> Void)? = nil) -> [N] {
        let array = UserDefaults.standard.object(forKey: "\(currentType.rawValue)Watchedlist") as? jsonArray ?? jsonArray()
        
        TraktManager.shared.getWatched(forMediaOfType: N.self) { [unowned self] (medias, error) in
            guard error == nil else { return }
            UserDefaults.standard.set(Mapper<N>().toJSONArray(medias), forKey: "\(self.currentType.rawValue)Watchedlist")
            completion?(medias)
        }
        
        return Mapper<N>().mapArray(JSONArray: array) ?? [N]()
    }
    
    /**
     Stores movie progress and syncs with Trakt if available.
     
     - Parameter progress:      The progress of the playing video. Possible values range from 0...1.
     - Parameter forMedia:      The media that is playing.
     - Parameter withStatus:    The status of the item.
     */
    open func setCurrentProgress(_ progress: Float, forMedia media: N, withStatus status: Trakt.WatchedStatus) {
        TraktManager.shared.scrobble(media.id, progress: progress, type: currentType, status: status)
        
        var raw = UserDefaults.standard.object(forKey: "\(currentType.rawValue)ProgressRawMedia") as? jsonDict ?? jsonDict()
        var progressDict = UserDefaults.standard.object(forKey: "\(self.currentType.rawValue)Progress") as? [String: Float] ?? [String: Float]()
        
        raw[media.id] = Mapper<N>().toJSON(media)
        progressDict[media.id] = progress
        
        progress >= 0.8 ? add(media) : ()
        
        UserDefaults.standard.set(raw, forKey: "\(self.currentType.rawValue)ProgressRawMedia")
        UserDefaults.standard.set(progressDict, forKey: "\(self.currentType.rawValue)Progress")
    }
    
    /**
     Retrieves latest progress from Trakt and updates local storage. 
     
     - Important: Local watchedlist may be more up-to-date than Trakt version but local version will be replaced with Trakt version regardless.
     
     - Parameter completion: Optional completion handler called when progress has been retrieved from trakt. May never be called if user hasn't authenticated with Trakt.
     
     - Returns: Locally stored progress (may be out of date if user has authenticated with trakt).
     */
    @discardableResult open func getProgress(completion: (([N: Float]) -> Void)? = nil) -> [N: Float] {
        TraktManager.shared.getPlaybackProgress(forMediaOfType: N.self) { (dict, error) in
            guard error == nil else { return }
            
            let media = Array(dict.keys)
            let ids = media.map({ $0.id })
            let progress = Array(dict.values)
            
            UserDefaults.standard.set(Dictionary<String, [String: Any]>(zip(ids, Mapper<N>().toJSONArray(media))), forKey: "\(self.currentType.rawValue)ProgressRawMedia")
            UserDefaults.standard.set(Dictionary<String, Float>(zip(ids, progress)), forKey: "\(self.currentType.rawValue)Progress")
            
            completion?(dict)
        }
        let raw = UserDefaults.standard.object(forKey: "\(currentType.rawValue)ProgressRawMedia") as? jsonDict ?? jsonDict()
        let progress = UserDefaults.standard.object(forKey: "\(self.currentType.rawValue)Progress") as? [String: Float] ?? [String: Float]()
        var dict = [N: Float]()
        
        for (id, media) in raw {
            guard let map = Mapper<N>().map(JSON: media), let progress = progress[id] else { continue }
            dict[map] = progress
        }
        
        return dict
    }
    
    /**
     Retrieves watched progress for movie or epsiode.
     
     - Parameter media: The media to retrieve progress for.
     
     - Returns: The users last play position progress from 0.0 to 1.0 (if any).
     */
    open func currentProgress(_ media: N) -> Float {
        if let dict = UserDefaults.standard.object(forKey: "\(currentType.rawValue)Progress") as? [String: Float],
            let progress = dict[media.id] {
            return progress
        }
        return 0.0
    }
    
    /**
     Retrieves media that the user is currently watching.
     
     - Parameter completion: Optional completion handler called when on deck media has been retrieved from trakt. May never be called if user hasn't authenticated with Trakt.
     
     - Returns: Locally stored on deck media id's (may be out of date if user has authenticated with trakt).
     */
    @discardableResult open func getOnDeck(completion: (([N]) -> Void)? = nil) -> [N] {
        let group = DispatchGroup()
        var watched:  [N] = []
        var progress: [N] = []
        
        group.enter()
        watched = getWatched() { updated in
            watched = updated
            group.leave()
        }
        
        group.enter()
        progress = Array(getProgress() { updated in
            progress = Array(updated.keys)
            group.leave()
        }.keys)
        
        group.notify(queue: .main) { 
            completion?(Array(Set(progress).subtracting(watched)))
        }
        
        return Array(Set(progress).subtracting(watched))
    }
}
