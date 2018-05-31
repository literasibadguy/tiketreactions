//
//  FacilityDetailViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 25/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import TiketKitModels
import UIKit

internal final class FacilityDetailViewCell: UITableViewCell, ValueCell {
    
    typealias Value = [HotelDirect.AvailableFacility]
    
    @IBOutlet fileprivate weak var groupLabel: UILabel!
    @IBOutlet fileprivate weak var subgroupLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self.groupLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.subgroupLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_500
    }
    
    func configureWith(value: [HotelDirect.AvailableFacility]) {
        
        let listNames = value.map { $0.facilityName }
        
        _ = self.groupLabel
            |> UILabel.lens.text .~ Localizations.FacilityRoomTitle
        
        let paragraphStyle = NSMutableParagraphStyle()
        //line height size
        paragraphStyle.lineSpacing = 2.6
        let attrString = NSMutableAttributedString(string: listNames.joined(separator: ", "))
        attrString.addAttribute(kCTParagraphStyleAttributeName as NSAttributedStringKey, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        
        _ = self.subgroupLabel
            |> UILabel.lens.attributedText .~ attrString
    }
}
