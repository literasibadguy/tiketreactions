//
//  CurrencyListViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 24/05/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import UIKit
import TiketKitModels


public final class CurrencyListViewCell: UITableViewCell, ValueCell {
    
    public typealias Value = CurrencyListEnvelope.Currency
    
    @IBOutlet fileprivate weak var currencyTitleLabel: UILabel!
    @IBOutlet fileprivate weak var currencySubtitleLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configureWith(value: CurrencyListEnvelope.Currency) {
        
        _ = self.currencyTitleLabel
            |> UILabel.lens.text .~ value.code
        
        _ = self.currencySubtitleLabel
            |> UILabel.lens.text .~ value.name
    }
}
