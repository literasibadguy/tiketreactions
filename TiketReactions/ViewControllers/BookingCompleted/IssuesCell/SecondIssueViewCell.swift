//
//  SecondIssueViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 12/06/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit
import PDFReader
import Prelude
import ReactiveSwift
import TiketKitModels

public protocol SecondIssueCelLDelegate: class {
    func emailVoucherButtonTapped(_ cell: SecondIssueViewCell)
    func printVoucherErrorDetected(_ cell: SecondIssueViewCell, description: String)
    func printVoucherButtonTapped(_ cell: SecondIssueViewCell, document: PDFDocument?)
}

public final class SecondIssueViewCell: UITableViewCell, ValueCell {
    
    public typealias Value = OrderCartDetail
    
    fileprivate let viewModel: ThirdIssueViewModelType = ThirdIssueViewModel()
    
    @IBOutlet private weak var headIssueStackView: UIStackView!
    @IBOutlet private weak var detailIssueStackView: UIStackView!
    
    @IBOutlet private weak var headOrderTitleLabel: UILabel!
    @IBOutlet private weak var headOrderSubtitleLabel: UILabel!
    @IBOutlet private weak var headSeparatorView: UIView!
    
    @IBOutlet private weak var guestNameStackView: UIStackView!
    @IBOutlet private weak var guestInputLabel: UILabel!
    @IBOutlet private weak var guestLabel: UILabel!
    
    @IBOutlet private weak var checkInStackView: UIStackView!
    @IBOutlet private weak var checkInInputLabel: UILabel!
    @IBOutlet private weak var checkInLabel: UILabel!
    
    @IBOutlet private weak var roomStackView: UIStackView!
    @IBOutlet private weak var roomInputLabel: UILabel!
    @IBOutlet private weak var roomLabel: UILabel!
    
    @IBOutlet private weak var breakfastStackView: UIStackView!
    @IBOutlet private weak var breakfastInputLabel: UILabel!
    @IBOutlet private weak var breakfastLabel: UILabel!
    @IBOutlet private weak var issueSeparatorView: UIView!
    
    @IBOutlet private weak var printVoucherButton: UIButton!
    
    weak var delegate: SecondIssueCelLDelegate?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        self.emailVoucherButton.addTarget(self, action: #selector(emailVoucherTapped), for: .touchUpInside)
        self.printVoucherButton.addTarget(self, action: #selector(printVoucherTapped), for: .touchUpInside)
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override public func bindStyles() {
        super.bindStyles()
        
        _ = self.headSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.headOrderTitleLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.guestLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.checkInLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.roomLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.breakfastLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.issueSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_typo_green_grey_500
        
        _ = self.printVoucherButton
            |> UIButton.lens.backgroundColor .~ .tk_official_green
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.guestInputLabel.rac.text = self.viewModel.outputs.firstFormTitle
        self.checkInInputLabel.rac.text = self.viewModel.outputs.secondFormTitle
        self.roomInputLabel.rac.text = self.viewModel.outputs.thirdFormTitle
        self.breakfastInputLabel.rac.text = self.viewModel.outputs.fourthFormTitle
        
        self.headOrderTitleLabel.rac.text = self.viewModel.outputs.titleOrderText
        self.headOrderSubtitleLabel.rac.text = self.viewModel.outputs.subtitleOrderText
        self.guestLabel.rac.text = self.viewModel.outputs.guestNameText
        self.checkInLabel.rac.text = self.viewModel.outputs.checkInText
        self.roomLabel.rac.text = self.viewModel.outputs.roomsText
        self.breakfastLabel.rac.text = self.viewModel.outputs.breakfastText
        
        self.viewModel.outputs.generateImage
            .observe(on: UIScheduler())
            .observeValues { [weak self] generated in
                guard let _self = self else { return }
                _self.delegate?.printVoucherButtonTapped(_self, document: generated)
        }
        
        self.viewModel.outputs.generatePDFError
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] error in
                guard let _self = self else { return }
                _self.delegate?.printVoucherErrorDetected(_self, description: error)
        }
    }
    
    public func configureWith(value: OrderCartDetail) {
        print("Configure With Value: \(value)")
        self.viewModel.inputs.configureWith(value)
        
    }
    
    @objc fileprivate func emailVoucherTapped() {
        self.viewModel.inputs.emailVoucherTapped()
    }
    
    @objc fileprivate func printVoucherTapped() {
        self.viewModel.inputs.downloadVoucherTapped()
    }
    
}
