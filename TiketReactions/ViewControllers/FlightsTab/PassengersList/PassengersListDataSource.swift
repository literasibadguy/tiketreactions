//
//  PassengersListDataSource.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 28/08/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import UIKit
import TiketKitModels

final class PassengersListDataSource: ValueCellDataSource {
    
    internal enum Section: Int {
        case contactInfo
        case guestOption
        case passengerSummary
        case passengerFilled
    }
    
    func loadPassengersForm() {
//        self.set(values: [1, 2], cellClass: PassengerSummaryViewCell.self, inSection: 2)
    }
    
    func loadPassenger(_ summaries: [FormatDataForm]) {
        self.set(values: [.flightResult], cellClass: ContactInfoViewCell.self, inSection: Section.contactInfo.rawValue)
        self.set(values: [.flightOption], cellClass: GuestOptionViewCell.self, inSection: Section.guestOption.rawValue)
        self.set(values: summaries, cellClass: PassengerSummaryViewCell.self, inSection: Section.passengerSummary.rawValue)
    }
    
    func addFilled(_ passengers: [AdultPassengerParam], formats: [FormatDataForm]) {
        self.set(values: passengers, cellClass: PassengerFilledViewCell.self, inSection: Section.passengerFilled.rawValue)
    }

    public func removeDataFormRows(index: Int) -> [IndexPath]? {
        if !self[section: Section.passengerSummary.rawValue].isEmpty {
            print("Data Format from Rows is not empty: \(index)")
            return [IndexPath(row: index, section: Section.passengerSummary.rawValue)]
        }
        
        return nil
    }
    
    public func passengerSummaryAtIndexPath(_ indexPath: IndexPath) -> FormatDataForm? {
        return self[indexPath] as? FormatDataForm
    }
    
    public func passengerUpdatedAtIndexPath(_ indexPath: IndexPath) -> AdultPassengerParam? {
        return self[indexPath] as? AdultPassengerParam
    }
    
    public override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as ContactInfoViewCell, value as ContactFormState):
            cell.configureWith(value: value)
        case let (cell as GuestOptionViewCell, value as BookingOptionFormState):
            cell.configureWith(value: value)
        case let (cell as PassengerSummaryViewCell, value as FormatDataForm):
            cell.configureWith(value: value)
        case let (cell as PassengerFilledViewCell, value as AdultPassengerParam):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized Error: \(type(of: cell)) \(type(of: value))")
        }
    }
}
