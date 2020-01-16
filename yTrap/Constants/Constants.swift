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
            static let loginUrl = URL(string:"https://accounts.spotify.com/authorize?nolinks=true&nosignup=true&response_type=code&scope=streaming%20playlist-read-private%20playlist-modify-public%20playlist-modify-private%20user-read-recently-played%20user-read-private&redirect_uri=socialmusic%3A%2F%2Freturnafterlogin&show_dialog=true&client_id=26065fe72a3c41e08f86d6f50e3c2204")
            static let baseSpotifyUrl = "https://accounts.spotify.com/api/token"
            static let callbackURL = "socialmusic://returnafterlogin"
            static let clientId = "26065fe72a3c41e08f86d6f50e3c2204"
            static let clientSecret = "7297eb1780f94f598a127e361482dbcc"
            static let playlistUrl = "https://api.spotify.com/v1/me/playlists"
            static let songsForPlaylistUrl = "https://api.spotify.com/v1/users/"
            static let recentsUrl = "https://api.spotify.com/v1/me/player/recently-played"
        }
    }
}
