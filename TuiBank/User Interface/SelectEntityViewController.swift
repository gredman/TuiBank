//
//  SelectEntityViewController.swift
//  TuiBank
//
//  Created by Gareth Redman on 8/10/16.
//  Copyright © 2016 Gareth Redman. All rights reserved.
//

import UIKit

protocol SelectEntityViewControllerDelegate: class {
    func viewController(_ viewController: SelectEntityViewController, didSelectEntity entity: Entity)
}

class SelectEntityViewController: UITableViewController {
    weak var delegate: SelectEntityViewControllerDelegate?
    var entities = [Entity]()
}

extension SelectEntityViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return entities.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "entity", for: indexPath)
        let entity = entities[indexPath.row]
        cell.textLabel?.text = entity.name
        cell.imageView?.image = UIImage(named: entity.imageName)
        return cell
    }
}

extension SelectEntityViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entity = entities[indexPath.row]
        delegate?.viewController(self, didSelectEntity: entity)
    }
}
