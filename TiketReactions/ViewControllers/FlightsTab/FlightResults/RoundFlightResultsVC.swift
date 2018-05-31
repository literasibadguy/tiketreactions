//
//  RoundFlightResultsVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 30/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import Spring
import TiketKitModels
import UIKit

protocol RoundFlightResultsDelegate: class {
    func getFlightData(_ roundFlightVC: RoundFlightResultsVC, envelope: SearchFlightEnvelope)
    
}

public final class RoundFlightResultsVC: UIViewController {
    
    fileprivate let viewModel: RoundFlightResultsViewModelType = RoundFlightResultsViewModel()
    fileprivate var dataSource: FlightResultsPageDataSource!
    
    private weak var navigationFlightVC: FlightResultsNavVC!
    private weak var resultsFlightVC: FlightResultsContentVC!
    
    
    @IBOutlet fileprivate weak var nextContainerView: UIView!
    @IBOutlet fileprivate weak var nextInteractionButton: DesignableButton!
    
    static func instantiate() -> RoundFlightResultsVC {
        let vc = Storyboard.FlightResults.instantiate(RoundFlightResultsVC.self)
        return vc
    }
    
    internal func configureRoundFlights(selectedFirst: Flight, envelope: SearchFlightEnvelope) -> RoundFlightResultsVC {
        let vc = Storyboard.FlightResults.instantiate(RoundFlightResultsVC.self)
        return vc
    }
    
    internal func configureAvailableRounds(selectedFirst: Flight, returns: [Flight]) -> RoundFlightResultsVC {
        let vc = Storyboard.FlightResults.instantiate(RoundFlightResultsVC.self)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationFlightVC = self.childViewControllers.flatMap { $0 as? FlightResultsNavVC }.first
        self.navigationFlightVC.delegate = self
        
        self.resultsFlightVC = self.childViewControllers.flatMap { $0 as? FlightResultsContentVC }.first
        self.resultsFlightVC.delegate = self
        
        self.nextInteractionButton.addTarget(self, action: #selector(nextButtonTapped), for: .touchUpInside)
        
        self.viewModel.inputs.viewDidLoad()
        
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        self.viewModel.inputs.viewWillAppear(animated: animated)
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.nextContainerView
            |> UIView.lens.isHidden .~ true
        
        _ = self.nextInteractionButton
            |> UIButton.lens.backgroundColor(forState: .normal) .~ .tk_official_green
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        
    }
    
    @objc fileprivate func nextButtonTapped() {
        self.viewModel.inputs.nextButtonTapped()
    }

}

extension RoundFlightResultsVC: FlightResultsNavDelegate {
    public func flightResultsNavigationHeaderSelectedParams(_ params: SearchFlightParams) {
        
    }
    
    public func goingBackToPickingDate(_ resultsNavVC: FlightResultsNavVC) {
        self.navigationController?.popToRootViewController(animated: true)
    }
}


extension RoundFlightResultsVC: FlightResultsContentViewDelegate {
    public func resultContentsFlightReturned(_ flights: [Flight]) {
        self.viewModel.inputs.configureReturned(flights: flights)
    }
    
    public func resultContentsFirstFlightSelected(_ flight: Flight) {
        print("RESULT CONTENT VIEW DELEGATE: SELECTED FLIGHT")
        self.viewModel.inputs.flightContentSelected(flight: flight)
    }
}

extension RoundFlightResultsVC: RoundTripSortViewDelegate {
    func sortButtons(_ viewController: UIViewController, selectedSort sort: SearchFlightParams) {
        
    }
}
