//
//  PassengersListVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 28/08/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import UIKit
import TiketKitModels

public final class PassengersListVC: UIViewController {
    
    fileprivate let viewModel: PassengersListViewModelType = PassengersListViewModel()
    fileprivate let dataSource = PassengersListDataSource()
    
    @IBOutlet fileprivate weak var listPassengersTableView: UITableView!
    @IBOutlet fileprivate weak var nextContainerButton: UIButton!
    
    @IBOutlet fileprivate weak var loadingOverlayView: UIView!
    @IBOutlet fileprivate weak var grayActivityIndicator: UIActivityIndicatorView!
    @IBOutlet fileprivate weak var loadingOverlayLabel: UILabel!
    
    fileprivate var muchPassengers: [AdultPassengerParam] = []
    fileprivate var childPassengers: [AdultPassengerParam] = []
    fileprivate var infantPassengers: [AdultPassengerParam] = []
    
    private var toggles = [String : AdultPassengerParam]()
    private var formatCount: Int!
    
    public static func instantiate() -> PassengersListVC {
        let vc = Storyboard.PassengersList.instantiate(PassengersListVC.self)
        return vc
    }
    
    public static func configureWith(_ envelope: GetFlightDataEnvelope) -> PassengersListVC {
        let vc = Storyboard.PassengersList.instantiate(PassengersListVC.self)
        vc.viewModel.inputs.configureWith(envelope)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nextContainerButton.addTarget(self, action: #selector(submitFlightOrderTapped), for: .touchUpInside)
        
        self.listPassengersTableView.register(nib: .ContactInfoViewCell)
        self.listPassengersTableView.register(nib: .PassengerSummaryViewCell)
        
        self.listPassengersTableView.dataSource = dataSource
        self.listPassengersTableView.delegate = self
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.grayActivityIndicator.center = self.listPassengersTableView.center
    }

    public override func bindStyles() {
        super.bindStyles()
        
        _ = self.grayActivityIndicator
            |> baseActivityIndicatorStyle
        
        _ = (self.navigationController?.navigationBar)!
            |> UINavigationBar.lens.barTintColor .~ .white
            |> UINavigationBar.lens.shadowImage .~ UIImage()
        
        _ = self.listPassengersTableView
            |> UITableView.lens.rowHeight .~ UITableViewAutomaticDimension
            |> UITableView.lens.backgroundColor .~ .white
            |> UITableView.lens.estimatedRowHeight .~ 480.0
            |> UITableView.lens.separatorStyle .~ .none
        
        _ = self.nextContainerButton
            |> UIButton.lens.backgroundColor .~ .tk_official_green
            |> UIButton.lens.backgroundColor(forState: .disabled) .~ .tk_typo_green_grey_600
            |> UIButton.lens.isEnabled .~ false
            |> UIButton.lens.title(forState: .normal) .~ Localizations.ChoosepaymentTitle
        
        _ = self.loadingOverlayView
            |> UIView.lens.isHidden .~ true
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.nextContainerButton.rac.isEnabled = self.viewModel.outputs.isPassengerListValid
        self.loadingOverlayView.rac.hidden = self.viewModel.outputs.orderFlightIsLoading.negate()
        self.grayActivityIndicator.rac.animating = self.viewModel.outputs.orderFlightIsLoading
        
        self.viewModel.outputs.loadPassengerLists
            .observe(on: UIScheduler())
            .observeValues { [weak self] passengerFormat in
                print("Should There be Passengers here: \(passengerFormat)")
                self?.dataSource.loadPassenger(passengerFormat)
                self?.listPassengersTableView.reloadData()
                self?.formatCount = passengerFormat.count
        }
        
        self.viewModel.outputs.goToFirstPassenger
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] format, status, resBaggage in
                self?.setFormatPassenger(format, status: status, res: resBaggage)
        }
        
        self.viewModel.outputs.goToAdultPassengers
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] tabData in
                let vc = PassengerInternationalVC.configureDataWith(tabData)
                vc.delegate = self
                self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.viewModel.outputs.remindAlert
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] remind in
                self?.present(UIAlertController.alert(message: remind, confirm: {
                    _ in self?.viewModel.inputs.remindAlertTappedOK(shouldCheckOut: true)
                }, cancel: { _ in self?.viewModel.inputs.remindAlertTappedOK(shouldCheckOut: false) }), animated: true, completion: nil)
        }
        
        self.viewModel.outputs.errorAlert
            .observe(on: UIScheduler())
            .observeValues { [weak self] errorReason in
                self?.present(UIAlertController.genericError(message: errorReason, cancel: {
                    _ in self?.viewModel.inputs.errorAlertTappedOK(shouldDismiss: true)
                }), animated: true, completion: nil)
        }
        
        self.viewModel.outputs.goToPaymentMethod
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] order in
                print("Is it going to success: \(order)")
                self?.goToPaymentMethod(order)
        }
    }
    
    fileprivate func goToPassengerFormVC(_ format: FormatDataForm, state: PassengerFormState) {
        let formVC = PassengerDetailVC.configureWith(format, state: state)
        formVC.adultDelegate = self
        self.navigationController?.pushViewController(formVC, animated: true)
    }
    
    fileprivate func goToPassengerInternationalVC(_ format: FormatDataForm, status: PassengerStatus, baggages: FormatDataForm? = nil) {
        let internationalVC = PassengerInternationalVC.configureWith(separator: format, status: status, baggage: baggages)
        internationalVC.delegate = self
        self.navigationController?.pushViewController(internationalVC, animated: true)
    }
    
    fileprivate func goToPaymentMethod(_ order: FlightMyOrder) {
        let paymentMethodVC = PaymentsListVC.configureFlightWith(myorder: order)
        self.navigationController?.pushViewController(paymentMethodVC, animated: true)
    }
    
    fileprivate func setFormatPassenger(_ format: FormatDataForm, status: PassengerStatus, res: FormatDataForm? = nil) {
        self.goToPassengerInternationalVC(format, status: status, baggages: res)
    }
    
    @objc fileprivate func submitFlightOrderTapped() {
//        self.viewModel.inputs.addOrderButtonSubmitTapped()
        self.viewModel.inputs.submitToPaymentButtonTapped()
    }
}

extension PassengersListVC: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let contactCell = cell as? ContactInfoViewCell {
            contactCell.flightDelegate = self
        } else if let passengerCell = cell as? PassengerSummaryViewCell {
            passengerCell.delegate = self
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let passenger = self.dataSource.passengerSummaryAtIndexPath(indexPath) {
            self.viewModel.inputs.selectedPassenger(passenger)
        }
    }
}

extension PassengersListVC: ContactFlightInfoViewCellDelegate {
    
    func goToPassengerPickerVC(passengerPickerVC: PassengerTitlePickerVC) {
        self.present(passengerPickerVC, animated: true, completion: nil)
    }
    
    func goToRegionalCodePhoneVC(phoneVC: PhoneCodeListVC) {
        self.present(phoneVC, animated: true, completion: nil)
    }
    
    func getFinishedForm(_ completed: Bool) {
        self.viewModel.inputs.contactFormValid(completed)
    }
    
    func getContactInfoParams(guestForm: GroupPassengersParam) {
        self.viewModel.inputs.getContactPassenger(guestForm)
        
    }
    
    func canceledTitlePick() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension PassengersListVC: PassengerSummaryCellDelegate {
    public func updatePassengerSummary(_ text: AdultPassengerParam, indexRow: Int) {
        print("Text: \(text), indexRow: \(indexRow)")
//        self.viewModel.inputs.saveEveryCurrent(passenger: text, index: indexRow)
    }
}

extension PassengersListVC: PassengerDomesticDelegate {
    public func submitAdultDomesticFormTapped(_ vc: PassengerDomesticVC, adult: AdultPassengerParam) {
//        self.viewModel.inputs.getAdultListPassenger(adult)
        
    }
}

extension PassengersListVC: PassengerInternationalDelegate {
    public func paramFormSubmitted(_ internationalVC: PassengerInternationalVC, format: FormatDataForm, passenger: AdultPassengerParam) {
        toggles[format.fieldText] = passenger
        if toggles.count == formatCount {
            self.viewModel.inputs.getRestPassenger(lists: toggles)
            print("Its time to take it to the lists")
        }
        print("What Inside in Dictionary here: \(toggles)")
    }
}

extension PassengersListVC: AdultPassengerDetailDelegate {
    public func submitAdultPassenger(_ detail: PassengerDetailVC, format: FormatDataForm, passenger: AdultPassengerParam) {
        toggles[format.fieldText] = passenger
        if toggles.count == formatCount {
            self.viewModel.inputs.getRestPassenger(lists: toggles)
            print("Its time to take it to the lists")
        }
        print("What Inside in Dictionary here: \(toggles)")
    }
}
