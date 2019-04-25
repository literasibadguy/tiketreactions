//
//  BookingCompletedDataSource.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 12/06/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import TiketKitModels
import UIKit

public final class BookingCompletedDataSource: ValueCellDataSource {
    
    func load(orderDetail: [OrderCartDetail]) {
        self.set(values: orderDetail, cellClass: FirstIssueViewCell.self, inSection: 0)
        self.set(values: orderDetail, cellClass: SecondIssueViewCell.self, inSection: 1)
    }
    
    override public func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as FirstIssueViewCell, value as OrderCartDetail):
            cell.configureWith(value: value)
        case let (cell as SecondIssueViewCell, value as OrderCartDetail):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized error: \(type(of: cell)), \(type(of: value))")
        }
    }
}
