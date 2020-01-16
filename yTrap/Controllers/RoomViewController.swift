//
//  RoomViewController.swift
//  yTrap
//
//  Created by Pawan on 2020-01-11.
//  Copyright © 2020 SocialMusic. All rights reserved.
//

import Foundation
import Firebase
class RoomViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var rooms = [Room]()
    private var user: User?
    let ref = Database.database().reference(withPath: "Rooms")
    
    private lazy var myTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .plain)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.delegate = self
        tv.dataSource = self
        tv.backgroundColor = Constants.Design.Color.Primary.main
        tv.tableFooterView = UIView(frame: .zero)
        tv.register(RoomTableViewCell.self, forCellReuseIdentifier: Constants.Content.roomCellIdentifier)
        return tv
    }()
    
    private lazy var profileImageView:UIImageView = {
        let iv = UIImageView()
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileAction))
        iv.image = UIImage(named: "ytrap")
        iv.layer.masksToBounds = true
        iv.isUserInteractionEnabled = true
        iv.addGestureRecognizer(tap)
        return iv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.user = AuthDataStore().getUserData()
        
        self.ref.observe(.value) { snapshot in
            var newRooms = [Room]()
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot,
                    let room = Room(snapshot: snapshot) {
                    newRooms.append(room)
                    
                }
                
            }
            self.rooms = newRooms
            self.myTableView.reloadData()
        }
        ImageCache().loadImage(fromUrlString: self.user?.imageUrl) { success, image in
            guard success else { return }
            self.profileImageView.image = image
        }
        setupView()
    }
    
    
    private func setupView(){
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: self.profileImageView)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleNewRoomAction))
        self.navigationItem.rightBarButtonItem?.tintColor = .white
        
        self.view.backgroundColor = .white
        self.title = "Rooms"
        
        self.view.addSubview(UIView(frame: .zero))
        
        self.view.addSubview(myTableView)
        
        self.profileImageView.layer.cornerRadius = 15
        
        self.profileImageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.profileImageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        myTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        myTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        myTableView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        myTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    @objc private func handleProfileAction() {
        
    }
    
    @objc private func handleNewRoomAction() {
        guard let user = self.user else { return }
        if user.isPremium {
            let room = Room(ownerName: self.user!.userName, imageString: self.user!.imageUrl, id: 0)
            let listRef = ref.child(self.user!.userName)
            listRef.setValue(room.toAnyObject())
            self.transitionToVote(withRoomId: room.id, isHost: true, hostName: room.ownerUserName,roomRef: listRef)
            
        } else {
            let uiAlert = UIAlertController(title: "Oops Sorry", message: "Cannot create room as you are not a spotify premium user. Try joining a room?", preferredStyle: UIAlertController.Style.alert)
            self.present(uiAlert, animated: true, completion: nil)
            uiAlert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: { action in
                uiAlert.dismiss(animated: true)
            }))
        }
    }
    
    private func transitionToVote(withRoomId id: Int, isHost: Bool, hostName: String, roomRef:DatabaseReference?) {
        let playerViewController = PlayerViewController()
        playerViewController.roomId = id
        playerViewController.isHost = isHost
        playerViewController.hostName = hostName
        playerViewController.ref = roomRef
        self.navigationController?.pushViewController(playerViewController, animated: false)
        
    }
    
    private func addUserToRoom(room:Room) {
        let listRef = room.ref?.child("users")
        let newListRef = listRef?.childByAutoId()
        newListRef?.setValue(self.user?.toAnyObject())

        self.transitionToVote(withRoomId: room.id, isHost: self.user?.userName == room.ownerUserName, hostName: room.ownerUserName, roomRef: room.ref)
    }
    
    //MARK:TABLEVIEW DELEGATES
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.addUserToRoom(room: rooms[indexPath.row])
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rooms.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Content.roomCellIdentifier, for: indexPath as IndexPath) as! RoomTableViewCell
        cell.titleLabel.text = "\(rooms[indexPath.row].ownerUserName)'s Trap"
        ImageCache().loadImage(fromUrlString: rooms[indexPath.row].imageUrl) { success, image in
            guard success else { return }
            cell.imgView.image = image
        }
        return cell
    }
}
