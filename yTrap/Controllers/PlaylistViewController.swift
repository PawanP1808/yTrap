//
//  PlaylistViewController.swift
//  yTrap
//
//  Created by Pawan on 2020-01-12.
//  Copyright © 2020 SocialMusic. All rights reserved.
//

import Foundation
import Firebase

enum Table {
    case defaultTable
    case playlist
    case recent
    case search
}

class PlaylistViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var roomId: Int?
    var serverDelegate: ManageServerCommandsProtocol?
    var ref:DatabaseReference?
    
    private var playlists: [Playlist]?
    private var recents: [Song]?
    private var oldRecents: [Song]?
    private var currentTable = Table.defaultTable
    
    private lazy var myTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = Constants.Design.Color.Primary.main
        tv.tableFooterView = UIView(frame: .zero)
        tv.register(DefaultTableViewCell.self, forCellReuseIdentifier: Constants.Content.defaultCellIdentifier)
        tv.register(SongTableViewCell.self, forCellReuseIdentifier: Constants.Content.songCellIdentifier)
        tv.register(PlaylistTableViewCell.self, forCellReuseIdentifier: Constants.Content.playlistCellIdentifier)
        return tv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        getUserPlaylistAndRecent()
    }
    
    
    private func setupView() {
        self.view.addSubview(UIView(frame: .zero))
        
        self.view.addSubview(myTableView)
        
        myTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        myTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        myTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func getUserPlaylistAndRecent(){
        SpotifyAPI().getCurrentUserPlaylists() { success,playlists in
            guard success else { return }
            self.playlists = playlists
            SpotifyAPI().getRecentTracks() { success, recents in
                guard success else { return }
                self.recents = recents
                self.oldRecents = recents
                self.myTableView.reloadData()
            }
        }
    }
    
    //MARK:TABLEVIEW DELEGATES
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch currentTable {
        case .defaultTable:
            if indexPath.row == 0 {
                self.currentTable = Table.playlist
            }
            if indexPath.row == 1 {
                self.recents = self.oldRecents
                self.currentTable = Table.recent
            }
            self.myTableView.reloadData()
        case .playlist:
            guard let unwrappedSongs = self.playlists else { return }
            let selectedPlaylist = unwrappedSongs[indexPath.row]
            SpotifyAPI().playlistTracks(ownerID: selectedPlaylist.ownerID, playlistID: selectedPlaylist.playlistID) { tracks in
                self.myTableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
                self.recents = tracks
                self.currentTable = Table.recent
                 self.myTableView.reloadData()
            }
        case .recent:
            guard let unwrappedSongs = self.recents else { return }
            let selectedSong = unwrappedSongs[indexPath.row]
            let voteRef = self.ref?.child("Vote")
            let newVoteRef = voteRef?.childByAutoId()
            newVoteRef?.setValue(selectedSong.toAnyObject())
            self.dismiss(animated: true)
        case .search:
            print("def")
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch currentTable{
        case .defaultTable:
            return 2
        case .playlist:
            self.resignFirstResponder()
            guard let count = self.playlists?.count else { return 0 }
            return count
        case .recent:
            guard let count = self.recents?.count else { return 0 }
            return count
        case .search:
            return 0
            //            return self.searchSongs.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch currentTable{
        case .defaultTable:
            guard let defaultCell = tableView.dequeueReusableCell(withIdentifier: Constants.Content.defaultCellIdentifier, for: indexPath as IndexPath) as? DefaultTableViewCell else {
                return UITableViewCell()
            }
            if indexPath.row == 0 {
                defaultCell.setup(withTitle: "Playlists")
            } else if indexPath.row == 1 {
                defaultCell.setup(withTitle: "Recently Played")
            }
            return defaultCell
        case .playlist:
            guard let playlistCell = tableView.dequeueReusableCell(withIdentifier: Constants.Content.playlistCellIdentifier, for: indexPath as IndexPath) as? PlaylistTableViewCell else {
                return UITableViewCell()
            }
            guard let unwrappedPlaylist = self.playlists?[indexPath.row] else {
                return playlistCell
            }
            playlistCell.setup(withPlaylist: unwrappedPlaylist)
            return playlistCell
        case .recent:
            guard let tracksCell = tableView.dequeueReusableCell(withIdentifier: Constants.Content.songCellIdentifier, for: indexPath as IndexPath) as? SongTableViewCell else {
                return UITableViewCell()
            }
            guard let unwrappedSongs = self.recents else { return tracksCell }
            let selectedSong = unwrappedSongs[indexPath.row]
            tracksCell.setup(withSong: selectedSong)
            return tracksCell
        case .search:
            //            guard let searchCell = tableView.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath as IndexPath) as? TracksTableViewCell else {
            //                return UITableViewCell()
            //            }
            //            let selectedSong = searchSongs[indexPath.row]
            //            searchCell.setup(withSong: selectedSong)
            //            return searchCell
            return UITableViewCell()
        }
    }
    
}
