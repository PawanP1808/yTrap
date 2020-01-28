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

class PlaylistViewController: UIViewController {
    
    var roomId: Int?
    var ref:DatabaseReference?
    
    private var playlists: [Playlist]?
    private var recents: [Song]?
    private var oldRecents: [Song]?
    private var defaultTableViewDelegate: DefaultTableViewDelegate?
    private var songsTableViewDelegate: SongsTableViewDelegate?
    private var playlistTableViewDelegate: PlaylistTableViewDelegate?
    
    private lazy var tableView: TableView = {
        var registerCell = [Register]()
        registerCell.append(Register(cellClass: DefaultTableViewCell.self, identifier: Constants.Content.defaultCellIdentifier))
        registerCell.append(Register(cellClass: SongTableViewCell.self, identifier: Constants.Content.songCellIdentifier))
        registerCell.append(Register(cellClass: PlaylistTableViewCell.self, identifier: Constants.Content.playlistCellIdentifier))
        return TableView(registerCells: registerCell)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.defaultTableViewDelegate = DefaultTableViewDelegate()
        self.defaultTableViewDelegate?.didSelectRow = didSelectDefaultRow(_:)
        
        self.songsTableViewDelegate = SongsTableViewDelegate(withSongs: [Song]() )
        self.songsTableViewDelegate?.didSelectRow = didSelectSongRow(_:)
        
        self.playlistTableViewDelegate = PlaylistTableViewDelegate(withPlaylists: [Playlist]() )
        self.playlistTableViewDelegate?.didSelectRow = didSelectPlaylistRow(_:)
        self.switchTo(table: .defaultTable)
        self.setupView()
        getUserPlaylistAndRecent()
    }

    private func setupView() {
        self.view.addSubview(UIView(frame: .zero))
        
        self.view.addSubview(tableView)
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    private func getUserPlaylistAndRecent(){
        SpotifyAPI().getCurrentUserPlaylists() { success,playlists in
            guard success else { return }
            self.playlists = playlists
            SpotifyAPI().getRecentTracks() { success, recents in
                guard success else { return }
                self.recents = recents
                self.oldRecents = recents
                self.tableView.reloadData()
            }
        }
    }
    
    private func switchTo(table: Table) {
        switch table {
        case .defaultTable:
            self.tableView.delegate = self.defaultTableViewDelegate
            self.tableView.dataSource = self.defaultTableViewDelegate
        case .playlist:
            self.tableView.delegate = self.playlistTableViewDelegate
            self.tableView.dataSource = self.playlistTableViewDelegate
        case .recent:
            self.tableView.delegate = self.songsTableViewDelegate
            self.tableView.dataSource = self.songsTableViewDelegate
        case .search:
            print("search")
        }
        self.tableView.reloadData()
    }
    
    func didSelectDefaultRow(_ item: Int){
        if item == 0 {
            self.playlistTableViewDelegate?.update(withPlaylists: self.playlists!)
            self.switchTo(table: .playlist)
        }
        if item == 1 {
            self.songsTableViewDelegate?.update(withSongs: self.oldRecents!)
            self.switchTo(table: .recent)
        }
    }
    
    func didSelectSongRow(_ item: Song){
        let voteRef = self.ref?.child("Vote")
        let newVoteRef = voteRef?.childByAutoId()
        newVoteRef?.setValue(item.toAnyObject())
        self.dismiss(animated: true)
    }
    
    func didSelectPlaylistRow(_ item: Playlist){
        SpotifyAPI().playlistTracks(ownerID: item.ownerID, playlistID: item.playlistID) { tracks in
            self.tableView.scrollRectToVisible(CGRect(x: 0, y: 0, width: 1, height: 1), animated: true)
            self.recents = tracks
            self.songsTableViewDelegate?.update(withSongs: self.recents!)
            self.switchTo(table: .recent)
        }
    }
}
