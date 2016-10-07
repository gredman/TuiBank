//
//  Payment.swift
//  TuiBank
//
//  Created by Gareth Redman on 8/10/16.
//  Copyright © 2016 Gareth Redman. All rights reserved.
//

import Foundation

struct Payment {
    let source: Account
    let target: Payee
    let amount: NSDecimalNumber
}
