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
    @IBOutlet private weak var subtotalPriceLabel: UILabel!
    @IBOutlet private weak var uniqueCodeLabel: UILabel!
    @IBOutlet private weak var totalPriceLabel: UILabel!
    @IBOutlet weak var orderExpiredTime: UILabel!
    
    
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
        
        _ = self.subtotalPriceLabel
            |> UILabel.lens.text .~ "Subtotal: \(Format.symbolForCurrency(AppEnvironment.current.apiService.currency)) \(Format.currency(value.orderResult.subTotal, country: AppEnvironment.current.apiService.currency ))"
        
        _ = self.uniqueCodeLabel
            |> UILabel.lens.text .~ Localizations.UniqueCodeInfo(value.orderResult.uniqueCode)
        
        let expireDate = stringToExpiredPayTime(raw: value.orderResult.expiredTime)
        
        print("IS IT CORRECT FOR EXPIRE TIME: \(value.orderResult.expiredTime)")
        
        _ = self.orderExpiredTime
            |> UILabel.lens.text .~ Localizations.OrderExpireInfo(Format.date(secondsInUTC: expireDate.timeIntervalSince1970, template: "HH:mm")!)
        
        _ = self.totalPriceLabel
            |> UILabel.lens.text .~ "\(Format.symbolForCurrency(AppEnvironment.current.apiService.currency)) \(Format.currency(value.orderResult.grandTotal, country: AppEnvironment.current.apiService.currency ))"
        
    }

}
