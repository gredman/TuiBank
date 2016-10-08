//
//  Entity.swift
//  TuiBank
//
//  Created by Gareth Redman on 8/10/16.
//  Copyright © 2016 Gareth Redman. All rights reserved.
//

import UIKit

protocol Entity {
    var name: String { get }
    var imageName: String { get }
}

extension Account: Entity {
    var imageName: String {
        return "accounts"
    }
}

extension Payee: Entity {
    var imageName: String {
        return "payee"
    }
}
