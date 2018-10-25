//
//  ReceiptOrderViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 17/10/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import TiketKitModels
import UIKit

internal final class ReceiptOrderViewCell: UITableViewCell, ValueCell {
    
    typealias Value = InstantTransferPaymentEnvelope
    
    @IBOutlet private weak var orderIdLabel: UILabel!
    @IBOutlet private weak var totalTitleLabel: UILabel!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self
            |> UIView.lens.backgroundColor .~ .tk_fade_green_grey
    }
    
    func configureWith(value: InstantTransferPaymentEnvelope) {
        
        _ = self.orderIdLabel
            |> UILabel.lens.text .~ "Order ID: \(value.orderId)"
        
        _ = self.totalPriceLabel
            |> UILabel.lens.text .~ "\(Format.currency(value.grandTotal, country: AppEnvironment.current.apiService.currency ))"
        
    }

}
