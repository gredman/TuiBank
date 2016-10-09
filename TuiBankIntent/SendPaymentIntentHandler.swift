//
//  SendPaymentIntentHandler.swift
//  TuiBank
//
//  Created by Gareth Redman on 8/10/16.
//  Copyright © 2016 Gareth Redman. All rights reserved.
//

import Intents

extension Payee {
    func asINPerson() -> INPerson {
        let handle = INPersonHandle(value: self.name, type: .unknown)
        return INPerson(personHandle: handle, nameComponents: PersonNameComponents(), displayName: self.name, image: nil, contactIdentifier: nil, customIdentifier: nil)
    }
}

class SendPaymentIntentHandler: INExtension {
}

extension SendPaymentIntentHandler: INSendPaymentIntentHandling {
    func handle(sendPayment intent: INSendPaymentIntent, completion: @escaping (INSendPaymentIntentResponse) -> Void) {
        let response: INSendPaymentIntentResponse

        if let displayName = intent.payee?.displayName,
            let payee = PayeesRepository.instance.payee(withName: displayName),
            let account = AccountsRepository.instance.accounts.first,
            let amount = intent.currencyAmount?.amount {

            if amount.decimalValue < 100 {
                let payment = Payment(source: account, target: payee, amount: amount)
                PaymentsRepository.instance.append(payment: payment)

                NSLog("successfully handled")
                response = INSendPaymentIntentResponse(code: .success, userActivity: nil)
            } else {
                let userActivity = NSUserActivity(activityType: "payment")
                userActivity.userInfo = [
                    "source_name": account.name,
                    "target_name": payee.name,
                    "amount": amount
                ]
                response = INSendPaymentIntentResponse(code: .failureRequiringAppLaunch, userActivity: userActivity)
            }
        } else {
            NSLog("unsuccessfully handled")
            response = INSendPaymentIntentResponse(code: .failure, userActivity: nil)
        }

        completion(response)
    }

    func confirm(sendPayment intent: INSendPaymentIntent, completion: @escaping (INSendPaymentIntentResponse) -> Void) {
        let response: INSendPaymentIntentResponse

        if let displayName = intent.payee?.displayName,
            let payee = PayeesRepository.instance.payee(withName: displayName),
            let account = AccountsRepository.instance.accounts.first,
            let amount = intent.currencyAmount?.amount {

            NSLog("successfully confirmed")
            response = INSendPaymentIntentResponse(code: .success, userActivity: nil)


//            let userActivity = NSUserActivity(activityType: "payment")
//            userActivity.userInfo = [
//                "source_name": account.name,
//                "target_name": payee.name,
//                "amount": amount
//            ]
//            response = INSendPaymentIntentResponse(code: .failureRequiringAppLaunch, userActivity: userActivity)
        } else {
            NSLog("unsuccessfully confirmed")
            response = INSendPaymentIntentResponse(code: .failure, userActivity: nil)
        }
        
        completion(response)
    }

    func resolvePayee(forSendPayment intent: INSendPaymentIntent, with completion: @escaping (INPersonResolutionResult) -> Void) {
        let result: INPersonResolutionResult
        if let displayName = intent.payee?.displayName {
            if PayeesRepository.instance.payee(withName: displayName) != nil {
                result = INPersonResolutionResult.success(with: intent.payee!)
            } else {
                let persons = PayeesRepository.instance.payees.map { $0.asINPerson() }
                result = INPersonResolutionResult.disambiguation(with: persons)
            }
        } else {
            result = INPersonResolutionResult.needsValue()
        }
        completion(result)
    }

    func resolveCurrencyAmount(forSendPayment intent: INSendPaymentIntent, with completion: @escaping (INCurrencyAmountResolutionResult) -> Void) {
        let result: INCurrencyAmountResolutionResult
        if let currencyAmount = intent.currencyAmount,
            let dollarAmount = currencyAmount.amount,
            let currencyCode = currencyAmount.currencyCode,
            currencyCode == "NZD" {

            NSLog("successfully resolved \(currencyCode)\(dollarAmount)")
            result = INCurrencyAmountResolutionResult.success(with: currencyAmount)
        } else {
            NSLog("amount is needed")
            result = INCurrencyAmountResolutionResult.needsValue()
        }
        completion(result)
    }
}
