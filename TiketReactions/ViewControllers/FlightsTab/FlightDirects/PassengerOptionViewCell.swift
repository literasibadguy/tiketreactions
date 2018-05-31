//
//  PassengerOptionViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 30/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit

public protocol PassengerOptionCellDelegate: class {
    func contactOptionPassengerChanged(_ switched: UISwitch)
}

class PassengerOptionViewCell: UITableViewCell, ValueCell {
    
    typealias Value = String
    
    public weak var delegate: PassengerOptionCellDelegate?
    
    @IBOutlet fileprivate weak var optionTitleLabel: UILabel!
    @IBOutlet fileprivate weak var optionSwitch: UISwitch!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configureWith(value: String) {
        
    }
    
    @IBAction internal func contactOptionPassengerChanged(_ sender: UISwitch) {
        self.delegate?.contactOptionPassengerChanged(sender)
    }
    
}
