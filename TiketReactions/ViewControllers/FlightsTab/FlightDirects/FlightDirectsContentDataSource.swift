//
//  FlightDirectsContentDataSource.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 26/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import TiketKitModels
import UIKit

internal final class FlightDirectsContentDataSource: ValueCellDataSource {
    
    internal enum Section: Int {
        case minimal
        case flightDirect
        case contactInfo
        case passengerOption
        case passengerSummary
    }
    
    func load(flight: Flight) {
        self.set(values: [flight], cellClass: MinimalFlightViewCell.self, inSection: Section.minimal.rawValue)
        
        self.set(values: [flight], cellClass: FlightDirectViewCell.self, inSection: Section.flightDirect.rawValue)
        
        self.set(values: [0], cellClass: ContactInfoViewCell.self, inSection: Section.contactInfo.rawValue)
    }
    
    func load(departed: Flight, returned: Flight) {
        self.set(values: [departed], cellClass: MinimalFlightViewCell.self, inSection: Section.minimal.rawValue)
        
        self.set(values: [departed, returned], cellClass: FlightDirectViewCell.self, inSection: Section.flightDirect.rawValue)
        
        self.set(values: [0], cellClass: ContactInfoViewCell.self, inSection: Section.contactInfo.rawValue)
    }
    
    func loadSingle(param: SearchSingleFlightParams, flight: Flight) {
        self.set(values: [flight], cellClass: MinimalFlightViewCell.self, inSection: Section.minimal.rawValue)
        
        self.set(values: [flight], cellClass: FlightDirectViewCell.self, inSection: Section.flightDirect.rawValue)
        
        self.set(values: [0], cellClass: ContactInfoViewCell.self, inSection: Section.contactInfo.rawValue)
        
        self.set(values: ["Options"], cellClass: PassengerOptionViewCell.self, inSection: Section.passengerOption.rawValue)
        
//        self.set(values: ["Contact"], cellClass: PassengerSummaryViewCell.self, inSection: Section.passengerSummary.rawValue)
    }
    
    func load(param: SearchFlightParams, depart: Flight, returned: Flight) {
        self.set(values: [depart], cellClass: MinimalFlightViewCell.self, inSection: Section.minimal.rawValue)
        
        self.set(values: [depart, returned], cellClass: FlightDirectViewCell.self, inSection: Section.flightDirect.rawValue)
        
        self.set(values: [0], cellClass: ContactInfoViewCell.self, inSection: Section.contactInfo.rawValue)
        
        self.set(values: ["Options"], cellClass: PassengerOptionViewCell.self, inSection: Section.passengerOption.rawValue)
        
//        self.set(values: ["Contact"], cellClass: PassengerSummaryViewCell.self, inSection: Section.passengerSummary.rawValue)
    }
    
    func load(passengers: [AdultPassengerParam], param: SearchFlightParams, depart: Flight, returned: Flight) {
        
        self.set(values: passengers, cellClass: PassengerSummaryViewCell.self, inSection: Section.passengerSummary.rawValue)
    }
    
    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as MinimalFlightViewCell, value as Flight):
            cell.configureWith(value: value)
        case let (cell as FlightDirectViewCell, value as Flight):
            cell.configureWith(value: value)
        case let (cell as ContactInfoViewCell, value as Int):
            cell.configureWith(value: value)
        case let (cell as PassengerOptionViewCell, value as String):
            cell.configureWith(value: value)
        case let (cell as PassengerSummaryViewCell, value as AdultPassengerParam):
            cell.configureWith(value: value)
        default:
            fatalError("Flight Directs Data Source Error: \(type(of: cell)), \(type(of: value))")
        }
    }
}
