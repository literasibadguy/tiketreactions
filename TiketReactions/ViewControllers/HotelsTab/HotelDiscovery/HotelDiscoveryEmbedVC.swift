//
//  HotelDiscoveryEmbedVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 10/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import ReactiveSwift
import TiketKitModels
import UIKit

public final class HotelDiscoveryEmbedVC: UIViewController {
    
    fileprivate var viewModel: HotelDiscoveryEmbedViewModelType = HotelDiscoveryEmbedViewModel()
    
    private weak var navDiscoveryVC: HotelDiscoveryNavVC!
    private weak var contentDiscoveryVC: HotelDiscoveryVC!
    
    internal static func configureWith(selected: AutoHotelResult, params: SearchHotelParams, booking: HotelBookingSummary) -> HotelDiscoveryEmbedVC {
        let vc = Storyboard.HotelDiscovery.instantiate(HotelDiscoveryEmbedVC.self)
        vc.viewModel.inputs.configureWith(selected: selected, params: params, booking: booking)
        return vc
    }

    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.navDiscoveryVC = self.childViewControllers.flatMap { $0 as? HotelDiscoveryNavVC }.first
//        self.navigationFlightVC.delegate = self
        
        self.contentDiscoveryVC = self.childViewControllers.flatMap { $0 as? HotelDiscoveryVC }.first
        self.contentDiscoveryVC.delegate = self
        
        
        // Do any additional setup after loading the view.
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.loadParamsIntoResults
            .observe(on: UIScheduler())
            .observeValues { [weak self] selected, params, summary in
                self?.contentDiscoveryVC.configuredWith(hotelSelected: selected, sort: params, summary: summary)
        }
        
        self.viewModel.outputs.loadDataRange
            .observe(on: UIScheduler())
            .observeValues { [weak self] selected, dateRange in
                self?.navDiscoveryVC.configureWith(result: selected, range: dateRange)
        }
        
        self.viewModel.outputs.loadResult
            .observe(on: UIScheduler())
            .observeValues { [weak self] result in
                self?.navDiscoveryVC.configureEnvelope(result)
        }
        
        self.viewModel.outputs.loadParamsFromFilters
            .observe(on: UIScheduler())
            .observeValues { [weak self] params in
                self?.contentDiscoveryVC.filterUpdated(params)
        }
        
        self.viewModel.outputs.filterDismiss
            .observe(on: UIScheduler())
            .observeValues { [weak self] dismiss in
                self?.contentDiscoveryVC.filterDismissed()
        }
    }
}

extension HotelDiscoveryEmbedVC: HotelDiscoveryDelegate {
    public func gettingEnvelope(discovery: HotelDiscoveryVC, envelope: SearchHotelEnvelopes) {
        self.viewModel.inputs.notifyResults(envelope)
    }
}

extension HotelDiscoveryEmbedVC: HotelDiscoveryNavDelegate {
    public func passHaveDismissed(_ nav: HotelDiscoveryNavVC) {
       self.viewModel.inputs.filterHasBeenDismissed()
    }
    
    public func paramHaveUpdated(_ nav: HotelDiscoveryNavVC, param: SearchHotelParams) {
        self.viewModel.inputs.filter(param)
    }
}

