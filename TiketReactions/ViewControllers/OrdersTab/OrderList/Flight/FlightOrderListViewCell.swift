//
//  FlightOrderListViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 03/10/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import TiketKitModels
import Prelude
import ReactiveSwift
import UIKit

public protocol FlightOrderListViewCellDelegate: class {
    func orderDeleteButtonTapped(_ listCell: FlightOrderListViewCell, order: FlightOrderData)
}

public final class FlightOrderListViewCell: UITableViewCell, ValueCell {
    
    public typealias Value = FlightOrderData
    
    fileprivate let viewModel: FlightOrderCellViewModelType = FlightOrderCellViewModel()
    
    @IBOutlet fileprivate weak var orderListStackView: UIStackView!
    
    @IBOutlet fileprivate weak var orderTypeLabel: UILabel!
    @IBOutlet fileprivate weak var orderNameLabel: UILabel!
    @IBOutlet fileprivate weak var orderNameDetailLabel: UILabel!
    
    @IBOutlet fileprivate weak var startDateLabel: UILabel!
    @IBOutlet fileprivate weak var deleteOrderButton: UIButton!
    
    @IBOutlet fileprivate weak var orderListSeparatorView: UIView!
    
    weak var delegate: FlightOrderListViewCellDelegate?
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.deleteOrderButton.addTarget(self, action: #selector(deleteOrderButtonTapped), for: .touchUpInside)
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.orderListStackView
            |> UIStackView.lens.layoutMargins %~~ { _, stackView in
                stackView.traitCollection.isRegularRegular
                    ? .init(topBottom: Styles.grid(2), leftRight: Styles.grid(14))
                    : .init(top: Styles.grid(2), left: Styles.grid(3), bottom: Styles.grid(2), right: Styles.grid(2))
            }
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
            |> UIStackView.lens.spacing .~ Styles.grid(1)
        
        _ = self.orderTypeLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.deleteOrderButton
            |> UIButton.lens.image(forState: .selected) .~ UIImage(named: "icon-delete-button-selected")
        
        _ = self.orderNameLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.orderNameDetailLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_500
        _ = self.startDateLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_500
        
        _ = self.orderListSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.orderTypeLabel.rac.text = self.viewModel.outputs.orderTypeText
        self.orderNameLabel.rac.text = self.viewModel.outputs.orderNameText
        self.orderNameDetailLabel.rac.text = self.viewModel.outputs.orderNameDetailText
        self.startDateLabel.rac.text = self.viewModel.outputs.startDateText
        
        self.viewModel.outputs.notifyToDeleteOrder
            .observe(on: UIScheduler())
            .observeValues { [weak self] flightOrder in
                guard let _self = self else { return }
                _self.delegate?.orderDeleteButtonTapped(_self, order: flightOrder)
        }
    }
    
    public func configureWith(value: FlightOrderData) {
        self.viewModel.inputs.configureFlightWith(value)
    }
    
    @objc fileprivate func deleteOrderButtonTapped() {
        self.viewModel.inputs.deleteOrderButtonTapped()
    }
    
}
