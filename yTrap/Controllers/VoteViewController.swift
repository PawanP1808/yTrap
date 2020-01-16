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

class VoteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var roomId: Int?
    var serverDelegate: ManageServerCommandsProtocol?
    var votes: [Song]?
    var alreadyVoted = [Song]()
    var ref: DatabaseReference?
    
    private lazy var myTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = Constants.Design.Color.Primary.main
        tv.tableFooterView = UIView(frame: .zero)
        tv.register(VoteTableViewCell.self, forCellReuseIdentifier: Constants.Content.voteCellIdentifier)
        return tv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref?.child("Vote").observe(.value) { snapshot in
            var newVotes = [Song]()
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot {
                    let song = Song(snapshot:snapshot)
                    newVotes.append(song!)
                }
            }
            
            self.votes = newVotes
            
            if(newVotes.count != 0 && !(self.serverDelegate!.isPlaying()) && self.serverDelegate!.isRoomHost() ){
                self.getSong()
            }
            self.myTableView.reloadData()
        }
        setupView()
    }
    
    private func updateVotes(forSong song:Song) {
        let voteRef = self.ref?.child("Vote").child(song.key!)
        voteRef?.setValue(song.toAnyObject())
    }
    
    private func vote(vote: Vote, sender: AnyObject){
        guard let voteIndex = sender.view?.tag,
            var voteSong = self.votes?[voteIndex]  else { return }
        var voted = false
        let alreadyVoted = self.alreadyVoted
        for song in alreadyVoted {
            if(voteSong.songURI==song.songURI){
                voted = true
            }
        }
        //        TODO: show alert no votes
        guard !voted else { return }
        self.alreadyVoted.append(voteSong)
        
        switch (vote) {
        case .up:
            voteSong.votes += 1
        case .down:
            if(voteSong.votes != 0) {
                voteSong.votes -= 1
            }
        }
        self.updateVotes(forSong: voteSong)
    }
    
    private func getMostVotedSong() -> Song? {
        guard votes?.count != 0 else { return nil }
        let song = votes!.max{ $0.votes < $1.votes}!
        song.ref?.removeValue()
        return song
    }
    
    func getSong() {
        self.serverDelegate?.playAudio(withSong: self.getMostVotedSong()!)
    }
  
    private func setupView(){
        self.view.addSubview(myTableView)
        
        myTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        myTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        myTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc func downVoted(_ sender:AnyObject){
        self.vote(vote: Vote.down, sender: sender)
    }
    
    @objc func upVoted(_ sender:AnyObject){
        self.vote(vote: Vote.up, sender: sender)
    }
    
    //MARK:TABLEVIEW DELEGATES
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Num: \(indexPath.row)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return votes?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Content.voteCellIdentifier, for: indexPath as IndexPath) as! VoteTableViewCell
        guard let votes = votes else { return UITableViewCell() }
        cell.setup(tag: indexPath.row, song: (votes[indexPath.row]), target: self)
        return cell
    }
}
