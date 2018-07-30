//
//  OrderDetailsVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 07/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit

public final class OrderDetailsVC: UITableViewController {
    
    public static func instantiate() -> OrderDetailsVC {
        let vc = Storyboard.OrderDetails.instantiate(OrderDetailsVC.self)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

}
