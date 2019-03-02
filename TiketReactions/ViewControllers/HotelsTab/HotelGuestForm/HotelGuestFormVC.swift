//
//  HotelGuestFormVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 15/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

public protocol HotelGuestFormDelegate: class {
    func shouldFirstGuestForm(_ valid: Bool)
    func shouldThereAnotherGuest(_ should: Bool)
    func preparedFinalCheckoutParam(_ param: CheckoutGuestParams)
}

internal final class HotelGuestFormVC: UITableViewController {
    
    fileprivate let dataSource = HotelGuestFormDataSource()
    fileprivate let viewModel: HotelGuestFormViewModelType = HotelGuestFormViewModel()
    
    public weak var delegate: HotelGuestFormDelegate?
    
    internal func configureWith(hotelDirect: HotelDirect, availableRoom: AvailableRoom, booking: HotelBookingSummary) {
        self.viewModel.inputs.configureWith(hotelDirect: hotelDirect, availableRoom: availableRoom, booking: booking)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = dataSource
        self.tableView.register(nib: .ContactInfoViewCell)
        self.tableView.register(nib: .NoticeSummaryViewCell)
        self.tableView.register(nib: .GuestFormTableViewCell)
        
        self.viewModel.inputs.viewDidLoad()
    }

    override func bindStyles() {
        super.bindStyles()
        
        _ = (self.navigationController?.navigationBar)!
            |> UINavigationBar.lens.barTintColor .~ .white
            |> UINavigationBar.lens.shadowImage .~ UIImage()
        
        _ = self
            |> baseTableControllerStyle(estimatedRowHeight: 500.0)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.loadHotelAndAvailableRoomIntoDataSource
            .observe(on: UIScheduler())
            .observeValues { [weak self] hotel, room, summary in
                print("OBserve Values into Data Source: \(room)")
                self?.dataSource.load(hotelDirect: hotel, availableRoom: room, summary: summary)
                self?.tableView.reloadData()
        }
        
        self.viewModel.outputs.guestFirstFormValid
            .observe(on: UIScheduler())
            .observeValues { [weak self] valid in
                print("Guest First Form Valid: \(valid)")
                self?.delegate?.shouldFirstGuestForm(valid)
        }

        self.viewModel.outputs.expandGuestCell
            .observe(on: UIScheduler())
            .observeValues { [weak self] params in
                self?.dataSource.loadedSourceParams(params)
                self?.tableView.reloadData()
                self?.tableView.scrollToRow(at: IndexPath(row: 0, section: 3), at: .bottom, animated: true)
        }
        
        self.viewModel.outputs.removeGuestCell
            .observe(on: UIScheduler())
            .observeValues { [weak self] _ in
                self?.deleteAnotherGuestForm()

        }
        
        self.viewModel.outputs.finalCheckoutData
            .observe(on: UIScheduler())
            .observeValues { [weak self] formData in
                self?.delegate?.preparedFinalCheckoutParam(formData)
        }
    }
    
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ContactInfoViewCell {
            cell.delegate = self
        }
        if let cell = cell as? GuestOptionViewCell {
            cell.delegate = self
        }
        if let cell = cell as? GuestFormTableViewCell {
            cell.delegate = self
        }
    }
    
    fileprivate func deleteAnotherGuestForm() {
        self.tableView.performBatchUpdates( {
            self.tableView.deleteRows(at: self.dataSource.removeForAnotherGuest(), with: .top)
        }, completion: nil)
    }
}

extension HotelGuestFormVC: GuestOptionViewCellDelegate {
    func guestFormOptionChanged(_ option: Bool) {
        self.viewModel.inputs.guestOptionChanged(option)
    }
}

extension HotelGuestFormVC: ContactInfoViewCellDelegate {
    
    func canceledTitlePick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func goToPassengerPickerVC(passengerPickerVC: PassengerTitlePickerVC) {
        self.present(passengerPickerVC, animated: true, completion: nil)
    }
    
    func goToRegionalCodePhoneVC(phoneVC: PhoneCodeListVC) {
        self.present(phoneVC, animated: true, completion: nil)
    }
    
    
    func getContactInfoParams(guestForm: CheckoutGuestParams) {
        print("WHAT IS IT ABOUT: ??: \(guestForm)")
        self.viewModel.inputs.configureExtendParam(guestForm)
    }
    
    func getFinishedForm(_ completed: Bool) {
        self.viewModel.inputs.contactFormValid(completed)
    }
}

extension HotelGuestFormVC: GuestFormTableCellDelegate {
    func putAnotherParams(_ guestForm: CheckoutGuestParams) {
        self.viewModel.inputs.anotherGuestFormDataChange(guestForm)
    }
    
    func getAnotherFinishedForm(_ completed: Bool) {
        print("Get Another Finished Form: \(completed)")
        self.viewModel.inputs.anotherGuestFormValid(completed)
    }
}


