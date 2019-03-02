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
    
    @IBOutlet fileprivate weak var summaryContainerView: UIView!
    @IBOutlet fileprivate weak var summaryStackView: UIStackView!
    @IBOutlet fileprivate weak var titlePassengerLabel: UILabel!
    @IBOutlet fileprivate weak var formSummaryLabel: UILabel!
    @IBOutlet fileprivate weak var detailGreenArrowImageView: UIImageView!
    
    internal weak var delegate: PassengerSummaryCellDelegate?
    
    internal var updateHandler: ((PassengerSummaryViewCell) -> Void)? {
        didSet {
            
        }
    }
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configureUpdated(value: AdultPassengerParam, row: Int) {
        _ = self.formSummaryLabel
            |> UILabel.lens.text .~ "\(value.title ?? "") \(value.firstname ?? "") \(value.lastname ?? "")"
        self.delegate?.updatePassengerSummary(value, indexRow: row)
    }
    
    public func configureWith(value: FormatDataForm) {
        
        _ = self.summaryContainerView
            |> UIView.lens.layer.borderColor .~ UIColor.tk_official_green.cgColor
            |> UIView.lens.layer.borderWidth .~ 1.0
        
        _ = self.titlePassengerLabel
            |> UILabel.lens.text .~ value.fieldText
        
        _ = self.formSummaryLabel
            |> UILabel.lens.text .~ Localizations.FillDataTitlePassengerForm
        
        
    }
}
