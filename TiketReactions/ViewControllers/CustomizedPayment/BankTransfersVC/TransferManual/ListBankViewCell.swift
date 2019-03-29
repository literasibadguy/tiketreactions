//
//  ListBankViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 21/06/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import UIKit
import TiketKitModels

public final class ListBankViewCell: UITableViewCell, ValueCell {
    
    public typealias Value = BankTransferPaymentEnvelope.Bank
    
    @IBOutlet fileprivate weak var cabangBankLabel: UILabel!
    @IBOutlet fileprivate weak var nameBankLabel: UILabel!
    @IBOutlet fileprivate weak var noRekLabel: UILabel!
    
    @IBOutlet fileprivate weak var transferSeparatorView: UIView!
    @IBOutlet fileprivate weak var bankTransferSeparatorView: UIView!
    
    
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
        
        _ = self.cabangBankLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.nameBankLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.noRekLabel
            |> UILabel.lens.textColor .~ .black
        
        _ = self.transferSeparatorView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.bankTransferSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    public func configureWith(value: BankTransferPaymentEnvelope.Bank) {
        
        print("Configured With: \(value)")
        
        _ = self.nameBankLabel
            |> UILabel.lens.text .~ "\(value.bankName) - \(value.bankBranch)"
        
        _ = self.cabangBankLabel
            |> UILabel.lens.text .~ "an \(value.bankOwner)"
        
        _ = self.noRekLabel
            |> UILabel.lens.text .~ "No. Rekening: \(value.bankAccount)"
        
    }
    
}
