//
//  PickDatesHotelVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 08/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import Spring
import TiketKitModels
import UIKit

public final class PickDatesHotelVC: UIViewController {
    
    fileprivate let viewModel: PickDatesHotelViewModelType = PickDatesHotelViewModel()
    fileprivate var dateRangeVC: DateRangesVC!
    
    @IBOutlet fileprivate weak var cancelButton: UIButton!
    @IBOutlet fileprivate weak var findHotelButton: DesignableButton!
    
    @IBOutlet fileprivate weak var mainDateLabel: UILabel!
    @IBOutlet fileprivate weak var checkInDateLabel: UILabel!
    @IBOutlet fileprivate weak var checkOutDateLabel: UILabel!
    
    @IBOutlet fileprivate weak var dateSeparatorView: UIView!
    @IBOutlet fileprivate weak var findHotelSeparatorView: UIView!
    
    internal static func configureWith(_ selected: AutoHotelResult, hotelParam: SearchHotelParams) -> PickDatesHotelVC {
        let vc = Storyboard.PickDatesHotel.instantiate(PickDatesHotelVC.self)
        vc.viewModel.inputs.configureWith(selected: selected, searchHotel: hotelParam)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dateRangeVC = self.childViewControllers
            .compactMap { $0 as? DateRangesVC }.first
        self.dateRangeVC.delegate = self
        
        self.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        self.findHotelButton.addTarget(self, action: #selector(findHotelButtonTapped), for: .touchUpInside)
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.findHotelButton
            |> UIButton.lens.backgroundColor(forState: .disabled) .~ .tk_typo_green_grey_500
            |> UIButton.lens.backgroundColor(forState: .normal) .~ .tk_official_green
            |> UIButton.lens.titleColor(forState: .normal) .~ .white
            |> UIButton.lens.isEnabled .~ false
        
        _ = self.mainDateLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.checkInDateLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_500
        
        _ = self.checkOutDateLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_500
        
        _ = self.dateSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.findHotelSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.checkInDateLabel.rac.text = self.viewModel.outputs.checkInDateText
        self.checkOutDateLabel.rac.text = self.viewModel.outputs.checkOutDateText
        self.mainDateLabel.rac.text = self.viewModel.outputs.rangesNightText
        
        self.findHotelButton.rac.isEnabled = self.viewModel.outputs.enabledHotelResultsButton
        self.findHotelButton.rac.title = self.viewModel.outputs.bookingText
        
        self.viewModel.outputs.overNightAlertText
            .observe(on: UIScheduler())
            .observeValues { [weak self] message in
                self?.present(UIAlertController.genericError(message: message, cancel: { _ in                 self?.viewModel.inputs.shouldClearDate(shouldFalse: false) } ), animated: true, completion: nil)
        }
        
        self.viewModel.outputs.goToResults
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] selected, param, summary in
                guard let _self = self else { return }
                _self.goToHotelResults(selected: selected, param: param, summary: summary)
        }
        
        self.viewModel.outputs.dismissPickDate
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.dismiss(animated: true,  completion: nil)
        }
    }
    
    fileprivate func goToHotelResults(selected: AutoHotelResult, param: SearchHotelParams, summary: HotelBookingSummary) {
        let vc = HotelDiscoveryEmbedVC.configureWith(selected: selected, params: param, booking: summary)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc fileprivate func findHotelButtonTapped() {
        print("TAPPED HOTEL FIND BUTTON..")
        self.viewModel.inputs.tappedHotelFindButton()
    }
    
    @objc fileprivate func cancelButtonTapped() {
        self.viewModel.inputs.tappedCancelButton()
    }
}

extension PickDatesHotelVC: DateRangesVCDelegate {
    
    public func didSelectStartDate(startDate: Date!) {
        self.viewModel.inputs.pickStartDate(start: startDate ?? Date())
    }
    
    public func diSelectEndDate(endDate: Date!) {
        self.viewModel.inputs.pickEndDate(end: endDate ?? Date())
    }
}


