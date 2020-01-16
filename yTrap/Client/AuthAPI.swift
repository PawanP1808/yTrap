//
//  AuthAPI.swift
//  yTrap
//
//  Created by Pawan on 2020-01-10.
//  Copyright © 2020 SocialMusic. All rights reserved.
//

import Foundation

import Alamofire
import Alamofire_Synchronous

class AuthAPI {
    
    func getAuthCode(authToken token:String, accessToken completion:@escaping (_ accessToken:String,_ refreshToken: String,String)->()) {
        let parameters:Parameters = ["grant_type":"authorization_code","code":token,"redirect_uri":"\(Constants.API.Spotify.callbackURL)","client_id":Constants.API.Spotify.clientId,"client_secret":Constants.API.Spotify.clientSecret]
        Alamofire.request(Constants.API.Spotify.baseSpotifyUrl, method: .post, parameters: parameters, headers:nil).responseJSON { response in
            if response.response?.statusCode == 200 {
                guard let data = response.value as? [String:Any], let accessToken = data["access_token"] as? String, let refreshToken = data["refresh_token"] as? String else { return }
                
                let unixTime = Date().timeIntervalSince1970
                let unixTimeString = "\(unixTime + 3600)"
                completion(accessToken,refreshToken,unixTimeString)
            }
        }
    }
    
    func refreshToken(withRefreshToken token: String) -> (String?,String?) {
        let parameters:Parameters = ["grant_type":"refresh_token","refresh_token":token,"client_id":Constants.API.Spotify.clientId,"client_secret": Constants.API.Spotify.clientSecret]
        let response = Alamofire.request(Constants.API.Spotify.baseSpotifyUrl, method: .post, parameters:parameters,headers:nil).responseJSON()
        if response.response?.statusCode == 200 {
            guard let data = response.result.value as? [String:Any], let accessToken = data["access_token"] as? String, let refreshInterval = data["expires_in"] as? Double else { return (nil, nil) }
            let unixTime = Date().timeIntervalSince1970
            let unixTimeString = "\(unixTime + refreshInterval)"
            return (accessToken, unixTimeString)
        }
        return (nil, nil)
    }
}
