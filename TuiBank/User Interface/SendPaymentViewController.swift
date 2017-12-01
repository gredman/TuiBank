//
//  SendPaymentViewController.swift
//  TuiBank
//
//  Created by Gareth Redman on 8/10/16.
//  Copyright © 2016 Gareth Redman. All rights reserved.
//

import UIKit

protocol SendPaymentViewControllerDelegate: class {
    func viewController(_: SendPaymentViewController, didFinishWithPayment: Payment?)
}

class SendPaymentViewController: UITableViewController {
    let numberFormatter = NumberFormatter.currencyFormatter()

    weak var delegate: SendPaymentViewControllerDelegate?
    var account: Account?
    var payee: Payee?
    var amount = NSDecimalNumber(value: 0)

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(onCancel))
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let viewController = segue.destination as? SelectEntityViewController, let identifier = segue.identifier {
            switch identifier {
            case "account":
                viewController.entities = AccountsRepository.instance.accounts
            case "payee":
                viewController.entities = PayeesRepository.instance.payees
            default:
                break
            }
            viewController.delegate = self
        }
    }

    @objc func onCancel(_ sender: AnyObject?) {
        delegate?.viewController(self, didFinishWithPayment: nil)
    }
}

extension SendPaymentViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 2:
            selectPaymentAmount()
            tableView.deselectRow(at: indexPath, animated: true)
        case 3:
            makePayment()
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            break
        }
    }

    private func selectPaymentAmount() {
        let alertController = UIAlertController(title: "Enter the amount", message: nil, preferredStyle: UIAlertControllerStyle.alert)

        alertController.addTextField { (textField) in
            textField.keyboardType = UIKeyboardType.decimalPad
        }
        alertController.show(self, sender: nil)

        let doneAction = UIAlertAction(title: "Done", style: .default) {
            (action) in
            if let text = alertController.textFields?.first?.text,
                let number = Decimal(string: text) {

                self.amount = NSDecimalNumber(decimal: number)
                self.tableView.reloadData()
            }
        }
        alertController.addAction(doneAction)

        present(alertController, animated: true)
    }

    private func makePayment() {
        if let account = account, let payee = payee {
            let payment = Payment(source: account, target: payee, amount: amount)
            PaymentsRepository.instance.append(payment: payment)
            delegate?.viewController(self, didFinishWithPayment: payment)
        }
    }
}

extension SendPaymentViewController {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        switch indexPath.section {
        case 0:
            if account == nil {
                cell.textLabel?.text = "Select an account"
            } else {
                cell.textLabel?.text = account?.name
                cell.imageView?.image = UIImage(named: "accounts")
            }
        case 1:
            if payee == nil {
                cell.textLabel?.text = "Select a payee"
            } else {
                cell.textLabel?.text = payee?.name
                cell.imageView?.image = UIImage(named: "payee")
            }
        case 2:
            cell.textLabel?.text = numberFormatter.string(from: amount)
        default:
            break
        }
        return cell
    }
}

extension SendPaymentViewController: SelectEntityViewControllerDelegate {
    func viewController(_ viewController: SelectEntityViewController, didSelectEntity entity: Entity) {
        _ = navigationController?.popToViewController(self, animated: true)
        if let account = entity as? Account {
            self.account = account
        } else if let payee = entity as? Payee {
            self.payee = payee
        }
        self.tableView.reloadData()
    }
}
