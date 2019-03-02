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
    public let passengers: [FormatDataForm]
    public let isInternational: Bool
    public let isBaggage: Bool
}

public enum PassengerDestinationStatus {
    case domestic
    case international
}

public enum PassengerFormState {
    case firstPassenger
    case adultPassenger
    case childPassenger
    case infantPassenger
}

public protocol PassengersListViewModelInputs {
    func configureWith(_ envelope: GetFlightDataEnvelope)
    func selectedPassenger(_ separator: FormatDataForm)
    func getContactPassenger(_ group: GroupPassengersParam)
    func contactFormValid(_ completed: Bool)
    func getRestPassenger(lists: [String: AdultPassengerParam])
    func getSomePassenger(_ pass: AdultPassengerParam, format: FormatDataForm)
    func remindAlertTappedOK(shouldCheckOut: Bool)
    func errorAlertTappedOK(shouldDismiss: Bool)
    func submitToPaymentButtonTapped()
    func viewDidLoad()
}

public protocol PassengersListViewModelOutputs {
    var loadPassengerLists: Signal<[FormatDataForm], NoError> { get }
    var setPassengerFormat: Signal<[FormatDataForm], NoError> { get }
    var goToFirstPassenger: Signal<(FormatDataForm, PassengerStatus, [FormatDataForm]), NoError> { get }
    var goToAdultPassengers: Signal<FormatDataForm, NoError> { get }
    var goToChildPassengers: Signal<FormatDataForm, NoError> { get }
    var goToInfantPassengers: Signal<FormatDataForm, NoError> { get }
    var goToPassengerForm: Signal<FormatDataForm, NoError> { get }
    var isPassengerListValid: Signal<Bool, NoError> { get }
    var orderFlightIsLoading: Signal<Bool, NoError> { get }
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
        
        let passsengerState: Signal<(isInternational: Bool, isDepartBaggage: Bool, isReturnBaggage: Bool), NoError> = current.signal.skipNil().map { ($0.adultPassengerList.adult1.passportNo != nil, $0.adultPassengerList.adult1.departBaggage != nil, $0.adultPassengerList.adult1.returnBaggage != nil) }
        
        let personalizedBaggagePassenger = Signal.combineLatest(current.signal.skipNil(), passsengerState.signal).map { flightData, state in
            [state.isDepartBaggage ? flightData.adultPassengerList.adult1.departBaggage : nil, state.isReturnBaggage ? flightData.adultPassengerList.adult1.returnBaggage : nil]
        }.map { $0.compact() }
        
//        let listInternational = current.signal.skipNil().filter { $0.adultPassengerList.adult1.passportNo != nil }.map { [$0.adultPassengerList.adult1.separator, $0.adultPassengerList.adult2.separtor, $0.adultPassengerList.adult3.separtor, $0.adultPassengerList.adult4.separtor, $0.adultPassengerList.adult5.separtor, $0.adultPassengerList.adult6.separtor, $0.adultPassengerList.child1.separtor, $0.adultPassengerList.child2.separtor, $0.adultPassengerList.child3.separtor, $0.adultPassengerList.child4.separtor, $0.adultPassengerList.child5.separtor, $0.adultPassengerList.child6.separtor, $0.adultPassengerList.infant1.separtor, $0.adultPassengerList.infant2.separtor, $0.adultPassengerList.infant3.separtor, $0.adultPassengerList.infant4.separtor, $0.adultPassengerList.infant5.separtor, $0.adultPassengerList.infant6.separtor].compact() }
        
        let listPassengerData = current.signal.skipNil().map { [$0.adultPassengerList.adult1.separator, $0.adultPassengerList.adult2.separtor, $0.adultPassengerList.adult3.separtor, $0.adultPassengerList.adult4.separtor, $0.adultPassengerList.adult5.separtor, $0.adultPassengerList.adult6.separtor, $0.adultPassengerList.child1.separtor, $0.adultPassengerList.child2.separtor, $0.adultPassengerList.child3.separtor, $0.adultPassengerList.child4.separtor, $0.adultPassengerList.child5.separtor, $0.adultPassengerList.child6.separtor, $0.adultPassengerList.infant1.separtor, $0.adultPassengerList.infant2.separtor, $0.adultPassengerList.infant3.separtor, $0.adultPassengerList.infant4.separtor, $0.adultPassengerList.infant5.separtor, $0.adultPassengerList.infant6.separtor].compact() }
        
        let listBaggageData = current.signal.skipNil().filter { $0.adultPassengerList.adult1.departBaggage == nil }.map { [$0.adultPassengerList.adult1.departBaggage, $0.adultPassengerList.adult2.departBaggage].compact() }
            
        self.loadPassengerLists = listPassengerData.signal
        
        self.setPassengerFormat = listPassengerData.signal
        
        let findOutStatus = Signal.merge(current.signal.skipNil().filter { $0.adultPassengerList.adult1.passportNo != nil }.mapConst(PassengerStatus.international), current.signal.skipNil().filter { $0.adultPassengerList.adult1.passportNo == nil }.mapConst(PassengerStatus.domestic))
        
        self.goToFirstPassenger = Signal.combineLatest(self.selectedPassengerProperty.signal.skipNil(), findOutStatus.signal, personalizedBaggagePassenger.signal)
        
        let contactForm = self.firstPassengerFilledProperty.signal.skipNil()
        
        self.remindAlert = self.submitButtonTappedProperty.signal.map { _ in Localizations.ConfirmdataTitle }
        
        let getOrderLoading = MutableProperty(false)
        let totalParam = Signal.combineLatest(current.signal.skipNil() ,contactForm.signal, self.getListsPassengerProperty.signal.skipNil()).switchMap { (arg) -> SignalProducer<GroupPassengersParam, NoError> in
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
        
        loginParams.values().observe(on: UIScheduler()).observeValues { envelope in
            print("Login params: \(envelope)")
        }
        
        let addOrderFlightService = totalParam.values().takeWhen(self.remindTappedCheckoutProperty.signal.skipNil().filter { isTrue($0) }.ignoreValues()).switchMap { entireParam in
            AppEnvironment.current.apiService.addOrderFlight(params: entireParam).ck_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler).on(started: { getOrderLoading.value = true }, terminated: { getOrderLoading.value = false }).materialize()
        }
        
        addOrderFlightService.values().observe(on: UIScheduler()).observeValues { envelope in
            print("Is there any flight order occured: \(envelope)")
        }
        
//        let someThought = Signal.combineLatest()
        
        let errorCheckout = addOrderFlightService.values().filter { $0.diagnostic.status == .error && $0.diagnostic.status == .failed }.ignoreValues()
        
        self.goToAdultPassengers = .empty
        self.goToChildPassengers = .empty
        self.goToInfantPassengers = .empty
        
        self.goToPassengerForm = .empty
        
        self.isPassengerListValid = Signal.combineLatest(self.contactFormValidProperty.signal, self.getListsPassengerProperty.signal.mapConst(true).skipRepeats(==)).map { isTrue($0.0 && $0.1) }
        
        self.orderFlightIsLoading = getOrderLoading.signal
        
        let lastOrderEvent = addOrderFlightService.signal.promoteError(CheckoutRetryError.self).switchMap { _ in SignalProducer<(), CheckoutRetryError>(value: ()).ck_delay(.seconds(1), on: AppEnvironment.current.scheduler).flatMap {
            AppEnvironment.current.apiService.fetchFlightOrder().on(starting: { getOrderLoading.value = true }, completed: { getOrderLoading.value = true }, terminated: { getOrderLoading.value = false }).flatMapError { _ in return SignalProducer(error: CheckoutRetryError()) }
                .flatMap { envelope -> SignalProducer<FlightOrderEnvelope, CheckoutRetryError> in
                    
                    switch envelope.diagnostic.status {
                    case .failed, .empty, .error, .timeout:
                        return SignalProducer(error: CheckoutRetryError())
                    case .successful:
                        return SignalProducer(value: envelope)
                    }
                }.retry(upTo: 2)
            }
            }.materialize()
        
        self.errorAlert = Signal.merge(errorCheckout.signal, lastOrderEvent.values().signal.filter { $0.diagnostic.status == .error }.ignoreValues()).map { _ in Localizations.ConfirmerrorTitle }
        
        let myOrder = lastOrderEvent.values().signal.map { $0.myOrder }.skipNil()
        
        let lastOrderDetailId = myOrder.signal.map { $0.orderData }.filter { !$0.isEmpty }
            .map { $0.last!.orderDetailId }
        
        lastOrderDetailId.observe(on: UIScheduler()).observeValues { lastDetailId in
            print("WHATS LAST ORDER DETAIL ID: \(String(describing: lastDetailId))")
        }
        
        let checkoutRequestLink = lastOrderEvent.values().signal.filter { $0.checkout != nil }.map { $0.checkout
        }
        
        checkoutRequestLink.observe(on: UIScheduler()).observeValues { checkoutURI in
            print("WHATS CHECKOUT URI: \(String(describing: checkoutURI))")
        }
        
        let checkoutPageRequestEnvelope = checkoutRequestLink.signal.switchMap { checkout in
            AppEnvironment.current.apiService.checkoutPageRequest(url: checkout ?? "").ck_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler).on(starting: { getOrderLoading.value = true }, completed: { getOrderLoading.value = true },  terminated: { getOrderLoading.value = false }).materialize()
        }
        
        let takeCheckoutCustomer = checkoutPageRequestEnvelope.values().filter { $0.diagnostic.status == .successful }.map { $0.nextCheckoutURI }

        let checkoutLoginEvent = Signal.combineLatest(takeCheckoutCustomer, loginParams.values()).switchMap {
            AppEnvironment.current.apiService.checkoutFlightLogin(url: $0.0, params: $0.1).ck_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler).on(starting: { getOrderLoading.value = true }, completed: { getOrderLoading.value = true }, terminated: { getOrderLoading.value = false }).retry(upTo: 3).materialize()
        }
        
       checkoutLoginEvent.observe(on: UIScheduler()).observeValues { checkoutURI in
            print("WHATS Checkout Login Event URI: \(String(describing: checkoutURI))")
        }
        
        let emailPick = checkoutLoginEvent.values().filter { $0.diagnostic.status == .successful }
        
        let decidedOrder = Signal.combineLatest(myOrder, emailPick).on(value: { saveIssuedOrder($0.0.orderId, email: $0.1.username) } ).map(first)
        
        self.goToPaymentMethod = decidedOrder.signal.takeWhen(emailPick.ignoreValues())
    }
    
    fileprivate let configFlightDataProperty = MutableProperty<GetFlightDataEnvelope?>(nil)
    public func configureWith(_ envelope: GetFlightDataEnvelope) {
        self.configFlightDataProperty.value = envelope
    }
    
    fileprivate let selectedPassengerProperty = MutableProperty<FormatDataForm?>(nil)
    public func selectedPassenger(_ separator: FormatDataForm) {
        self.selectedPassengerProperty.value = separator
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
    public let goToFirstPassenger: Signal<(FormatDataForm, PassengerStatus, [FormatDataForm]), NoError>
    public let goToAdultPassengers: Signal<FormatDataForm, NoError>
    public let goToChildPassengers: Signal<FormatDataForm, NoError>
    public let goToInfantPassengers: Signal<FormatDataForm, NoError>
    public let goToPassengerForm: Signal<FormatDataForm, NoError>
    public let isPassengerListValid: Signal<Bool, NoError>
    public let orderFlightIsLoading: Signal<Bool, NoError>
    public let remindAlert: Signal<String, NoError>
    public let errorAlert: Signal<String, NoError>
    public let goToPaymentMethod: Signal<FlightMyOrder, NoError>
    
    public var inputs: PassengersListViewModelInputs { return self }
    public var outputs: PassengersListViewModelOutputs { return self }
}

private func createOrder(contact: GroupPassengersParam, lists: [String: AdultPassengerParam]) -> SignalProducer<AddOrderFlightEnvelope, ErrorEnvelope> {
    _ = contact
        |> GroupPassengersParam.lens.groupPassengers .~ lists
    return AppEnvironment.current.apiService.addOrderFlight(params: contact)
}

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
