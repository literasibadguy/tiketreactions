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
    
    func loadPassengersForm() {
//        self.set(values: [1, 2], cellClass: PassengerSummaryViewCell.self, inSection: 2)
    }
    
    func loadPassenger(_ dataForm: [FormatDataForm]) {
        self.set(values: [.flightResult], cellClass: ContactInfoViewCell.self, inSection: 0)
        self.set(values: dataForm, cellClass: PassengerSummaryViewCell.self, inSection: 1)
        
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
        case let (cell as PassengerSummaryViewCell, value as FormatDataForm):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized Error: \(type(of: cell)) \(type(of: value))")
        }
    }
}
