//
//  OrderListDataSource.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 24/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import TiketKitModels
import UIKit

public final class OrderListDataSource: ValueCellDataSource {
    
    public func load(orders: [OrderData]) {
        self.set(values: orders, cellClass: OrderListViewCell.self, inSection: 0)
    }
    
    public override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as OrderListViewCell, value as OrderData):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized error: \(type(of: cell)), \(type(of: value))")
        }
    }
}
