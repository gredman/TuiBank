//
//  AccountsRepository.swift
//  TuiBank
//
//  Created by Gareth Redman on 8/10/16.
//  Copyright © 2016 Gareth Redman. All rights reserved.
//

class AccountsRepository {
    let accounts = [
        Account(name: "Cheque", balance: 50.00),
        Account(name: "Savings", balance: 2000.00)
    ]

    static let instance = AccountsRepository()
}
