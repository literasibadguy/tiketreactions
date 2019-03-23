//
//  PassengerFilledViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 17/03/19.
//  Copyright © 2019 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

class PassengerFilledViewCell: UITableViewCell, ValueCell {
    
    typealias Value = AdultPassengerParam
    
    @IBOutlet weak var filledContainerView: UIView!
    @IBOutlet fileprivate weak var summaryStackView: UIStackView!
    @IBOutlet fileprivate weak var formatFieldTextLabel: UILabel!
    @IBOutlet fileprivate weak var filledPassengerLabel: UILabel!
    
    fileprivate let viewModel: PassengerSummaryCellViewModelType = PassengerSummaryCellViewModel()
    
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
        
        _ = self.formatFieldTextLabel
            |> UILabel.lens.text .~ "Passenger"
        
        _ = self.filledContainerView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.filledPassengerLabel.rac.text = self.viewModel.outputs.summaryText
    }
    
    func configureWith(value: AdultPassengerParam) {
        self.viewModel.inputs.configureSummary(value)
    }
    
}
