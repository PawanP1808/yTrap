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
    func getUserData(authToken: String, callback: @escaping ((_ success: Bool,_ data: SPTUser?) -> ())) {
        guard let userRequest = try? SPTUser.createRequestForCurrentUser(withAccessToken: authToken) else { return }
        Alamofire.request(userRequest).response { response in
            guard let data = response.data, let unwrappedResponse = response.response else {
                callback(false,nil)
                return
            }
            let userData = try? SPTUser.init(from: data, with: unwrappedResponse)
            callback(true,userData)
        }
    }
}
