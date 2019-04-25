//
//  FirstIssueViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 12/06/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit
import Prelude
import ReactiveSwift
import TiketKitModels

public protocol FirstIssueCellDelegate: class {
    func baggageIssueButtonTapped()
}

public final class FirstIssueViewCell: UITableViewCell, ValueCell {
    
    public typealias Value = OrderCartDetail
    
    fileprivate let viewModel: FirstIssueViewModelType = FirstIssueViewModel()
    
    @IBOutlet fileprivate weak var noticeStackView: UIStackView!
    @IBOutlet fileprivate weak var thankYouLabel: UILabel!
    @IBOutlet fileprivate weak var confirmedLabel: UILabel!
    @IBOutlet fileprivate weak var flightNoticeButton: UIButton!
    
    public weak var delegate: FirstIssueCellDelegate?
    
   public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    self.flightNoticeButton.addTarget(self, action: #selector(flightBaggageButtonTapped), for: .touchUpInside)
    
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self
            |> UIView.lens.backgroundColor .~ .tk_fade_green_grey
        
        _ = self.flightNoticeButton
            |> UIButton.lens.isHidden .~ true
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.flightNoticeButton.rac.hidden = self.viewModel.outputs.isItLionFlight
        
        self.viewModel.outputs.baggageTapped
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                guard let _self = self else { return }
                _self.delegate?.baggageIssueButtonTapped()
        }
    }
    
    @objc private func flightBaggageButtonTapped() {
        self.viewModel.inputs.baggageDetailButtonTapped()
    }
    
    public func configureWith(value: OrderCartDetail) {
        self.viewModel.inputs.configureWith(value)
        
        _ = self.thankYouLabel
            |> UILabel.lens.text .~ Localizations.ThankyouNotice
        _ = self.confirmedLabel
            |> UILabel.lens.text .~ Localizations.ConfirmedNotice
        _ = self.flightNoticeButton
            |> UIButton.lens.title(forState: .normal) .~ Localizations.LionAirNotice
    }
}
