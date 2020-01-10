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
                // example: static let Blue = UIColor.rgba(red: 0, green: 122, blue: 255, alpha: 1)
                
               
            }
            struct Secondary {
               
            }
            struct Grayscale {
                
            }
        }
        struct Image {
            // example: static let icoStar = UIImage(named: "ico_imageName")
            static let logo = UIImage(named: "ytrap")
          
        }
        struct Font {
           
            // example: static let Body = UIFont.systemFont(ofSize: 16, weight: .regular)
            static let buttonTxt =  UIFont.boldSystemFont(ofSize: 15)
           
        }
        
    }

    struct Content {
        
        // example: static let Category = "category"
        static let loginBtnTxt = "Login With Spotify"

    }

    struct API {
        
        struct Spotify {
            static let loginUrl = URL(string:"https://accounts.spotify.com/authorize?nolinks=true&nosignup=true&response_type=code&scope=streaming%20playlist-read-private%20playlist-modify-public%20playlist-modify-private%20user-read-recently-played%20user-read-private&redirect_uri=socialmusic%3A%2F%2Freturnafterlogin&show_dialog=true&client_id=26065fe72a3c41e08f86d6f50e3c2204")
        }
        
        // example: static let twitterApiUrl = "https://api.twitter.com/"
        // example: static let DB_REF = Firestore.firestore()
        
    }
}
