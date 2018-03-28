//
//  HotelDirectsContentDataSource.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 01/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import UIKit

class HotelDirectsContentDataSource: ValueCellDataSource {
    internal enum Section: Int {
        case main
        case subpages
        case availableRooms
    }
    
    internal func load(hotelDirect: HotelDirect) {
        self.set(values: [hotelDirect], cellClass: HotelDirectMainViewCell.self, inSection: Section.main.rawValue)
        
        hotelDirect.availableRooms.roomResults.forEach { availableRoom in
            self.appendRow(value: availableRoom, cellClass: AvailableRoomViewCell.self, toSection: Section.main.rawValue)
        }
        
//        self.set(values: [hotelDirect], cellClass: HotelSubpageViewCell.self, inSection: Section.subpages.rawValue)
        
    }
    
    internal func indexPathForMainCell() -> IndexPath {
        return IndexPath(item: 0, section: Section.main.rawValue)
    }
    
    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as HotelDirectMainViewCell, value as HotelDirect):
            cell.configureWith(value: value)
        case let (cell as AvailableRoomViewCell, value as AvailableRoom):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized type error: \(type(of: cell)) \(type(of: value))")
        }
    }
}
