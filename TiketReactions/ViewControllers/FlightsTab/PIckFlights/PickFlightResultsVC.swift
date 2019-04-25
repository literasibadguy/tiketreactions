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
//    @IBOutlet fileprivate weak var filterButton: UIButton!
    
    @IBOutlet fileprivate weak var flightsTableView: UITableView!
    @IBOutlet fileprivate weak var footerContainerView: UIView!
    @IBOutlet fileprivate weak var nextStepsButton: UIButton!
    
    public static func configureWith(_ envelope: SearchFlightEnvelope) -> PickFlightResultsVC {
        let resultsVC = Storyboard.PickFlight.instantiate(PickFlightResultsVC.self)
        resultsVC.viewModel.inputs.configureWith(envelope)
        return resultsVC
    }
    
    public static func configureWith(_ param: SearchFlightParams) -> PickFlightResultsVC {
        let resultsVC = Storyboard.PickFlight.instantiate(PickFlightResultsVC.self)
        resultsVC.viewModel.inputs.configureWith(param)
        return resultsVC
    }
    
    public static func configureWith(flights: [Flight]) -> PickFlightResultsVC {
         let returnedVC = Storyboard.PickFlight.instantiate(PickFlightResultsVC.self)
        return returnedVC
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.dismissButton.addTarget(self, action: #selector(dismissButtonTapped), for: .touchUpInside)
        self.nextStepsButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        self.flightsTableView.addSubview(self.loadingIndicatorView)
        self.flightsTableView.register(nib: .PickFlightNoticeViewCell)
        self.flightsTableView.register(nib: .FlightResultViewCell)
        self.flightsTableView.dataSource = dataSource
        self.flightsTableView.delegate = self
        
        let emptyVC = EmptyStatesVC.configuredWith(emptyState: nil)
        self.emptyStatesController = emptyVC
        self.addChild(emptyVC)
        self.flightsTableView.addSubview(emptyVC.view)
        NSLayoutConstraint.activate([
            emptyVC.view.topAnchor.constraint(equalTo: self.flightsTableView.topAnchor),
            emptyVC.view.leadingAnchor.constraint(equalTo: self.flightsTableView.leadingAnchor),
            emptyVC.view.bottomAnchor.constraint(equalTo: self.flightsTableView.bottomAnchor),
            emptyVC.view.trailingAnchor.constraint(equalTo: self.flightsTableView.trailingAnchor)
            ])
        emptyVC.didMove(toParent: self)
        
        self.viewModel.inputs.viewDidLoad()
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
            |> UITableView.lens.rowHeight .~ UITableView.automaticDimension
            |> UITableView.lens.estimatedRowHeight .~ 480.0
            |> UITableView.lens.separatorStyle .~ .none
        
        _ = self.destinationMainLabel
            |> UILabel.lens.textColor .~ .tk_dark_grey_500
        
        _ = self.datesMainLabel
            |> UILabel.lens.textColor .~ .tk_dark_grey_500
        
        _ = self.dismissButton
            |> UIButton.lens.titleColor(forState: .normal) .~ .tk_official_green
        
//        _ = self.filterButton
//            |> UIButton.lens.titleColor(forState: .normal) .~ .tk_official_green
//            |> UIButton.lens.isHidden .~ true
        
        _ = self.loadingIndicatorView
            |> baseActivityIndicatorStyle
        
        _ = self.footerContainerView
            |> UIView.lens.isHidden .~ true
        
        _ = self.nextStepsButton
            |> UIButton.lens.backgroundColor .~ .tk_official_green
            |> UIButton.lens.title(forState: .normal) .~ Localizations.ChooseTitleButtonPickFlight
        
        _ = self.separatorContainerView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        
        self.loadingIndicatorView.rac.animating = self.viewModel.outputs.flightsAreLoading
        
//        self.loadingIndicatorView.rac.animating = self.viewModel.outputs.flightsAreLoading
        self.datesMainLabel.rac.text = self.viewModel.outputs.showDateText
        self.destinationMainLabel.rac.text = self.viewModel.outputs.showDestinationText
        
        self.viewModel.outputs.flights
            .observe(on: UIScheduler())
            .observeValues { [weak self] flights, notice in
                self?.dataSource.load(flights: flights, notice: notice)
                self?.flightsTableView.reloadData()
        }
        
        self.viewModel.outputs.showNextSteps
            .observe(on: UIScheduler())
            .observeValues { [weak self] showed in
                self?.footerContainerView.isHidden = false
        }
        
        self.viewModel.outputs.goToReturnFlights
            .observe(on: QueueScheduler.main) 
            .observeValues { [weak self] envelope, departed in
                self?.goToReturnFlights(envelope, selectedDepart: departed)
        }
        
        self.viewModel.outputs.goToFlight
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] selectedFlight in
                print("Go To Flights")
                self?.goToFlight(flight: selectedFlight)
        }
        
        self.viewModel.outputs.hideEmptyState
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                print("HIDE EMPTY STATE")
                self?.emptyStatesController?.view.alpha = 0
                self?.emptyStatesController?.view.isHidden = true
        }
        
        self.viewModel.outputs.showEmptyState
            .observe(on: UIScheduler())
            .observeValues { [weak self] emptyState in
                print("SHOW EMPTY STATE")
                self?.showEmptyState(emptyState)
        }
        
        self.viewModel.outputs.dismissToPickDate
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.dismiss(animated: true, completion: nil)
        }
    }
    fileprivate func goToFlight(flight: Flight) {
        let singleSummaries = FlightSummariesVC.configureSingleWith(flight)
        self.navigationController?.pushViewController(singleSummaries, animated: true)
    }
    
    fileprivate func goToReturnFlights(_ envelope: SearchFlightEnvelope, selectedDepart: Flight) {
        let returnVC = PickFlightReturnsVC.configureWith(envelope, selectedDepart: selectedDepart)
        self.navigationController?.pushViewController(returnVC, animated: true)
    }
    
    fileprivate func showEmptyState(_ emptyState: EmptyState) {
        guard let emptyVC = self.emptyStatesController else { return }
        
        emptyVC.setEmptyState(emptyState)
        emptyVC.view.isHidden = false
        self.flightsTableView.bringSubviewToFront(emptyVC.view)
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

