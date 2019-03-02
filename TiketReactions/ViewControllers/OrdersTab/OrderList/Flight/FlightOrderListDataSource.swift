//
//  FlightOrderListDataSource.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 03/10/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import TiketKitModels
import UIKit

public final class FlightOrderListDataSource: ValueCellDataSource {
    
    public func load(orders: [FlightOrderData]) {
        self.set(values: orders, cellClass: FlightOrderListViewCell.self, inSection: 0)
    }
    
    public func flightOrderAtIndexPath(_ indexPath: IndexPath) -> FlightOrderData? {
        return self[indexPath] as? FlightOrderData
    }
    
    public override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as FlightOrderListViewCell, value as FlightOrderData):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized error: \(type(of: cell)), \(type(of: value))")
        }
    }
}
