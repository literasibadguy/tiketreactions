//
//  OrderListViewCell.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 25/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

public protocol OrderListViewCellDelegate: class {
    func orderDeleteButtonTapped(_ listCell: OrderListViewCell, order: OrderData)
}

public final class OrderListViewCell: UITableViewCell, ValueCell {
    
    public typealias Value = OrderData
    
    fileprivate let viewModel: OrderListCellViewModelType = OrderListCellViewModel()
    
    weak var delegate: OrderListViewCellDelegate?

    @IBOutlet fileprivate weak var orderListStackView: UIStackView!
    
    @IBOutlet fileprivate weak var orderTypeLabel: UILabel!
    @IBOutlet fileprivate weak var orderNameLabel: UILabel!
    @IBOutlet fileprivate weak var orderNameDetailLabel: UILabel!
    
    @IBOutlet fileprivate weak var startDateLabel: UILabel!
    @IBOutlet fileprivate weak var deleteOrderButton: UIButton!
    
    @IBOutlet fileprivate weak var orderListSeparatorView: UIView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.deleteOrderButton.addTarget(self, action: #selector(deleteOrderButtonTapped), for: .touchUpInside)
    }
    
    override public func bindStyles() {
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
        
        if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            _ = self.orderNameLabel
                |> UILabel.lens.font .~ UIFont.boldSystemFont(ofSize: 16.0)
            
            _ = self.orderNameDetailLabel
                |> UILabel.lens.font .~ UIFont.systemFont(ofSize: 14.0)
            
            _ = self.startDateLabel
                |> UILabel.lens.font .~ UIFont.systemFont(ofSize: 14.0)
        }
        
        _ = self.orderNameDetailLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_500
        _ = self.startDateLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_500
        
        _ = self.orderListSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    override public func bindViewModel() {
        super.bindViewModel()
        
        self.orderTypeLabel.rac.text = self.viewModel.outputs.orderTypeText
        self.orderNameLabel.rac.text = self.viewModel.outputs.orderNameText
        self.orderNameDetailLabel.rac.text = self.viewModel.outputs.orderNameDetailText
        self.startDateLabel.rac.text = self.viewModel.outputs.startDateText
        
        self.viewModel.outputs.notifyToDeleteOrder
            .observe(on: UIScheduler())
            .observeValues { [weak self] order in
              guard let _self = self else { return }
              print("NOTIFY TO DELETE ORDER")
              _self.delegate?.orderDeleteButtonTapped(_self, order: order)
        }
    }

    public func configureWith(value: OrderData) {
        
        self.viewModel.inputs.configureWith(value)
    }
    
    @objc fileprivate func deleteOrderButtonTapped() {
        print("DELETE ORDER BUTTON TAPPED")
        self.viewModel.inputs.deleteOrderButtonTapped()
    }
}
