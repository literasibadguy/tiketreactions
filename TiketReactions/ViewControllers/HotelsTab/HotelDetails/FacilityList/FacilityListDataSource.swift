//
//  FacilityListDataSource.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 25/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import TiketKitModels
import UIKit

internal final class FacilityListDataSource: ValueCellDataSource {
    
    internal enum Section: Int {
        case main
        case room
    }
    
    internal func load(facilities: [HotelDirect.AvailableFacility]) {
        
        let hotelContents = facilities.filter { $0.facilityType == "hotel" }.map { $0 }
        let roomContents = facilities.filter { $0.facilityType == "room" }.map { $0 }
        
        
        self.set(values: [hotelContents], cellClass: FacilityDetailViewCell.self, inSection: Section.main.rawValue)
        
        self.set(values: [roomContents], cellClass: FacilityDetailViewCell.self, inSection: Section.room.rawValue)
    }
    
    
    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as FacilityDetailViewCell, value as [HotelDirect.AvailableFacility]):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized cell instance")
        }
    }
}
