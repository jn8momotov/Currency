//
//  SelectCourseController.swift
//  Currency
//
//  Created by Евгений on 23/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit

enum SelectedCurrentCurrency {
    case from
    case to
}

class SelectCourseController: UITableViewController {

    var flagCurrency: SelectedCurrentCurrency = .from
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.shared.currencies.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellCourse", for: indexPath)
        let course = Model.shared.currencies[indexPath.row]
        cell.textLabel?.text = course.name
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let currency = Model.shared.currencies[indexPath.row]
        if flagCurrency == .from {
            Model.shared.fromCurrency = currency
        }
        else {
            Model.shared.toCurrency = currency
        }
        dismiss(animated: true, completion: nil)
    }

}
