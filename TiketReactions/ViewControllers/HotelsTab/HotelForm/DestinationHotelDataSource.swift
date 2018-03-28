//
//  DestinationHotelDataSource.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 13/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import TiketAPIs

internal final class DestinationHotelDataSource: ValueCellDataSource {
    internal enum Section: Int {
        case autoResults
    }
    
    internal func load(results: [AutoHotelResult]) {
        self.clearValues(section: Section.autoResults.rawValue)
        
        if !results.isEmpty {
            results.forEach {
                self.appendRow(value: $0, cellClass: DestHotelViewCell.self, toSection: Section.autoResults.rawValue)
            }
        }
    }
    
    internal func destHotelRow(indexPath: IndexPath) -> AutoHotelResult? {
        return self[indexPath] as? AutoHotelResult
    }
    
    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as DestHotelViewCell, value as AutoHotelResult):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized error: \(type(of: cell)) \(type(of: value))")
        }
    }
}
