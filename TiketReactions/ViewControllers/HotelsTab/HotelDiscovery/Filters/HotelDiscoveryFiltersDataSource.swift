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
        self.set(values: [SearchHotelParams.Sort.popular, SearchHotelParams.Sort.priceLowToHigh, SearchHotelParams.Sort.priceHighToLow, SearchHotelParams.Sort.starLowToHigh, SearchHotelParams.Sort.starHighToLow], cellClass: SortFilterViewCell.self, inSection: Section.sort.rawValue)
    }
    
    public func sortAtIndexPath(_ indexPath: IndexPath) -> SearchHotelParams.Sort? {
        return self[indexPath] as? SearchHotelParams.Sort
    }
    
    public override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as SortFilterViewCell, value as SearchHotelParams.Sort):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecongized error: \(type(of: cell)) \(type(of: value))")
        }
    }
}
