//
//  HotelGuestFormDataSource.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 15/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import TiketAPIs

internal final class HotelGuestFormDataSource: ValueCellDataSource {
    
    internal enum Section: Int {
        case orderSummary
        case roomSummary
        case guestForm
        case guestOption
    }
    
    internal func load(hotelDirect: HotelDirect, availableRoom: AvailableRoom) {
        self.clearValues()
        
        self.set(values: [hotelDirect], cellClass: OrderFirstViewCell.self, inSection: Section.orderSummary.rawValue)
        self.set(values: [availableRoom], cellClass: RoomSummaryViewCell.self, inSection: Section.roomSummary.rawValue)
        self.set(values: [1], cellClass: ContactInfoViewCell.self, inSection: Section.guestForm.rawValue)
        self.set(values: [1], cellClass: GuestOptionViewCell.self, inSection: Section.guestOption.rawValue)
    }
    
    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as OrderFirstViewCell, value as HotelDirect):
            cell.configureWith(value: value)
        case let (cell as RoomSummaryViewCell, value as AvailableRoom):
            cell.configureWith(value: value)
        case let (cell as ContactInfoViewCell, value as Int):
            cell.configureWith(value: value)
        case let (cell as GuestOptionViewCell, value as Int):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized message error: \(cell) \(value)")
        }
    }
}
