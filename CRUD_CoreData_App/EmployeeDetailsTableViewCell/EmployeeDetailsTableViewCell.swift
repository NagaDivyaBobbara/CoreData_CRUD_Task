//
//  EmployeeDetailsTableViewCell.swift
//  CRUDApp
//
//  Created by Naga Divya Bobbara on 07/11/24.
//

import UIKit

class EmployeeDetailsTableViewCell: UITableViewCell {

    @IBOutlet weak open var nameLabel: UILabel!
    @IBOutlet weak open var emailLabel: UILabel!
    @IBOutlet weak open var dobLabel: UILabel!
    @IBOutlet weak open var mobileNumberLabel: UILabel!
    
    public static let cellIdentifier = "EmployeeDetailsTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
