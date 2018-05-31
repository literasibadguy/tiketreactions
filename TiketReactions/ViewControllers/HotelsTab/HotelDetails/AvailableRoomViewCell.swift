 //
//  AvailableRoomViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 08/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import Result
import Spring
import TiketKitModels
import UIKit

public protocol AvailableRoomCellDelegate: class {
    func goToNextCheckout(_ cell: AvailableRoomViewCell, with room: AvailableRoom)
}
 
public final class AvailableRoomViewCell: UITableViewCell, ValueCell {
    
    public typealias Value = AvailableRoom
    fileprivate let viewModel: AvailableRoomViewModelType = AvailableRoomViewModel()
    
    weak var delegate: AvailableRoomCellDelegate?
    
    @IBOutlet fileprivate weak var roomTypeLabel: UILabel!
    @IBOutlet fileprivate weak var roomPriceLabel: UILabel!
    @IBOutlet fileprivate weak var roomDescriptionLabel: UILabel!
    @IBOutlet fileprivate weak var availableRoomSeparatorView: UIView!
    @IBOutlet fileprivate weak var availableRoomLabel: UILabel!
    
    @IBOutlet fileprivate weak var bookRoomButton: DesignableButton!
    
    
    public override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.bookRoomButton.addTarget(self, action: #selector(bookingButtonTapped), for: .touchUpInside)
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.contentView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.roomTypeLabel
            |> UILabel.lens.font .~ UIFont.systemFont(ofSize: 14.0)
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.roomPriceLabel
            |> UILabel.lens.font .~ UIFont.boldSystemFont(ofSize: 14.0)
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.availableRoomSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.bookRoomButton
            |> UIButton.lens.backgroundColor(forState: .normal) .~ .tk_official_green
            |> UIButton.lens.backgroundColor(forState: .selected) .~ .tk_official_green_selected
            |> UIButton.lens.title(forState: .normal) .~ Localizations.OrderRoomTitle
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.roomTypeLabel.rac.text = self.viewModel.outputs.titleRoomText
        self.roomDescriptionLabel.rac.text = self.viewModel.outputs.descriptionRoomText
        self.roomPriceLabel.rac.text = self.viewModel.outputs.priceRoomText
        self.availableRoomLabel.rac.text = self.viewModel.outputs.availableRoomText
        self.viewModel.outputs.notifyDelegateNextCheckout
            .observe(on: UIScheduler())
            .observeValues { [weak self] room in
                guard let _self = self else { return }
                _self.delegate?.goToNextCheckout(_self, with: room)
        }
    }
    
    public func configureWith(value: AvailableRoom) {
        self.viewModel.inputs.configureWith(room: value)
    }
    
    @objc fileprivate func bookingButtonTapped() {
        self.viewModel.inputs.tappedBookingButton()
    }
}
