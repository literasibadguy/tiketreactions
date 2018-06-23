//
//  FirstIssueViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 12/06/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit
import Prelude
import TiketKitModels

public final class FirstIssueViewCell: UITableViewCell, ValueCell {
    
    @IBOutlet fileprivate weak var paymentStatusLabel: UILabel!
    @IBOutlet fileprivate weak var orderNameTitleLabel: UILabel!
    @IBOutlet fileprivate weak var orderDetailTitleLabel: UILabel!
    @IBOutlet fileprivate weak var orderSubTitleLabel: UILabel!
    
    public typealias Value = OrderCartDetail
    
   public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configureWith(value: OrderCartDetail) {
        
        _ = self.orderNameTitleLabel
            |> UILabel.lens.text .~ value.orderName
        
        _ = self.orderDetailTitleLabel
            |> UILabel.lens.text .~ value.orderDetailId
    }
}
