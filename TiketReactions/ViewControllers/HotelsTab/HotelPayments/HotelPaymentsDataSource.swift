//
//  HotelPaymentsDataSource.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 22/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import TiketKitModels

internal final class HotelPaymentsDataSource: ValueCellDataSource {
    
    internal enum Section: Int {
        case orderSummary
        case availablePayments
    }
    
    internal func loadPayments(_ order: MyOrder, envelope: AvailablePaymentEnvelope) {
        
        self.set(values: [order], cellClass: PaymentSummaryViewCell.self, inSection: Section.orderSummary.rawValue)
        
        self.set(values: envelope.payments, cellClass: HotelPaymentViewCell.self, inSection: Section.availablePayments.rawValue)
    }
    
    internal func loadFlightPayments(_ order: FlightMyOrder, envelope: AvailablePaymentEnvelope) {
        
    }
    
    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as PaymentSummaryViewCell, value as MyOrder):
            cell.configureWith(value: value)
        case let (cell as HotelPaymentViewCell, value as AvailablePaymentEnvelope.AvailablePayment):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized message error: \(cell) \(value)")
        }
    }
}
