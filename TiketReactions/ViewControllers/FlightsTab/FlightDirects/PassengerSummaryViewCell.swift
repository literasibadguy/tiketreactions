//
//  PassengerSummaryViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 30/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import TiketKitModels
import UIKit

class PassengerSummaryViewCell: UITableViewCell, ValueCell {
    
    typealias Value = AdultPassengerParam
    
    @IBOutlet fileprivate weak var titlePassengerLabel: UILabel!
    @IBOutlet fileprivate weak var formSummaryLabel: UILabel!
    @IBOutlet fileprivate weak var detailGreenArrowImageView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWith(value: AdultPassengerParam) {
        
    }
}
