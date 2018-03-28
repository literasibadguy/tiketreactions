//
//  HotelDiscoveryDataSource.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 10/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import TiketAPIs

internal final class HotelDiscoveryDataSource: ValueCellDataSource {
    internal enum Section: Int {
        case hotels
    }
    
    func load(hotelResult: [HotelResult]) {
        self.clearValues(section: Section.hotels.rawValue)
        
        hotelResult.forEach { hotel in
            self.appendRow(value: hotel, cellClass: HotelDiscoveryViewCell.self, toSection: Section.hotels.rawValue)
        }
    }
    
    internal func hotelAtIndexPath(_ indexPath: IndexPath) -> HotelResult? {
        return (self[indexPath] as? HotelResult)!
    }
    
    internal func indexPath(forHotelRow row: Int) -> IndexPath {
        return IndexPath(item: row, section: Section.hotels.rawValue)
    }
    
    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as HotelDiscoveryViewCell, value as HotelResult):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized error: \(type(of: cell)), \(type(of: value))")
        }
    }
}
