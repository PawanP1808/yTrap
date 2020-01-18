//
//  Constants.swift
//  yTrap
//
//  Created by Pawan on 2020-01-09.
//  Copyright © 2020 SocialMusic. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct Design {
        struct Color {
            struct Spotify {
                static let Green = UIColor(red:0.11, green:0.73, blue:0.33, alpha:1.0)
            }
            struct Primary {
                static let white = UIColor.white
                static let black = UIColor.black
                static let main =  UIColor.black
//
            }
            struct Secondary {
                
            }
            struct Grayscale {
                
            }
        }
        struct Image {
            static let logo = UIImage(named: "ytrap")
            static let up = UIImage(named: "up")
            static let down = UIImage(named: "down")
            static let play = UIImage(named: "play")
            static let pause = UIImage(named: "pause")
            static let skip = UIImage(named: "skip")
        }
        struct Font {
            static let buttonTxt =  UIFont.boldSystemFont(ofSize: 15)
            static let cellTitleTxt = UIFont.boldSystemFont(ofSize: 15)
        }
        
    }
    
    struct Content {
        static let loginBtnTxt = "Login With Spotify"
        static let kCloseSafariViewControllerNotification = "kCloseSafariViewControllerNotification"
        static let roomCellIdentifier = "RoomsTableViewCell"
        static let voteCellIdentifier = "VoteTableViewCell"
        static let playlistCellIdentifier = "PlaylistTableViewCell"
        static let songCellIdentifier = "SongTableViewCell"
        static let defaultCellIdentifier = "defaultTableViewCell"
    }
    
    struct API {
        static let defaultImageString = "https://tinyurl.com/tpeesp7"
        
        struct Spotify {
            static let callbackURL = "socialmusic://returnafterlogin"
            static let clientId = "26065fe72a3c41e08f86d6f50e3c2204"
            static let clientSecret = "7297eb1780f94f598a127e361482dbcc"
            static private let baseAuthUrlString = "https://accounts.spotify.com/"
            static private let baseUrlString = "https://api.spotify.com/v1/"
            static let loginUrl = URL(string: API.Spotify.baseAuthUrlString + "authorize?nolinks=true&nosignup=true&response_type=code&scope=streaming%20playlist-read-private%20playlist-modify-public%20playlist-modify-private%20user-read-recently-played%20user-read-private&redirect_uri=socialmusic%3A%2F%2Freturnafterlogin&show_dialog=true&client_id=" + API.Spotify.clientId)
            static let tokenAuthSpotifyUrl = API.Spotify.baseAuthUrlString + "api/token"
            
            static let playlistUrl = API.Spotify.baseUrlString + "me/playlists"
            
            static let songsForPlaylistUrl =  API.Spotify.baseUrlString + "users/"
            static let recentsUrl =  API.Spotify.baseUrlString + "me/player/recently-played"
        }
    }
}
