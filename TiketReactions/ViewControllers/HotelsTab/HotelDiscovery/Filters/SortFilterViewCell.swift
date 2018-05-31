//
//  SortFilterViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 14/05/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit
import Prelude

public final class SortFilterViewCell: UITableViewCell, ValueCell {
    
    public typealias Value = String
    
    @IBOutlet fileprivate weak var sortLabel: UILabel!
    @IBOutlet fileprivate weak var sortCheckImageView: UIImageView!
    @IBOutlet fileprivate weak var sortSeparatorView: UIView!
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        if selected == true {
            _ = sortCheckImageView
                |> UIImageView.lens.image .~ UIImage(named: "icon-check-sort")
        } else {
            _ = sortCheckImageView
                |> UIImageView.lens.image .~ UIImage(named: "icon-unchecked-sort")
        }
        // Configure the view for the selected state
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.sortLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.sortSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    public func configureWith(value: String) {
        _ = self.sortLabel
            |> UILabel.lens.text .~ sortFilterLists(value)
    }
    
}

fileprivate func sortFilterLists(_ sort: String) -> String {
    switch sort {
    case "popular":
        return Localizations.FilterPopulerTitle
    case "priceasc":
        return Localizations.FilterLowpriceTitle
    case "pricedesc":
        return Localizations.FilterHighpriceTitle
    default:
        return ""
    }
}
