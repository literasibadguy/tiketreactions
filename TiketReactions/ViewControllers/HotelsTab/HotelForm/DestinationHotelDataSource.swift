//
//  DestinationHotelDataSource.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 13/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import GoogleMaps
import TiketKitModels
import UIKit

internal final class DestinationHotelDataSource: ValueCellDataSource {
    internal enum Section: Int {
        case suggestDestination
        case autoResults
    }
    
    internal func initialDestination(_ address: GMSAddress) {
        self.set(values: [address], cellClass: DestinationLocationViewCell.self, inSection: Section.suggestDestination.rawValue)
    }
    
    internal func load(results: [AutoHotelResult]) {
        self.clearValues(section: Section.autoResults.rawValue)
        
        if !results.isEmpty {
            results.forEach {
                self.appendRow(value: $0, cellClass: DestHotelViewCell.self, toSection: Section.autoResults.rawValue)
            }
        }
    }
    
    internal func suggestLocationRow(indexPath: IndexPath) -> GMSAddress? {
        return self[indexPath] as? GMSAddress
    }
    
    internal func destHotelRow(indexPath: IndexPath) -> AutoHotelResult? {
        return self[indexPath] as? AutoHotelResult
    }
    
    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as DestHotelViewCell, value as AutoHotelResult):
            cell.configureWith(value: value)
        case let (cell as DestinationLocationViewCell, value as GMSAddress):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized error: \(type(of: cell)) \(type(of: value))")
        }
    }
}
