

import Foundation
import AVFoundation
import Alamofire
import SwiftyJSON

/// Class for managing TV Show and Movie Theme songs.
public class ThemeSongManager: NSObject, AVAudioPlayerDelegate {
    
    /// Global player ref.
    private var player: AVAudioPlayer?
    
    /// Creates new instance of AnimeManager class
    public static let shared: ThemeSongManager = ThemeSongManager()
    
    /**
     Starts playing TV Show theme music.
     
     - Parameter id: TVDB id of the show.
     */
    public func playShowTheme(_ id: Int) {
        playTheme("http://tvthemes.plexapp.com/\(id).mp3")
    }
    
    /**
     Starts playing Movie theme music.
     
     - Parameter name: The name of the movie.
     */
    public func playMovieTheme(_ name: String) {
        Alamofire.request("https://itunes.apple.com/search", parameters: ["term": "\(name) soundtrack", "media": "music", "attribute": "albumTerm", "limit": 1]).validate().responseJSON { (response) in
            guard let response = response.result.value else { return }
            let responseDict = JSON(response)
            if let url = responseDict["results"].arrayValue.first?["previewUrl"].string { self.playTheme(url) }
        }
    }
    
    /**
     Starts playing theme music from URL.
     
     - Parameter url: Valid url pointing to a track.
     */
    private func playTheme(_ url: String) {
        if let player = player, player.isPlaying { player.stop() }
        
        URLSession.shared.dataTask(with: URL(string: url)!, completionHandler: { (data, response, error) in
            do {
                if let data = data {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
                    try AVAudioSession.sharedInstance().setActive(true)
                    
                    let volume = UserDefaults.standard.float(forKey: "ThemeSongVolume")
                    
                    self.player = try AVAudioPlayer(data: data)
                    self.player!.volume = volume
                    self.player!.delegate = self
                    self.player!.prepareToPlay()
                    self.player!.play()
                }
            } catch let error {
                print(error)
            }
        }).resume()
    }
    
    /// Stops playing theme music, if previously playing.
    public func stopTheme() {
        self.player?.stop()
    }
    
    public func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.player = nil
    }
}

