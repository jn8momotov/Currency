//
//  SettingsController.swift
//  Currency
//
//  Created by Евгений on 22/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {

    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var showNewCoursesButton: UIButton! {
        didSet {
            showNewCoursesButton.layer.cornerRadius = 5
            showNewCoursesButton.clipsToBounds = true
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func cancelBarButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showNewCoursesButtonPressed(_ sender: UIButton) {
        Model.shared.loadXMLFile(date: datePicker.date)
        dismiss(animated: true, completion: nil)
    }

}
