//
//  FlightResultsContentVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 30/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import Result
import TiketKitModels
import UIKit

public protocol FlightResultsContentViewDelegate: class {
    func resultContentsFirstFlightSelected(_ flight: Flight)
    func resultContentsFlightReturned(_ flights: [Flight])
}

public final class FlightResultsContentVC: UITableViewController {
    
    fileprivate let viewModel: FlightResultsContentViewModelTypes = FlightResultsContentViewModel()
    public weak var delegate: FlightResultsContentViewDelegate?
    
    fileprivate var emptyStatesController: EmptyStatesVC?
    fileprivate let dataSource = FlightResultsDataSource()
    fileprivate let loadingIndicatorView = UIActivityIndicatorView()
    
    public static func instantiate() -> FlightResultsContentVC {
        let vc = Storyboard.FlightResults.instantiate(FlightResultsContentVC.self)
        return vc
    }
    
    public static func instantiate(sort: SearchFlightParams) -> FlightResultsContentVC {
        let vc = Storyboard.FlightResults.instantiate(FlightResultsContentVC.self)
        vc.viewModel.inputs.configureWith(sort: sort)
        return vc
    }
    
    internal func instantiateReturns(round: Bool) -> FlightResultsContentVC {
        let vc = Storyboard.FlightResults.instantiate(FlightResultsContentVC.self)
        return vc
    }
    
    internal func configureWith(params: SearchFlightParams) {
        self.viewModel.inputs.configureWith(sort: params)
    }
    
    internal func configureWith(depart: Flight) {
        self.viewModel.inputs.configureReturnWith(selectedDepart: depart)
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.addSubview(self.loadingIndicatorView)
        self.tableView.dataSource = dataSource
        
        self.tableView.register(nib: .FlightResultViewCell)
        
        let emptyVC = EmptyStatesVC.configuredWith(emptyState: nil)
        self.emptyStatesController = emptyVC
        self.addChildViewController(emptyVC)
        self.view.addSubview(emptyVC.view)
        NSLayoutConstraint.activate([
            emptyVC.view.topAnchor.constraint(equalTo: self.view.topAnchor),
            emptyVC.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            emptyVC.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            emptyVC.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
        emptyVC.didMove(toParentViewController: self)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.inputs.viewWillAppear()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewModel.inputs.viewDidAppear()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.loadingIndicatorView.center = self.tableView.center
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self
            |> baseTableControllerStyle(estimatedRowHeight: 200)
        
        _ = self.loadingIndicatorView
            |> baseActivityIndicatorStyle
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.loadingIndicatorView.rac.animating = self.viewModel.outputs.flightsAreLoading
        
        self.viewModel.outputs.envelope
            .observe(on: UIScheduler())
            .observeValues { envelope in
                print("FLIGHT ENVELOPE: \(envelope)")
        }
        
        self.viewModel.outputs.flights
            .observe(on: UIScheduler())
            .observeValues { [weak self] flights in
                print("FLIGHT RESULTS: \(flights)")
                self?.dataSource.load(flights: flights)
                self?.tableView.reloadData()
        }
        
        self.viewModel.outputs.returnedFlights
            .observe(on: UIScheduler())
            .observeValues { [weak self] returnFlights in
                guard let _self = self else { return }
                print("RETURNED FLIGHTS ARE AVAILABLE")
                _self.delegate?.resultContentsFlightReturned(returnFlights)
                _self.dataSource.load(flights: returnFlights)
                _self.tableView.reloadData()
        }
        
        self.viewModel.outputs.hideEmptyState
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.emptyStatesController?.view.alpha = 0
                self?.emptyStatesController?.view.isHidden = true
        }
        
        self.viewModel.outputs.selectedFlight
            .observe(on: UIScheduler())
            .observeValues { [weak self] selected in
                guard let _self = self else { return }
                print("SELECTED FLIGHT")
                _self.delegate?.resultContentsFirstFlightSelected(selected)
        }

        
        self.viewModel.outputs.showEmptyState
            .observe(on: UIScheduler())
            .observeValues { [weak self] show in
                self?.tableView.bounces = false
                if let emptyVC = self?.emptyStatesController {
                    self?.emptyStatesController?.view.isHidden = show
                    self?.view.bringSubview(toFront: emptyVC.view)
                }
        }
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let flight = self.dataSource.flightAtIndexPath(indexPath) {
            self.viewModel.inputs.tapped(flight: flight)
        }
    }
    
    fileprivate func showEmptyState(_ emptyState: String) {
        guard let emptyVC = self.emptyStatesController else { return }
        
        emptyVC.view.isHidden = false
        self.view.bringSubview(toFront: emptyVC.view)
        UIView.animate(withDuration: 0.3, animations: {
            self.emptyStatesController?.view.alpha = 1.0
        }, completion: nil)
    }
}
