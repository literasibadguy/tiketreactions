//
//  HotelEmbedGuestFormViewModel.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 15/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

private struct CheckoutRetryError: Error {}

public protocol HotelEmbedGuestFormViewModelInputs {
    func configureWith(hotelDirect: HotelDirect, availableRoom: AvailableRoom, booking: HotelBookingSummary)
    func configFormOrder(_ param: CheckoutGuestParams)
    func isThereAnotherGuest(_ should: Bool)
    func configAnotherGuest(salutation: String, fullname: String)
    func remindAlertTappedOK(shouldCheckOut: Bool)
    func errorAlertTappedOK(shouldDismiss: Bool)
    func loadingProgressBegin(_ loading: Bool)
    func bookingButtonTapped()
    func tellsToCheckoutCustomer(status: String)
    func viewDidLoad()
}

public protocol HotelEmbedGuestFormViewModelOutputs {
    var configureEmbedVCWithHotelAndRoom: Signal<(HotelDirect, AvailableRoom, HotelBookingSummary), NoError> { get }
    var configureGuestFormParam: Signal<CheckoutGuestParams, NoError> { get }
    
    var completeForm: Signal<(String, String, String, String, String), NoError> { get }
    
//    var isGuestFormValid: Signal<Bool, NoError> { get }
    var loadingOverlayIsHidden: Signal<Bool, NoError> { get }
    var notifyEnabled: Signal<Bool, NoError> { get }
    var orderIsLoading: Signal<Bool, NoError> { get }
    
    var bookURI: Signal<String, NoError> { get }
    
    var isOrderCompleted: Signal<HotelOrderEnvelope, NoError> { get }
    var isLoginCompleted: Signal<CheckoutLoginEnvelope, NoError> { get }
    
    var errorAlert: Signal<String, NoError> { get }
    var dismissAlert: Signal<Void, NoError> { get }
    var remindAlert: Signal<String, NoError> { get }
    var goToPayments: Signal<MyOrder, NoError> { get }
    
    var dismissGuestForm: Signal<AddOrderEnvelope, NoError> { get }
}

public protocol HotelEmbedGuestFormViewModelType {
    var inputs: HotelEmbedGuestFormViewModelInputs { get }
    var outputs: HotelEmbedGuestFormViewModelOutputs { get }
}

public final class HotelEmbedGuestFormViewModel: HotelEmbedGuestFormViewModelType, HotelEmbedGuestFormViewModelInputs, HotelEmbedGuestFormViewModelOutputs {
    
    init() {
        let hotelPrepare = Signal.combineLatest(self.configDataProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        self.dismissGuestForm = .empty
        
        let initialText = self.viewDidLoadProperty.signal.mapConst("")
        
        let anotherGuestForm = self.configAnotherGuestProperty.signal.skipNil()
        
        self.bookURI = hotelPrepare.map(second).map { $0.bookURI }
        
        // STEPS BY STEP
        
        self.configureEmbedVCWithHotelAndRoom = Signal.combineLatest(self.configDataProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        self.configureGuestFormParam = .empty
        self.completeForm = .empty
        
        self.notifyEnabled = self.configFormOrderProperty.signal.map { !$0.isNil }
        
        let isLoading = MutableProperty(false)
        
        self.remindAlert = self.bookButtonTappedProperty.signal.map { _ in Localizations.ConfirmdataTitle }
        
        let addOrderEnvelope = hotelPrepare.map(second).signal.promoteError(CheckoutRetryError.self).switchMap {
            package in SignalProducer<(), CheckoutRetryError>(value: ()).ck_delay(.seconds(1), on: AppEnvironment.current.scheduler).flatMap {_ in
                AppEnvironment.current.apiService.addOrder(url: package.bookURI).on(starting: { isLoading.value = true }, completed: { isLoading.value = true },  terminated: { isLoading.value = false }).flatMapError { _ in
                    return SignalProducer(error: CheckoutRetryError())
                    }.flatMap { envelope -> SignalProducer<AddOrderEnvelope, CheckoutRetryError> in
                        return SignalProducer(value: envelope)
                }
            }
        }.materialize().takeWhen(self.remindCheckoutProperty.signal.filter(isTrue).ignoreValues())
        
        let lastOrderEvent = addOrderEnvelope.signal.promoteError(CheckoutRetryError.self).switchMap { _ in SignalProducer<(), CheckoutRetryError>(value: ()).ck_delay(.seconds(1), on: AppEnvironment.current.scheduler).flatMap {
            AppEnvironment.current.apiService.fetchHotelOrder().on(starting: { isLoading.value = true }, completed: { isLoading.value = true }, terminated: { isLoading.value = false }).flatMapError { _ in return SignalProducer(error: CheckoutRetryError()) }.flatMap { envelope -> SignalProducer<HotelOrderEnvelope, CheckoutRetryError> in
                    return SignalProducer(value: envelope)
                }
            }
        }.materialize()
        
        let myOrder = lastOrderEvent.values().signal.map { $0.myOrder }
        let lastOrderDetailId = myOrder.signal.map { $0.orderData }.filter { !$0.isEmpty }.map { $0.last!.orderDetailId }
        
        lastOrderDetailId.observe(on: UIScheduler()).observeValues { lastDetailId in
            print("WHATS LAST ORDER DETAIL ID: \(lastDetailId)")
        }
        
        let checkoutRequestLink = lastOrderEvent.values().signal.filter { !$0.checkout.isEmpty }.map { $0.checkout
        }
        
        checkoutRequestLink.observe(on: UIScheduler()).observeValues { checkoutURI in
            print("WHATS CHECKOUT URI: \(checkoutURI)")
        }
        
        self.isOrderCompleted = lastOrderEvent.values()
        
        let loginParams = self.configFormOrderProperty.signal.skipNil().switchMap { params -> SignalProducer<CheckoutLoginParams, NoError> in
            let new = .defaults
                |> CheckoutLoginParams.lens.salutation .~ "Mr"
                |> CheckoutLoginParams.lens.firstName .~ params.conFirstName
                |> CheckoutLoginParams.lens.lastName .~ params.conLastName
                |> CheckoutLoginParams.lens.email .~ params.conEmailAddress
                |> CheckoutLoginParams.lens.phone .~ "\(params.conPhone ?? "")"
                |> CheckoutLoginParams.lens.saveContinue .~ "2"
            return SignalProducer(value: new)
        }.materialize()
        
        loginParams.values().observe(on: UIScheduler()).observeValues { loginData in
            print("LOGIN DATA PREPARED: \(loginData)")
        }
        
        let checkoutPageRequestEnvelope = checkoutRequestLink.signal.promoteError(CheckoutRetryError.self).switchMap { checkout in
            SignalProducer<(), CheckoutRetryError>(value: ()).ck_delay(.seconds(1), on: AppEnvironment.current.scheduler).flatMap {
                AppEnvironment.current.apiService.checkoutPageRequest(url: checkout).on(starting: { isLoading.value = true }, completed: { isLoading.value = true },  terminated: { isLoading.value = false }).flatMapError {
                    _ in return SignalProducer(error: CheckoutRetryError())
                    }.flatMap { envelope -> SignalProducer<CheckoutPageRequestEnvelope, CheckoutRetryError> in
                        return SignalProducer(value: envelope)
                }
            }
        }.materialize()
        
        checkoutPageRequestEnvelope.values().observe(on: UIScheduler()).observeValues { envelope in
            print("WHAT STATUS CHECKOUT: \(envelope.diagnostic.status)")
        }
        
        let errorCheckoutPage = checkoutPageRequestEnvelope.values().filter { $0.diagnostic.status == 204 }
        
        /*
        let deleteOrderEvent =  myOrder.signal.map { $0.orderData }.filter { !$0.isEmpty }.map { $0.last!.deleteUri }.switchMap { orderData in
            AppEnvironment.current.apiService.deleteOrder(url: orderData).materialize()
        }.values().takeWhen(self.errorDismisssProperty.signal.ignoreValues())
        
        
        deleteOrderEvent.signal.observe(on: UIScheduler()).observeValues { whats in
            print("DELETING ORDER: \(whats.diagnostic)")
        }
        */
        
        self.dismissAlert = self.errorDismisssProperty.signal.filter { $0 == true }.ignoreValues()
        
        let takeCheckoutCustomer = checkoutPageRequestEnvelope.values().filter { $0.diagnostic.status == 200 }.map { $0.nextCheckoutURI }

        
        let checkoutLoginEvent = Signal.combineLatest(takeCheckoutCustomer, loginParams.values()).switchMap {
            
            AppEnvironment.current.apiService.checkoutLogin(url: $0.0, params: $0.1).ck_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler).on(starting: { isLoading.value = true }, completed: { isLoading.value = true }, terminated: { isLoading.value = false }).retry(upTo: 3).demoteErrors()
        }.materialize()
        
        let falseCheckoutLoginEvent = checkoutLoginEvent.values().filter { $0.loginStatus == "false" }.ignoreValues()
        
        self.isLoginCompleted = checkoutLoginEvent.values()
        
        let finalCheckoutParam = Signal.combineLatest(self.configFormOrderProperty.signal.skipNil(), lastOrderDetailId).switchMap { formOrder, detailId -> SignalProducer<CheckoutGuestParams, NoError> in
            let final = formOrder
                |> CheckoutGuestParams.lens.detailId .~ detailId
                |> CheckoutGuestParams.lens.country .~ "id"
            return SignalProducer(value: final)
        }.materialize()
        
        let checkoutCustomerRequestEnvelope = Signal.combineLatest(checkoutLoginEvent.values().filter { $0.loginStatus == "true" }.ignoreValues(), takeCheckoutCustomer, finalCheckoutParam.values()).promoteError(CheckoutRetryError.self).switchMap { _, checkout, customer in
            SignalProducer<(), CheckoutRetryError>(value: ()).ck_delay(.seconds(1), on: AppEnvironment.current.scheduler).flatMap {
                AppEnvironment.current.apiService.checkoutHotelCustomer(url: checkout, params: customer).on(starting: { isLoading.value = true }, completed: { isLoading.value = true },  terminated: { isLoading.value = false }).flatMapError {
                    _ in return SignalProducer(error: CheckoutRetryError())
                    }.flatMap { envelope -> SignalProducer<CheckoutHotelCustomerEnvelope, CheckoutRetryError> in
                        return SignalProducer(value: envelope)
                }
            }
            }.materialize()
        
        
        let checkoutErrorCustomer = checkoutCustomerRequestEnvelope.values().filter { $0.diagnostic.status != 200 }

        self.errorAlert = Signal.merge(errorCheckoutPage.ignoreValues(), falseCheckoutLoginEvent, checkoutErrorCustomer.ignoreValues()).map { Localizations.ConfirmerrorTitle }
        
        self.orderIsLoading = Signal.merge(self.viewDidLoadProperty.signal.mapConst(false), self.remindCheckoutProperty.signal.mapConst(true), checkoutCustomerRequestEnvelope.values().map { $0.diagnostic.status != 200 })
        self.loadingOverlayIsHidden = Signal.merge(self.viewDidLoadProperty.signal.mapConst(true), self.remindCheckoutProperty.signal.mapConst(false), checkoutCustomerRequestEnvelope.values().map { $0.diagnostic.status == 200 })
        
        self.goToPayments = myOrder.takeWhen(checkoutCustomerRequestEnvelope.values().filter { $0.diagnostic.status == 200 })
    }
    
    private let configDataProperty = MutableProperty<(HotelDirect, AvailableRoom, HotelBookingSummary)?>(nil)
    public func configureWith(hotelDirect: HotelDirect, availableRoom: AvailableRoom, booking: HotelBookingSummary) {
        self.configDataProperty.value = (hotelDirect, availableRoom, booking)
    }
    
    private let configFormOrderProperty = MutableProperty<CheckoutGuestParams?>(nil)
    public func configFormOrder(_ param: CheckoutGuestParams) {
        self.configFormOrderProperty.value = param
    }
    
    private let anotherGuestShouldProperty = MutableProperty(false)
    public func isThereAnotherGuest(_ should: Bool) {
        self.anotherGuestShouldProperty.value = should
    }
    
    private let configAnotherGuestProperty = MutableProperty<(String, String)?>(nil)
    public func configAnotherGuest(salutation: String, fullname: String) {
        self.configAnotherGuestProperty.value = (salutation, fullname)
    }
    
    private let errorDismisssProperty = MutableProperty(false)
    public func errorAlertTappedOK(shouldDismiss: Bool) {
        self.errorDismisssProperty.value = shouldDismiss
    }
    
    private let remindCheckoutProperty = MutableProperty(false)
    public func remindAlertTappedOK(shouldCheckOut: Bool) {
        self.remindCheckoutProperty.value = shouldCheckOut
    }
    
    private let loadingProgressProperty = MutableProperty(false)
    public func loadingProgressBegin(_ loading: Bool) {
        self.loadingProgressProperty.value = loading
    }
    
    fileprivate let bookButtonTappedProperty = MutableProperty(())
    public func bookingButtonTapped() {
        self.bookButtonTappedProperty.value = ()
    }
    
    fileprivate let checkoutStatusProperty = MutableProperty("")
    public func tellsToCheckoutCustomer(status: String) {
        self.checkoutStatusProperty.value = status
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let configureEmbedVCWithHotelAndRoom: Signal<(HotelDirect, AvailableRoom, HotelBookingSummary), NoError>
    public let configureGuestFormParam: Signal<CheckoutGuestParams, NoError>
    public let completeForm: Signal<(String, String, String, String, String), NoError>
    public let loadingOverlayIsHidden: Signal<Bool, NoError>
    public let notifyEnabled: Signal<Bool, NoError>
    public let orderIsLoading: Signal<Bool, NoError>
    public let bookURI: Signal<String, NoError>
    public let isOrderCompleted: Signal<HotelOrderEnvelope, NoError>
    public let isLoginCompleted: Signal<CheckoutLoginEnvelope, NoError>
    public let errorAlert: Signal<String, NoError>
    public let dismissAlert: Signal<Void, NoError>
    public let remindAlert: Signal<String, NoError>
    public let goToPayments: Signal<MyOrder, NoError>
    public let dismissGuestForm: Signal<AddOrderEnvelope, NoError>
    
    public var inputs: HotelEmbedGuestFormViewModelInputs { return self }
    public var outputs: HotelEmbedGuestFormViewModelOutputs { return self }
}

private func checkoutGuestFormParam(salutation: String, fullname: String, email: String, phone: String) -> CheckoutGuestParams {
        let guestParam = .defaults
            |> CheckoutGuestParams.lens.conFirstName .~ String(fullname.first!)
            |> CheckoutGuestParams.lens.conLastName .~ String(fullname.last!)
            |> CheckoutGuestParams.lens.conPhone .~ phone
            |> CheckoutGuestParams.lens.conEmailAddress .~ email
            |> CheckoutGuestParams.lens.firstName .~ String(fullname.first!)
            |> CheckoutGuestParams.lens.lastName .~ String(fullname.last!)
            |> CheckoutGuestParams.lens.phone .~ phone
            |> CheckoutGuestParams.lens.salutation .~ salutation
    
    return guestParam
}

/*
 let getOrderEvent = addOrderEnvelope.signal.switchMap { _ in
 AppEnvironment.current.apiService.fetchHotelOrder().on(starting: { isLoading.value = true },  terminated: { isLoading.value = false }).ck_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler).demoteErrors()
 }
 let myOrder = getOrderEvent.signal.map { $0.myOrder }
 let orders = getOrderEvent.signal.map { $0.myOrder.orderData }
 let lastSelected = orders.filter { !$0.isEmpty }.map { $0.last! }
 */

private func getLastOrderDetailId() -> SignalProducer<String, CheckoutRetryError> {
    
    return AppEnvironment.current.apiService.fetchHotelOrder().mapError { _ in CheckoutRetryError() }.flatMap { env -> SignalProducer<String, CheckoutRetryError> in
        
        guard let myOrder = env.myOrder.orderData.last else { return .empty }
        let selectedDetailId = myOrder.orderDetailId
        
        return SignalProducer(value: selectedDetailId)
    }
}

private func getCheckoutLinkRequest() -> SignalProducer<String, CheckoutRetryError> {
    
    return AppEnvironment.current.apiService.fetchHotelOrder().mapError { _ in CheckoutRetryError() }.flatMap { env -> SignalProducer<String, CheckoutRetryError> in
        
        let checkoutLink = env.checkout
        
        return SignalProducer(value: checkoutLink)
    }
}

private func isSimpleValid(title: String, name: String, email: String, phone: String) -> Bool {
    return !title.isEmpty && !name.isEmpty && isValidEmail(email) && isValidPhone(phone)
}

private func isValid(title: String, firstname: String, lastname: String, email: String, phone: String) -> Bool {
    return !title.isEmpty && !firstname.isEmpty && !lastname.isEmpty && isValidEmail(email) && isValidPhone(phone)
}

/*
private func createCustomerCheckout(checkoutURI: String, customer: CheckoutGuestParams) -> SignalProducer<URLRequest, CheckoutRetryError> {
    
    return AppEnvironment.current.apiService
        .checkoutHotelCustomer(url: checkoutURI,
        params: customer
        ).mapError { _ in CheckoutRetryError() }.flatMap { env -> SignalProducer<URLRequest, CheckoutRetryError> in
            
            let paymentURI = env.nextPaymentUrl
            
            guard let url = URL(string: paymentURI) else { return .empty }
            
            let request = URLRequest(url: url)
            return SignalProducer(value: request)
    }
}
 */


