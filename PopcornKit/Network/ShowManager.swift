

import ObjectMapper
import SwiftyJSON

open class ShowManager: NetworkManager {
    
    /// Creates new instance of ShowManager class
    open static let shared = ShowManager()
    
    /// Possible genres used in API call.
    public enum Genres: String {
        case all = "All"
        case action = "Action"
        case adventure = "Adventure"
        case animation = "Animation"
        case comedy = "Comedy"
        case crime = "Crime"
        case disaster = "Disaster"
        case documentary = "Documentary"
        case drama = "Drama"
        case family = "Family"
        case fanFilm = "Fan Film"
        case fantasy = "Fantasy"
        case filmNoir = "Film Noir"
        case history = "History"
        case holiday = "Holiday"
        case horror = "Horror"
        case indie = "Indie"
        case music = "Music"
        case mystery = "Mystery"
        case road = "Road"
        case romance = "Romance"
        case sciFi = "Science Fiction"
        case short = "Short"
        case sport = "Sports"
        case sportingEvent = "Sporting Event"
        case suspense = "Suspense"
        case thriller = "Thriller"
        case war = "War"
        case western = "Western"
        
        public static let array = [all, action, adventure, animation, comedy, crime, disaster, documentary, drama, family, fanFilm, fantasy, filmNoir, history, holiday, horror, indie, music, mystery, road, romance, sciFi, short, sport, sportingEvent, suspense, thriller, war, western]
    }
    
    /// Possible filters used in API call.
    public enum Filters: String {
        case popularity = "popularity"
        case year = "year"
        case date = "updated"
        case rating = "rating"
        case alphabet = "name"
        case trending = "trending"
        
        public static let array = [trending, popularity, rating, date, year, alphabet]
        
        public var string: String {
            switch self {
            case .popularity:
                return "Popular"
            case .year:
                return "Year"
            case .date:
                return "Last Updated"
            case .rating:
                return "Top Rated"
            case .alphabet:
                return "A-Z"
            case .trending:
                return "Trending"
            }
        }
    }
    
    /**
     Load TV Shows from API.
     
     - Parameter page:       The page number to load.
     - Parameter filterBy:   Sort the response by Popularity, Year, Date Rating, Alphabet or Trending.
     - Paramter genre:       Only return shows that match the provided genre.
     - Parameter searchTerm: Only return shows that match the provided string.
     - Parameter orderBy:    Ascending or descending.
     
     - Parameter completion: Completion handler for the request. Returns array of shows upon success, error upon failure.
     */
    open func load(
        _ page: Int,
        filterBy filter: Filters,
        genre: Genres,
        searchTerm: String?,
        orderBy order: Orders,
        completion: @escaping (_ shows: [Show]?, _ error: NSError?) -> Void) {
        var params: [String: Any] = ["sort": filter.rawValue, "genre": genre.rawValue.replacingOccurrences(of: " ", with: "-").lowercased(), "order": order.rawValue]
        if let searchTerm = searchTerm , !searchTerm.isEmpty {
            params["keywords"] = searchTerm
        }
        self.manager.request(Popcorn.base + Popcorn.shows + "/\(page)", method: .get, parameters: params).validate().responseJSON { response in
            guard let value = response.result.value else { completion(nil, response.result.error as NSError?); return }
            let group = DispatchGroup()
            var shows = [Show]()
            for (_, item) in JSON(value) {
                guard var show = Mapper<Show>().map(JSONObject: item.dictionaryObject) else { continue }
                group.enter()
                TMDBManager.shared.getPoster(forMediaOfType: .shows, withImdbId: show.id, orTMDBId: show.tmdbId, completion: { (tmdb, image, error) in
                    if let tmdb = tmdb { show.tmdbId = tmdb }
                    if let image = image { show.largeCoverImage = image }
                    group.leave()
                })
                shows.append(show)
            }
            group.notify(queue: .main, execute: { completion(shows, nil) })
        }
    }
    
    /**
     Get more show information.
     
     - Parameter imdbId:        The imdb identification code of the show.
     - Parameter tmdbId:        The tmdb identification code of the show.
     
     - Parameter completion:    Completion handler for the request. Returns show upon success, error upon failure.
     */
    open func getInfo(_ imdbId: String, tmdbId: Int?, completion: @escaping (_ show: Show?, _ error: NSError?) -> Void) {
        self.manager.request(Popcorn.base + Popcorn.show + "/\(imdbId)", method: .get).validate().responseJSON { response in
            guard let value = response.result.value, var show = Mapper<Show>().map(JSONObject: value) else {completion(nil, response.result.error as NSError?); return }
            TMDBManager.shared.getPoster(forMediaOfType: .shows, withImdbId: imdbId, orTMDBId: tmdbId, completion: { (tmdb, image, error) in
                if let tmdb = tmdb { show.tmdbId = tmdb }
                if let image = image { show.largeCoverImage = image }
                completion(show, nil)
            })
        }
    }
}
