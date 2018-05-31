    //
//  HotelLiveFeedNavVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 06/05/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import Spring
import UIKit
import TiketKitModels

internal protocol HotelLiveFeedNavViewDelegate: class {
    func hotelLiveFeedNavigationFilterSelectedParams(_ params: SearchHotelParams)
}
    
internal final class HotelLiveFeedNavVC: UIViewController {
    
    fileprivate let viewModel: HotelLiveFeedNavViewModelType = HotelLiveFeedNavViewModel()
    
    @IBOutlet fileprivate weak var locationContainerView: DesignableView!
    @IBOutlet fileprivate weak var locationFormButton: UIButton!
    @IBOutlet fileprivate weak var locationContentLabel: UILabel!
    
    @IBOutlet fileprivate weak var dateContainerView: DesignableView!
    @IBOutlet fileprivate weak var dateFormButton: UIButton!
    @IBOutlet fileprivate weak var dateContentLabel: UILabel!
    
    @IBOutlet fileprivate weak var guestRoomButton: UIButton!
    @IBOutlet fileprivate weak var sortFilterButton: UIButton!
    
    internal weak var delegate: HotelLiveFeedNavViewDelegate?
    
    internal static func instantiate() -> HotelLiveFeedNavVC {
        return Storyboard.HotelLiveFeed.instantiate(HotelLiveFeedNavVC.self)
    }
    
    internal func configureWith(params: SearchHotelParams) {
        self.viewModel.inputs.configureWith(params: params)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.locationFormButton.addTarget(self, action: #selector(locationFormButtonTapped), for: .touchUpInside)
        self.dateFormButton.addTarget(self, action: #selector(dateFormButtonTapped), for: .touchUpInside)
        self.guestRoomButton.addTarget(self, action: #selector(guestRoomButtonTapped), for: .touchUpInside)
        self.sortFilterButton.addTarget(self, action: #selector(sortFilterButtonTapped), for: .touchUpInside)
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.showDestinationFilters
            .observe(on: UIScheduler())
            .observeValues { [weak self] selectedDestination in
                self?.showDestinationFilters(selectedRow: selectedDestination)
//                self?.showDestinationFilters(selectedRow: selectedDestination)
        }
        
        self.viewModel.outputs.showDateRangeFilters
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.showDateRangeFilters()
        }
        
        self.viewModel.outputs.showGuestRoomFilters
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.showGuestRoomFilters()
        }
        
        self.viewModel.outputs.showSortFilters
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.showSortFilters()
        }
        
        self.viewModel.outputs.dismissDestinationFilters
            .observe(on: UIScheduler())
            .observeValues { [weak self] params in
                self?.delegate?.hotelLiveFeedNavigationFilterSelectedParams(params)
        }
    }
    
    fileprivate func showDestinationFilters(selectedRow: SelectableRow) {
        let desinationVC = DestinationHotelListVC.configuredWith()
        desinationVC.delegate = self
        desinationVC.modalPresentationStyle = .fullScreen
        self.present(desinationVC, animated: true, completion: nil)
    }
    
    fileprivate func showDateRangeFilters() {
//        let dateRangeVC = PickDatesHotelVC.configureWith(nil, hotelParam: nil)
//        self.present(dateRangeVC, animated: true, completion: nil)
    }
    
    fileprivate func showGuestRoomFilters() {
        
    }
    
    fileprivate func showSortFilters() {
        
    }
    
    @objc fileprivate func locationFormButtonTapped() {
        print("Destination Button Tapped")
        self.viewModel.inputs.destinationButtonTapped()
    }
    
    @objc fileprivate func dateFormButtonTapped() {
        self.viewModel.inputs.dateRangeButtonTapped()
    }
    
    @objc fileprivate func guestRoomButtonTapped() {
        self.viewModel.inputs.guestRoomButtonTapped()
    }
    
    @objc fileprivate func sortFilterButtonTapped() {
        self.viewModel.inputs.sortFilterButtonTapped()
    }
}
    
extension HotelLiveFeedNavVC: DestinationHotelListVCDelegate {
    func destinationHotelList(_ vc: DestinationHotelListVC, selectedRow: AutoHotelResult) {
        
        let changedParams = .defaults
            |> SearchHotelParams.lens.query .~ selectedRow.category.components(separatedBy: " ").first!
            |> SearchHotelParams.lens.startDate .~ "2018-05-11"
            |> SearchHotelParams.lens.endDate .~ "2018-05-12"
            |> SearchHotelParams.lens.adult .~ "2"
            |> SearchHotelParams.lens.room .~ 1
            |> SearchHotelParams.lens.night .~ 1
        
        print("Changing Params Defaults: \(changedParams)")
        self.viewModel.inputs.destinationSelected(SelectableRow(isSelected: true, params: changedParams))
    }
        
    func destinationHotelListDidClose(_ vc: DestinationHotelListVC) {
        
    }
}

    
