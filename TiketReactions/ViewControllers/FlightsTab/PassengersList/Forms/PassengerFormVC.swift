//
//  PassengerFormVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 29/12/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

public protocol PassengerFormAdultDelegate: class {
    func submittedPassengerForm(pass: GroupPassengersParam)
}

internal final class PassengerFormVC: UITableViewController {
    
    fileprivate let dataSource = PassengerFormDataSource()
    fileprivate let viewModel: PassengerFormViewModelType = PassengerFormViewModel()
    
    public static func configureWith(format: FormatDataForm, state: PassengerFormState) -> PassengerFormVC {
        let vc = Storyboard.PassengerForm.instantiate(PassengerFormVC.self)
        vc.viewModel.inputs.configureWith(format, state: state)
        return vc
    }
    
    weak var adultDelegate: PassengerFormAdultDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.dataSource = dataSource
        
        self.tableView.register(nib: .ContactInfoViewCell)
        self.tableView.register(nib: .PassengerFormTableViewCell)
       
        self.viewModel.inputs.viewDidLoad()
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self
            |> baseTableControllerStyle(estimatedRowHeight: 500.0)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.sourceContactFirstPassenger
            .observe(on: UIScheduler())
            .observeValues { [weak self] format in
                self?.dataSource.configureContactFirstPassenger(format)
        }
        
        self.viewModel.outputs.sourceAdultsPassenger
            .observe(on: UIScheduler())
            .observeValues { [weak self] format in
                self?.dataSource.configureAdultsPassenger(format)
        }
        
        self.viewModel.outputs.sourceChildsPassenger
            .observe(on: UIScheduler())
            .observeValues { [weak self] format in
                self?.dataSource.configureChildsPassenger(format)
        }
        
        self.viewModel.outputs.sourceInfantsPassenger
            .observe(on: UIScheduler())
            .observeValues { [weak self] format in
                self?.dataSource.configureInfantsPassenger(format)
        }
        
        self.viewModel.outputs.submitPassenger
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] passParam in
                guard let _self = self else { return }
                _self.adultDelegate?.submittedPassengerForm(pass: passParam)
        }
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let contactCell = cell as? ContactInfoViewCell {
            contactCell.delegate = self
        }
        /*
        if let contactCell = cell as? PassengerFormTableViewCell {
            
        }
        */
    }
}

extension PassengerFormVC: ContactInfoViewCellDelegate {
    func getContactInfoParams(guestForm: CheckoutGuestParams) {
        
    }
    
    func getFinishedForm(_ completed: Bool) {
        
    }
    
    func canceledTitlePick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func goToPassengerPickerVC(passengerPickerVC: PassengerTitlePickerVC) {
        self.present(passengerPickerVC, animated: true, completion: nil)
    }
    
    func goToRegionalCodePhoneVC(phoneVC: PhoneCodeListVC) {
        self.present(phoneVC, animated: true, completion: nil)
    }
}

extension PassengerFormVC: PassengerFormTableDelegate {
    func canceledPick() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func goToBirthdatePicker(controller: PassengerBirthdatePickerVC) {
        self.present(controller, animated: true, completion: nil)
    }
    
    func submitPassengerAgain() {
        
    }
    
    func goToTitlePicker(controller: PassengerTitlePickerVC) {
        self.present(controller, animated: true, completion: nil)
    }
}
