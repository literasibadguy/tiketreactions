//
//  HotelSubpageViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 01/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import TiketAPIs
import UIKit

class HotelSubpageViewCell: UITableViewCell, ValueCell {
    typealias Value = HotelDirect
    
    @IBOutlet fileprivate weak var rootStackView: UIStackView!
    
    @IBOutlet fileprivate weak var subpageLabel: UILabel!
    
    @IBOutlet fileprivate weak var countContainerView: UIView!
    
    @IBOutlet fileprivate weak var countLabel: UILabel!
    
    @IBOutlet fileprivate weak var topSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var separatorView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func bindStyles() {
        super.bindStyles()
        
        _ = self.countContainerView
            |> UIView.lens.layoutMargins .~ .init(topBottom: Styles.grid(1), leftRight: Styles.grid(2))
            |> UIView.lens.layer.borderWidth .~ 1
        
        _ = self.countLabel
            |> UILabel.lens.font .~ UIFont.systemFont(ofSize: 13.0)
            |> UIView.lens.contentHuggingPriority(for: .horizontal) .~ .required
            |> UIView.lens.contentCompressionResistancePriority(for: .horizontal) .~ .required
        
        _ = self.rootStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
            |> UIStackView.lens.alignment .~ .center
            |> UIStackView.lens.distribution .~ .fill
        
        _ = [self.separatorView, self.topSeparatorView] ||> separatorStyle
        
        _ = self.subpageLabel
            |> UILabel.lens.numberOfLines .~ 2
            |> UILabel.lens.font .~ UIFont.systemFont(ofSize: 14.0)
            |> UIView.lens.contentHuggingPriority(for: .horizontal) .~ .defaultLow
            |> UIView.lens.contentCompressionResistancePriority(for: .horizontal) .~ .defaultLow
    }
    
    func configureWith(value: HotelDirect) {
        self.subpageLabel.text = value.breadcrumb.continentName
    }
    
    
}
