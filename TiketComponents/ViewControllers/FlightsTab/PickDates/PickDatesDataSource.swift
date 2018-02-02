//
//  PickDatesDataSource.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 29/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation

class PickDatesDataSource: ValueCellDataSource {
    
    func loadCalendar(date: Date) {
        self.set(values: [date], cellClass: PickDateCollectionViewCell.self, inSection: 0)
    }
    
    override func configureCell(collectionCell cell: UICollectionViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as PickDateCollectionViewCell, value as Date):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized error: \(type(of: cell)), \(type(of: value))")
        }
    }
}
