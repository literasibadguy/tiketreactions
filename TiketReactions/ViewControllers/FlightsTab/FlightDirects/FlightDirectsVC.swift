//
//  FlightDirectsVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 26/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

public final class FlightDirectsVC: UIViewController {
    
    fileprivate let viewModel: FlightDirectsViewModelType = FlightDirectsViewModel()
    
    fileprivate var contentController: FlightDirectsContentVC!
    fileprivate var bookingBarController: FlightDirectsNavVC!
    
    
    
    static func configureSingleWith(param: SearchSingleFlightParams, flight: Flight) -> FlightDirectsVC {
        let vc = Storyboard.FlightDirects.instantiate(FlightDirectsVC.self)
        vc.viewModel.inputs.configureWith(param: param, flight: flight)
        return vc
    }
    
    static func configureWith(param: SearchFlightParams, flight: Flight, returnedFlight: Flight) -> FlightDirectsVC {
        let vc = Storyboard.FlightDirects.instantiate(FlightDirectsVC.self)
        vc.viewModel.inputs.configureWith(param: param, depart: flight, returned: returnedFlight)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.contentController = self.childViewControllers
            .flatMap { $0 as? FlightDirectsContentVC }.first
        self.contentController.delegate = self
        self.bookingBarController = self.childViewControllers
            .flatMap { $0 as? FlightDirectsNavVC }.first
        
        // Do any additional setup after loading the view.
        
        let backButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(backButtonTapped))
        self.navigationController?.navigationItem.leftBarButtonItem = backButton
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        
        self.viewModel.inputs.viewWillAppear(animated: animated)
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.configureParamWithFlight
            .observe(on: UIScheduler())
            .observeValues { [weak self] params, single in
                self?.contentController.configuredSingleWith(params: params, flight: single)
                self?.bookingBarController.configureWith(flight: single, returned: nil)
                
        }
        
        self.viewModel.outputs.configureParamWithReturnFlight
            .observe(on: UIScheduler())
            .observeValues { [weak self] param, depart, returned in
                self?.contentController.configureReturnWith(params: param, departed: depart, returned: returned)
        }
        
         self.viewModel.outputs.dismissFlightDirect
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.dismiss(animated: true, completion: nil)
        }
        
        self.viewModel.outputs.goToPassengerTitlePick
            .observe(on: UIScheduler())
            .observeValues { [weak self] title in
                guard let _self = self else { return }
                let passengerPickVC = PassengerTitlePickerVC.instantiate(titles: ["Tuan", "Nyonya", "Nona"], selectedTitle: title, delegate: _self)
                _self.present(passengerPickVC, animated: true, completion: nil)
        }
    }
    
    @objc fileprivate func backButtonTapped() {
        self.viewModel.inputs.backButtonTapped()
    }
}

extension FlightDirectsVC: FlightDirectsContentDelegate {
    public func preparingPassenger(group: GroupPassengersParam) {
        self.bookingBarController.configureWith(passengers: group)
    }
}

extension FlightDirectsVC: PassengerTitlePickerVCDelegate {
    func passengerTitlePickerVC(_ controller: PassengerTitlePickerVC, choseTitle: String) {
        
    }
    
    func passengerTitlePickerVCCancelled(_ controller: PassengerTitlePickerVC) {
        
    }
}

