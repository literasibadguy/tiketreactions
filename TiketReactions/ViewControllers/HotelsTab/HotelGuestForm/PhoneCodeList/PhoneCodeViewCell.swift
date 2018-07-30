//
//  PhoneCodeViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 28/06/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import UIKit

public final class PhoneCodeViewCell: UITableViewCell, ValueCell {
    
    public typealias Value = Country
    
    @IBOutlet fileprivate weak var phoneCodeStackView: UIStackView!
    @IBOutlet fileprivate weak var countryNameLabel: UILabel!
    @IBOutlet fileprivate weak var countryCodeLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.countryNameLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.countryCodeLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
    }
    
    public func configureWith(value: Country) {
        
        _ = self.countryNameLabel
            |> UILabel.lens.text .~ value.name!
        
        _ = self.countryCodeLabel
            |> UILabel.lens.text .~ value.phoneCode!
    }
}
