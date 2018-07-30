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
    func printVoucherButtonTapped(_ cell: SecondIssueViewCell, document: PDFDocument)
}

public final class SecondIssueViewCell: UITableViewCell, ValueCell {
    
    public typealias Value = OrderCartDetail
    
    fileprivate let viewModel: ThirdIssueViewModelType = ThirdIssueViewModel()
    
    @IBOutlet fileprivate weak var firstIssueStackView: UIStackView!
    
    @IBOutlet fileprivate weak var paymentStatusLabel: UILabel!
    @IBOutlet fileprivate weak var orderNameTitleLabel: UILabel!
    @IBOutlet fileprivate weak var orderDetailTitleLabel: UILabel!
    @IBOutlet fileprivate weak var orderSubTitleLabel: UILabel!
    
    @IBOutlet fileprivate weak var checkinInputLabel: UILabel!
    @IBOutlet fileprivate weak var guestnameInputLabel: UILabel!
    
    @IBOutlet fileprivate weak var checkinValueLabel: UILabel!
    @IBOutlet fileprivate weak var guestnameValueLabel: UILabel!
    @IBOutlet fileprivate weak var nightsValueLabel: UILabel!
    
    @IBOutlet fileprivate weak var emailVoucherButton: UIButton!
    @IBOutlet fileprivate weak var printVoucherButton: UIButton!
    @IBOutlet fileprivate weak var thirdIssueSeparatorView: UIView!
    
    weak var delegate: SecondIssueCelLDelegate?
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.emailVoucherButton.addTarget(self, action: #selector(emailVoucherTapped), for: .touchUpInside)
        self.printVoucherButton.addTarget(self, action: #selector(printVoucherTapped), for: .touchUpInside)
    }

    override public func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override public func bindStyles() {
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
        
        _ = self.checkinInputLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_500
        
        _ = self.guestnameInputLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_500
        
        _ = self.checkinValueLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.guestnameValueLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.nightsValueLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.emailVoucherButton
            |> UIButton.lens.tintColor .~ .tk_official_green
        
        _ = self.printVoucherButton
            |> UIButton.lens.backgroundColor .~ .tk_official_green
            |> UIButton.lens.tintColor .~ .white
        
        _ = self.thirdIssueSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.generateImage
            .observe(on: UIScheduler())
            .observeValues { [weak self] generated in
                guard let _self = self else { return }
                _self.delegate?.printVoucherButtonTapped(_self, document: generated)
        }
    }
    
    public func configureWith(value: OrderCartDetail) {
        print("Configure With Value: \(value)")
        self.viewModel.inputs.configureWith(value)
        
        _ = self.paymentStatusLabel
            |> UILabel.lens.text .~ "Pesan Hotel"
        
        _ = self.orderNameTitleLabel
            |> UILabel.lens.text .~ value.orderName
        
        _ = self.orderDetailTitleLabel
            |> UILabel.lens.text .~ "61014414"
        
        _ = self.orderSubTitleLabel
            |> UILabel.lens.text .~ "Superior ROOM Only, 2 Kamar"
        
        _ = self.checkinValueLabel
            |> UILabel.lens.text .~ value.hotelDetail.checkin
        
        let fullname = "\(value.passenger.last?.accountSalutationName ?? "") \(value.passenger.last?.accountFirstName ?? "") \(value.passenger.last?.accountLastName ?? "")"
        
        _ = self.guestnameValueLabel
            |> UILabel.lens.text .~ fullname
        
        _ = self.nightsValueLabel
            |> UILabel.lens.text .~ "\(value.hotelDetail.nights) Malam"
    }
    
    @objc fileprivate func emailVoucherTapped() {
        self.viewModel.inputs.emailVoucherTapped()
    }
    
    @objc fileprivate func printVoucherTapped() {
        self.viewModel.inputs.downloadVoucherTapped()
    }
    
}
