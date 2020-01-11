//
//  User.swift
//  yTrap
//
//  Created by Pawan on 2020-01-11.
//  Copyright © 2020 SocialMusic. All rights reserved.
//

import Foundation

struct User:Codable {
    var imageUrl:String
    var userName:String
    var isPremium:Bool
    
    init(imageUrlString:String,userName:String,isPremium: Bool){
        self.imageUrl = imageUrlString
        self.userName = userName
        self.isPremium = isPremium
    }
    
    init(withData user:SPTUser){
        
        self.imageUrl = "https://i.ytimg.com/vi/EgRCa_zuM1I/hqdefault.jpg?sqp=-oaymwEXCNACELwBSFryq4qpAwkIARUAAIhCGAE=&amp;rs=AOn4CLCyaXDje504Q9cguQPBJKFOa7XTwQ"
        if user.images.count != 0 {
            if user.largestImage.imageURL != nil, let largestImageUrl = user.largestImage.imageURL {
                self.imageUrl = "\(largestImageUrl)"
            }
        }
        self.userName = user.canonicalUserName
        self.isPremium = user.product == SPTProduct.premium
        
    }
}
