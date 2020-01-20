//
//  PlaylistTableViewDelegate.swift
//  yTrap
//
//  Created by Pawan on 2020-01-17.
//  Copyright © 2020 SocialMusic. All rights reserved.
//

import Foundation

class PlaylistTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private var data = [Playlist]()
    var didSelectRow: ((_ withDataItem: Playlist) -> Void)?
    
    init(withPlaylists data: [Playlist]) {
        self.data = data
        
    }
    
    func update(withPlaylists data : [Playlist]) {
        self.data = data
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let dataItem = data[indexPath.row]
        if let didSelectRow = didSelectRow {
             didSelectRow(dataItem)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Content.playlistCellIdentifier, for: indexPath as IndexPath) as! PlaylistTableViewCell
        let selectedPlaylist = data[indexPath.row]
        cell.setup(withPlaylist: selectedPlaylist)
        return cell
    }
}
