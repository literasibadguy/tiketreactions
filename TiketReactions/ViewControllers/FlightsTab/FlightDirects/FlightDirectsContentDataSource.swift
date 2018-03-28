//
//  FlightDirectsContentDataSource.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 26/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import TiketAPIs
import UIKit

internal final class FlightDirectsContentDataSource: ValueCellDataSource {
    
    internal enum Section: Int {
        case minimal
        case flightDirect
        case contactInfo
        case passengerOption
        case passengerSummary
    }
    
    func load() {
    }
    
    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as MinimalFlightViewCell, value as String):
            cell.configureWith(value: value)
        case let (cell as FlightDirectViewCell, value as String):
            cell.configureWith(value: value)
        case let (cell as ContactInfoViewCell, value as Int):
            cell.configureWith(value: value)
        case let (cell as PassengerOptionViewCell, value as String):
            cell.configureWith(value: value)
        case let (cell as PassengerSummaryViewCell, value as String):
            cell.configureWith(value: value)
        default:
            fatalError("Flight Directs Data Source Error: \(type(of: cell)), \(type(of: value))")
        }
    }
}
