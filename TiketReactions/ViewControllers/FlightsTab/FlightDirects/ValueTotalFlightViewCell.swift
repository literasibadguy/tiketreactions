//
//  ValueTotalFlightViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 23/08/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit
import Prelude
import TiketKitModels

public final class ValueTotalFlightViewCell: UITableViewCell, ValueCell {
    
    public typealias Value = String
    
    @IBOutlet fileprivate weak var totalPassengersLabel: UILabel!
    @IBOutlet fileprivate weak var totalPriceStackView: UIStackView!
    @IBOutlet fileprivate weak var totalTitleLabel: UILabel!
    @IBOutlet fileprivate weak var totalPriceValueLabel: UILabel!
    @IBOutlet fileprivate weak var valueSeparatorView: UIView!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.valueSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    public func configureWith(value: String) {
        _ = self.totalPriceValueLabel
            |> UILabel.lens.text .~ value
    }
    
}
