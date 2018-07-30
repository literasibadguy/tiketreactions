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
    
    @IBOutlet fileprivate weak var firstIssueStackView: UIStackView!
    
    @IBOutlet fileprivate weak var paymentStatusLabel: UILabel!
    @IBOutlet fileprivate weak var orderNameTitleLabel: UILabel!
    @IBOutlet fileprivate weak var orderDetailTitleLabel: UILabel!
    @IBOutlet fileprivate weak var orderSubTitleLabel: UILabel!
    
    @IBOutlet fileprivate weak var firstIssueSeparatorView: UIView!
    
    
    public typealias Value = OrderCartDetail
    
   public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    public override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.firstIssueStackView
            |> UIStackView.lens.layoutMargins %~~ { _, stackView in
                stackView.traitCollection.isRegularRegular
                    ? .init(topBottom: Styles.grid(6), leftRight: Styles.grid(4))
                    : .init(top: Styles.grid(4), left: Styles.grid(4), bottom: Styles.grid(3), right: Styles.grid(2))
            }
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
            |> UIStackView.lens.spacing .~ 3
        
        _ = self.paymentStatusLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        _ = self.orderNameTitleLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        _ = self.orderDetailTitleLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        _ = self.orderSubTitleLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.firstIssueSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    public func configureWith(value: OrderCartDetail) {
        
        _ = self.orderNameTitleLabel
            |> UILabel.lens.text .~ value.orderName
        
        _ = self.orderDetailTitleLabel
            |> UILabel.lens.text .~ value.orderDetailId
    }
}
