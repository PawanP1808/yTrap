//
//  VoteTableViewDelegate.swift
//  yTrap
//
//  Created by Pawan on 2020-01-16.
//  Copyright © 2020 SocialMusic. All rights reserved.
//

import Foundation


class VoteTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private var data = [Song]()
    var delegate: VoteDelegate?
    
    init(withRooms data: [Song]) {
        self.data = data
        
    }
    
    func update(withVotes data : [Song]) {
        self.data = data
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Content.voteCellIdentifier, for: indexPath as IndexPath) as! VoteTableViewCell
        cell.delegate = delegate
        cell.setup(tag: indexPath.row, song: (data[indexPath.row]))
        return cell
    }
}
