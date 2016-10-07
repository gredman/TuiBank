//
//  PayeesViewController.swift
//  TuiBank
//
//  Created by Gareth Redman on 8/10/16.
//  Copyright © 2016 Gareth Redman. All rights reserved.
//

import UIKit

class PayeesViewController: UITableViewController {
    internal let repository = PayeesRepository.instance
}

extension PayeesViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repository.payees.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "payee", for: indexPath)
        let payee = repository.payees[indexPath.row]
        cell.textLabel?.text = payee.name
        return cell
    }
}
