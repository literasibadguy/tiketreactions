//
//  FlightOrderListViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 03/10/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import TiketKitModels
import UIKit

public final class FlightOrderListViewCell: UITableViewCell, ValueCell {
    
    public typealias Value = FlightOrderData
    
    @IBOutlet fileprivate weak var orderListStackView: UIStackView!
    
    @IBOutlet fileprivate weak var orderTypeLabel: UILabel!
    @IBOutlet fileprivate weak var orderNameLabel: UILabel!
    @IBOutlet fileprivate weak var orderNameDetailLabel: UILabel!
    
    @IBOutlet fileprivate weak var startDateLabel: UILabel!
    @IBOutlet fileprivate weak var deleteOrderButton: UIButton!
    
    @IBOutlet fileprivate weak var orderListSeparatorView: UIView!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configureWith(value: FlightOrderData) {
        
    }
    
}
