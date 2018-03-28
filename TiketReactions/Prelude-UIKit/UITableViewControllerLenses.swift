//
//  UITableViewControllerLenses.swift
//  TiketSignal
//
//  Created by Firas Rafislam on 12/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import UIKit

public protocol UITableViewControllerProtocol: UIViewControllerProtocol {
    var tableView: UITableView! { get set }
}

extension UITableViewController: UITableViewControllerProtocol {}

public extension LensHolder where Object: UITableViewControllerProtocol {
    public var tableView: Lens<Object, UITableView> {
        return Lens(
            view: { view in view.tableView },
            set: { view, set in set.tableView = view; return set }
        )
    }
}

extension Lens where Whole: UITableViewControllerProtocol, Part == UITableView {
    public var rowHeight: Lens<Whole, CGFloat> {
        return Whole.lens.tableView..Part.lens.rowHeight
    }
    
    public var estimatedRowHeight: Lens<Whole, CGFloat> {
        return Whole.lens.tableView..Part.lens.estimatedRowHeight
    }
    
    #if os(iOS)
    public var separatorStyle: Lens<Whole, UITableViewCellSeparatorStyle> {
        return Whole.lens.tableView..Part.lens.separatorStyle
    }
    #endif
}

