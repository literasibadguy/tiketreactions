//
//  HotelGuestFormVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 15/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import TiketAPIs
import UIKit

internal final class HotelGuestFormVC: UITableViewController {
    
    fileprivate let dataSource = HotelGuestFormDataSource()
    fileprivate let viewModel: HotelGuestFormViewModelType = HotelGuestFormViewModel()
    
    internal func configureWith(hotelDirect: HotelDirect, availableRoom: AvailableRoom) {
        self.viewModel.inputs.configureWith(hotelDirect: hotelDirect, availableRoom: availableRoom)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = dataSource
        self.tableView.register(nib: .RoomSummaryViewCell)
        self.tableView.register(nib: .ContactInfoViewCell)
        
        self.viewModel.inputs.viewDidLoad()
    }

    override func bindStyles() {
        super.bindStyles()
        
        _ = self
            |> baseTableControllerStyle(estimatedRowHeight: 450.0)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.loadHotelAndAvailableRoomIntoDataSource
            .observe(on: UIScheduler())
            .observeValues { [weak self] hotel, room in
                print("OBserve Values into Data Source: \(room)")
                self?.dataSource.load(hotelDirect: hotel, availableRoom: room)
                self?.tableView.reloadData()
        }
    }
}
