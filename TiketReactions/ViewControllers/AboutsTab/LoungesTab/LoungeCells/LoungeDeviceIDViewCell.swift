//
//  LoungeDeviceIDViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 07/11/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import UIKit

class LoungeDeviceIDViewCell: UITableViewCell, ValueCell {
    
    typealias Value = String
    
    @IBOutlet private weak var deviceIDTitleLabel: UILabel!
    @IBOutlet private weak var deviceIDValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
    
    func configureWith(value: String) {
        _ = self.deviceIDValueLabel
            |> UILabel.lens.text .~ value
    }
    
}
