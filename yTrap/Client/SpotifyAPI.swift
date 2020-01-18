//
//  SpotifyAPI.swift
//  yTrap
//
//  Created by Pawan on 2020-01-10.
//  Copyright © 2020 SocialMusic. All rights reserved.
//

import Foundation
import Alamofire

class SpotifyAPI {
    
    private lazy var playlists = [Playlist?]()
    private lazy var trackArray = [Song]()
    private var offset = 0
    private var total = 0
    private var nextSongsListUrl:String?
    
    func getUserData(authToken: String, callback: @escaping ((_ success: Bool,_ data: SPTUser?) -> ())) {
        guard let userRequest = try? SPTUser.createRequestForCurrentUser(withAccessToken: authToken) else { return }
        Alamofire.request(userRequest).response { response in
            guard let data = response.data, let unwrappedResponse = response.response, response.response?.statusCode == 200 else {
                callback(false,nil)
                return
            }
            let userData = try? SPTUser.init(from: data, with: unwrappedResponse)
            callback(true,userData)
        }
    }
    
    func getCurrentUserPlaylists(completionArray: @escaping (_ success: Bool,_ playlists: [Playlist]) -> ()) {
        Alamofire.request(Constants.API.Spotify.playlistUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: getHeaders()).responseJSON { (dataResponse) in
            var playlistArray: [Playlist] = []
            if let result = dataResponse.result.value, let data = result as? [String:AnyObject], let items = data["items"] as? [[String:AnyObject]], dataResponse.response?.statusCode == 200 {
                for item in items {
                    let playlist = Playlist(jsonDictionary: item)
                    playlistArray.append(playlist)
                    completionArray(true,playlistArray)
                }
            }
        }
    }
    
    func getRecentTracks(completionArray: @escaping (_ success: Bool, _ songs: [Song]) -> ()) {
        Alamofire.request(Constants.API.Spotify.recentsUrl, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: getHeaders()).responseJSON { (dataResponse) in
            if let result = dataResponse.result.value, let data = result as? [String:AnyObject], let items = data["items"] as? [[String:AnyObject]], dataResponse.response?.statusCode == 200 {
                var trackArray: [Song] = []
                for item in items {
                    guard let trackDict = item["track"] as? [String:AnyObject] else { continue }
                    let song = Song(trackDict: trackDict)
                    trackArray.append(song)
                }
                completionArray(true, trackArray)
            }
        }
    }
    
    func playlistTracks(ownerID: String, playlistID: String, completionArray: @escaping ([Song]) -> ()) {
        Alamofire.request(Constants.API.Spotify.songsForPlaylistUrl +  "\(ownerID)/playlists/\(playlistID)/tracks", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: getHeaders()).responseJSON { (dataResponse) in
            if dataResponse.response?.statusCode == 200,
                let result = dataResponse.result.value,
                let data = result as? [String:AnyObject],
                let items = data["items"] as? [[String:AnyObject]] {
                var trackArray: [Song] = []
                guard let offset = data["offset"] as? Int, let total = data["total"] as? Int else { return }
                self.offset = offset
                self.total = total
                self.nextSongsListUrl = data["next"] as? String

                for item in items {

                    guard let trackDict = item["track"] as? [String:AnyObject] else { continue }
                    let song = Song(trackDict: trackDict)
                    trackArray.append(song)
                }
                while self.offset != self.total {
                    if  let nextSongsList = self.nextSongsListUrl {

                        let data1 =  self.getAllTracks(forURL: nextSongsList)
                        guard let offset1 = data1["offset"] as? Int, let total1 = data1["total"] as? Int, let items1 = data1["items"] as? [[String:AnyObject]] else { return }
                        self.offset = offset1
                        self.total = total1
                        self.nextSongsListUrl = data1["next"] as? String
                        for item in items1 {

                            guard let trackDict = item["track"] as? [String:AnyObject] else { continue }
                            let song = Song(trackDict: trackDict)
                            trackArray.append(song)
                        }
                    } else {
                        break
                    }
                }
                self.offset = 0
                self.total = 0
                self.nextSongsListUrl = nil
                completionArray(trackArray)
            }
        }
    }
    
    func getAllTracks(forURL:String)->[String:AnyObject] {
     
        let dataResponse = Alamofire.download(forURL, method: .get,encoding: JSONEncoding.default, headers: getHeaders()).responseJSON()

        guard dataResponse.response?.statusCode == 200,
            let result = dataResponse.result.value,
            let data = result as? [String:AnyObject] else  { return [:]}
        return data
    }
    
    private func getHeaders() -> HTTPHeaders {
        let (accessToken,refreshToken,expireTime) = AuthDataStore().getAccessInfo()
        if (self.checkIfTokenNeedsRefresh(forUnixTime: Double(expireTime!)!)) {
           let (newAccessToken, newExpireTime) = AuthAPI().refreshToken(withRefreshToken: refreshToken!)
            AuthDataStore().storeAccessInfo(accessToken: newAccessToken!, refreshToken: refreshToken!, expireHour: newExpireTime!)
            return [
                "Authorization": "Bearer \(newAccessToken!)",
                "Accept": "application/json"
            ]
        } else {
            return [
                "Authorization": "Bearer \(accessToken!)",
                "Accept": "application/json"
            ]
        }
    }
    
    private func checkIfTokenNeedsRefresh(forUnixTime time: Double) -> Bool {
        if(Date().timeIntervalSince1970 < time){
            return false
        }
        return true
    }
}
