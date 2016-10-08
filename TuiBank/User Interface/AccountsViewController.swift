//
//  AccountsViewController.swift
//  TuiBank
//
//  Created by Gareth Redman on 8/10/16.
//  Copyright © 2016 Gareth Redman. All rights reserved.
//

import UIKit

class AccountsViewController: UITableViewController {
    let repository = AccountsRepository.instance
    let numberFormatter = NumberFormatter.currencyFormatter()
}

extension AccountsViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repository.accounts.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "account", for: indexPath)
        let account = repository.accounts[indexPath.row]
        cell.textLabel?.text = account.name
        cell.detailTextLabel?.text = numberFormatter.string(from: account.balance)
        return cell
    }
}
