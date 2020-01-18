//
//  VoteTableViewCell.swift
//  yTrap
//
//  Created by Pawan on 2020-01-12.
//  Copyright © 2020 SocialMusic. All rights reserved.
//

import Foundation
import UIKit

class VoteTableViewCell: UITableViewCell {
    
    var delegate: VoteDelegate?
    
    lazy var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.backgroundColor = UIColor.lightGray
        return imgView
    }()
    
    lazy var titleLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.adjustsFontSizeToFitWidth = true
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = .white
        lbl.font = Constants.Design.Font.cellTitleTxt
        return lbl
    }()
    
    lazy var upVote: UIImageView = {
        let imgView = UIImageView()
        imgView.tag = 0
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.backgroundColor = UIColor.clear
        imgView.image = Constants.Design.Image.up
        return imgView
    }()
    
    lazy var downVote: UIImageView = {
        let imgView = UIImageView()
        imgView.tag = 1
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.backgroundColor = UIColor.clear
        imgView.image = Constants.Design.Image.down
        return imgView
    }()
    
    lazy var votelbl: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.backgroundColor = UIColor.clear
        lbl.textColor = .white
        lbl.text = "0"
        lbl.textAlignment = .center
        lbl.font = Constants.Design.Font.cellTitleTxt
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        backgroundColor = Constants.Design.Color.Primary.main
        
        contentView.backgroundColor = Constants.Design.Color.Primary.main
        
        contentView.addSubview(imgView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(upVote)
        contentView.addSubview(downVote)
        contentView.addSubview(votelbl)
        
        imgView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imgView.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imgView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        imgView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8).isActive = true
        
        titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        titleLabel.leadingAnchor.constraint(equalTo: imgView.trailingAnchor, constant: 20).isActive = true
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        titleLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        upVote.widthAnchor.constraint(equalToConstant: 25).isActive = true
        upVote.heightAnchor.constraint(equalToConstant: 25).isActive = true
        upVote.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        upVote.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        downVote.widthAnchor.constraint(equalToConstant: 25).isActive = true
        downVote.heightAnchor.constraint(equalToConstant: 25).isActive = true
        downVote.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        downVote.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
        votelbl.widthAnchor.constraint(equalToConstant: 25).isActive = true
        votelbl.heightAnchor.constraint(equalToConstant: 25).isActive = true
        votelbl.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        votelbl.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10).isActive = true
        
    }
    
    func setup(tag: Int, song: Song) {
        self.titleLabel.text = song.title
        self.votelbl.text = "\(song.votes)"
        self.tag = tag
        ImageCache().loadImage(fromUrlString: song.image) { success, image in
            guard success else { return }
            self.imgView.image = image
        }
        self.addGestures(tag: tag)
    }
    
    @objc func handleVote(_ sender:AnyObject) {
        guard let canUpdate = self.delegate?.canUpdate(forIndex: self.tag), canUpdate else { return }
        let voteIndex = sender.view.tag
        if(voteIndex == 1) {
            //downvote
            self.votelbl.text = "\(Int(self.votelbl.text!)! - 1)"
            self.delegate?.vote(withIndex: self.tag, vote: .down)
            
        } else {
            //upvote
            self.votelbl.text = "\(Int(self.votelbl.text!)! + 1)"
            self.delegate?.vote(withIndex: self.tag, vote: .up)
        }
        
    }
    
    private func addGestures(tag:Int){
        self.upVote.isUserInteractionEnabled = true
        self.downVote.isUserInteractionEnabled = true
        let tapped:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleVote(_:)))
        let tappedDownVote:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleVote(_:)))
        tapped.numberOfTapsRequired = 1
        tappedDownVote.numberOfTapsRequired = 1
        self.upVote.addGestureRecognizer(tapped)
        self.downVote.addGestureRecognizer(tappedDownVote)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
