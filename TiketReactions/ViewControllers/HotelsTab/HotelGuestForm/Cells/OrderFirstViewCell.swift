//
//  OrderFirstViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 17/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import TiketAPIs
import UIKit

class OrderFirstViewCell: UITableViewCell, ValueCell {
    
    typealias Value = HotelDirect
    
    @IBOutlet fileprivate weak var orderFirstStackView: UIStackView!
    @IBOutlet fileprivate weak var hotelNameOrderLabel: UILabel!
    @IBOutlet fileprivate weak var statusOrderDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self.orderFirstStackView
            |> UIStackView.lens.layoutMargins %~~ { _, stackView in
                stackView.traitCollection.isRegularRegular
                    ? .init(topBottom: Styles.grid(6), leftRight: Styles.grid(4))
                    : .init(top: Styles.grid(4), left: Styles.grid(2), bottom: Styles.grid(3), right: Styles.grid(2))
            }
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
            |> UIStackView.lens.spacing .~ 3
        
    }
    
    func configureWith(value: HotelDirect) {
        _ = self.hotelNameOrderLabel
            |> UILabel.lens.text .~ value.breadcrumb.businessName
        
        _ = self.statusOrderDateLabel
            |> UILabel.lens.text .~ "5 Malam"
    }
}
