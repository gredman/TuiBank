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
    let numberFormatter: NumberFormatter

    required init?(coder aDecoder: NSCoder) {
        numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        super.init(coder: aDecoder)
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
