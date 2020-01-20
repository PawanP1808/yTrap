//
//  PlayerView.swift
//  yTrap
//
//  Created by Pawan on 2020-01-17.
//  Copyright © 2020 SocialMusic. All rights reserved.
//

import Foundation

class PlayerView: UIView {
    
    var delegate: PlayerDelegateProtocol?
    
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
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func skip() {
        self.delegate?.skip()
    }
    
    @objc func playPause() {
        self.delegate?.playPause()
    }
    
    func set(isPlaying playing: Bool) {
        if(playing){
            self.playPauseImg.image = Constants.Design.Image.pause?.withRenderingMode(.alwaysTemplate)
        } else {
            self.playPauseImg.image = Constants.Design.Image.play?.withRenderingMode(.alwaysTemplate)
        }
        self.playPauseImg.tintColor = .white
    }
    
    func updateProgressBar(with value: Float) {
        self.progressBar.progress = value
    }
    
    func setNowPlaying(withSong song: Song) {
        self.titleLabel.text = song.title
        self.artistLabel.text = song.artist
        
        ImageCache().loadImage(fromUrlString: song.image) {success, image in
            guard success else { return }
            self.imgView.image = image
        }
    }
    
    private func setupView() {
        self.backgroundColor = Constants.Design.Color.Primary.main
        self.translatesAutoresizingMaskIntoConstraints = false
        self.layer.borderColor = UIColor.white.cgColor
        
        self.addSubview(titleLabel)
        self.addSubview(imgView)
        self.addSubview(artistLabel)
        self.addSubview(progressBar)
        self.addSubview(playPauseImg)
        self.addSubview(skipImg)
        
        self.topAnchor.constraint(equalTo: progressBar.topAnchor).isActive = true
        
        progressBar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        progressBar.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 8).isActive = true
        progressBar.bottomAnchor.constraint(equalTo: imgView.topAnchor, constant: -8).isActive = true
        progressBar.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        imgView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 8).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imgView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -32).isActive = true
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
        playPauseImg.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        playPauseImg.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 8).isActive = true
        
        skipImg.heightAnchor.constraint(equalToConstant: 30).isActive = true
        skipImg.widthAnchor.constraint(equalToConstant: 30).isActive = true
        skipImg.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 40).isActive = true
        skipImg.topAnchor.constraint(equalTo: artistLabel.bottomAnchor, constant: 8).isActive = true
    }
    
}
