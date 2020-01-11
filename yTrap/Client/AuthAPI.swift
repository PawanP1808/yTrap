//
//  AuthAPI.swift
//  yTrap
//
//  Created by Pawan on 2020-01-10.
//  Copyright © 2020 SocialMusic. All rights reserved.
//

import Foundation

import Alamofire
//import Alamofire_Synchronous
//import AlamofireImage

class AuthAPI {

    func getAuthCode(authToken token:String, accessToken completion:@escaping (String,String,Int)->()) {
        let parameters:Parameters = ["grant_type":"authorization_code","code":token,"redirect_uri":"\(Constants.API.Spotify.callbackURL)","client_id":Constants.API.Spotify.clientId,"client_secret":Constants.API.Spotify.clientSecret]
        Alamofire.request(Constants.API.Spotify.baseSpotifyUrl, method: .post, parameters: parameters, headers:nil).responseJSON { response in
            if response.response?.statusCode == 200 {
                guard let data = response.value as? [String:Any], let accessToken = data["access_token"] as? String, let refreshToken = data["refresh_token"] as? String else { return }
                let date = Date()
                let calender = Calendar.current
                let components = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)
                let hour = components.hour
                let expireTime = hour!+1
//                let userDefaults = UserDefaults.standard
//                userDefaults.set(accessToken, forKey: "accessToken")
//                userDefaults.set(refreshToken, forKey: "refreshToken")
//                userDefaults.set(hour!+1, forKey: "expireHour")
//                userDefaults.synchronize()
                completion(accessToken,refreshToken,expireTime)
            }
        }
    }




}




