//
//  LoungesDataSource.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 07/11/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import TiketKitModels
import UIKit

public final class LoungesDataSource: ValueCellDataSource {
    
    private enum LoungesSection: Int {
        case pastTripsSection = 0
        case currencySection
        case deviceIDSection
        case versionSection
    }
    
    public func load() {
        self.set(values: [""], cellClass: RiwayatBookingViewCell.self, inSection: LoungesSection.pastTripsSection.rawValue)
//        self.set(values: [.defaults], cellClass: LoungeCurrencyCell.self, inSection: LoungesSection.currencySection.rawValue)
        self.set(values: [AppEnvironment.current.device.identifierForVendor?.description ?? ""], cellClass: LoungeDeviceIDViewCell.self, inSection: LoungesSection.deviceIDSection.rawValue)
        self.set(values: [AppEnvironment.current.device.systemVersion], cellClass: VersionBuildLoungeViewCell.self, inSection: LoungesSection.versionSection.rawValue)
        
    }
    
    public func loadCurrency(_ value: String) {
        self.set(values: [value], cellClass: LoungeCurrencyCell.self, inSection: LoungesSection.currencySection.rawValue)
    }
    
    public override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as RiwayatBookingViewCell, value as String):
            cell.configureWith(value: value)
        case let (cell as LoungeCurrencyCell, value as String):
            cell.configureWith(value: value)
        case let (cell as LoungeDeviceIDViewCell, value as String):
            cell.configureWith(value: value)
        case let (cell as VersionBuildLoungeViewCell, value as String):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized error: \(type(of: cell)), \(type(of: value))")
        }
    }
    
    internal func indexPathForRiwayatIssues() -> IndexPath {
        return IndexPath(row: 0, section: LoungesSection.pastTripsSection.rawValue)
    }
    
    internal func indexPathForCurrency() -> IndexPath {
        return IndexPath(row: 0, section: LoungesSection.currencySection.rawValue)
    }
    
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == LoungesSection.currencySection.rawValue {
            return " "
        }
        
        return ""
    }
    
    
}
