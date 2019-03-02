//
//  NoticeSummaryViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 06/09/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import UIKit

public final class NoticeSummaryViewCell: UITableViewCell, ValueCell {
    
    public typealias Value = String
    
    @IBOutlet fileprivate weak var noticeMainLabel: UILabel!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self
            |> UIView.lens.backgroundColor .~ .clear
        
        _ = self.noticeMainLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
    }
    
    public func configureWith(value: String) {
        _ = self.noticeMainLabel
            |> UILabel.lens.text .~ "\(value)"
    }
}
