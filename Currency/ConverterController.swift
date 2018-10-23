//
//  ConverterController.swift
//  Currency
//
//  Created by Евгений on 23/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit

class ConverterController: UIViewController {

    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var fromCurrencyButton: UIButton!
    @IBOutlet weak var toCurrencyButton: UIButton!
    
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var toTextField: UITextField!
    
    @IBOutlet var doneBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fromTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        refreshButtons()
        fromTextFieldEditingChanged(self)
        navigationItem.rightBarButtonItem = nil
        dateLabel.text = "Курс за дату: \(Model.shared.currentDate)"
    }
    
    @IBAction func fromCurrencyButtonPressed(_ sender: UIButton) {
        let navController = storyboard?.instantiateViewController(withIdentifier: "navControllerToSelectCourse") as? UINavigationController
        (navController?.viewControllers[0] as? SelectCourseController)?.flagCurrency = .from
        present(navController!, animated: true, completion: nil)
    }
    
    @IBAction func toCurrencyButtonPressed(_ sender: UIButton) {
        let navController = storyboard?.instantiateViewController(withIdentifier: "navControllerToSelectCourse") as? UINavigationController
        (navController?.viewControllers[0] as? SelectCourseController)?.flagCurrency = .to
        present(navController!, animated: true, completion: nil)
    }
    
    @IBAction func doneBarButtonPressed(_ sender: UIBarButtonItem) {
        fromTextField.resignFirstResponder()
        navigationItem.rightBarButtonItem = nil
    }
    
    @IBAction func fromTextFieldEditingChanged(_ sender: Any) {
        let amount = Double(fromTextField.text!)
        toTextField.text = Model.shared.converter(amount: amount)
    }
    
    func refreshButtons() {
        fromCurrencyButton.setTitle(Model.shared.fromCurrency.charCode, for: .normal)
        toCurrencyButton.setTitle(Model.shared.toCurrency.charCode, for: .normal)
    }

}

extension ConverterController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        navigationItem.rightBarButtonItem = doneBarButton
        return true
    }
    
}
