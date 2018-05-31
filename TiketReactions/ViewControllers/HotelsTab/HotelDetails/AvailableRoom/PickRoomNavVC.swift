//
//  PickRoomNavVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 13/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import Spring
import TiketKitModels
import UIKit

internal final class PickRoomNavVC: UIViewController {
    
    fileprivate let viewModel: PickRoomNavViewModelType = PickRoomNavViewModel()
    
    @IBOutlet fileprivate weak var roomNavSeparatorView: UIView!
    @IBOutlet fileprivate weak var startingPriceLabel: UILabel!
    @IBOutlet weak var chooseRoomButton: DesignableButton!
    
    internal func configureWith(hotel: HotelDirect, booking: HotelBookingSummary) {
        self.viewModel.inputs.configureWith(hotelDirect: hotel, booking: booking)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.chooseRoomButton.addTarget(self, action: #selector(chooseRoomButtonTapped), for: .touchUpInside)
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self.chooseRoomButton
            |> UIButton.lens.backgroundColor .~ UIColor.tk_official_green
            |> UIButton.lens.title(forState: .normal) .~ Localizations.ChooseRoomTitle
        
        _ = startingPriceLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
            |> UILabel.lens.font .~ UIFont.systemFont(ofSize: 16.0)
        
        _ = self.roomNavSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.startingPriceLabel.rac.text = self.viewModel.outputs.startPriceRoomTitleText
        
        self.viewModel.outputs.goToAvailableRooms
            .observe(on: UIScheduler())
            .observeValues { [weak self] direct, summary in
                self?.goToAvailableRooms(hotelDirect: direct, booking: summary)
        }
    }
    
    fileprivate func goToAvailableRooms(hotelDirect: HotelDirect, booking: HotelBookingSummary) {
        let roomVC = AvailableRoomListsVC.configureWith(hotelDirect: hotelDirect, booking: booking)
        self.navigationController?.pushViewController(roomVC, animated: true)
    }
    
    @objc fileprivate func chooseRoomButtonTapped() {
        self.viewModel.inputs.chooseRoomsButtonTapped()
    }

}
