//
//  PickFlightNoticeViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 07/09/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import UIKit

public final class PickFlightNoticeViewCell: UITableViewCell, ValueCell {
    
    public typealias Value = PickNoticeFlight
    
    
    @IBOutlet fileprivate weak var noticeStackView: UIStackView!
    @IBOutlet fileprivate weak var dateNoticeLabel: UILabel!
    @IBOutlet fileprivate weak var routeNoticeLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self
            |> UIView.lens.backgroundColor .~ .tk_fade_green_grey
        
        _ = self.dateNoticeLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.routeNoticeLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
    }
    
    public func configureWith(value: PickNoticeFlight) {
        _ = self.dateNoticeLabel
            |> UILabel.lens.text .~ (value.date ?? "")
        
        _ = self.routeNoticeLabel
            |> UILabel.lens.text .~ (value.route ?? "")
    }
    
}


public struct PickNoticeFlight {
    public var date: String?
    public var route: String?
}
