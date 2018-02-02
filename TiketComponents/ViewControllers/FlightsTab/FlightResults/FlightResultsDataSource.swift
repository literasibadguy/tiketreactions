//
//  FlightResultsDataSource.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 30/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation

class FlightResultsDataSource: ValueCellDataSource {
    
    func load() {
        self.set(values: ["SINGAPORE AIR", "GARUDA", "AIR ASIA", "QANTAS", "EMIRATES", "SINGAPORE AIR", "GARUDA", "AIR ASIA", "QANTAS", "EMIRATES"], cellClass: FlightResultViewCell.self, inSection: 0)
    }
    
    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as FlightResultViewCell, value as String):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized Error: \(type(of: cell)) \(type(of: value))")
        }
    }
}
