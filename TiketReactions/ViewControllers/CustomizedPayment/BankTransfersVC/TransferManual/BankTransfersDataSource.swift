//
//  BankTransfersDataSource.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 21/06/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import TiketKitModels

public final class BankTransfersDataSource: ValueCellDataSource {
    

    public func load(_ bankEnvelope: BankTransferPaymentEnvelope) {
        self.set(values: [bankEnvelope], cellClass: ReceiptManualViewCell.self, inSection: 0)
        self.set(values: bankEnvelope.banks, cellClass: ListBankViewCell.self, inSection: 1)
        self.set(values: ["\(bankEnvelope.messages) -- \(Localizations.NoticescreenshotTitle)"], cellClass: NoticeSummaryViewCell.self, inSection: 2)
    }
    
    public override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as ReceiptManualViewCell, value as BankTransferPaymentEnvelope):
            cell.configureWith(value: value)
        case let (cell as ListBankViewCell, value as BankTransferPaymentEnvelope.Bank):
            cell.configureWith(value: value)
        case let (cell as NoticeSummaryViewCell, value as String):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized error: \(type(of: cell)), \(type(of: value))")
        }
    }
}
