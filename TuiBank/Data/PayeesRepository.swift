//
//  PayeesRepository.swift
//  TuiBank
//
//  Created by Gareth Redman on 8/10/16.
//  Copyright © 2016 Gareth Redman. All rights reserved.
//

class PayeesRepository {
    let payees = [
        Payee(name: "Alfaaz"),
        Payee(name: "Matthew"),
        Payee(name: "Nick"),
        Payee(name: "Reginald"),
        Payee(name: "Stephen")
    ]

    func payee(withName name: String) -> Payee? {
        return payees.first { $0.name == name }
    }

    static let instance = PayeesRepository()
}
