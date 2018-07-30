//
//  DestinationLocationViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 29/05/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import GoogleMaps
import UIKit
import TiketKitModels
import Prelude

public final class DestinationLocationViewCell: UITableViewCell, ValueCell {
    
    public typealias Value = GMSAddress
    
    @IBOutlet fileprivate weak var currentLocationTitleLabel: UILabel!
    @IBOutlet fileprivate weak var currentLocationInputLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        _ = self.currentLocationTitleLabel
            |> UILabel.lens.font .~ UIFont.boldSystemFont(ofSize: 16.0)
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.currentLocationInputLabel
            |> UILabel.lens.font .~ UIFont.systemFont(ofSize: 16.0)
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_500
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configureWith(value: GMSAddress) {
        
        _ = self.currentLocationInputLabel
            |> UILabel.lens.text .~ (value.locality ?? "")
    }
}
