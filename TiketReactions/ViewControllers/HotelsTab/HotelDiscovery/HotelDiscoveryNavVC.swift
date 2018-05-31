//
//  HotelDiscoveryNavVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 10/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

public protocol HotelDiscoveryNavDelegate: class {
    func paramHaveUpdated(_ nav: HotelDiscoveryNavVC, param: SearchHotelParams)
    func passHaveDismissed(_ nav: HotelDiscoveryNavVC)
}

public final class HotelDiscoveryNavVC: UIViewController {
    
    fileprivate let viewModel: HotelDiscoveryNavViewModelType = HotelDiscoveryNavViewModel()
    
    @IBOutlet fileprivate weak var backButton: UIButton!
    @IBOutlet fileprivate weak var filterButton: UIButton!
    
    @IBOutlet fileprivate weak var cityLabel: UILabel!
    @IBOutlet fileprivate weak var detailNavLabel: UILabel!
    
    weak var delegate: HotelDiscoveryNavDelegate?
    
    internal func configureWith(result: AutoHotelResult, range: String) {
        self.viewModel.inputs.configureWith(selected: result)
        self.viewModel.inputs.configDateText(range: range)
    }
    
    internal func configureEnvelope(_ envelope: SearchHotelEnvelopes) {
        self.viewModel.inputs.takingResults(envelope)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.backButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        self.filterButton.addTarget(self, action: #selector(filterButtonTapped), for: .touchUpInside)
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.cityLabel.rac.text = self.viewModel.outputs.locationText
        self.detailNavLabel.rac.text = self.viewModel.outputs.subtextContent
        
        self.viewModel.outputs.goFilters
            .observe(on: UIScheduler())
            .observeValues { [weak self] results in
                self?.goFilters(results)
        }
        
        self.viewModel.outputs.updatedParams
            .observe(on: UIScheduler())
            .observeValues { [weak self] updated in
                print("Navigation Updated: \(updated)")
                guard let _self = self else { return }
                self?.delegate?.passHaveDismissed(_self)
                self?.delegate?.paramHaveUpdated(_self, param: updated)
        }
    }
    
    fileprivate func goFilters(_ result: SearchHotelEnvelopes) {
        let filtersVC = HotelDiscoveryFiltersVC.configureWith(envelope: result)
        filtersVC.delegate = self
        let nav = UINavigationController(rootViewController: filtersVC)
        self.present(nav, animated: true, completion: nil)
    }
    
    @objc fileprivate func cancelButtonTapped() {
//        self.viewModel.inputs.cancelButtonTapped()
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc fileprivate func filterButtonTapped() {
        self.viewModel.inputs.filterButtonTapped()
    }
}

extension HotelDiscoveryNavVC: HotelDiscoveryFiltersDelegate {
    public func filtersHaveDismissed(_ discovery: HotelDiscoveryFiltersVC) {
        self.viewModel.inputs.filtersHaveDismissed()
    }
    
    public func filterParamChanged(_ discovery: HotelDiscoveryFiltersVC, param: SearchHotelParams) {
        self.viewModel.inputs.extendingParam(param)
    }
}
