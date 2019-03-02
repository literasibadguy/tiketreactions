//
//  InstantTransfersDataSource.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 16/10/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import TiketKitModels
import UIKit

internal final class InstantTransfersDataSource: ValueCellDataSource {
    
    internal func load(instant: InstantTransferPaymentEnvelope) {
        self.set(values: [instant], cellClass: ReceiptOrderViewCell.self, inSection: 0)
        self.set(values: ["\(instant.message) -- \(Localizations.NoticescreenshotTitle)"], cellClass: NoticeSummaryViewCell.self, inSection: 1)
        self.set(values: instant.steps, cellClass: ATMTransferStepsViewCell.self, inSection: 2)
    }
    
    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as ReceiptOrderViewCell, value as InstantTransferPaymentEnvelope):
            cell.configureWith(value: value)
        case let (cell as NoticeSummaryViewCell, value as String):
            cell.configureWith(value: value)
        case let (cell as ATMTransferStepsViewCell, value as TransferATMSteps):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized error: \(type(of: cell)), \(type(of: value))")
        }
    }
}
