//
//  PhoneCodeListDataSource.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 27/06/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit
import Foundation

public final class PhoneCodeListDataSource: ValueCellDataSource {
    
    public func load(_ countries: [Country]) {
        self.set(values: countries, cellClass: PhoneCodeViewCell.self, inSection: 0)
    }
    
    public func countryCodeAtIndexPath(_ indexPath: IndexPath) -> Country? {
        return self[indexPath] as? Country
    }
    
    
    public override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as PhoneCodeViewCell, value as Country):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized message error: \(cell) \(value)")
        }
    }
}
