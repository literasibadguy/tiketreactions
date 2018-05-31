//
//  CurrencyListDataSource.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 24/05/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit
import TiketKitModels

public final class CurrencyListDataSource: ValueCellDataSource {
    
    public func load(_ currencies: [CurrencyListEnvelope.Currency]) {
        self.set(values: currencies, cellClass: CurrencyListViewCell.self, inSection: 0)
    }
    
    public func currencyAtIndexPath(_ indexPath: IndexPath) -> CurrencyListEnvelope.Currency? {
        return self[indexPath] as? CurrencyListEnvelope.Currency
    }
    
    public override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as CurrencyListViewCell, value as CurrencyListEnvelope.Currency):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized error: \(type(of: cell)), \(type(of: value))")
        }
    }
}
