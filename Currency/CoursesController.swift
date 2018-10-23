//
//  CoursesController.swift
//  Currency
//
//  Created by Евгений on 22/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit

class CoursesController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("startLoadXML"), object: nil, queue: nil) { (notification) in
            DispatchQueue.main.async {
                let activityIndicator = UIActivityIndicatorView(style: .gray)
                activityIndicator.startAnimating()
                self.navigationItem.rightBarButtonItem?.customView = activityIndicator
            }
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name.init("dataUpdate"), object: nil, queue: nil) { (notification) in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.navigationItem.title = Model.shared.currentDate
                let barButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: nil, action: #selector(self.refreshCoursesBarButtonPressed(_:)))
                self.navigationItem.rightBarButtonItem = barButtonItem
            }
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name("errorLoadingXML"), object: nil, queue: nil) { (notification) in
            let error = notification.userInfo!["error"]
            DispatchQueue.main.async {
                let alertController = UIAlertController(title: "Ошибка", message: (error as! String), preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true, completion: nil)
                let barButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.refresh, target: nil, action: #selector(self.refreshCoursesBarButtonPressed(_:)))
                self.navigationItem.rightBarButtonItem = barButtonItem
            }
        }
        navigationItem.title = Model.shared.currentDate
    }
    
    @IBAction func refreshCoursesBarButtonPressed(_ sender: UIBarButtonItem) {
        Model.shared.loadXMLFile(date: nil)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Model.shared.currencies.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "idCoursesCell", for: indexPath)
        let course = Model.shared.currencies[indexPath.row]
        cell.textLabel?.text = course.name
        cell.detailTextLabel?.text = course.value
        return cell
    }

}
