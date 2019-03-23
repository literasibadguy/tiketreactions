//
//  ChooseFlightVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 08/02/19.
//  Copyright © 2019 Firas Rafislam. All rights reserved.
//

import UIKit
import Prelude
import ReactiveSwift
import TiketKitModels

internal final class ChooseFlightVC: UIViewController {
    
    private let viewModel: FlightFormViewModelType = FlightFormViewModel()
    
    @IBOutlet private weak var formStackView: UIStackView!
    @IBOutlet private weak var statusFlightStackView: UIStackView!
    
    @IBOutlet private weak var singleButton: UIButton!
    @IBOutlet private weak var returnButton: UIButton!
    @IBOutlet private weak var statusSeparatorView: UIView!
    
    @IBOutlet private weak var originInputStackView: UIStackView!
    @IBOutlet private weak var originInputLabel: UILabel!
    @IBOutlet private weak var originContainerView: UIView!
    @IBOutlet private weak var originButton: UIButton!
    @IBOutlet private weak var originValueLabel: UILabel!
    @IBOutlet private weak var originSeparatorView: UIView!
    
    @IBOutlet private weak var destinationInputStackView: UIStackView!
    @IBOutlet private weak var destinationInputLabel: UILabel!
    @IBOutlet private weak var destinationContainerView: UIView!
    @IBOutlet private weak var destinationButton: UIButton!
    @IBOutlet private weak var destinationValueLabel: UILabel!
    @IBOutlet private weak var destinationSeparatorView: UIView!
    
    @IBOutlet private weak var datesPickButton: UIButton!
    @IBOutlet private weak var datesInputStackView: UIStackView!
    @IBOutlet private weak var dateSeparatorView: UIView!
    
    @IBOutlet private weak var departureInputLabel: UILabel!
    @IBOutlet private weak var firstDateValueLabel: UILabel!
    @IBOutlet private weak var departureDateContainerView: UIView!
    
    @IBOutlet private weak var returnInputLabel: UILabel!
    @IBOutlet private weak var returnInputStackView: UIStackView!
    @IBOutlet private weak var returnDateValueLabel: UILabel!
    @IBOutlet private weak var returnDateContainerView: UIView!
    
    @IBOutlet private weak var passengersContainerView: UIView!
    @IBOutlet private weak var passengersPickButton: UIButton!
    @IBOutlet private weak var passengersValueLabel: UILabel!
    @IBOutlet private weak var passengerSeparatorView: UIView!
    
    @IBOutlet private weak var searchFinalContainerView: UIView!
    
    @IBOutlet private weak var searchFinalButton: UIButton!
    
    
    static func instantiate() -> ChooseFlightVC {
        let vc = Storyboard.FlightForm.instantiate(ChooseFlightVC.self)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.singleButton.addTarget(self, action: #selector(singleTripButtonTapped), for: .touchUpInside)
        
        self.returnButton.addTarget(self, action: #selector(returnTripButtonTapped), for: .touchUpInside)
        
        self.originButton.addTarget(self, action: #selector(originButtonTapped), for: .touchUpInside)
        
        self.destinationButton.addTarget(self, action: #selector(destinationButtonTapped), for: .touchUpInside)
        
        self.datesPickButton.addTarget(self, action: #selector(datesButtonTapped), for: .touchUpInside)
        
        self.passengersPickButton.addTarget(self, action: #selector(passengerButtonTapped), for: .touchUpInside)
        
        self.searchFinalButton.addTarget(self, action: #selector(submitFlightButtonTapped), for: .touchUpInside)
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self.formStackView
            |> UIStackView.lens.layoutMargins .~ .init(topBottom: Styles.grid(6), leftRight: Styles.grid(2))
            |> UIStackView.lens.spacing .~ Styles.grid(2)
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true

        _ = self.originContainerView
            |> UIView.lens.backgroundColor .~ .clear
        
        _ = self.singleButton
            |> UIButton.lens.backgroundColor(forState: .selected) .~ .clear
        
        _ = self.originInputLabel
            |> UILabel.lens.textColor .~ .black
            |> UILabel.lens.text .~ Localizations.FromFlightForm
        
        _ = self.destinationInputLabel
            |> UILabel.lens.textColor .~ .black
            |> UILabel.lens.text .~ Localizations.ToFlightForm
        
        _ = self.departureInputLabel
            |> UILabel.lens.text .~ Localizations.OutboundTitlePickDate
        
        _ = self.returnInputLabel
            |> UILabel.lens.text .~ Localizations.ReturnTitlePickDate
        
        _ = self.destinationContainerView
            |> UIView.lens.backgroundColor .~ .clear
        
        _ = self.passengersContainerView
            |> UIView.lens.backgroundColor .~ .clear
            |> UIView.lens.layoutMargins .~ .init(left: 20.0)
            |> UIView.lens.preservesSuperviewLayoutMargins .~ true
        
        _ = self.departureDateContainerView
            |> UIView.lens.backgroundColor .~ .clear
        
        _ = self.returnDateContainerView
            |> UIView.lens.backgroundColor .~ .clear
        
        
        _ = self.datesInputStackView
            |> UIStackView.lens.isUserInteractionEnabled .~ false
        
        _ = self.searchFinalContainerView
            |> UIView.lens.backgroundColor .~ .clear
        
        _ = self.searchFinalButton
            |> UIButton.lens.backgroundColor(forState: .normal) .~ .tk_official_green
            |> UIButton.lens.title(forState: .normal) .~ Localizations.FindFlightsButtonPickDate
        
        _ = self.originValueLabel
            |> UILabel.lens.textColor .~ .tk_official_green
        
        _ = self.destinationValueLabel
            |> UILabel.lens.textColor .~ .tk_official_green
        
        _ = self.firstDateValueLabel
            |> UILabel.lens.textColor .~ .tk_official_green
        
        _ = self.returnDateValueLabel
            |> UILabel.lens.textColor .~ .tk_official_green
        
        _ = self.passengersValueLabel
            |> UILabel.lens.textColor .~ .tk_official_green
        
        if UIDevice.current.screenType == .iPhones_5_5s_5c_SE {
            _ = self.departureInputLabel
                |> UILabel.lens.font .~ UIFont.boldSystemFont(ofSize: 14.0)
            
            _ = self.returnInputLabel
                |> UILabel.lens.font .~ UIFont.boldSystemFont(ofSize: 14.0)
            
            _ = self.firstDateValueLabel
                |> UILabel.lens.font .~ UIFont.systemFont(ofSize: 17.0)
            
            _ = self.returnDateValueLabel
                |> UILabel.lens.font .~ UIFont.systemFont(ofSize: 17.0)
            
            _ = self.passengersValueLabel
                |> UILabel.lens.font .~ UIFont.boldSystemFont(ofSize: 17.0)
        }
        
        _ = self.statusSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.originSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.destinationSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.dateSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.passengerSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.destinationValueLabel.rac.text = self.viewModel.outputs.destinationAirportText
        self.originValueLabel.rac.text = self.viewModel.outputs.originAirportText
        
        self.firstDateValueLabel.rac.text = self.viewModel.outputs.firstDateText
        self.returnDateValueLabel.rac.text = self.viewModel.outputs.secondDateText
        
        self.viewModel.outputs.goToOrigin
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] origin in
                self?.goToOrigin(selected: origin)
        }
        
        self.viewModel.outputs.goToDestination
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] destination in
                self?.goToDestination(selected: destination)
        }
        
        self.viewModel.outputs.errorNotice
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                guard let _self = self else { return }
                _self.present(UIAlertController.genericError("Error", message: $0, cancel:nil), animated: true, completion: nil)
//            _ = _self.destinationValueLabel
//                |> UILabel.lens.text .~ Localizations.DestinationFlightTitleForm
        }
        
        self.viewModel.outputs.goToPassengers
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] adult, child, infant in
                self?.goToPassengers(adult: adult, child: child, infant: infant)
        }
        
        self.viewModel.outputs.passengersChanged
            .observe(on: UIScheduler())
            .observeValues { [weak self] adult, child, infant in
                self?.passengersValueLabel.text = "\(Localizations.PassengerAdultStatusList(adult)), \(Localizations.PassengerChildStatusList(child)), \(Localizations.PassengerInfantStatusList(infant))"
        }
        
        self.viewModel.outputs.goToPickDate
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                print("Go to Pick Date")
                self?.goToPickDate($0)
        }
        
        self.viewModel.outputs.navigateToFlightStatusTab
            .observe(on: UIScheduler())
            .observeValues { [weak self] statusTab in
//                self?.viewModel.inputs.switchFlightStatusSearch(tab: statusTab)
                self?.selectButton(atTab: statusTab)
        }
        
        self.viewModel.outputs.singleStatusFlight
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                guard let _self = self else { return }
                _ = _self.returnInputStackView
                    |> UIStackView.lens.isHidden .~ true
        }
        
        self.viewModel.outputs.goToFlightResults
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] params in
                self?.goToFlightResults(param: params)
        }
    }
    
    @objc private func singleTripButtonTapped() {
        self.viewModel.inputs.oneWayButtonTapped()
    }
    
    @objc private func returnTripButtonTapped() {
        self.viewModel.inputs.roundTripButtonTapped()
    }
    
    @objc private func originButtonTapped() {
        self.viewModel.inputs.originButtonTapped()
    }
    
    @objc private func destinationButtonTapped() {
        self.viewModel.inputs.desinationButtonTapped()
    }
    
    @objc private func datesButtonTapped() {
        print("Dates Button Tapped")
        self.viewModel.inputs.pickDateButtonTapped()
    }
    
    @objc private func passengerButtonTapped() {
        self.viewModel.inputs.passengersButtonTapped()
    }
    
    @objc private func submitFlightButtonTapped() {
        self.viewModel.inputs.submitSearchFlightTapped()
    }
    
    private func selectButton(atTab tab: FlightStatusTab) {
        switch tab {
        case .oneWay:
            _ = self.singleButton
                |> UIButton.lens.isSelected .~ true
            
            _ = self.returnButton
                |> UIButton.lens.isSelected .~ false
            
            _ = self.returnInputStackView
                |> UIStackView.lens.isHidden .~ true
            
        case .roundTrip:
            _ = self.returnButton
                |> UIButton.lens.isSelected .~ true
            
            _ = self.singleButton
                |> UIButton.lens.isSelected .~ false
            
            _ = self.returnInputStackView
                |> UIStackView.lens.isHidden .~ false
        }
    }
    
    private func goToOrigin(selected: AirportResult) {
        let airportVC = PickAirportsTableVC.configureWith(status: "Departure", selectedRow: selected)
        airportVC.delegate = self
        self.present(airportVC, animated: true, completion: nil)
    }
    
    private func goToDestination(selected: AirportResult) {
        let airportVC = PickAirportsTableVC.configureWith(status: "Arrival", selectedRow: selected)
        airportVC.destinationDelegate = self
        self.present(airportVC, animated: true, completion: nil)
    }
    
    private func goToPassengers(adult: Int, child: Int, infant: Int) {
        let pickPassengersVC = PassengersStepperVC.configureWith(adult: adult, child: child, infant: infant)
        pickPassengersVC.delegate = self
        pickPassengersVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        pickPassengersVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(pickPassengersVC, animated: true, completion: nil)
    }
    
    private func goToPickDate(_ status: FlightStatusTab) {
        let pickDateVC = PickDatesVC.configureWith(status)
        switch status {
        case .oneWay:
            pickDateVC.singleDelegate = self
            self.present(pickDateVC, animated: true, completion: nil)
        case .roundTrip:
            pickDateVC.delegate = self
            self.present(pickDateVC, animated: true, completion: nil)
        }
    }
    
    private func goToFlightResults(param: SearchFlightParams) {
        let pickFlightResults = PickFlightResultsVC.configureWith(param)
        let navFlight = UINavigationController(rootViewController: pickFlightResults)
        self.present(navFlight, animated: true, completion: nil)
    }
}

extension ChooseFlightVC: PickOriginTableDelegate {
    func pickOriginAirportsTable(_ vc: PickAirportsTableVC, selectedRow: AirportResult) {
        self.viewModel.inputs.selectedOrigin(airport: selectedRow)
    }
}

extension ChooseFlightVC: PickDestinationTableDelegate {
    func pickDestinationAirportsTable(_ vc: PickAirportsTableVC, selectedRow: AirportResult) {
        self.viewModel.inputs.selectedDestination(airport: selectedRow)
    }
}

extension ChooseFlightVC: PassengersStepperDelegate {
    func didDismissPassengers(_ adult: Int, child: Int, infant: Int) {
        self.viewModel.inputs.selectedPassengers(adult: adult, child: child, infant: infant)
    }
}

extension ChooseFlightVC: PickSingleDateDelegate {
    func submitSingleDate(depart: Date) {
        self.viewModel.inputs.selectedDate(first: depart, returned: nil)
        print("Submit Single Date: \(depart)")
    }
}

extension ChooseFlightVC: PickDatesDelegate {
    public func submitDate(depart: Date, returned: Date?) {
        self.viewModel.inputs.selectedDate(first: depart, returned: returned)
    }
}
