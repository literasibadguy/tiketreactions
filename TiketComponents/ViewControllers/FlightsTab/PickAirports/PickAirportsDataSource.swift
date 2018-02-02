//
//  PickAirportsDataSource.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 28/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation

internal final class PickAirportsDataSource: ValueCellDataSource {
    
    func load() {
        self.set(values: ["Jakarta", "Hongkong", "Singapore", "Seoul", "Tokyo", "Jakarta", "Hongkong", "Singapore", "Seoul", "Tokyo", "Jakarta", "Hongkong", "Singapore", "Seoul", "Tokyo", "Jakarta", "Hongkong", "Singapore", "Seoul", "Tokyo"], cellClass: AirportViewCell.self, inSection: 0)
    }
    
    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as AirportViewCell, value as String):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized cell: \(type(of: cell)), value: \(type(of: value))")
        }
    }
}
