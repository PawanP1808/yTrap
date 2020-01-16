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

class PlayerViewController: UIViewController, ManageServerCommandsProtocol, SPTAudioStreamingPlaybackDelegate, SPTAudioStreamingDelegate {
    
    var roomId: Int?
    var isHost: Bool?
    var hostName: String?
    var ref: DatabaseReference?
    
    var songNow: Song?
    
    private let info = MPNowPlayingInfoCenter.default()
    
    private var playerIsPlaying = false
    
    var voteController: VoteViewController?
    
    private var player: SPTAudioStreamingController?
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var playerView: UIView = {
        let view = UIView()
        view.backgroundColor = Constants.Design.Color.Primary.main
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.borderColor = UIColor.white.cgColor
        view.isHidden = true
        return view
    }()
    
    private lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.backgroundColor = UIColor.clear
        return imgView
    }()
    
    private lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = .white
        lbl.font = Constants.Design.Font.cellTitleTxt
        return lbl
    }()
    
    private lazy var artistLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = .white
        lbl.font = Constants.Design.Font.cellTitleTxt
        return lbl
    }()
    
    private lazy var progressBar: UIProgressView = {
        let bar = UIProgressView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.progressTintColor = UIColor.white
        
        return bar
    }()
    
    private lazy var playPauseImg: UIImageView = {
        let imgView = UIImageView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(playPause))
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.backgroundColor = UIColor.clear
        imgView.isUserInteractionEnabled = true
        imgView.image = Constants.Design.Image.pause?.withRenderingMode(.alwaysTemplate)
        imgView.tintColor = .white
        
        imgView.addGestureRecognizer(tap)
        return imgView
    }()
    
    private lazy var skipImg: UIImageView = {
         let imgView = UIImageView()
         let tap = UITapGestureRecognizer(target: self, action: #selector(skip))
         imgView.translatesAutoresizingMaskIntoConstraints = false
         imgView.backgroundColor = UIColor.clear
         imgView.isUserInteractionEnabled = true
        imgView.image = Constants.Design.Image.skip?.withRenderingMode(.alwaysTemplate)
         imgView.tintColor = .white
         imgView.addGestureRecognizer(tap)
         return imgView
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
        
        self.view.addSubview(containerView)
        self.view.addSubview(playerView)
        self.playerView.addSubview(titleLabel)
        self.playerView.addSubview(imgView)
        self.playerView.addSubview(artistLabel)
        self.playerView.addSubview(progressBar)
        self.playerView.addSubview(playPauseImg)
        self.playerView.addSubview(skipImg)
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handlePlaylistAction))
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        
        containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        containerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        containerView.bottomAnchor.constraint(equalTo: playerView.topAnchor).isActive = true
        
        playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        playerView.topAnchor.constraint(equalTo: progressBar.topAnchor).isActive = true
        playerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        progressBar.leadingAnchor.constraint(equalTo: playerView.leadingAnchor, constant: 8).isActive = true
        progressBar.trailingAnchor.constraint(equalTo: playerView.trailingAnchor, constant: 8).isActive = true
        progressBar.bottomAnchor.constraint(equalTo: imgView.topAnchor, constant: -8).isActive = true
        progressBar.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        imgView.leadingAnchor.constraint(equalTo: playerView.leadingAnchor, constant: 8).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imgView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        titleLabel.topAnchor.constraint(equalTo: imgView.topAnchor, constant: 0).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 20).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        artistLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8).isActive = true
        artistLabel.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 20).isActive = true
        artistLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        artistLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        playPauseImg.heightAnchor.constraint(equalToConstant: 30).isActive = true
        playPauseImg.widthAnchor.constraint(equalToConstant: 30).isActive = true
        playPauseImg.centerXAnchor.constraint(equalTo: playerView.centerXAnchor).isActive = true
        playPauseImg.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 8).isActive = true
        
        skipImg.heightAnchor.constraint(equalToConstant: 30).isActive = true
        skipImg.widthAnchor.constraint(equalToConstant: 30).isActive = true
        skipImg.centerXAnchor.constraint(equalTo: playerView.centerXAnchor, constant: 40).isActive = true
        skipImg.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 8).isActive = true
        
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
    
    @objc private func handlePlaylistAction() {
        let playlistViewController = PlaylistViewController()
        playlistViewController.roomId = self.roomId
        playlistViewController.serverDelegate = self
        playlistViewController.ref = self.ref
        self.navigationController?.present(playlistViewController, animated: true)
    }
    
    func audioStreaming(_ audioStreaming: SPTAudioStreamingController, didChangePosition position: TimeInterval) {
        print("position \(position)")
        print("duration \(Double(self.songNow!.duration/1000))")
        
        if(Double(position) >= Double(self.songNow!.duration/1000) - 3.0) {
            self.voteController?.getSong()
        } else {
            self.setInfoCenter(withSong: self.songNow!, position: "\(position)")
            self.updateProgressBar(with: Float(Double(position)/(Double(self.songNow!.duration/1000))))
        }
    }
    
    
    
    
    //MARK: ManageServerCommandsProtocol DELEGATES
    
    func updateProgressBar(with value: Float) {
        self.progressBar.progress = value
        
    }
    
    func setNowPlaying(withSong song: Song) {
        self.playerView.isHidden = false 
        self.setInfoCenter(withSong: song, position: "0")
        self.titleLabel.text = song.title
        self.artistLabel.text = song.artist
        self.songNow = song
        ImageCache().loadImage(fromUrlString: song.image) {success, image in
            guard success else { return }
            self.imgView.image = image
        }
    }
    
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
    
    func setInfoCenter(withSong song: Song, position: String ) {
        ImageCache().loadImage(fromUrlString: song.image) {success, image in
            guard success,let image = image else { return }
            self.info.nowPlayingInfo = [
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
    
    @objc func skip() {
        self.voteController?.getSong()
    }
    
    @objc func playPause() {
        if let playState = self.player?.playbackState {
            if playState.isPlaying {
                self.player?.setIsPlaying(false){ error in
                    NSLog("paused error:\(String(describing: error))")
                }
                self.playPauseImg.image = Constants.Design.Image.play?.withRenderingMode(.alwaysTemplate)
            } else {
                self.player?.setIsPlaying(true){ error in
                    NSLog("play error:\(String(describing: error))")
                }
                self.playPauseImg.image = Constants.Design.Image.pause?.withRenderingMode(.alwaysTemplate)
              
            }
        }
          self.playPauseImg.tintColor = .white
    }
    
    
    
    func isPlaying() -> Bool {
        return self.playerIsPlaying
    }
    
    func isRoomHost() -> Bool {
        return self.isHost!
    }

    func getRoomId()-> Int {
        return self.roomId!
    }
}
