//
//  RiwayatBookingViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 07/11/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import UIKit

internal final class RiwayatBookingViewCell: UITableViewCell, ValueCell {
    typealias Value = String
    
    @IBOutlet private weak var bookingSavedLabel: UILabel!
    @IBOutlet private weak var rightArrowLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self.bookingSavedLabel
            |> UILabel.lens.textColor .~ .tk_official_green
        
        _ = self.rightArrowLabel
            |> UILabel.lens.textColor .~ .tk_official_green
    }

    func configureWith(value: String) {
        
    }
}
