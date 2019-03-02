//
//  FlightSummariesDataSource.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 05/09/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit
import TiketKitModels


internal final class FlightSummariesDataSource: ValueCellDataSource {
    
    func loadSingle(_ single: Flight) {
        self.set(values: [single], cellClass: FlightDirectViewCell.self, inSection: 0)
    }
    
    func load(first: Flight, returned: Flight) {
        self.set(values: [first, returned], cellClass: FlightDirectViewCell.self, inSection: 0)
    }
    
    func load(_ totalPrice: String) {
        self.set(values: [totalPrice], cellClass: ValueTotalFlightViewCell.self, inSection: 1)
        self.set(values: [Localizations.CheckFlightNoticeSummary], cellClass: NoticeSummaryViewCell.self, inSection: 2)
    }
    
    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as FlightDirectViewCell, value as Flight):
            cell.configureWith(value: value)
        case let (cell as ValueTotalFlightViewCell, value as String):
            cell.configureWith(value: value)
        case let (cell as NoticeSummaryViewCell, value as String):
            cell.configureWith(value: value)
        default:
            fatalError("Flight Directs Data Source Error: \(type(of: cell)), \(type(of: value))")
        }
    }
}
