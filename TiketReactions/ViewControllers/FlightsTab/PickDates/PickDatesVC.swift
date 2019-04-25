//
//  PickDatesVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 29/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

public protocol PickDatesDelegate: class {
    func submitDate(depart: Date, returned: Date?)
}

public protocol PickSingleDateDelegate: class {
    func submitSingleDate(depart: Date)
}

public final class PickDatesVC: UIViewController {
    
    fileprivate let cellReuseIdentifier = "PickDateRangeViewCell"
    
    fileprivate let viewModel: PickDatesViewModelType = PickDatesViewModel()
    fileprivate var dateRangeController: DateRangesVC!
    
    @IBOutlet fileprivate weak var cancelButton: UIButton!

    @IBOutlet fileprivate weak var headTitleStackView: UIStackView!
    @IBOutlet fileprivate weak var navDateSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var firstDateTitleLabel: UILabel!
    @IBOutlet fileprivate weak var firstDateTextLabel: UILabel!
    
    @IBOutlet fileprivate weak var endDateTitleLabel: UILabel!
    @IBOutlet fileprivate weak var endDateTextLabel: UILabel!
    @IBOutlet fileprivate weak var flightFindButton: UIButton!
    @IBOutlet fileprivate weak var loadingOverlayView: UIView!
    @IBOutlet fileprivate weak var loadingFlightIndicatorView: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var cancelLoadingButton: UIButton!
    
    private var minimumDate: Date!
    private var maximumDate: Date!
    private var selectedStartDate: Date?
    private var selectedEndDate: Date?
    
    weak var delegate: PickDatesDelegate?
    weak var singleDelegate: PickSingleDateDelegate?
    
    
    public static func configureWith(_ status: FlightStatusTab) -> PickDatesVC {
        let vc = Storyboard.PickDates.instantiate(PickDatesVC.self)
        vc.viewModel.inputs.configureWith(status)
        return vc
    }
    
    public static func instantiate() -> PickDatesVC {
        let vc = Storyboard.PickDates.instantiate(PickDatesVC.self)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cancelButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        self.flightFindButton.addTarget(self, action: #selector(flightResultButtonTapped), for: .touchUpInside)

        self.dateRangeController = self.children.compactMap { $0 as? DateRangesVC }.first
        self.dateRangeController.delegate = self
    
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.headTitleStackView
            |> UIStackView.lens.layoutMargins .~ .init(top: Styles.grid(2))
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
        
        _ = self.navDateSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.firstDateTitleLabel
            |> UILabel.lens.text .~ Localizations.OutboundTitlePickDate
        
        _ = self.endDateTitleLabel
            |> UILabel.lens.text .~ Localizations.ReturnTitlePickDate
        
        _ = self.flightFindButton
            |> UIButton.lens.backgroundColor .~ .tk_official_green
            |> UIButton.lens.titleColor(forState: .normal) .~ .white
            |> UIButton.lens.title(forState: .normal) .~ Localizations.FindFlightsButtonPickDate
        
        _ = self.loadingOverlayView
            |> UIView.lens.isHidden .~ true
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.loadingOverlayView.rac.hidden = self.viewModel.outputs.flightsAreLoading
        self.loadingFlightIndicatorView.rac.animating = self.viewModel.outputs.flightsAreLoading.negate()
        
        self.firstDateTextLabel.rac.text = self.viewModel.outputs.startDateText
        self.endDateTextLabel.rac.text = self.viewModel.outputs.endDateText
        self.flightFindButton.rac.title = self.viewModel.outputs.singleFlightStatus
        
        self.endDateTextLabel.rac.hidden = self.viewModel.outputs.hideReturnLabels
        self.endDateTitleLabel.rac.hidden = self.viewModel.outputs.hideReturnLabels
        
        self.viewModel.outputs.dismissPickDates
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.dismiss(animated: true, completion: nil)
        }
        
        self.viewModel.outputs.statusPickDate
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.lockedReturnDate(tab: $0)
        }
        
        self.viewModel.outputs.singleFlightDate
            .observe(on: UIScheduler())
            .observeValues { [weak self] status in
                guard let _self = self else { return }
                if status == true {
                    _ = _self.endDateTitleLabel
                        |> UILabel.lens.isHidden .~ true
                    _ = _self.endDateTextLabel
                        |> UILabel.lens.isHidden .~ true
                    
                }
                
                _self.dateRangeController.isStatusFlightOneWay = status
        }
        
        self.viewModel.outputs.singleFlightStatus
            .observe(on: UIScheduler())
            .observeValues { [weak self] status in
                self?.flightFindButton.titleLabel?.text = status
        }
        
        self.viewModel.outputs.showErrorOccured
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                let alertNotFound = UIAlertController.genericError(message: "Mohon maaf untuk penerbangan ini", cancel: nil)
                self?.present(alertNotFound, animated: true, completion: nil)
        }
        
        self.viewModel.outputs.selectedDate
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] (first, second) in
                guard let _self = self else { return }
                _self.delegate?.submitDate(depart: first, returned: second)
                _self.dismiss(animated: true, completion: nil)
        }
        
        self.viewModel.outputs.selectedSingleDate
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] single in
                guard let _self = self else { return }
                print("Is there any Single Date: \(single)")
                _self.singleDelegate?.submitSingleDate(depart: single)
                _self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc fileprivate func dismissButtonTapped() {
        self.viewModel.inputs.tappedButtonCancel()
    }
    
    @objc fileprivate func flightResultButtonTapped() {
        self.viewModel.inputs.flightButtonTapped()
    }
    
    private func lockedReturnDate(tab: FlightStatusTab) {
        switch tab {
        case .oneWay:
            self.viewModel.inputs.isThisOneWayFlight(true)
        default:
            self.dateRangeController.view.isUserInteractionEnabled = true
        }
    }
    
}

extension PickDatesVC: DateRangesVCDelegate {
    
    public func diSelectEndDate(endDate: Date!) {
        self.viewModel.inputs.endDate(endDate ?? Date())
    }
    
    
    public func didSelectStartDate(startDate: Date!) {
        self.viewModel.inputs.startDate(startDate ?? Date())
    }
    
}

