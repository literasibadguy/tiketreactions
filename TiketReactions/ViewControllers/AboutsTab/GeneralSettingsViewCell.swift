//
//  GeneralSettingsViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 23/05/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import UIKit

internal final class GeneralSettingsViewCell: UITableViewCell {
    
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var subtitleLabel: UILabel!
    
    @IBOutlet fileprivate weak var detailGreenArrow: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self.titleLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.subtitleLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
    }
}
