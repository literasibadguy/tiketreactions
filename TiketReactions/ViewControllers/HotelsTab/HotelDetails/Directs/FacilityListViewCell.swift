//
//  FacilityListViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 25/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import UIKit

internal final class FacilityListViewCell: UITableViewCell, ValueCell {
    
    typealias Value = String
    
    @IBOutlet fileprivate weak var facilityTitleLabel: UILabel!
    @IBOutlet fileprivate weak var facilitySeparatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindStyles() {
        _ = self.facilityTitleLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
            |> UILabel.lens.text .~ Localizations.FacilityHotelTitle
        
        _ = self.facilitySeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    
    func configureWith(value: String) {
        
    }
}
