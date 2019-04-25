//
//  IssuedListDataSource.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 27/06/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

public final class IssuedListDataSource: ValueCellDataSource {

    public func load(_ issues: List<IssuedOrder>) {
        self.clearValues()
        
        if !issues.isEmpty {
            issues.forEach {
                self.appendRow(value: $0, cellClass: IssuedListViewCell.self, toSection: 0)
            }
        }
    }
    
    public func issueAtIndexPath(_ indexPath: IndexPath) -> IssuedOrder? {
        return self[indexPath] as? IssuedOrder
    }
    
    public override func configureCell(tableCell cell: UITableViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as IssuedListViewCell, value as IssuedOrder):
            cell.configureWith(value: value)
        default:
            fatalError("Unrecognized error: \(type(of: cell)), \(type(of: value))")
        }
    }
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            if let issue = issueAtIndexPath(indexPath) {
                guard !issue.isInvalidated else {
                    return
                }
                let realm = try! Realm()
                try! realm.write {
                    let list = realm.objects(IssuedOrderList.self).first!
                    list.items.realm?.delete(issue)
                }
            }
        }
    }
}
