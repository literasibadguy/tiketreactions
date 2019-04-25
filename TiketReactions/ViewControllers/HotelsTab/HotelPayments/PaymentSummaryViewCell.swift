//
//  PaymentSummaryViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 08/05/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import TiketKitModels
import UIKit

class PaymentSummaryViewCell: UITableViewCell, ValueCell {
    
    typealias Value = MyOrder
    
    @IBOutlet fileprivate weak var orderTitleLabel: UILabel!
    @IBOutlet fileprivate weak var orderIdLabel: UILabel!
    
    @IBOutlet fileprivate weak var summarySeparatorView: UIView!
    
    @IBOutlet fileprivate weak var totalInputLabel: UILabel!
    @IBOutlet fileprivate weak var totalValueLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self.orderTitleLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.orderIdLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.totalInputLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.totalValueLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.summarySeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    func configureWith(value: MyOrder) {
        _ = self.orderIdLabel
            |> UILabel.lens.text .~ value.orderId
        
        _ = self.totalValueLabel
            |> UILabel.lens.text .~ String("\(Format.symbolForCurrency()) \(Format.currency(value.total, country: "IDR"))")
    }
}
