//
//  NationalityPickDataSource.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 30/01/19.
//  Copyright © 2019 Firas Rafislam. All rights reserved.
//

import UIKit
import TiketKitModels

public final class NationalityPickDataSource: ValueCellDataSource {
    
    public func load(_ countries: [CountryListEnvelope.ListCountry]) {
        self.set(values: countries, cellClass: NationalListViewCell.self, inSection: 0)
    }
    
    public func countryAtIndexPath(_ indexPath: IndexPath) -> CountryListEnvelope.ListCountry? {
        return self[indexPath] as? CountryListEnvelope.ListCountry
    }
    
    public override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as NationalListViewCell, value as CountryListEnvelope.ListCountry):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized error: \(type(of: cell)), \(type(of: value))")
        }
    }
}
