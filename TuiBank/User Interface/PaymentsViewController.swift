//
//  PaymentsViewController.swift
//  TuiBank
//
//  Created by Gareth Redman on 8/10/16.
//  Copyright © 2016 Gareth Redman. All rights reserved.
//

import UIKit

class PaymentsViewController: UITableViewController {
    let repository = PaymentsRepository.instance
    let numberFormatter = NumberFormatter.currencyFormatter()

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navigationController = segue.destination as? UINavigationController,
            let viewController = navigationController.topViewController as? SendPaymentViewController {
            
            viewController.delegate = self

            if let userActivity = sender as? NSUserActivity,
                let sourceName = userActivity.userInfo?["source_name"] as? String,
                let targetName = userActivity.userInfo?["target_name"] as? String,
                let amount = (userActivity.userInfo?["amount"] as? NSNumber)?.decimalValue,
                let source = AccountsRepository.instance.accounts.first(where: { $0.name == sourceName }),
                let target = PayeesRepository.instance.payee(withName: targetName) {

                viewController.account = source
                viewController.payee = target
                viewController.amount = NSDecimalNumber(decimal: amount)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        repository.reloadData()
        tableView.reloadData()
    }

    func showPayment(for userActivity: NSUserActivity) {
        performSegue(withIdentifier: "payment", sender: userActivity)
    }
}

extension PaymentsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repository.payments.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "payment", for: indexPath)
        let payment = repository.payments[indexPath.row]
        cell.textLabel?.text = payment.target.name
        cell.detailTextLabel?.text = numberFormatter.string(for: payment.amount)
        return cell
    }
}

extension PaymentsViewController: SendPaymentViewControllerDelegate {
    func viewController(_ viewController: SendPaymentViewController, didFinishWithPayment: Payment?) {
        viewController.dismiss(animated: true) { 
            self.tableView.reloadData()
        }
    }
}
