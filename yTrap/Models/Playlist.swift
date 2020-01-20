//
//  Playlist.swift
//  yTrap
//
//  Created by Pawan on 2020-01-12.
//  Copyright © 2020 SocialMusic. All rights reserved.
//

import Foundation

struct Playlist: Codable {
    
    var name: String
    var trackRequestURL: String
    var playlistID: String
    var ownerID: String
    var image: String
    var total: Int
    
    init(jsonDictionary: [String:AnyObject]) {
        let owner = jsonDictionary["owner"] as! [String : AnyObject]
        let images = jsonDictionary["images"] as! [[String : AnyObject]]
        let tracks = jsonDictionary["tracks"] as! [String:Any]
        
        self.name = jsonDictionary["name"] as! String
        self.trackRequestURL = jsonDictionary["href"] as! String
        self.playlistID = jsonDictionary["id"] as! String
        self.ownerID = owner["id"] as! String
        self.image = images.first?["url"] as! String
        self.total = tracks["total"] as! Int
        
    }
}

