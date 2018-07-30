//
//  OrderFirstViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 17/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import TiketKitModels
import UIKit

class OrderFirstViewCell: UITableViewCell, ValueCell {
    
    typealias Value = HotelBookingSummary
    
    @IBOutlet fileprivate weak var orderFirstStackView: UIStackView!
    
    @IBOutlet fileprivate weak var orderHotelTitleLabel: UILabel!
    @IBOutlet fileprivate weak var hotelNameOrderLabel: UILabel!
    @IBOutlet fileprivate weak var statusOrderDateLabel: UILabel!
    @IBOutlet fileprivate weak var guestRoomLabel: UILabel!
    @IBOutlet fileprivate weak var orderFirstSeparatorView: UIView!
    
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
                    : .init(top: Styles.grid(4), left: Styles.grid(4), bottom: Styles.grid(3), right: Styles.grid(2))
            }
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
            |> UIStackView.lens.spacing .~ 3
        
        _ = self.hotelNameOrderLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.statusOrderDateLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_500
        
        _ = self.guestRoomLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_500
        
        _ = self.orderFirstSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.orderHotelTitleLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
            |> UILabel.lens.text .~ Localizations.OrderHotelTitle
    }
    
    func configureWith(value: HotelBookingSummary) {
        
        _ = self.hotelNameOrderLabel
            |> UILabel.lens.text .~ value.hotelName
        _ = self.statusOrderDateLabel
            |> UILabel.lens.text .~ "\(value.dateRange)"
        _ = self.guestRoomLabel
            |> UILabel.lens.text .~ "\(Localizations.GuestTitle(value.guestCount)), \(value.roomCount) \(value.roomType)"
    }
}
