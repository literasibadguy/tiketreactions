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
        
        self.title = Localizations.PassengerListsTitle
        
        self.nextContainerButton.addTarget(self, action: #selector(submitFlightOrderTapped), for: .touchUpInside)
        
        self.listPassengersTableView.register(nib: .ContactInfoViewCell)
        self.listPassengersTableView.register(nib: .PassengerSummaryViewCell)
        self.listPassengersTableView.register(nib: .PassengerFilledViewCell)
        
        self.listPassengersTableView.dataSource = dataSource
        self.listPassengersTableView.delegate = self
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        startListeningToNotifications()
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
            |> UIButton.lens.title(forState: .normal) .~ Localizations.ChoosepaymentTitle
        
        _ = self.loadingOverlayView
            |> UIView.lens.isHidden .~ true
        
        _ = self.loadingOverlayLabel
            |> UILabel.lens.text .~ Localizations.BookingNoticeGetOrder
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
//        self.nextContainerButton.rac.isEnabled = self.viewModel.outputs.isPassengerListValid
        self.loadingOverlayView.rac.hidden = self.viewModel.outputs.hideLoadingOverlay
        self.grayActivityIndicator.rac.animating = self.viewModel.outputs.orderFlightIsLoading
        self.loadingOverlayLabel.rac.hidden = self.viewModel.outputs.hideLoadingOverlay
        
        self.viewModel.outputs.loadPassengerLists
            .observe(on: UIScheduler())
            .observeValues { [weak self] summaries in
//                print("Should There be Passengers here: \(passengerFormat)")
                self?.dataSource.loadPassenger(summaries)
                self?.listPassengersTableView.reloadData()
                self?.formatCount = summaries.count
        }
        
        self.viewModel.outputs.goToAdultPassengers
          .observe(on: QueueScheduler.main)
            .observeValues { [weak self] tabData in
                let vc = PassengerInternationalVC.configureDataWith(tabData)
                vc.delegate = self
                self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.viewModel.outputs.goSameAsContact
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] contact in
                guard let _self = self else { return }
                _self.listPassengersTableView.selectRow(at: IndexPath(row: 0, section: 2), animated: true, scrollPosition: UITableViewScrollPosition.none)
                let vc = PassengerInternationalVC.configureDataWith(contact)
                vc.delegate = self
                self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.viewModel.outputs.goExtendPassengers
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] extended in
                print("EXTENDING PASSENGER: \(extended)")
                let vc = PassengerInternationalVC.configureExtendedWith(extended)
                vc.delegate = self
                self?.navigationController?.pushViewController(vc, animated: true)
        }
        
        self.viewModel.outputs.isPassengerListValid
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] valid in
                if valid == false {
                    self?.present(UIAlertController.genericError(message: "Data hasnt been valid", cancel:nil), animated: true, completion: nil)
                }
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
        
        self.viewModel.outputs.addOrderFlightError
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] errorMsg in
                self?.present(UIAlertController.genericError(message: errorMsg, cancel: {
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
    
    fileprivate func goToPassengerInternationalVC(_ format: FormatDataForm, status: PassengerStatus, baggages: FormatDataForm? = nil) {
        let internationalVC = PassengerInternationalVC.configureWith(separator: format, status: status, baggage: baggages)
        internationalVC.delegate = self
        self.navigationController?.pushViewController(internationalVC, animated: true)
    }
    
    fileprivate func goToPaymentMethod(_ order: FlightMyOrder) {
        let paymentMethodVC = PaymentsListVC.configureFlightWith(myorder: order)
        self.navigationController?.pushViewController(paymentMethodVC, animated: true)
    }
    
    fileprivate func deleteCategoriesLoaderRow(row: Int) {
        guard let
            deleteCategoriesLoaderRow = self.dataSource.removeDataFormRows(index: row),
            !deleteCategoriesLoaderRow.isEmpty else {
                return
        }
        
        self.listPassengersTableView.performBatchUpdates( {
            self.listPassengersTableView.deleteRows(at: deleteCategoriesLoaderRow, with: .fade)
        }, completion: nil)
    }
    
    fileprivate func setFormatPassenger(_ format: FormatDataForm, status: PassengerStatus, res: FormatDataForm? = nil) {
        self.goToPassengerInternationalVC(format, status: status, baggages: res)
    }
    
    func startListeningToNotifications() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        nc.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    @objc fileprivate func keyboardWillShow(_ notification: Foundation.Notification) {
        guard
            let userInfo = notification.userInfo as? [String: AnyObject],
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else {
                return
        }
        
        refreshInsets(forKeyboardFrame: keyboardFrame)
    }
    
    @objc fileprivate func keyboardWillHide(_ notification: Foundation.Notification) {
        guard
            let userInfo = notification.userInfo as? [String: AnyObject],
            let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            else {
                return
        }
        
        refreshInsets(forKeyboardFrame: keyboardFrame)
//        dismissOptionsViewControllerIfNecessary()
    }
    
    fileprivate func refreshInsets(forKeyboardFrame keyboardFrame: CGRect) {
        let referenceView: UIScrollView = self.listPassengersTableView
        
        let scrollInsets = UIEdgeInsets(top: referenceView.scrollIndicatorInsets.top, left: 0, bottom: view.frame.maxY - keyboardFrame.minY, right: 0)
        let contentInsets  = UIEdgeInsets(top: referenceView.contentInset.top, left: 0, bottom: view.frame.maxY - keyboardFrame.minY, right: 0)
        
        self.listPassengersTableView.scrollIndicatorInsets = scrollInsets
        self.listPassengersTableView.contentInset = contentInsets
        
//        htmlTextView.scrollIndicatorInsets = scrollInsets
//        htmlTextView.contentInset = contentInsets
        
//        richTextView.scrollIndicatorInsets = scrollInsets
//        richTextView.contentInset = contentInsets
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
            self.viewModel.inputs.willDisplayCellPassenger(indexPath: indexPath)
        } else if let optionCell = cell as? GuestOptionViewCell {
            optionCell.delegate = self
        }
        
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let passenger = self.dataSource.passengerSummaryAtIndexPath(indexPath) {
            if !toggles[passenger.fieldText].isNil {
                print("There is passenger filled here: \(passenger.fieldText)")
                self.viewModel.inputs.selectedExtended(passenger, passengerRow: indexPath.row)
            } else {
                self.viewModel.inputs.selectedPassenger(passenger, row: indexPath.row)
                print("What did I select row: \(indexPath.row) and Section: \(indexPath.section)")
            }
        }
//        self.listPassengersTableView.deselectRow(at: indexPath, animated: true)
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

extension PassengersListVC: GuestOptionViewCellDelegate {
    func guestFormOptionChanged(_ option: Bool) {
        self.viewModel.inputs.contactSameWithFirstPassenger(valid: option)
    }
}

extension PassengersListVC: PassengerSummaryCellDelegate {
    public func updatePassengerSummary(_ text: AdultPassengerParam, indexRow: Int) {
        print("Text: \(text), indexRow: \(indexRow))")
//        self.viewModel.inputs.saveEveryCurrent(passenger: text, index: indexRow)
//        self.deleteCategoriesLoaderRow(row: indexRow + 1)
    }
}

extension PassengersListVC: PassengerDomesticDelegate {
    public func submitAdultDomesticFormTapped(_ vc: PassengerDomesticVC, adult: AdultPassengerParam) {
        
    }
}

extension PassengersListVC: PassengerInternationalDelegate {
    public func paramFormSubmitted(_ internationalVC: PassengerInternationalVC, format: FormatDataForm, passenger: AdultPassengerParam) {
        toggles[format.fieldText] = passenger
        if toggles.count == formatCount {
            print("Its time to take it to the lists")
        }
        self.viewModel.inputs.getRestPassenger(lists: toggles)
        print("What behind on my dictionary: \(toggles)")
//        self.viewModel.inputs.updateTableViewWith(Array(toggles.values))
        
        guard let selectedIndexPath = self.listPassengersTableView.indexPathForSelectedRow else { return }
        if format.fieldText == "Penumpang Dewasa 1" {
            print("IS IT PENUMPANG DEWASA 1")
            (self.listPassengersTableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? PassengerSummaryViewCell)?.extendWith(passenger: passenger, indexRow: 0)
        } else {
            (self.listPassengersTableView.cellForRow(at: selectedIndexPath) as? PassengerSummaryViewCell)?.extendWith(passenger: passenger, indexRow: selectedIndexPath.row)
        }
    }
}

