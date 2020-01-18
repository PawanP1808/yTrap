//
//  TableView.swift
//  yTrap
//
//  Created by Pawan on 2020-01-16.
//  Copyright © 2020 SocialMusic. All rights reserved.
//

import Foundation

class TableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: .zero, style: .plain)
        self.setupView()
        
    }
    
    convenience init(registerCells: [Register]) {
        self.init(frame: .zero, style: .plain)
        self.setupView()
        self.registerCells(withRegisters: registerCells)
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundColor = Constants.Design.Color.Primary.main
        self.tableFooterView = UIView(frame: .zero)
        
    }
    
    private func registerCells(withRegisters registers: [Register]) {
        for cellRegistor in registers {
            self.register(cellRegistor.cellClass, forCellReuseIdentifier: cellRegistor.identifier)
        }
    }
}
