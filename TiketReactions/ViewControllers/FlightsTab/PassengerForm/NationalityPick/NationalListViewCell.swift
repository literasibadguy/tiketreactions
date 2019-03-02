//
//  NationalListViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 30/01/19.
//  Copyright © 2019 Firas Rafislam. All rights reserved.
//

import UIKit
import Prelude
import TiketKitModels

public final class NationalListViewCell: UITableViewCell, ValueCell {
    
    public typealias Value = CountryListEnvelope.ListCountry
    
    @IBOutlet fileprivate weak var nationalTitleLabel: UILabel!
    @IBOutlet fileprivate weak var nationalSubtitleLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configureWith(value: CountryListEnvelope.ListCountry) {
        
        _ = self.nationalTitleLabel
            |> UILabel.lens.text .~ value.countryName
        
        _ = self.nationalSubtitleLabel
            |> UILabel.lens.text .~ value.countryId
    }

}
