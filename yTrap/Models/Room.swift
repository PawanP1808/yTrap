//
//  Room.swift
//  yTrap
//
//  Created by Pawan on 2020-01-11.
//  Copyright © 2020 SocialMusic. All rights reserved.
//

import Foundation
import Firebase

struct Room {
    
    var imageUrl:String
    var ownerUserName:String
    var id:Int
    let ref: DatabaseReference?
    
    init(ownerName name: String, imageString image:String, id:Int) {
        self.imageUrl = image
        self.ownerUserName = name
        self.id = id
        self.ref = nil
    }
    
    init?(snapshot:DataSnapshot){
        guard
            let value = snapshot.value as? [String: AnyObject],
            let owner = value["owner"] as? String,
            let image = value["image"] as? String,
            let id = value["id"] as? Int else {
                return nil
        }
        self.imageUrl = image
        self.ownerUserName = owner
        self.id = id
        self.ref = snapshot.ref
    }
    
    func toAnyObject() -> [String:Any] {
        return ["id":self.id,
                "owner": self.ownerUserName,
                "image":self.imageUrl
        ]
    }
}
