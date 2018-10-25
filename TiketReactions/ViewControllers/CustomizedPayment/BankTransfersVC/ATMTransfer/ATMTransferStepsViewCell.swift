//
//  ATMTransferStepsViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 16/10/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import TiketKitModels
import UIKit

internal final class ATMTransferStepsViewCell: UITableViewCell, ValueCell {
    
    typealias Value = TransferATMSteps
    
    @IBOutlet private weak var headlineTransferLabel: UILabel!
    @IBOutlet private weak var stepsStackView: UIStackView!
    @IBOutlet private weak var stepsCellSeparatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        
        _ = self.stepsStackView
            |> UIStackView.lens.spacing .~ 8
        
        _ = self.stepsCellSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    func configureWith(value: TransferATMSteps) {
        
        _ = self.headlineTransferLabel
            |> UILabel.lens.text .~ value.name
        
        self.load(items: value.stepsDecrtiption)
    }
    
    private func load(items: [String]) {
        self.stepsStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for item in items {
            let label = UILabel()
                |> UILabel.lens.font .~ UIFont.systemFont(ofSize: 16.0)
                |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
                |> UILabel.lens.text .~ item
                |> UILabel.lens.numberOfLines .~ 0
            
            /*
            let separator = UIView()
                |> separatorStyle
            separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
            */
            
            self.stepsStackView.addArrangedSubview(label)
        }
    }
    
}
