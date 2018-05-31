//
//  PickFlightResultsDataSource.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 21/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import TiketKitModels

public final class PickFlightResultsDataSource: ValueCellDataSource {
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
