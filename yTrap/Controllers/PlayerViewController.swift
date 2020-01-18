//
//  PlayerViewController.swift
//  yTrap
//
//  Created by Pawan on 2020-01-12.
//  Copyright © 2020 SocialMusic. All rights reserved.
//

import Foundation
import Firebase
import AVKit
import MediaPlayer

protocol ManageServerCommandsProtocol: class {
    func playAudio(withSong: Song)
    func isPlaying() -> Bool
    func isRoomHost() -> Bool 
}

protocol PlayerDelegateProtocol: class {
    func playPause()
    func skip()
    
}

class PlayerViewController: UIViewController, ManageServerCommandsProtocol, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate,PlayerDelegateProtocol {
    
    var roomId: Int?
    var isHost: Bool?
    var hostName: String?
    var ref: DatabaseReference?
    
    private var songNow: Song?
    private let nowPlayingCenter = MPNowPlayingInfoCenter.default()
    private var playerIsPlaying = false
    private var voteController: VoteViewController?
    private var player: SPTAudioStreamingController?
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var playerView: PlayerView = {
        let playerView = PlayerView()
        playerView.delegate = self
        playerView.isHidden = true
        return playerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.initializePlayer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        guard let uwIsHost = isHost, uwIsHost else { return }
        self.ref?.removeValue()
        self.player?.logout()
        self.player?.playbackDelegate = nil
        self.player?.delegate = nil
        self.player = nil
    }
    
    private func initializePlayer(){
        guard self.player == nil, let uwIsHost = isHost, uwIsHost else { return }
        self.player = SPTAudioStreamingController.sharedInstance()
        guard let player = self.player else { return }
        player.playbackDelegate = self
        player.delegate = self
        
        try? player.start(withClientId:  Constants.API.Spotify.clientId)
        let (accesstoken, _, _) = AuthDataStore().getAccessInfo()
        player.login(withAccessToken: accesstoken)
    }
    
    private func addCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.previousTrackCommand.isEnabled = false;
        
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget{ [weak self] event -> MPRemoteCommandHandlerStatus in
            guard let sSelf = self else { return .commandFailed }
            sSelf.skip()
            return .success
        }
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget{ [weak self] event -> MPRemoteCommandHandlerStatus in
            guard let sSelf = self else { return .commandFailed }
            sSelf.playPause()
            return .success
        }
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget{ [weak self] event -> MPRemoteCommandHandlerStatus in
            guard let sSelf = self else { return .commandFailed }
            sSelf.playPause()
            return .success
        }
    }
    
    
    
    private func setupView(){
        self.title = String(describing: self.hostName!) + "'s trap"
        self.view.backgroundColor = Constants.Design.Color.Primary.main
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handlePlaylistAction))
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        
        self.view.addSubview(containerView)
        self.view.addSubview(playerView)
        
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: playerView.topAnchor).isActive = true
        
        playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        let vc = VoteViewController()
        voteController = vc
        vc.serverDelegate = self
        vc.roomId = self.roomId
        vc.ref = self.ref
        self.addChild(vc)
        vc.view.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.addSubview(UIView(frame: .zero))
        self.containerView.addSubview(vc.view)
        
        vc.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        vc.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
        vc.view.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        vc.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        
    }
    
    private func updateProgressBar(with value: Float) {
        self.playerView.updateProgressBar(with: value)
    }
    
    private func setNowPlaying(withSong song: Song) {
        self.playerView.isHidden = false 
        self.setInfoCenter(withSong: song, position: "0")
        self.songNow = song
        self.playerView.setNowPlaying(withSong: song)
    }
    
    @objc private func handlePlaylistAction() {
        let playlistViewController = PlaylistViewController()
        playlistViewController.roomId = self.roomId
        playlistViewController.ref = self.ref
        self.navigationController?.present(playlistViewController, animated: true)
    }
    
    private func setInfoCenter(withSong song: Song, position: String ) {
        ImageCache().loadImage(fromUrlString: song.image) {success, image in
            guard success,let image = image else { return }
            self.nowPlayingCenter.nowPlayingInfo = [
                MPMediaItemPropertyTitle: song.title,
                MPMediaItemPropertyAlbumTitle: "Album",
                MPMediaItemPropertyArtist: song.artist,
                MPMediaItemPropertyPlaybackDuration: song.duration/1000,
                MPNowPlayingInfoPropertyElapsedPlaybackTime: position,
                MPNowPlayingInfoPropertyPlaybackRate: 1,
                MPMediaItemPropertyArtwork: MPMediaItemArtwork(image: image)
            ]
        }
        
    }
    
    //MARK: PlayerDelegate DELEGATES
    
    func skip() {
        if let nextSong = self.voteController?.getMostVotedSong() {
            self.playAudio(withSong: nextSong)
        }
    }
    
    func playPause() {
        if let playState = self.player?.playbackState {
            if playState.isPlaying {
                self.player?.setIsPlaying(false){ error in
                    NSLog("paused error:\(String(describing: error))")
                }
                self.playerView.set(isPlaying: false)
            } else {
                self.player?.setIsPlaying(true){ error in
                    NSLog("play error:\(String(describing: error))")
                }
                self.playerView.set(isPlaying: true)
            }
        }
    }
    
    //MARK: ManageServerCommandsProtocol DELEGATES
    
    func playAudio(withSong song: Song) {
        self.setNowPlaying(withSong: song)
        self.addCommandCenter()
        guard let player = self.player,let uwIsHost = self.isHost, uwIsHost else { return }
        self.playerIsPlaying = true
        player.playSpotifyURI(song.songURI, startingWith: 0, startingWithPosition: 0, callback: { (error) in
            guard error == nil else {
                NSLog("Unable to Play")
                return
            }
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback)
                UIApplication.shared.beginReceivingRemoteControlEvents()
                do {
                    try AVAudioSession.sharedInstance().setActive(true)
                    print("AVAudioSession is Active")
                } catch {
                    print(error)
                }
            } catch {
                print(error)
            }
        })
    }
    
    func isPlaying() -> Bool {
        return self.playerIsPlaying
    }
    
    func isRoomHost() -> Bool {
        return self.isHost!
    }
    
    //MARK: SPTAudioSteaming DELEGATES
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController, didChangePosition position: TimeInterval) {
        let duration = Double(self.songNow!.duration/1000)

        if(Double(position) >= duration - 3.0) {
            self.skip()
        } else {
            self.setInfoCenter(withSong: self.songNow!, position: "\(position)")
            self.updateProgressBar(with: Float(Double(position)/(Double(self.songNow!.duration/1000))))
        }
    }
}
