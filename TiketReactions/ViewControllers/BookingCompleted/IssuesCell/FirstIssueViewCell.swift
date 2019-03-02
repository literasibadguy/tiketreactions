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
    
    public typealias Value = String
    
    @IBOutlet private weak var noticeStackView: UIStackView!
    @IBOutlet private weak var thankYouLabel: UILabel!
    @IBOutlet private weak var confirmedLabel: UILabel!
    
    
   public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self
            |> UIView.lens.backgroundColor .~ .tk_fade_green_grey
        
    }
    
    public func configureWith(value: String) {
        
        _ = self.thankYouLabel
            |> UILabel.lens.text .~ Localizations.ThankyouNotice
        _ = self.confirmedLabel
            |> UILabel.lens.text .~ Localizations.ConfirmedNotice
    }
}
