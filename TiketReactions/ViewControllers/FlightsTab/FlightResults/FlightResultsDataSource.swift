//
//  FlightResultsDataSource.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 30/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import TiketKitModels
import UIKit

public final class FlightResultsDataSource: ValueCellDataSource {
    
    public func load(flights: [Flight]) {
        self.set(values: flights, cellClass: FlightResultViewCell.self, inSection: 0)
    }
    
    public func flightAtIndexPath(_ indexPath: IndexPath) -> Flight? {
        return self[indexPath] as? Flight
    }
    
    public override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as FlightResultViewCell, value as Flight):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized Error: \(type(of: cell)) \(type(of: value))")
        }
    }
}
