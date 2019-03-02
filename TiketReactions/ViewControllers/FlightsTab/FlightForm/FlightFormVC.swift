//
//  FlightFormVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 25/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import CalendarDateRangePickerViewController
import FSPagerView
import Prelude
import ReactiveSwift
import RealmSwift
import Spring
import TiketKitModels
import UIKit

class FlightFormVC: UIViewController {
    
    fileprivate let viewModel: FlightFormViewModelType = FlightFormViewModel()
    
    @IBOutlet private weak var flightFormStackView: UIStackView!
    
    @IBOutlet fileprivate weak var fromInputStackView: UIStackView!
    
    @IBOutlet fileprivate weak var originMenuStackView: UIStackView!
    @IBOutlet fileprivate weak var passengerMenuStackView: UIStackView!
    @IBOutlet fileprivate weak var destinationMenuStackView: UIStackView!
    
    @IBOutlet fileprivate weak var originInputLabel: UILabel!
    @IBOutlet fileprivate weak var originLabel: UILabel!
    @IBOutlet fileprivate weak var originSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var destinationInputLabel: UILabel!
    @IBOutlet fileprivate weak var destinationLabel: UILabel!
    @IBOutlet fileprivate weak var destinationSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var passengersInputLabel: UILabel!
    @IBOutlet fileprivate weak var passengersLabel: UILabel!
    
    @IBOutlet fileprivate weak var originButton: UIButton!
    @IBOutlet fileprivate weak var destinationButton: UIButton!
    @IBOutlet fileprivate weak var passengerButton: UIButton!
    
    @IBOutlet fileprivate weak var fromContainerView: UIView!
    @IBOutlet fileprivate weak var ToContainerView: UIView!
    @IBOutlet fileprivate weak var passengersContainerView: UIView!
    
    @IBOutlet fileprivate weak var orderFirstButton: DesignableButton!
    
    static func instantiate() -> FlightFormVC {
        let vc = Storyboard.FlightForm.instantiate(FlightFormVC.self)
        return vc
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        self.originButton.addTarget(self, action: #selector(originButtonTapped), for: .touchUpInside)
        self.destinationButton.addTarget(self, action: #selector(destinationButtonTapped), for: .touchUpInside)
        self.passengerButton.addTarget(self, action: #selector(passengerButtonTapped), for: .touchUpInside)
        self.orderFirstButton.addTarget(self, action: #selector(pickDateButtonTapped), for: .touchUpInside)
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        self.classButton.addTarget(self, action: #selector(), for: .touchUpInside)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        print("Lets some do bind styles..")
        
        _ = self.flightFormStackView
            |> UIStackView.lens.layoutMargins .~ .init(topBottom: Styles.grid(6), leftRight: Styles.grid(2))
            |> UIStackView.lens.spacing .~ Styles.grid(2)
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
        
        _ = self.fromContainerView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.originButton
            |> UIButton.lens.isEnabled .~ true
        
        _ = self.originInputLabel
            |> UILabel.lens.text .~ Localizations.OriginFlightTitleForm
            |> UILabel.lens.textColor .~ .black
        
        _ = self.destinationInputLabel
            |> UILabel.lens.text .~ Localizations.DestinationFlightTitleForm
            |> UILabel.lens.textColor .~ .black
        
        _ = self.passengersInputLabel
            |> UILabel.lens.text .~ Localizations.PassengerFlightTitleForm
            |> UILabel.lens.textColor .~ .black
        
        _ = self.originLabel
            |> UILabel.lens.isUserInteractionEnabled .~ false
            |> UILabel.lens.textColor .~ .tk_official_green
            |> UILabel.lens.text .~ "-> Asal Kota"
        
        _ = self.destinationLabel
            |> UILabel.lens.isUserInteractionEnabled .~ false
            |> UILabel.lens.textColor .~ .tk_official_green
            |> UILabel.lens.text .~ "-> Tujuan Kota"
        
        _ = self.originSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_fade_green_grey
        
        _ = self.destinationSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_fade_green_grey
        
        _ = self.passengerMenuStackView
            |> UIView.lens.isUserInteractionEnabled .~ false
        
        _ = self.passengersLabel
            |> UILabel.lens.isUserInteractionEnabled .~ false
            |> UILabel.lens.textColor .~ .tk_official_green
        
        _ = self.ToContainerView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.passengersContainerView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.orderFirstButton
            |> UIButton.lens.titleColor(forState: .normal) .~ .white
            |> UIButton.lens.backgroundImage(forState: .normal) .~ UIImage(named: "background-flight-tab")
            |> UIButton.lens.title(forState: .normal) .~ Localizations.PickDateTitleForm
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.destinationLabel.rac.text = self.viewModel.outputs.destinationAirportText
        self.originLabel.rac.text = self.viewModel.outputs.originAirportText
        
        
        self.viewModel.outputs.goToOrigin
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] result in
                self?.goToOrigin(selected: result)
        }
        
        self.viewModel.outputs.goToDestination
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] result in
                self?.goToDestination(selected: result)
        }
        
        self.viewModel.outputs.goToPassengers
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] adult, child, infant in
                self?.goToPassengers(adult: adult, child: child, infant: infant)
        }
        
        self.viewModel.outputs.passengersChanged
            .observe(on: UIScheduler())
            .observeValues { [weak self] adult, child, infant in
                self?.passengersLabel.text = "\(adult) Dewasa, \(child) Anak, \(infant) Bayi"
        }
    }
    

    private func setAttributedTitles(for button: UIButton, with string: String) {
        let normalTitleString = NSAttributedString(string: string, attributes: [
            NSAttributedStringKey.font: self.traitCollection.isRegularRegular
                ? UIFont.boldSystemFont(ofSize: 16.0)
                : UIFont.boldSystemFont(ofSize: 14.0),
            NSAttributedStringKey.foregroundColor: UIColor.tk_typo_green_grey_600
            ])
        
        let selectedTitleString = NSAttributedString(string: string, attributes: [
            NSAttributedStringKey.font: self.traitCollection.isRegularRegular
                ? UIFont.boldSystemFont(ofSize: 16.0)
                : UIFont.boldSystemFont(ofSize: 14.0),
            NSAttributedStringKey.foregroundColor: UIColor.tk_typo_green_grey_500
            ])
        
        _ = button
            |> UIButton.lens.attributedTitle(forState: .normal) %~ { _ in normalTitleString }
            |> UIButton.lens.attributedTitle(forState: .selected) %~ { _ in selectedTitleString }
            |> (UIButton.lens.titleLabel..UILabel.lens.lineBreakMode) .~ .byWordWrapping
            |> UIButton.lens.backgroundColor(forState: .selected) .~ .clear
    }
    
    fileprivate func goToOrigin() {
        let airportVC = PickAirportsTableVC.instantiate(status: "Departure")
        airportVC.delegate = self
        self.present(airportVC, animated: true, completion: nil)
    }
    
    fileprivate func goToDestination() {
        let destinationVC = PickAirportsTableVC.instantiate(status: "Arrival")
        destinationVC.delegate = self
        self.present(destinationVC, animated: true, completion: nil)
    }
    
    fileprivate func goToOrigin(selected: AirportResult) {
        let airportVC = PickAirportsTableVC.configureWith(status: "Departure", selectedRow: selected)
        airportVC.delegate = self
        self.present(airportVC, animated: true, completion: nil)
    }
    
    fileprivate func goToDestination(selected: AirportResult) {
        let airportVC = PickAirportsTableVC.configureWith(status: "Arrival", selectedRow: selected)
        airportVC.destinationDelegate = self
        self.present(airportVC, animated: true, completion: nil)
    }
    
    fileprivate func goToPassengers(adult: Int, child: Int, infant: Int) {
        let pickPassengersVC = PassengersStepperVC.configureWith(adult: adult, child: child, infant: infant)
        pickPassengersVC.delegate = self
        pickPassengersVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        pickPassengersVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        self.present(pickPassengersVC, animated: true, completion: nil)
    }

    /*
    fileprivate func goToPickDate(param: SearchFlightParams) {
        let pickDatesVC = PickDatesVC.configureWith(param: param, status: false)
        let dateNavVC = UINavigationController(rootViewController: pickDatesVC)
        self.present(dateNavVC, animated: true, completion: nil)
    }
    */

    @objc fileprivate func roundTripButtonTapped() {
        self.viewModel.inputs.roundTripButtonTapped()
    }
    
    @objc fileprivate func oneWayButtonTapped() {
        self.viewModel.inputs.oneWayButtonTapped()
    }
    
    @objc fileprivate func originButtonTapped() {
        self.viewModel.inputs.originButtonTapped()
    }
    
    @objc fileprivate func destinationButtonTapped() {
        print("Something Detected: Destination Button Tapped")
        self.viewModel.inputs.desinationButtonTapped()
    }
    
    @objc fileprivate func roundConfigureTapped() {
        self.viewModel.inputs.crossPathButtonTapped()
    }
    
    @objc fileprivate func passengerButtonTapped() {
        self.viewModel.inputs.passengersButtonTapped()
    }
    
    @objc fileprivate func pickDateButtonTapped() {
        print("Picking Date Button Tapped Worked")
        self.viewModel.inputs.pickDateButtonTapped()
    }
    
    @objc fileprivate func searchFlightButtonTapped() {
        
    }
    
    @objc fileprivate func classButtonTapped() {
        self.viewModel.inputs.crossPathButtonTapped()
    }
}

extension FlightFormVC: FSPagerViewDataSource {
    func numberOfItems(in pagerView: FSPagerView) -> Int {
        return 3
    }
    
    func pagerView(_ pagerView: FSPagerView, cellForItemAt index: Int) -> FSPagerViewCell {
        let cell = pagerView.dequeueReusableCell(withReuseIdentifier: "BannerPagerViewCell", at: index) as! BannerPagerViewCell
        cell.configureWith(value: "banner-sample-1")
        return cell
    }
}

extension FlightFormVC: PickOriginTableDelegate {
    
    func pickOriginAirportsTable(_ vc: PickAirportsTableVC, selectedRow: AirportResult) {
        self.viewModel.inputs.selectedOrigin(airport: selectedRow)
    }
}

extension FlightFormVC: PickDestinationTableDelegate {
    
    func pickDestinationAirportsTable(_ vc: PickAirportsTableVC, selectedRow: AirportResult) {
        self.viewModel.inputs.selectedDestination(airport: selectedRow)
    }
}

extension FlightFormVC: PassengersStepperDelegate {
    func didDismissPassengers(_ adult: Int, child: Int, infant: Int) {
        self.viewModel.inputs.selectedPassengers(adult: adult, child: child, infant: infant)
    }
}

