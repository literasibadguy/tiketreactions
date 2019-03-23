//
//  PassengerSummaryViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 30/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import TiketKitModels
import UIKit

public protocol PassengerSummaryCellDelegate: class {
    func updatePassengerSummary(_ text: AdultPassengerParam, indexRow: Int)
}

public class PassengerSummaryViewCell: UITableViewCell, ValueCell {
    
    public typealias Value = FormatDataForm
    
    fileprivate let viewModel: PassengerSummaryCellViewModelType = PassengerSummaryCellViewModel()
    
    @IBOutlet fileprivate weak var summaryContainerView: UIView!
    @IBOutlet fileprivate weak var summaryStackView: UIStackView!
    @IBOutlet fileprivate weak var titlePassengerLabel: UILabel!
    @IBOutlet fileprivate weak var formSummaryLabel: UILabel!
    @IBOutlet fileprivate weak var detailGreenArrowImageView: UIImageView!
    
    internal weak var delegate: PassengerSummaryCellDelegate?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.summaryContainerView
            |> UIView.lens.layer.borderColor .~ UIColor.tk_official_green.cgColor
            |> UIView.lens.layer.borderWidth .~ 1.0
        
        _ = self.formSummaryLabel
            |> UILabel.lens.text .~ Localizations.FillDataTitlePassengerForm
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.formSummaryLabel.rac.text = self.viewModel.outputs.summaryText
    }
    
    public func configureWith(value: FormatDataForm) {
//        print("INSIDE VALUE ADULT PASSENGER: \(value.1)")
        
        _ = self.titlePassengerLabel
            |> UILabel.lens.text .~ value.fieldText
        
        self.viewModel.inputs.configurePassenger(value)
        
    }
    
    public func extendWith(passenger: AdultPassengerParam, indexRow: Int) {
//        self.delegate?.updatePassengerSummary(passenger, indexRow: indexRow)
        self.viewModel.inputs.configureSummary(passenger)
    }
}
