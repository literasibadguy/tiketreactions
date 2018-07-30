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
    

    public func load(_ banks: [BankTransferPaymentEnvelope.Bank]) {
        
        self.set(values: banks, cellClass: ListBankViewCell.self, inSection: 0)
    }
    
    public override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
            case let (cell as ListBankViewCell, value as BankTransferPaymentEnvelope.Bank):
                cell.configureWith(value: value)
            default:
                fatalError("Unrecognized error: \(type(of: cell)), \(type(of: value))")
        }
    }
}
