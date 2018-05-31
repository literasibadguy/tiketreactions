//
//  DestHotelViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 13/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import TiketKitModels
import UIKit

class DestHotelViewCell: UITableViewCell, ValueCell {
    
    typealias Value = AutoHotelResult
    
    @IBOutlet fileprivate weak var destHotelStackView: UIStackView!
    @IBOutlet fileprivate weak var contentStackView: UIStackView!
    
    @IBOutlet fileprivate weak var hotelTitleLabel: UILabel!
    @IBOutlet fileprivate weak var hotelSubtitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        _ = self.hotelTitleLabel
            |> UILabel.lens.font .~ UIFont.boldSystemFont(ofSize: 16.0)
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.hotelSubtitleLabel
            |> UILabel.lens.font .~ UIFont.systemFont(ofSize: 16.0)
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_500
    }
    
    func configureWith(value: AutoHotelResult) {
       _ = self.hotelTitleLabel
        |> UILabel.lens.text .~ value.category
        
        
        _ = self.hotelSubtitleLabel
            |> UILabel.lens.text .~ value.labelLocation

    }
    
}
