//
//  PassengerFormDataSource.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 29/12/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import TiketKitModels
import UIKit

public final class PassengerFormDataSource: ValueCellDataSource {
    
    
    public func configureContactFirstPassenger(_ format: FormatDataForm) {
        self.set(values: [.flightResult], cellClass: ContactInfoViewCell.self, inSection: 0)
        self.set(values: [format], cellClass: PassengerFormTableViewCell.self, inSection: 1)
    }
    
    public func configureAdultsPassenger(_ format: FormatDataForm) {
        self.set(values: [format], cellClass: PassengerFormTableViewCell.self, inSection: 0)
    }
    
    public func configureChildsPassenger(_ format: FormatDataForm) {
        self.set(values: [format], cellClass: PassengerFormTableViewCell.self, inSection: 0)
    }
    
    public func configureInfantsPassenger(_ format: FormatDataForm) {
        self.set(values: [format], cellClass: PassengerFormTableViewCell.self, inSection: 0)
    }
    
    public override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as ContactInfoViewCell, value as ContactFormState):
            cell.configureWith(value: value)
        case let (cell as GuestOptionViewCell, value as BookingOptionFormState):
            cell.configureWith(value: value)
        case let (cell as PassengerFormTableViewCell, value as FormatDataForm):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized Error: \(type(of: cell)) \(type(of: value))")
        }
    }
}
