//
//  HotelPaymentViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 22/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import TiketKitModels
import UIKit

class HotelPaymentViewCell: UITableViewCell, ValueCell {
    
    typealias Value = AvailablePaymentEnvelope.AvailablePayment
    
    
    @IBOutlet fileprivate weak var payDesignableView: UIView!
    
    @IBOutlet fileprivate weak var titlePaymentLabel: UILabel!
    @IBOutlet fileprivate weak var availablePaymentStackView: UIStackView!
    
    // AVAILABLE PAYMENTS
    @IBOutlet fileprivate weak var pay1ImageView: UIImageView!
    @IBOutlet fileprivate weak var pay2ImageView: UIImageView!
    
    @IBOutlet fileprivate weak var pay1WidthConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var pay1HeightConstraint: NSLayoutConstraint!
    
    @IBOutlet fileprivate weak var pay2WidthConstraint: NSLayoutConstraint!
    @IBOutlet fileprivate weak var pay2HeightConstraint: NSLayoutConstraint!
    
    @IBOutlet fileprivate weak var pay3ImageView: UIImageView!
    @IBOutlet fileprivate weak var pay4ImageView: UIImageView!
    
    @IBOutlet fileprivate weak var paymentSeparatorView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindStyles() {
        super.bindStyles()
        
//        self.payDesignableView.borderColor = .tk_base_grey_100
        
        _ = self.titlePaymentLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.paymentSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    func configureWith(value: AvailablePaymentEnvelope.AvailablePayment) {
        
        _ = self.titlePaymentLabel
            |> UILabel.lens.text .~ value.text
        
        paymentsImageAvailable(pay: value.text)
    }
    
    private func paymentsImageAvailable(pay: String) {
        switch pay {
        case "Kartu Kredit":
            _ = self.pay1ImageView
                |> UIImageView.lens.image .~ UIImage(named: "visa-logo")
            _ = self.pay2ImageView
                |> UIImageView.lens.image .~ UIImage(named: "mastercard-logo")

            break
        case "Transfer":
            _ = self.pay1ImageView
                |> UIImageView.lens.image .~ UIImage(named: "bank-mandiri-logo")
            _ = self.pay2ImageView
                |> UIImageView.lens.image .~ UIImage(named: "bank-bca-logo")
            _ = self.pay3ImageView
                |> UIImageView.lens.image .~ UIImage(named: "bank-bni-logo")
            _ = self.pay4ImageView
                |> UIImageView.lens.image .~ UIImage(named: "bank-bri-logo")
            
            break
        case "ATM":
            _ = self.pay1ImageView
                |> UIImageView.lens.image .~ UIImage(named: "atm-bersama-logo")
            _ = self.pay2ImageView
                |> UIImageView.lens.image .~ UIImage(named: "alto-logo")
            _ = self.pay3ImageView
                |> UIImageView.lens.image .~ UIImage(named: "prima-logo")
            
            break
        case "KlikBCA":
            _ = self.pay1ImageView
                |> UIImageView.lens.image .~ UIImage(named: "klikbca-logo")
            
            break
        case "BCA KlikPay":
            _ = self.pay1ImageView
                |> UIImageView.lens.image .~ UIImage(named: "bca-klikpay-logo")
            break
            
        case "Mandiri Clickpay":
            _ = self.pay1ImageView
                |> UIImageView.lens.image .~ UIImage(named: "mandiri-clickpay-logo")

            break
            
        case "CIMB Clicks":
            _ = self.pay1ImageView
                |> UIImageView.lens.image .~ UIImage(named: "cimb-clicks-logo")
            
            break
            
        case "ePay BRI":
            _ = self.pay1ImageView
                |> UIImageView.lens.image .~ UIImage(named: "bank-bri-logo")
            _ = self.pay2ImageView
                |> UIImageView.lens.image .~ UIImage(named: "")
            
            break
        default: break
            
        }
    }
}
