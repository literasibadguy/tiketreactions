//
//  AvailableRoomListsDataSource.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 13/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import TiketKitModels
import UIKit

public final class AvailableRoomListsDataSource: ValueCellDataSource {
    
    public func load(rooms: [AvailableRoom]) {
        self.set(values: rooms, cellClass: AvailableRoomViewCell.self, inSection: 0)
    }
    
    public func roomAtIndexPath(_ indexPath: IndexPath) -> AvailableRoom? {
        return self[indexPath] as? AvailableRoom
    }
    
    public override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as AvailableRoomViewCell, value as AvailableRoom):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized error: \(type(of: cell)) \(type(of: value))")
        }
    }
}
