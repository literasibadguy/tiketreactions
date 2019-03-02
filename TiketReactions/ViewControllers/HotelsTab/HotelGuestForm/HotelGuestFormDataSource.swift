//
//  HotelGuestFormDataSource.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 15/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import TiketKitModels
import UIKit

internal final class HotelGuestFormDataSource: ValueCellDataSource {
    
    internal enum Section: Int {
        case orderSummary
        case noticeForm
        case contactForm
        case guestOption
        case guestForm
    }
    
    internal func load(hotelDirect: HotelDirect, availableRoom: AvailableRoom, summary: HotelBookingSummary) {
        self.set(values: [summary], cellClass: OrderFirstViewCell.self, inSection: Section.orderSummary.rawValue)
        self.set(values: [Localizations.NoticematchformTitle], cellClass: NoticeSummaryViewCell.self, inSection: Section.noticeForm.rawValue)
        self.set(values: [.hotelResult], cellClass: ContactInfoViewCell.self, inSection: Section.contactForm.rawValue)
        self.set(values: [.hotelOption], cellClass: GuestOptionViewCell.self, inSection: Section.guestOption.rawValue)
    }
    
    internal func loadedSourceParams(_ params: CheckoutGuestParams) {
        self.set(values: [params], cellClass: GuestFormTableViewCell.self, inSection: Section.guestForm.rawValue)
    }
    
    internal func removeForAnotherGuest() -> [IndexPath] {
        self.clearValues(section: Section.guestForm.rawValue)
        return [IndexPath(row: 0, section: Section.guestForm.rawValue)]
    }

    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as OrderFirstViewCell, value as HotelBookingSummary):
            cell.configureWith(value: value)
        case let (cell as NoticeSummaryViewCell, value as String):
            cell.configureWith(value: value)
        case let (cell as ContactInfoViewCell, value as ContactFormState):
            cell.configureWith(value: value)
        case let (cell as GuestOptionViewCell, value as BookingOptionFormState):
            cell.configureWith(value: value)
        case let (cell as GuestFormTableViewCell, value as CheckoutGuestParams):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized message error: \(cell) \(value)")
        }
    }
}
