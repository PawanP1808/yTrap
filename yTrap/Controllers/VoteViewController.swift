//
//  VoteViewController.swift
//  yTrap
//
//  Created by Pawan on 2020-01-12.
//  Copyright © 2020 SocialMusic. All rights reserved.
//

import Foundation
import Firebase

enum Vote {
    case up
    case down
}

protocol VoteDelegate {
    func vote(withIndex index: Int, vote: Vote)
    func canUpdate(forIndex: Int) -> Bool
}

class VoteViewController: UIViewController, VoteDelegate {
    
    var roomId: Int?
    var serverDelegate: ManageServerCommandsProtocol?
    var ref: DatabaseReference?
    var tableViewDelegate: VoteTableViewDelegate?
    
    private var votes: [Song]?
    private var alreadyVoted = [Song]()
    
    private lazy var tableView: TableView = {
        return TableView(registerCells: [Register(cellClass: VoteTableViewCell.self, identifier: Constants.Content.voteCellIdentifier)])
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewDelegate = VoteTableViewDelegate(withRooms: [Song]())
        self.tableViewDelegate?.delegate = self
        self.tableView.delegate = self.tableViewDelegate
        self.tableView.dataSource = self.tableViewDelegate
        setupView()
        getVotes()
    }
    
    private func getVotes() {
        self.ref?.child("Vote").observe(.value) { [weak self] snapshot in
            guard let sSelf = self else { return }
            var newVotes = [Song]()
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot {
                    let song = Song(snapshot:snapshot)
                    newVotes.append(song!)
                }
            }
            sSelf.votes = newVotes
            sSelf.tableViewDelegate?.update(withVotes: newVotes)
            
            if(newVotes.count != 0 && !(sSelf.serverDelegate!.isPlaying()) && sSelf.serverDelegate!.isRoomHost() ){
                sSelf.serverDelegate?.playAudio(withSong: sSelf.getMostVotedSong()!)
            }
            sSelf.reload(tableView: sSelf.tableView)
        }
    }
    
    private func updateVotes(forSong song:Song) {
        let voteRef = self.ref?.child("Vote").child(song.key!)
        voteRef?.setValue(song.toAnyObject())
    }
    
    func getMostVotedSong() -> Song? {
        guard votes?.count != 0 else { return nil }
        let song = votes!.max{ $0.votes < $1.votes}!
        song.ref?.removeValue()
        return song
    }
  
    private func setupView(){
        self.view.addSubview(tableView)
        
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    //MARK:VoteDelegate
    
    func canUpdate(forIndex index: Int) -> Bool {
        guard let voteSong = self.votes?[index] else { return false }
        var canVote = true
        let alreadyVoted = self.alreadyVoted
        for song in alreadyVoted {
            if(voteSong.songURI==song.songURI){
                canVote = false
                break
            }
        }
        return canVote
    }
    
    func vote(withIndex index: Int, vote: Vote) {
        guard var voteSong = self.votes?[index]  else { return }
        switch vote {
        case .up:
            voteSong.votes += 1
        case .down:
            voteSong.votes -= 1
        }
        self.alreadyVoted.append(voteSong)
        self.updateVotes(forSong: voteSong)
    }
}
