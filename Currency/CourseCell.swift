//
//  CourseCell.swift
//  Currency
//
//  Created by Евгений on 23/10/2018.
//  Copyright © 2018 Евгений. All rights reserved.
//

import UIKit

class CourseCell: UITableViewCell {

    @IBOutlet weak var imageFlag: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    func initCoursesCell(with currency: Currency) {
        imageFlag.image = UIImage(named: "\(currency.charCode!)")
        nameLabel.text = currency.name!
        valueLabel.text = currency.value!
    }
    
    func initSelectCourseCell(with currency: Currency) {
        imageFlag.image = UIImage(named: "\(currency.charCode!)")
        nameLabel.text = currency.name!
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
