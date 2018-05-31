//
//  PickAirportsDataSource.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 28/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import TiketKitModels
import UIKit

internal final class PickAirportsDataSource: ValueCellDataSource {
    
    
    func load(airportResults: [AirportResult]) {
        self.clearValues()
        
        if !airportResults.isEmpty {
            airportResults.forEach {
                self.appendRow(value: $0, cellClass: AirportViewCell.self, toSection: 0)
            }
        }
    }
    
    func load(airportResults: [AirportResult], selectedRow: AirportResult) {
        self.clearValues()
        
        if !airportResults.isEmpty {
            airportResults.forEach {
                self.appendRow(value: $0, cellClass: AirportViewCell.self, toSection: 0)
//                self.prependRow(value: selectedRow, cellClass: AirportViewCell.self, toSection: 0)s
            }
//            self.prependRow(value: selectedRow, cellClass: AirportViewCell.self, toSection: 0)
        }
    }
    
    internal func flightRow(indexPath: IndexPath) -> AirportResult? {
        return self[indexPath] as? AirportResult
    }
    
    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as AirportViewCell, value as AirportResult):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized cell: \(type(of: cell)), value: \(type(of: value))")
        }
    }
}
