//
//  HotelLiveFormVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 12/10/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import Spring
import TiketKitModels
import UIKit

public final class HotelLiveFormVC: UIViewController {
    
    fileprivate let viewModel: HotelFormViewModelType = HotelFormViewModel()
    
    @IBOutlet private weak var hotelFormStackView: UIStackView!
    @IBOutlet private weak var destinationInputStackView: UIStackView!
    @IBOutlet private weak var destinationInputTextLabel: UILabel!
    @IBOutlet private weak var destinationContainerView: UIView!
    @IBOutlet private weak var destinationPickButton: UIButton!
    @IBOutlet private weak var destinationMenuStackView: UIStackView!
    @IBOutlet private weak var destinationLabel: UILabel!
    
    @IBOutlet private weak var destinationSeparatorView: UIView!
    @IBOutlet private weak var guestInputStackView: UIStackView!
    @IBOutlet private weak var guestInputTextLabel: UILabel!
    @IBOutlet private weak var guestContainerView: UIView!
    @IBOutlet private weak var guestPickButton: UIButton!
    @IBOutlet private weak var guestMenuStackView: UIStackView!
    @IBOutlet private weak var guestLabel: UILabel!
    
    @IBOutlet private weak var guestSeparatorView: UIView!
    @IBOutlet private weak var confirmSearchButton: DesignableButton!
    
    public static func instantiate() -> HotelLiveFormVC {
        let vc = Storyboard.HotelForm.instantiate(HotelLiveFormVC.self)
        return vc
    }
    
    public override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.destinationPickButton.addTarget(self, action: #selector(destinationPickTapped), for: .touchUpInside)
        self.guestPickButton.addTarget(self, action: #selector(guestPickTapped), for: .touchUpInside)
        self.confirmSearchButton.addTarget(self, action: #selector(confirmDateTapped), for: .touchUpInside)
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setNeedsStatusBarAppearanceUpdate()
        
        self.viewModel.inputs.viewWillAppear()
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.hotelFormStackView
            |> UIStackView.lens.layoutMargins .~ .init(topBottom: Styles.grid(6), leftRight: Styles.grid(2))
            |> UIStackView.lens.spacing .~ Styles.grid(2)
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
        
        _ = self.destinationMenuStackView
            |> UIView.lens.isUserInteractionEnabled .~ false
        
        _ = self.guestMenuStackView
            |> UIView.lens.isUserInteractionEnabled .~ false
        
        _ = self.destinationInputTextLabel
            |> UILabel.lens.text .~ Localizations.DestinationHotelTitleForm
            |> UILabel.lens.textColor .~ .black
        
        _ = self.guestInputTextLabel
            |> UILabel.lens.text .~ Localizations.GuestRoomTitleForm
            |> UILabel.lens.textColor .~ .black
        
        _ = self.guestLabel
            |> UILabel.lens.textColor .~ .tk_official_green
        
        _ = self.destinationLabel
            |> UILabel.lens.textColor .~ .tk_official_green
        
        _ = self.destinationContainerView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.guestContainerView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.destinationSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.guestSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        self.confirmSearchButton.cornerRadius = 10.0
        
        _ = self.confirmSearchButton
            |> DesignableButton.lens.title(forState: .normal) .~ Localizations.PickDateTitleForm
            |> DesignableButton.lens.backgroundImage(forState: .normal) .~ UIImage(named: "background-hotel-tab")
            |> DesignableButton.lens.backgroundImage(forState: .selected) .~ UIImage(named: "background-hotel-tab")
    }
    
    public override func bindViewModel() {
        super.bindViewModel()

        self.destinationLabel.rac.text = self.viewModel.outputs.destinationHotelLabelText
        self.guestLabel.rac.text = self.viewModel.outputs.guestHotelLabelText
        
        self.viewModel.outputs.showDestinationHotelList
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.goToDestinationList()
        }
        
        self.viewModel.outputs.showGuestRoomPick
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] guest, room in
                self?.goToGuestList(guest: guest, room: room)
        }
        
        self.viewModel.outputs.goToPickDate
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] selected, params in
                self?.confirmToPickDate(selected: selected, params: params)
        }
    }
    
    private func goToDestinationList() {
        let destinationVC = Storyboard.DestinationHotel.instantiate(DestinationHotelListVC.self)
        destinationVC.delegate = self
        destinationVC.modalPresentationStyle = .overFullScreen
        self.present(destinationVC, animated: true, completion: nil)
    }
    
    private func goToGuestList(guest: Int, room: Int) {
        let pickGuestVC = GuestRoomStepperVC.configureWith(guest: guest, room: room)
        pickGuestVC.delegate = self
        pickGuestVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        pickGuestVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(pickGuestVC, animated: true, completion: nil)
    }
    
    private func confirmToPickDate(selected: AutoHotelResult, params: SearchHotelParams) {
        let hotelPickDateVC = PickDatesHotelVC.configureWith(selected, hotelParam: params)
        let nav = UINavigationController(rootViewController: hotelPickDateVC)
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc private func destinationPickTapped() {
        self.viewModel.inputs.destinationButtonTapped()
    }
    
    @objc private func guestPickTapped() {
        self.viewModel.inputs.guestButtonTapped()
    }
    
    @objc private func confirmDateTapped() {
        self.viewModel.inputs.selectDatePressed()
    }
}

extension HotelLiveFormVC: DestinationHotelListVCDelegate {
    func destinationHotelList(_ vc: DestinationHotelListVC, selectedRow: AutoHotelResult) {
        print("HOTEL FORM VC UPDATED DESTINATION: \(selectedRow.category)")
        self.viewModel.inputs.destinationHotelSelected(row: selectedRow)
    }
    
    func destinationHotelListDidClose(_ vc: DestinationHotelListVC) {
        
    }
}

extension HotelLiveFormVC: GuestRoomStepperDelegate {
    public func didDismissCounting(_ guest: Int, room: Int) {
        self.viewModel.inputs.selectedCounts(guest: guest, room: room)
    }
}
