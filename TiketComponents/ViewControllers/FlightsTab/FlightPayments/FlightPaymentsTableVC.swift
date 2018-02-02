//
//  FlightPaymentsTableVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 26/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit

class FlightPaymentsTableVC: UITableViewController {
    
    static func instantiate() -> FlightPaymentsTableVC {
        let vc = Storyboard.FlightPayments.instantiate(FlightPaymentsTableVC.self)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let cancelBarButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        self.navigationItem.setLeftBarButton(cancelBarButton, animated: true)
        self.navigationController?.navigationBar.isTranslucent = false
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            print("Credit Card Pay View Cell Selected")
        } else if indexPath.row == 2 {
            print("Bank Transfer Pay View Cell Selected")
        } else if indexPath.row == 3 {
            print("BCA Klikpay Pay View Cell Selected")
        } else if indexPath.row == 4 {
            print("CIMB Clicks Pay View Cell Selected")
        }
    }
    
    @objc fileprivate func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
}
