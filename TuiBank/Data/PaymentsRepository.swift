//
//  PaymentsRepository.swift
//  TuiBank
//
//  Created by Gareth Redman on 8/10/16.
//  Copyright © 2016 Gareth Redman. All rights reserved.
//

import Foundation

private extension Payment {
    init(dictionary: Dictionary<String, AnyObject>) {
        let sourceName = dictionary["source_name"] as! String
        let sourceBalance = NSDecimalNumber(decimal: (dictionary["source_balance"] as! NSNumber).decimalValue)
        let targetName = dictionary["target_name"] as! String
        let amount = NSDecimalNumber(decimal: (dictionary["amount"] as! NSNumber).decimalValue)

        let source = Account(name: sourceName, balance: sourceBalance)
        let target = Payee(name: targetName)
        self.init(source: source, target: target, amount: amount)
    }

    func asDictionary() -> Dictionary<String, AnyObject> {
        return [
            "source_name": source.name as AnyObject,
            "source_balance": source.balance,
            "target_name": target.name as AnyObject,
            "amount": amount
        ]
    }
}

class PaymentsRepository {
    private let userDefaults = UserDefaults.standard
    private let key = "payments"

    private(set) var payments: [Payment]

    init() {
        if let array = userDefaults.array(forKey: key) {
            self.payments = array.map({ Payment(dictionary: $0 as! Dictionary<String, AnyObject>) })
        } else {
            payments = []
        }
    }
    
    func append(payment: Payment) {
        payments.append(payment)

        let array = payments.map { $0.asDictionary() }
        userDefaults.set(array, forKey: key)
        userDefaults.synchronize()
    }

    static let instance = PaymentsRepository()
}
