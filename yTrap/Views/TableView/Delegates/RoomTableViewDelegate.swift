//
//  RoomTableViewDelegate.swift
//  yTrap
//
//  Created by Pawan on 2020-01-16.
//  Copyright © 2020 SocialMusic. All rights reserved.
//

import Foundation


class RoomTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private var data = [Room]()
    var didSelectRow: ((_ withDataItem: Room) -> Void)?
    
    init(withRooms data: [Room]) {
        self.data = data
        
    }
    
    func update(withRooms data : [Room]) {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Content.roomCellIdentifier, for: indexPath as IndexPath) as! RoomTableViewCell
        cell.titleLabel.text = "\(data[indexPath.row].ownerUserName)'s Trap"
        ImageCache().loadImage(fromUrlString: data[indexPath.row].imageUrl) { success, image in
            guard success else { return }
            cell.imgView.image = image
        }
        return cell
    }
    
    
}
