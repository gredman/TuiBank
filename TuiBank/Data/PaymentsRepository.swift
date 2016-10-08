//
//  PaymentsRepository.swift
//  TuiBank
//
//  Created by Gareth Redman on 8/10/16.
//  Copyright © 2016 Gareth Redman. All rights reserved.
//

class PaymentsRepository {
    var payments = [
        Payment(source: AccountsRepository.instance.accounts.last!, target: PayeesRepository.instance.payees.last!, amount: 2.50)
    ]

    static let instance = PaymentsRepository()
}
