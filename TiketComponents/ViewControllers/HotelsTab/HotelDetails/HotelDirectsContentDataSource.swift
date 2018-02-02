//
//  HotelDirectsContentDataSource.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 01/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation

class HotelDirectsContentDataSource: ValueCellDataSource {
    internal enum Section: Int {
        case main
        case subpages
    }
    
    internal func loadMinimal() {
        self.set(values: ["J.W. Marriot Hotel"], cellClass: HotelDirectMainViewCell.self, inSection: Section.main.rawValue)
        
        self.set(values: ["Tambahan Info"], cellClass: HotelSubpageViewCell.self, inSection: Section.subpages.rawValue)
    }
    
    internal func load() {
        self.clearValues()
        
        self.set(values: ["J.W. Marriot Hotel"], cellClass: HotelSummaryViewCell.self, inSection: Section.main.rawValue)
        
        self.set(values: ["Tambahan Info"], cellClass: HotelSubpageViewCell.self, inSection: Section.subpages.rawValue)
    }
    
    internal func indexPathForMainCell() -> IndexPath {
        return IndexPath(item: 0, section: Section.main.rawValue)
    }
    
    override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as HotelDirectMainViewCell, value as String):
            cell.configureWith(value: value)
        case let (cell as HotelSummaryViewCell, value as String):
            cell.configureWith(value: value)
        case let (cell as HotelSubpageViewCell, value as String):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized type error: \(type(of: cell)) \(type(of: value))")
        }
    }
}
