//
//  FlightResultsFilterDataSource.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 31/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import UIKit

class FlightResultsFilterDataSource: ValueCellDataSource {
    
    internal enum Section: Int {
        case sortsHeader
        case sorts
        case timesHeader
        case times
        case transitHeader
        case transit
        case airlinesHeader
        case airlines
    }
    
    func load() {
        self.set(values: ["Berdasarkan"], cellClass: HeaderFilterViewCell.self, inSection: Section.sortsHeader.rawValue)
        self.set(values: ["Berdasarkan"], cellClass: FilterExpandedRowViewCell.self, inSection: Section.sorts.rawValue)
        self.set(values: ["Berdasarkan"], cellClass: FilterExpandableRowViewCell.self, inSection: Section.timesHeader.rawValue)
        self.set(values: ["Berdasarkan"], cellClass: TimeFilterSliderViewCell.self, inSection: Section.times.rawValue)
        self.set(values: ["Berdasarkan"], cellClass: FilterExpandableRowViewCell.self, inSection: Section.transitHeader.rawValue)
        self.set(values: ["Berdasarkan"], cellClass: FilterExpandedRowViewCell.self, inSection: Section.transit.rawValue)
        self.set(values: ["Penerbangan"], cellClass: FilterExpandableRowViewCell.self, inSection: Section.airlinesHeader.rawValue)
        self.set(values: ["Penerbangan"], cellClass: FilterExpandedRowViewCell.self, inSection: Section.airlines.rawValue)
    }
    
    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as HeaderFilterViewCell, value as String):
            cell.configureWith(value: value)
        case let (cell as FilterExpandedRowViewCell, value as String):
            cell.configureWith(value: value)
        case let (cell as FilterExpandableRowViewCell, value as String):
            cell.configureWith(value: value)
        case let (cell as TimeFilterSliderViewCell, value as String):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized error: \(type(of:cell)), \(type(of: value))")
        }
    }
}
