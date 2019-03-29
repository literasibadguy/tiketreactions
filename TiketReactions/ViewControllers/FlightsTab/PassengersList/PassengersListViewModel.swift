//
//  PassengersListViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 28/08/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public struct PassengersData {
    public let passenger: FormatDataForm
    public let isInternational: Bool
    public let isBaggage: Bool
    public let departBaggage: FormatDataForm?
    public let returnBaggage: FormatDataForm?
    public let extended: AdultPassengerParam?
    public let isScootFlight: Bool?
}


public struct PassengerSummary {
    public let formatData: [FormatDataForm]
    public let extended: [AdultPassengerParam]
}

public enum PassengerStatus {
    case international
    case domestic
}

public enum PassengerFormState {
    case firstPassenger
    case adultPassenger
    case childPassenger
    case infantPassenger
    case expiredPassport
    case issueDatePassport
}

public protocol PassengersListViewModelInputs {
    func configureWith(_ envelope: GetFlightDataEnvelope)
    func contactSameWithFirstPassenger(valid: Bool)
    func willDisplayCellPassenger(indexPath: IndexPath)
    func selectedPassenger(_ separator: FormatDataForm, row: Int)
    func selectedExtended(_ separator: FormatDataForm, passengerRow: Int)
    func whichSelectedPassenger(_ row: Int)
    func getContactPassenger(_ group: GroupPassengersParam)
    func contactFormValid(_ completed: Bool)
    func getRestPassenger(lists: [String: AdultPassengerParam])
    func updateTableViewWith(_ passengers: [AdultPassengerParam])
    func getSomePassenger(_ pass: AdultPassengerParam, format: FormatDataForm)
    func remindAlertTappedOK(shouldCheckOut: Bool)
    func errorAlertTappedOK(shouldDismiss: Bool)
    func submitToPaymentButtonTapped()
    func viewDidLoad()
}

public protocol PassengersListViewModelOutputs {
    var loadPassengerLists: Signal<[FormatDataForm], NoError> { get }
    var setPassengerFormat: Signal<[FormatDataForm], NoError> { get }
    var goToAdultPassengers: Signal<PassengersData, NoError> { get }
    var goExtendPassengers: Signal<AdultPassengerParam, NoError> { get }
    var goSameAsContact: Signal<PassengersData, NoError> { get }
    var goToPassengerForm: Signal<FormatDataForm, NoError> { get }
    var updatePassengerTable: Signal<(IndexPath, [AdultPassengerParam]), NoError> { get }
    var isPassengerListValid: Signal<Bool, NoError> { get }
    var addOrderFlightError: Signal<String, NoError> { get }
    var orderFlightIsLoading: Signal<Bool, NoError> { get }
    var hideLoadingOverlay: Signal<Bool, NoError> { get }
    var remindAlert: Signal<String, NoError> { get }
    var errorAlert: Signal<String, NoError> { get }
    var goToPaymentMethod: Signal<FlightMyOrder, NoError> { get }
}

public protocol PassengersListViewModelType {
    var inputs: PassengersListViewModelInputs { get }
    var outputs: PassengersListViewModelOutputs { get }
}

public final class PassengersListViewModel: PassengersListViewModelType, PassengersListViewModelInputs, PassengersListViewModelOutputs {
    
    public init() {
        
        let current = Signal.combineLatest(self.viewDidLoadProperty.signal, self.configFlightDataProperty.signal).map(second)
        
        let scootFlight = current.signal.skipNil().map { $0.departures.airlinesName == "SCOOT" }
        
        let passsengerState: Signal<(isInternational: Bool, isDepartBaggage: Bool, isReturnBaggage: Bool), NoError> = current.signal.skipNil().map { ($0.adultPassengerList.adult1.passportNo != nil, $0.adultPassengerList.adult1.departBaggage != nil, $0.adultPassengerList.adult1.returnBaggage != nil) }
        
        let detectedFormat = current.signal.skipNil().map { [$0.adultPassengerList.adult1.separator, $0.adultPassengerList.adult2.separtor, $0.adultPassengerList.adult3.separtor, $0.adultPassengerList.adult4.separtor, $0.adultPassengerList.adult5.separtor, $0.adultPassengerList.adult6.separtor, $0.adultPassengerList.child1.separtor, $0.adultPassengerList.child2.separtor, $0.adultPassengerList.child3.separtor, $0.adultPassengerList.child4.separtor, $0.adultPassengerList.child5.separtor, $0.adultPassengerList.child6.separtor, $0.adultPassengerList.infant1.separtor, $0.adultPassengerList.infant2.separtor, $0.adultPassengerList.infant3.separtor, $0.adultPassengerList.infant4.separtor, $0.adultPassengerList.infant5.separtor, $0.adultPassengerList.infant6.separtor].compact() }
            
        self.loadPassengerLists = detectedFormat.signal
        
        self.setPassengerFormat = .empty

        let contactForm = self.firstPassengerFilledProperty.signal.skipNil()
        
        let firstTempoPassenger = contactForm.signal.switchMap { params -> SignalProducer<AdultPassengerParam, NoError> in
            let new = .defaults
                |> AdultPassengerParam.lens.title .~ params.conSalutation
                |> AdultPassengerParam.lens.firstname .~ params.conFirstName
                |> AdultPassengerParam.lens.lastname .~ params.conLastName
            return SignalProducer(value: new)
            }.materialize()
        
        let getValidFirst = Signal.combineLatest( self.contactFormValidProperty.signal.filter(isTrue).skipRepeats(), detectedFormat.signal.map { $0.first! }, current.signal.skipNil().map { $0.adultPassengerList }, firstTempoPassenger.values(), scootFlight.signal).map {  _, detected, lists, tempo, scoot in
                return tabData(selected: detected, required: lists, extended: tempo, scootFlight: scoot)
            }.sample(on: self.sameValidFirstPassengerProperty.signal.skipNil().filter(isTrue).ignoreValues())
        
        let initialEmptyPassenger = Signal.combineLatest(self.selectedPassengerProperty.signal.skipNil().map(first), current.signal.skipNil().map { $0.adultPassengerList }, scootFlight.signal).map { detected, lists, scoot in
            return tabData(selected: detected, required: lists, scootFlight: scoot)
        }
        
        let firedFilledPassenger = Signal.combineLatest(self.selectedExtendedPassengerProperty.signal.skipNil(), current.signal.skipNil().map { $0.adultPassengerList }, self.getListsPassengerProperty.signal.skipNil().filter { !$0.isEmpty }, scootFlight.signal).map { detected, lists, extends, scoot in
            return tabData(selected: detected.0, required: lists, extended: extends[detected.0.fieldText], scootFlight: scoot)
        }
        
        /*
        let firedFilledPassenger = Signal.combineLatest(self.selectedExtendedPassengerProperty.signal.skipNil().map(second), initialEmptyPassenger, self.tablePassengersProperty.signal.skipNil().filter { !$0.isEmpty }).switchMap { took, initial, selectFilled -> SignalProducer<PassengersData, NoError> in
            let newExtend = initial
                |> PassengersData.lens.extendedPassenger .~ selectFilled[took]
            return SignalProducer(value: newExtend)
        }
        */

        
        self.goToAdultPassengers = Signal.merge(initialEmptyPassenger.signal, firedFilledPassenger.signal.skipRepeats { lhs, rhs in lhs.extended?.firstname == rhs.extended?.firstname })
        
        self.goSameAsContact = getValidFirst.signal
        
        self.goExtendPassengers = .empty
        let getOrderLoading = MutableProperty(false)
        
        
        let totalSingleParam = Signal.combineLatest(current.signal.skipNil().filter { $0.returns.isNil }, contactForm.signal, self.getListsPassengerProperty.signal.skipNil()).switchMap { (arg) -> SignalProducer<GroupPassengersParam, NoError> in
            let (flightData, contactParam, listsParam) = arg
            let totalForm = contactParam
                |> GroupPassengersParam.lens.flightId .~ flightData.departures.flightId
                |> GroupPassengersParam.lens.adult .~ Int(flightData.departures.countAdult)
                |> GroupPassengersParam.lens.child .~ Int(flightData.departures.countChild)
                |> GroupPassengersParam.lens.groupPassengers .~ listsParam
            return SignalProducer(value: totalForm)
            }.materialize()
        
        let totalParam = Signal.combineLatest(current.signal.skipNil().filter { !$0.returns.isNil }, contactForm.signal, self.getListsPassengerProperty.signal.skipNil()).switchMap { (arg) -> SignalProducer<GroupPassengersParam, NoError> in
            let (flightData, contactParam, listsParam) = arg
            let totalForm = contactParam
                |> GroupPassengersParam.lens.flightId .~ flightData.departures.flightId
                |> GroupPassengersParam.lens.returnFlightId .~ flightData.returns?.flightId
                |> GroupPassengersParam.lens.adult .~ Int(flightData.departures.countAdult)
                |> GroupPassengersParam.lens.child .~ Int(flightData.departures.countChild)
                |> GroupPassengersParam.lens.groupPassengers .~ listsParam
            return SignalProducer(value: totalForm)
        }.materialize()
        
        let loginParams = contactForm.signal.switchMap { params -> SignalProducer<CheckoutLoginParams, NoError> in
            let new = .defaults
                |> CheckoutLoginParams.lens.salutation .~ params.conSalutation
                |> CheckoutLoginParams.lens.firstName .~ params.conFirstName
                |> CheckoutLoginParams.lens.lastName .~ params.conLastName
                |> CheckoutLoginParams.lens.email .~ params.conEmailAddress
                |> CheckoutLoginParams.lens.phone .~ "\(params.conPhone ?? "")"
            return SignalProducer(value: new)
        }.materialize()
        
        let howManyCount = Signal.combineLatest(detectedFormat.signal, self.getListsPassengerProperty.signal.skipNil()).map {$0.0.count == $0.1.count }
        
        self.isPassengerListValid = Signal.merge(current.signal.mapConst(false), Signal.combineLatest(self.contactFormValidProperty.signal, howManyCount.signal).map { isTrue($0.0 && $0.1) }).takeWhen(self.submitButtonTappedProperty.signal)
        
        self.remindAlert = Signal.combineLatest(self.isPassengerListValid.signal.filter { $0 == true }, self.submitButtonTappedProperty.signal.map { _ in Localizations.ConfirmdataTitle }).map(second)
        
        
        loginParams.values().observe(on: UIScheduler()).observeValues { envelope in
            print("Login params: \(envelope)")
        }
        
        let addOrderFlightService = Signal.merge(totalParam.values(), totalSingleParam.values()).takeWhen(self.remindTappedCheckoutProperty.signal.skipNil().filter { isTrue($0) }.ignoreValues()).switchMap { entireParam in
            AppEnvironment.current.apiService.addOrderFlight(params: entireParam).ck_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler).on(started: { getOrderLoading.value = true }, terminated: { getOrderLoading.value = false }).materialize()
        }
        
        /*
        self.updatePassengerTable = Signal.combineLatest(detectedFormat.signal, self.tablePassengersProperty.signal.skipNil()).map { return PassengerSummary(formatData: $0.0, extended: $0.1) }
        */
        self.updatePassengerTable = Signal.combineLatest(self.indexPathPassengerProperty.signal.skipNil(), self.getListsPassengerProperty.signal.skipNil().filter { !$0.isEmpty }).map { ($0.0, Array($0.1.values)) }
        
        addOrderFlightService.values().observe(on: UIScheduler()).observeValues { envelope in
            print("Is there any flight order occured: \(envelope)")
        }
        
//        let someThought = Signal.combineLatest()
        
        let errorCheckout = addOrderFlightService.values().filter { $0.diagnostic.status == .error }
        
        self.addOrderFlightError = errorCheckout.signal.map { $0.diagnostic.errorMessage }.skipNil()
        
        self.goToPassengerForm = .empty
        
        let lastOrderEvent = addOrderFlightService.signal.promoteError(CheckoutRetryError.self).switchMap { _ in SignalProducer<(), CheckoutRetryError>(value: ()).ck_delay(.seconds(1), on: AppEnvironment.current.scheduler).flatMap {
            AppEnvironment.current.apiService.fetchFlightOrder().on(started: { getOrderLoading.value = true }, terminated: { getOrderLoading.value = false }).flatMapError { _ in return SignalProducer(error: CheckoutRetryError()) }
                .flatMap { envelope -> SignalProducer<FlightOrderEnvelope, CheckoutRetryError> in
                    switch envelope.diagnostic.status {
                    case .failed, .empty, .error, .timeout, .expired:
                        return SignalProducer(error: CheckoutRetryError())
                    case .successful:
                        return SignalProducer(value: envelope)
                    }
                }
            }
            }.materialize()
        
        let myOrder = lastOrderEvent.values().signal.map { $0.myOrder }.skipNil()
        
        let lastOrderDetailId = myOrder.signal.map { $0.orderData }.filter { !$0.isEmpty }
            .map { $0.last!.orderDetailId }
        
        let checkoutRequestLink = lastOrderEvent.values().signal.filter { $0.checkout != nil }.map { $0.checkout
        }
        
        let checkoutPageRequestEnvelope = checkoutRequestLink.signal.switchMap { checkout in
            AppEnvironment.current.apiService.checkoutPageRequest(url: checkout ?? "").ck_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler).on(started: { getOrderLoading.value = true },  terminated: { getOrderLoading.value = false }).materialize()
        }
        
        let takeCheckoutCustomer = checkoutPageRequestEnvelope.values().filter { $0.diagnostic.status == .successful }.map { $0.nextCheckoutURI }

        let checkoutLoginEvent = Signal.combineLatest(takeCheckoutCustomer, loginParams.values()).switchMap {
            AppEnvironment.current.apiService.checkoutFlightLogin(url: $0.0, params: $0.1).ck_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler).on(started: { getOrderLoading.value = true }, terminated: { getOrderLoading.value = false }).retry(upTo: 3).materialize()
        }
        
        let emailPick = checkoutLoginEvent.values().filter { $0.diagnostic.status == .successful }
        
        let decidedOrder = Signal.combineLatest(myOrder, emailPick).on(value: { saveIssuedOrder($0.0.orderId, email: $0.1.username) } ).map(first)
        
        decidedOrder.observe(on: UIScheduler()).observeValues { ordering in
            print("DECIDED ORDER: \(String(describing: ordering))")
        }
        
        self.errorAlert = Signal.merge(checkoutPageRequestEnvelope.values().filter { $0.diagnostic.status == .error }.map { $0.diagnostic.errorMessage }.skipNil(), errorCheckout.signal.map { $0.diagnostic.errorMessage }.skipNil(), lastOrderEvent.values().signal.filter { $0.diagnostic.status == .error }.map { $0.diagnostic.errorMessage }.skipNil())
        
        self.orderFlightIsLoading = Signal.merge(self.viewDidLoadProperty.signal.mapConst(false), self.remindTappedCheckoutProperty.signal.skipNil().filter(isTrue), checkoutLoginEvent.values().map { $0.diagnostic.status != .successful }, self.errorAlert.mapConst(false))
        
        self.hideLoadingOverlay = Signal.merge(self.viewDidLoadProperty.signal.mapConst(true), self.remindTappedCheckoutProperty.signal.skipNil().filter(isTrue).map { _ in return false }, checkoutLoginEvent.values().map { $0.diagnostic.status == .successful }, self.errorAlert.mapConst(true))
        
        self.goToPaymentMethod = decidedOrder.signal.takeWhen(checkoutLoginEvent.values().filter { $0.diagnostic.status == .successful }.ignoreValues())
    }
    
    fileprivate let configFlightDataProperty = MutableProperty<GetFlightDataEnvelope?>(nil)
    public func configureWith(_ envelope: GetFlightDataEnvelope) {
        self.configFlightDataProperty.value = envelope
    }
    
    fileprivate let sameValidFirstPassengerProperty = MutableProperty<Bool?>(nil)
    public func contactSameWithFirstPassenger(valid: Bool) {
        self.sameValidFirstPassengerProperty.value = valid
    }
    
    fileprivate let indexPathPassengerProperty = MutableProperty<IndexPath?>(nil)
    public func willDisplayCellPassenger(indexPath: IndexPath) {
        self.indexPathPassengerProperty.value = indexPath
    }
    
    fileprivate let selectedPassengerProperty = MutableProperty<(FormatDataForm, Int)?>(nil)
    public func selectedPassenger(_ separator: FormatDataForm, row: Int) {
        self.selectedPassengerProperty.value = (separator, row)
    }
    
    fileprivate let selectedExtendedPassengerProperty = MutableProperty<(FormatDataForm, Int)?>(nil)
    public func selectedExtended(_ separator: FormatDataForm, passengerRow: Int) {
        self.selectedExtendedPassengerProperty.value = (separator, passengerRow)
    }
    
    fileprivate let whichRowPassengerProperty = MutableProperty<Int?>(nil)
    public func whichSelectedPassenger(_ row: Int) {
        self.whichRowPassengerProperty.value = row
    }
    
    fileprivate let firstPassengerFilledProperty = MutableProperty<GroupPassengersParam?>(nil)
    public func getContactPassenger(_ group: GroupPassengersParam) {
        self.firstPassengerFilledProperty.value = group
    }
    
    fileprivate let contactFormValidProperty = MutableProperty(false)
    public func contactFormValid(_ completed: Bool) {
        self.contactFormValidProperty.value = completed
    }
    
    fileprivate let getListsPassengerProperty = MutableProperty<[String: AdultPassengerParam]?>(nil)
    public func getRestPassenger(lists: [String: AdultPassengerParam]) {
        self.getListsPassengerProperty.value = lists
    }
    
    fileprivate let tablePassengersProperty = MutableProperty<[AdultPassengerParam]?>(nil)
    public func updateTableViewWith(_ passengers: [AdultPassengerParam]) {
        self.tablePassengersProperty.value = passengers
    }
    
    fileprivate let somePassengerProperty = MutableProperty<(AdultPassengerParam, FormatDataForm)?>(nil)
    public func getSomePassenger(_ pass: AdultPassengerParam, format: FormatDataForm) {
        self.somePassengerProperty.value = (pass, format)
    }
    
    fileprivate let firstAdultPassengerProperty = MutableProperty<AdultPassengerParam?>(nil)
    public func getFirstAdultPassenger(_ adultA1: AdultPassengerParam) {
        self.firstAdultPassengerProperty.value = adultA1
    }
    
    fileprivate let secondAdultPassengerProperty = MutableProperty<AdultPassengerParam?>(nil)
    public func getSecondAdultPassenger(_ adultA2: AdultPassengerParam) {
        self.secondAdultPassengerProperty.value = adultA2
    }
    
    fileprivate let remindTappedCheckoutProperty = MutableProperty<Bool?>(nil)
    public func remindAlertTappedOK(shouldCheckOut: Bool) {
        self.remindTappedCheckoutProperty.value = shouldCheckOut
    }
    
    fileprivate let errorTappedDismissProperty = MutableProperty<Bool?>(nil)
    public func errorAlertTappedOK(shouldDismiss: Bool) {
        self.errorTappedDismissProperty.value = shouldDismiss
    }
    
    fileprivate let submitButtonTappedProperty = MutableProperty(())
    public func submitToPaymentButtonTapped() {
        self.submitButtonTappedProperty.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let loadPassengerLists: Signal<[FormatDataForm], NoError>
    public let setPassengerFormat: Signal<[FormatDataForm], NoError>
    public let goToAdultPassengers: Signal<PassengersData, NoError>
    public let goExtendPassengers: Signal<AdultPassengerParam, NoError>
    public let goSameAsContact: Signal<PassengersData, NoError>
    public let goToPassengerForm: Signal<FormatDataForm, NoError>
    public let updatePassengerTable: Signal<(IndexPath, [AdultPassengerParam]), NoError>
    public let isPassengerListValid: Signal<Bool, NoError>
    public let addOrderFlightError: Signal<String, NoError>
    public let orderFlightIsLoading: Signal<Bool, NoError>
    public let hideLoadingOverlay: Signal<Bool, NoError>
    public let remindAlert: Signal<String, NoError>
    public let errorAlert: Signal<String, NoError>
    public let goToPaymentMethod: Signal<FlightMyOrder, NoError>
    
    public var inputs: PassengersListViewModelInputs { return self }
    public var outputs: PassengersListViewModelOutputs { return self }
}

// [PassengersData]
private func tabData(selected: FormatDataForm, required: RequiredPassengers, extended: AdultPassengerParam? = nil, scootFlight: Bool? = nil) -> PassengersData {
    let isInternational = required.adult1.passportNo != nil
    let isDepartBaggage = required.adult1.departBaggage != nil
    let isReturnBaggage = required.adult1.returnBaggage != nil
    
    if selected.fieldText.contains("Anak") {
        print("Ini penumpang Anak")
    } else if selected.fieldText.contains("Dewasa") {
        print("Ini penumpang Dewasa")
    }
    
    let departBaggage = isDepartBaggage ? required.adult1.departBaggage : nil
    let returnBaggage = isReturnBaggage ? required.adult1.returnBaggage : nil
    
    print("List Depart Baggage: \(String(describing: departBaggage))")
    
    return PassengersData(passenger: selected, isInternational: isInternational, isBaggage: isDepartBaggage, departBaggage: departBaggage, returnBaggage: returnBaggage, extended: extended, isScootFlight: scootFlight)
}

/*
extension PassengersData {
    public enum lens {
        public static let extendedPassenger = Lens<PassengersData, AdultPassengerParam?>(
            view: { $0.extended },
            set: { view, set in PassengersData(passenger: set.passenger, isInternational: set.isInternational, isBaggage: set.isBaggage, departBaggage: set.departBaggage, returnBaggage: set.returnBaggage, extended: view) }
        )
    }
}
 */

private func countThePassengers(lists: [FormatDataForm]) -> Int {
    return lists.count
}

private func find(passengerForFormat format: FormatDataForm, in passengers: [AdultPassengerParam]) -> AdultPassengerParam? {
    return passengers.filter { passenger in
        if case passenger.id = format.fieldText { return true }
        return false
    }.first
}

private func matchedPassengers(property: (passenger: AdultPassengerParam, format: FormatDataForm), lists: [FormatDataForm]) -> FormatDataForm {
    
    let selectedFormat = property.format
    return lists.filter { formatList in
        if case formatList.fieldText = selectedFormat.fieldText { return true }
        return false
    }.first!
}
