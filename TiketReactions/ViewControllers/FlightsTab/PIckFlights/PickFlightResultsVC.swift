//
//  PickFlightResultsVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 21/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import TiketKitModels
import Spring
import UIKit

public final class PickFlightResultsVC: UIViewController {
    fileprivate var emptyStatesController: EmptyStatesVC?
    fileprivate let viewModel: PickFlightResultsViewModelType = PickFlightResultsViewModel()
    fileprivate let dataSource = PickFlightResultsDataSource()
    
    fileprivate let loadingIndicatorView = UIActivityIndicatorView()
    
    @IBOutlet fileprivate weak var navContainerView: UIView!
    @IBOutlet fileprivate weak var separatorContainerView: UIView!
    
    @IBOutlet fileprivate weak var dismissButton: UIButton!
    @IBOutlet fileprivate weak var HeadLabelStackView: UIStackView!
    @IBOutlet fileprivate weak var destinationMainLabel: UILabel!
    @IBOutlet fileprivate weak var datesMainLabel: UILabel!
    @IBOutlet fileprivate weak var filterButton: UIButton!
    
    @IBOutlet fileprivate weak var flightsTableView: UITableView!
    @IBOutlet fileprivate weak var footerContainerView: UIView!
    @IBOutlet fileprivate weak var nextStepsButton: DesignableButton!
    
    public static func instantiate() -> PickFlightResultsVC {
        let vc = Storyboard.PickFlight.instantiate(PickFlightResultsVC.self)
        let sampleParams = .defaults
            |> SearchFlightParams.lens.departDate .~ "2018-03-22"
            |> SearchFlightParams.lens.returnDate .~ "2018-03-23"
            |> SearchFlightParams.lens.adult .~ 1
            |> SearchFlightParams.lens.child .~ 0
            |> SearchFlightParams.lens.infant .~ 0
            |> SearchFlightParams.lens.fromAirport .~ "CGK"
            |> SearchFlightParams.lens.toAirport .~ "DPS"
        
        print("PICK FLIGHT RESULTS VC INSTANTIATE")
        vc.viewModel.inputs.configureWith(params: sampleParams)
        return vc
    }
    
    public static func configureSingleWith(param: SearchSingleFlightParams) -> PickFlightResultsVC {
        let vc = Storyboard.PickFlight.instantiate(PickFlightResultsVC.self)
        vc.viewModel.inputs.configureSingleWith(params: param)
        return vc
    }
    
    public static func configureWith(param: SearchFlightParams) -> PickFlightResultsVC {
        let vc = Storyboard.PickFlight.instantiate(PickFlightResultsVC.self)
        vc.viewModel.inputs.configureWith(params: param)
        return vc
    }
    
    public static func configureWith(params: SearchFlightParams, selected: Flight, returns: [Flight]) -> PickFlightResultsVC {
        let vc = Storyboard.PickFlight.instantiate(PickFlightResultsVC.self)
        vc.viewModel.inputs.configureReturn(params: params, selected: selected, returns: returns)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        self.nextStepsButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        self.flightsTableView.addSubview(self.loadingIndicatorView)
        self.flightsTableView.register(nib: .FlightResultViewCell)
        self.flightsTableView.dataSource = dataSource
        self.flightsTableView.delegate = self
        
        let emptyVC = EmptyStatesVC.configuredWith(emptyState: nil)
        self.emptyStatesController = emptyVC
        self.addChildViewController(emptyVC)
        self.flightsTableView.addSubview(emptyVC.view)
        NSLayoutConstraint.activate([
            emptyVC.view.topAnchor.constraint(equalTo: self.flightsTableView.topAnchor),
            emptyVC.view.leadingAnchor.constraint(equalTo: self.flightsTableView.leadingAnchor),
            emptyVC.view.bottomAnchor.constraint(equalTo: self.flightsTableView.bottomAnchor),
            emptyVC.view.trailingAnchor.constraint(equalTo: self.flightsTableView.trailingAnchor)
        ])
        emptyVC.didMove(toParentViewController: self)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        self.viewModel.inputs.viewWillAppear(animated)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewModel.inputs.viewDidAppear()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.loadingIndicatorView.center = self.flightsTableView.center
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.viewModel.inputs.viewDidDisappear(animated: animated)
    }
    
    public override func bindStyles() {
        super.bindStyles()

        _ = self.flightsTableView
            |> UITableView.lens.backgroundColor .~ .white
            |> UITableView.lens.rowHeight .~ UITableViewAutomaticDimension
            |> UITableView.lens.estimatedRowHeight .~ 480.0
            |> UITableView.lens.separatorStyle .~ .none
        
        _ = self.destinationMainLabel
            |> UILabel.lens.textColor .~ .tk_dark_grey_500
        
        _ = self.datesMainLabel
            |> UILabel.lens.textColor .~ .tk_dark_grey_500
        
        _ = self.dismissButton
            |> UIButton.lens.titleColor(forState: .normal) .~ .tk_official_green
        
        _ = self.filterButton
            |> UIButton.lens.titleColor(forState: .normal) .~ .tk_official_green
        
        _ = self.loadingIndicatorView
            |> baseActivityIndicatorStyle
        
        _ = self.footerContainerView
            |> UIView.lens.isHidden .~ true
        
        _ = self.nextStepsButton
            |> UIButton.lens.backgroundColor .~ .tk_official_green
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.loadingIndicatorView.rac.animating = self.viewModel.outputs.flightsAreLoading
        self.footerContainerView.rac.hidden = self.viewModel.outputs.showNextSteps
        self.destinationMainLabel.rac.text = self.viewModel.outputs.destinationTitleText
        self.datesMainLabel.rac.text = self.viewModel.outputs.dateTitleText
        
        self.viewModel.outputs.dismissFlightResults
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.navigationController?.popViewController(animated: true)
        }
        
        self.viewModel.outputs.flights
            .observe(on: UIScheduler())
            .observeValues { [weak self] flights in
                print("FLIGHTS AVAILABLE: \(flights)")
                self?.dataSource.load(flights: flights)
                self?.flightsTableView.reloadData()
        }

        self.viewModel.outputs.goToSingleFlights
            .observe(on: UIScheduler())
            .observeValues { [weak self] param, depart in
                print("ONLY SINGLE FLIGHTS AVAILABLE")
                self?.goToSingleFlight(param: param, flight: depart)
        }
        
        self.viewModel.outputs.goToReturnFlights
            .observe(on: UIScheduler())
            .observeValues { [weak self] params, depart, returns in
                self?.goToRoundFlights(param: params, flight: depart, returnResults: returns)
                print("DEPARTS FLIGHT SELECTED: \(depart)")
        }
        
        self.viewModel.outputs.returnFlights
            .observe(on: UIScheduler())
            .observeValues { [weak self] results in
                print("RETURNS AVAILABLE")
                self?.dataSource.load(flights: results)
                self?.flightsTableView.reloadData()
        }
        
        self.viewModel.outputs.showReturnDirectText
            .observe(on: UIScheduler())
            .observeValues { [weak self] valueText in
                self?.nextStepsButton.titleLabel?.text = valueText
        }
        
        self.viewModel.outputs.goToDirectReturnFlights
            .observe(on: UIScheduler())
            .observeValues { [weak self] param, depart, returned in
                print("DIRECT RETURN FLIGHTS: \(depart) \(returned)")
                self?.goToDirectReturns(param: param, depart: depart, returned: returned)
        }
        
        self.viewModel.outputs.showEmptyState
            .observe(on: UIScheduler())
            .observeValues { [weak self] emptyState in
                print("EMPTY STATE IS DECLARED")
                self?.showEmptyState(emptyState)
        }
        
        self.viewModel.outputs.hideEmptyState
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.emptyStatesController?.view.alpha = 0
                self?.emptyStatesController?.view.isHidden = true
                
                
        }
    }
    
    fileprivate func goToSingleFlight(param: SearchSingleFlightParams, flight: Flight) {
        let vc = FlightDirectsVC.configureSingleWith(param: param, flight: flight)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func goToRoundFlights(param: SearchFlightParams, flight: Flight, returnResults: [Flight]) {
        let vc = PickFlightResultsVC.configureWith(params: param, selected: flight, returns: returnResults)
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    fileprivate func goToDirectReturns(depart: Flight, returned: Flight) {
        print("GO TO DIRECT RETURNS: \(depart) \(returned)")
//        let vc = FlightDirectsVC.configureWith(param: nil, flight: depart, returnedFlight: returned)
//        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func goToDirectReturns(param: SearchFlightParams, depart: Flight, returned: Flight) {
        let vc = FlightDirectsVC.configureWith(param: param, flight: depart, returnedFlight: returned)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    fileprivate func showEmptyState(_ emptyState: EmptyState) {
        guard let emptyVC = self.emptyStatesController else { return }
        
        emptyVC.setEmptyState(emptyState)
        emptyVC.view.isHidden = false
        self.flightsTableView.bringSubview(toFront: emptyVC.view)
        UIView.animate(withDuration: 0.3, animations: {
            self.emptyStatesController?.view.alpha = 1.0
        })
    }
    
    @objc fileprivate func dismissButtonTapped() {
        self.viewModel.inputs.tappedButtonDismiss()
    }
    
    @objc fileprivate func nextButtonTapped() {
        self.viewModel.inputs.tappedButtonNextStep()
    }
}

extension PickFlightResultsVC: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let flight = self.dataSource.flightAtIndexPath(indexPath) {
            self.viewModel.inputs.tapped(flight: flight)
        }
    }
}

