//
//  DefaultTableViewDelegate.swift
//  yTrap
//
//  Created by Pawan on 2020-01-17.
//  Copyright © 2020 SocialMusic. All rights reserved.
//

import Foundation


class DefaultTableViewDelegate: NSObject, UITableViewDelegate, UITableViewDataSource {
    
    private var data = ["Playlists","Recently Played"]
    var didSelectRow: ((_ item: Int) -> Void)?
    
    override init() {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let didSelectRow = didSelectRow {
            didSelectRow(indexPath.row)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.Content.defaultCellIdentifier, for: indexPath as IndexPath) as! DefaultTableViewCell
        if indexPath.row == 0 {
            cell.setup(withTitle: "Playlists")
        } else if indexPath.row == 1 {
            cell.setup(withTitle: "Recently Played")
        }
        return cell
    }
}
