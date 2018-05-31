//
//  HotelDiscoveryFiltersDataSource.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 14/05/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import TiketKitModels

public final class HotelDiscoveryFiltersDataSource: ValueCellDataSource {
    
    internal enum Section: Int {
        case sort
    }
    
    public func load() {
        self.set(values: ["popular", "priceasc", "pricedesc"], cellClass: SortFilterViewCell.self, inSection: Section.sort.rawValue)
    }
    
    public func sortAtIndexPath(_ indexPath: IndexPath) -> String? {
        return self[indexPath] as? String
    }
    
    public override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as SortFilterViewCell, value as String):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecongized error: \(type(of: cell)) \(type(of: value))")
        }
    }
}
