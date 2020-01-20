//
//  Register.swift
//  yTrap
//
//  Created by Pawan on 2020-01-16.
//  Copyright © 2020 SocialMusic. All rights reserved.
//

import Foundation

class Register {
    var cellClass: AnyClass?
    var identifier: String
    init(cellClass: AnyClass?, identifier: String ) {
        self.cellClass = cellClass
        self.identifier = identifier
    }
}
