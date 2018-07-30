//
//  FlightDirectsContentVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 26/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

public protocol FlightDirectsContentDelegate: class {
    func preparingPassenger(group: GroupPassengersParam)
}

public final class FlightDirectsContentVC: UITableViewController {
    
    fileprivate let dataSource = FlightDirectsContentDataSource()
    fileprivate let viewModel: FlightDirectsContentViewModelType = FlightDirectsContentViewModel()
    
    internal weak var delegate: FlightDirectsContentDelegate?
    
    internal func configuredSingleWith(params: SearchSingleFlightParams, flight: Flight) {
        self.viewModel.inputs.configureSingleWith(param: params, flight: flight)
    }
    
    internal func configureReturnWith(params: SearchFlightParams, departed: Flight, returned: Flight) {
        self.viewModel.inputs.configureReturnWith(param: params, departed: departed, returned: returned)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Booking"
        
        self.tableView.register(nib: .FlightDirectViewCell)
        self.tableView.register(nib: .ContactInfoViewCell)
        self.tableView.register(nib: .PassengerSummaryViewCell)
        self.tableView.dataSource = dataSource
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self
            |> baseTableControllerStyle()
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.loadFlightParamDataSource
            .observe(on: UIScheduler())
            .observeValues { [weak self] params, flight in
                self?.dataSource.loadSingle(param: params, flight: flight)
        }
        
        self.viewModel.outputs.loadFlightIntoDataSource
            .observe(on: UIScheduler())
            .observeValues { [weak self] flight in
                self?.dataSource.load(flight: flight)
                self?.tableView.reloadData()
        }
        
        self.viewModel.outputs.loadReturnedFlightIntoDataSource
            .observe(on: UIScheduler())
            .observeValues { [weak self] depart, returned in
                self?.dataSource.load(departed: depart, returned: returned)
                self?.tableView.reloadData()
        }
        
        self.viewModel.outputs.loadReturnedFlightParamDataSource
            .observe(on: UIScheduler())
            .observeValues { [weak self] params, depart, returned in
                self?.dataSource.load(param: params, depart: depart, returned: returned)
                self?.tableView.reloadData()
        }
        
        self.viewModel.outputs.preparingPassenger
            .observe(on: UIScheduler())
            .observeValues { [weak self] group in
                self?.delegate?.preparingPassenger(group: group)
        }
        
        self.viewModel.outputs.filledOrder
            .observe(on: UIScheduler())
            .observeValues { [weak self] envelope in
                print("FLIGHT ORDER CURRENT STATUS: \(envelope.diagnostic.confirm!)")
        }
    }
    
    public override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? ContactInfoViewCell {
            cell.delegate = self
        }
    }
}

extension FlightDirectsContentVC: ContactInfoViewCellDelegate {
    func goToPassengerPickerVC(passengerPickerVC: PassengerTitlePickerVC) {
        self.present(passengerPickerVC, animated: true, completion: nil)
    }
    
    func goToRegionalCodePhoneVC(phoneVC: PhoneCodeListVC) {
        
    }
    
    
    func getContactInfoParams(guestForm: CheckoutGuestParams) {
        
    }
    
    func getGuestForms(salutation: String, firstName: String, lastName: String, email: String, phone: String) {
        self.viewModel.inputs.contactForm(salutation: salutation, fullname: firstName, email: email, phone: phone)
    }
    
    func getFinishedForm(_ completed: Bool) {
        self.viewModel.inputs.contactFormCompleted(completed)
    }
    
    func canceledTitlePick() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension FlightDirectsContentVC: PassengerOptionCellDelegate {
    public func contactOptionPassengerChanged(_ switched: UISwitch) {
        self.viewModel.inputs.contactOptionPassengerChanged(switched.isOn)
    }
}



