//
//  FacilityListVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 25/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift

import TiketKitModels
import UIKit

internal final class FacilityListVC: UIViewController {
    
    fileprivate let dataSource = FacilityListDataSource()
    
    fileprivate let viewModel: FacilityListViewModelType = FacilityListViewModel()
    
    @IBOutlet fileprivate weak var headerFacilityView: UIView!
    @IBOutlet fileprivate weak var facilityTitleLabel: UILabel!
    @IBOutlet fileprivate weak var facilityCancelButton: UIButton!
    @IBOutlet fileprivate weak var facilityHotelTableView: UITableView!
    
    @IBOutlet fileprivate weak var facilityHeaderSeparatorView: UIView!
    
    internal static func configureWith(facilities: [HotelDirect.AvailableFacility]) -> FacilityListVC {
        let vc = Storyboard.FacilityList.instantiate(FacilityListVC.self)
        vc.viewModel.inputs.configureWith(facilities)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.facilityHotelTableView.dataSource = dataSource
        
        self.facilityCancelButton.addTarget(self, action: #selector(tappedButtonCancel), for: .touchUpInside)
        
        self.viewModel.inputs.viewDidLoad()
    }

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self.facilityTitleLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600

        
        _ = self.facilityHotelTableView
            |> UITableView.lens.separatorStyle .~ .none
            |> UITableView.lens.rowHeight .~ UITableViewAutomaticDimension
        
        _ = self.facilityHeaderSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.facilities
            .observe(on: UIScheduler())
            .observeValues { [weak self] facilities in
                self?.dataSource.load(facilities: facilities)
                self?.facilityHotelTableView.reloadData()
        }
        
        self.viewModel.outputs.goBack
            .observe(on: UIScheduler())
            .observeValues { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
        }
    }
    
    @objc fileprivate func tappedButtonCancel() {
        self.viewModel.inputs.tappedCancelButton()
    }
}
