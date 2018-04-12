//
//  OrderListViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 25/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import TiketKitModels
import UIKit

public final class OrderListViewCell: UITableViewCell, ValueCell {
    
    
    public typealias Value = OrderData
    
    @IBOutlet fileprivate weak var orderTypeLabel: UILabel!
    @IBOutlet fileprivate weak var orderNameLabel: UILabel!
    @IBOutlet fileprivate weak var orderNameDetailLabel: UILabel!
    
    @IBOutlet weak var startDateLabel: UILabel!
    
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public func configureWith(value: OrderData) {
        
        _ = self.orderTypeLabel
            |> UILabel.lens.text .~ value.orderType
        _ = self.orderNameLabel
            |> UILabel.lens.text .~ value.orderName
        _ = self.orderNameDetailLabel
            |> UILabel.lens.text .~ value.orderNameDetail
        _ = self.startDateLabel
            |> UILabel.lens.text .~ value.detail.startdate
    }
}
