//
//  HotelDirectsContentDataSource.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 01/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import TiketKitModels
import UIKit

class HotelDirectsContentDataSource: ValueCellDataSource {
    
    internal enum Section: Int {
        case main
        case facilityList
        case summaryMap
    }
    
    internal func load(selected: HotelResult, hotelDirect: HotelDirect) {
        self.set(values: [hotelDirect], cellClass: HotelDirectMainViewCell.self, inSection: Section.main.rawValue)
        
        self.set(values: [Localizations.FacilityHotelTitle], cellClass: FacilityListViewCell.self, inSection: Section.facilityList.rawValue)
        
        self.set(values: [selected], cellClass: HotelMapViewCell.self, inSection: Section.summaryMap.rawValue)
        
    }
    
    internal func indexPathForMainCell() -> IndexPath {
        return IndexPath(item: 0, section: Section.main.rawValue)
    }
    
    internal func indexPathForMapCell() -> IndexPath {
        return IndexPath(item: 0, section: Section.summaryMap.rawValue)
    }
    
    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as HotelDirectMainViewCell, value as HotelDirect):
            cell.configureWith(value: value)
        case let (cell as FacilityListViewCell, value as String):
            cell.configureWith(value: value)
        case let (cell as HotelMapViewCell, value as HotelResult):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized type error: \(type(of: cell)) \(type(of: value))")
        }
    }
}
