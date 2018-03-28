//
//  DestHotelViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 13/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import TiketAPIs
import UIKit

class DestHotelViewCell: UITableViewCell, ValueCell {
    
    typealias Value = AutoHotelResult
    
    @IBOutlet fileprivate weak var destHotelStackView: UIStackView!
    @IBOutlet fileprivate weak var contentStackView: UIStackView!
    
    @IBOutlet fileprivate weak var hotelTitleLabel: UILabel!
    @IBOutlet fileprivate weak var hotelSubtitleLabel: UILabel!
    @IBOutlet fileprivate weak var hotelTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configureWith(value: AutoHotelResult) {
       _ = self.hotelTitleLabel
        |> UILabel.lens.text .~ value.category
        
        
        _ = self.hotelSubtitleLabel
            |> UILabel.lens.text .~ value.labelLocation
        
        _ = self.hotelTypeLabel
            |> UILabel.lens.isHidden .~ true
        
    }
    
}
