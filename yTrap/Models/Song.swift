//
//  Song.swift
//  yTrap
//
//  Created by Pawan on 2020-01-12.
//  Copyright © 2020 SocialMusic. All rights reserved.
//

import Foundation
import Firebase

struct Song {
    
    var title: String
    var artist: String
    var songURI: String
    var album: String
    var albumURI: String
    var duration: TimeInterval
    var isExplicit: Bool
    var image: String
    var votes: Int
    var key: String?
    var ref:DatabaseReference?
    
    init?(snapshot: DataSnapshot) {
        
        guard let snapshotDict = snapshot.value as? [String:Any],
            let songUri = snapshotDict["uri"] as? String,
            let artist = snapshotDict["artist"] as? String,
            let album = snapshotDict["album"] as? String,
            let albumUri = snapshotDict["albumUri"] as? String,
            let duration = snapshotDict["duration"] as? TimeInterval,
            let isExplicit = snapshotDict["isExplicit"] as? Bool,
            let image = snapshotDict["image"] as? String,
            let votes = snapshotDict["votes"] as? Int,
            let title = snapshotDict["title"] as? String else { return nil }
        
        self.key = snapshot.key
        self.ref = snapshot.ref
        self.artist = artist
        self.songURI = songUri
        self.album = album
        self.albumURI = albumUri
        self.duration = duration
        self.isExplicit = isExplicit
        self.image = image
        self.votes = votes
        self.title = title
        
    }
    
    init(trackDict: [String:AnyObject]) {
        guard let album = trackDict["album"],
            let artists = album["artists"] as? [[String:AnyObject]],
            let images = album["images"] as? [[String:AnyObject]],
            let songURI = trackDict["uri"] as? String,
            let album1 = album["name"] as? String,
            let albumURI = album["uri"] as? String,
            let duration = trackDict["duration_ms"] as? TimeInterval,
            let isExplicit = trackDict["explicit"] as? Bool,
            let image = images[1]["url"] as? String
            else {
                self.title = ""
                self.artist = ""
                self.songURI = ""
                self.album = ""
                self.albumURI = ""
                self.duration = 0
                self.isExplicit = false
                self.image = ""
                self.votes = 0
                return
        }
        self.title = trackDict["name"] as! String
        if let artist = artists.first?["name"] {
            self.artist = artist as! String
        } else {
            self.artist = "DJ No Name"
        }
        self.songURI = songURI
        self.album = album1
        self.albumURI = albumURI
        self.duration = duration
        self.isExplicit = isExplicit
        self.image = image
        self.votes = 0
    }
    
    func toAnyObject() -> [String:Any] {
        return [ "title" : self.title,
                 "artist":self.artist,
                 "uri":self.songURI,
                 "album":self.album,
                 "albumUri":self.albumURI,
                 "duration":self.duration,
                 "isExplicit":self.isExplicit,
                 "image":self.image,
                 "votes":self.votes,
        ]
        
    }
    
}

