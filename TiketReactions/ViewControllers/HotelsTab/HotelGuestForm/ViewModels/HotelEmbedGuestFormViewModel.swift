//
//  HotelEmbedGuestFormViewModel.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 15/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import RealmSwift
import ReactiveSwift
import Result
import TiketKitModels

public struct CheckoutRetryError: Error {}

public protocol HotelEmbedGuestFormViewModelInputs {
    func configureWith(hotelDirect: HotelDirect, availableRoom: AvailableRoom, booking: HotelBookingSummary)
    func isFormFilled(_ valid: Bool)
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
}

public protocol HotelEmbedGuestFormViewModelType {
    var inputs: HotelEmbedGuestFormViewModelInputs { get }
    var outputs: HotelEmbedGuestFormViewModelOutputs { get }
}

public final class HotelEmbedGuestFormViewModel: HotelEmbedGuestFormViewModelType, HotelEmbedGuestFormViewModelInputs, HotelEmbedGuestFormViewModelOutputs {
    
    init() {
        let hotelPrepare = Signal.combineLatest(self.configDataProperty.signal.skipNil(), self.viewDidLoadProperty.signal.skipRepeats(==)).map(first)
        
        hotelPrepare.observe(on: UIScheduler()).observeValues { _ in
            print("Preparing Any Final Data Information")
        }
            
        
        self.bookURI = hotelPrepare.map(second).map { $0.bookURI }
        
        // STEPS BY STEP
        
        self.configureEmbedVCWithHotelAndRoom = Signal.combineLatest(self.configDataProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        self.configureGuestFormParam = .empty
        self.completeForm = .empty
        
        self.notifyEnabled = self.formFilledProperty.signal.skipNil()
        
        let isLoading = MutableProperty(false)
        
        self.remindAlert = self.bookButtonTappedProperty.signal.map { _ in Localizations.ConfirmdataTitle }
        
        let addOrderEnvelope = hotelPrepare.map(second).takeWhen(self.remindCheckoutProperty.signal.filter { isTrue($0) }).switchMap { package in
            AppEnvironment.current.apiService.addOrder(url: package.bookURI).ck_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler).on(started: { isLoading.value = true }, completed: { isLoading.value = true },  terminated: { isLoading.value = false }).materialize()
        }
        
        /*
        let addOrderEnvelope = Signal.combineLatest(hotelPrepare.map(second), self.remindCheckoutProperty.signal.skipNil().filter(isTrue).ignoreValues())
            .map(first).signal.promoteError(CheckoutRetryError.self).switchMap {
            package in SignalProducer<(), CheckoutRetryError>(value: ()).ck_delay(.seconds(1), on: AppEnvironment.current.scheduler).flatMap {_ in
                AppEnvironment.current.apiService.addOrder(url: package.bookURI).on(starting: { isLoading.value = true }, completed: { isLoading.value = true },  terminated: { isLoading.value = false }).flatMapError { _ in
                    return SignalProducer(error: CheckoutRetryError())
                    }.flatMap { envelope -> SignalProducer<AddOrderEnvelope, CheckoutRetryError> in
                        
                        switch envelope.diagnostic.status {
                        case .failed, .error, .timeout:
                            return SignalProducer(error: CheckoutRetryError())
                        case .successful:
                            return SignalProducer(value: envelope)
                        case .empty: break
                            
                        }
                        
                        return SignalProducer(value: envelope)
                }.retry(upTo: 2)
            }
        }.materialize()
        */
        
        addOrderEnvelope.observe(on: UIScheduler()).observeValues { _ in
            print("I Hope there is no add order envelope automatically without reminder")
        }
        

        let lastOrderEvent = addOrderEnvelope.signal.promoteError(CheckoutRetryError.self).switchMap { _ in SignalProducer<(), CheckoutRetryError>(value: ()).ck_delay(.seconds(1), on: AppEnvironment.current.scheduler).flatMap {
            AppEnvironment.current.apiService.fetchHotelOrder().on(starting: { isLoading.value = true }, completed: { isLoading.value = true }, terminated: { isLoading.value = false }).flatMapError { _ in return SignalProducer(error: CheckoutRetryError()) }
                .flatMap { envelope -> SignalProducer<HotelOrderEnvelope, CheckoutRetryError> in
                
                switch envelope.diagnostic.status {
                    case .failed, .empty, .error, .timeout:
                        return SignalProducer(error: CheckoutRetryError())
                    case .successful:
                        return SignalProducer(value: envelope)
                }
                }.retry(upTo: 2)
            }
        }.materialize()
        
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
        
        self.isOrderCompleted = lastOrderEvent.values()
        
        let loginParams = self.configFormOrderProperty.signal.skipNil().switchMap { params -> SignalProducer<CheckoutLoginParams, NoError> in
            let new = .defaults
                |> CheckoutLoginParams.lens.salutation .~ params.conSalutation
                |> CheckoutLoginParams.lens.firstName .~ params.conFirstName
                |> CheckoutLoginParams.lens.lastName .~ params.conLastName
                |> CheckoutLoginParams.lens.email .~ params.conEmailAddress
                |> CheckoutLoginParams.lens.phone .~ "\(params.conPhone ?? "")"
            
            return SignalProducer(value: new)
        }.materialize()
        
        loginParams.values().observe(on: UIScheduler()).observeValues { loginData in
            print("LOGIN DATA PREPARED: \(loginData)")
        }
        
        let checkoutPageRequestEnvelope = checkoutRequestLink.signal.switchMap { checkout in
                AppEnvironment.current.apiService.checkoutPageRequest(url: checkout ?? "").ck_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler).on(starting: { isLoading.value = true }, completed: { isLoading.value = true },  terminated: { isLoading.value = false }).materialize()
        }
        
        checkoutPageRequestEnvelope.values().observe(on: UIScheduler()).observeValues { envelope in
            print("WHAT STATUS CHECKOUT: \(envelope.diagnostic.status)")
        }
        
        let errorCheckoutPage = Signal.merge(checkoutPageRequestEnvelope.values().filter { $0.diagnostic.status == .error }.ignoreValues(), addOrderEnvelope.values().filter { $0.diagnostic.status == .error }.ignoreValues())
        
        self.dismissAlert = self.errorDismisssProperty.signal.filter { $0 == true }.ignoreValues()
        
        let takeCheckoutCustomer = checkoutPageRequestEnvelope.values().filter { $0.diagnostic.status == .successful }.map { $0.nextCheckoutURI }

        let checkoutLoginEvent = Signal.combineLatest(takeCheckoutCustomer, loginParams.values()).switchMap {
            AppEnvironment.current.apiService.checkoutLogin(url: $0.0, params: $0.1).ck_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler).on(starting: { isLoading.value = true }, completed: { isLoading.value = true }, terminated: { isLoading.value = false }).retry(upTo: 3).materialize()
        }
        
        let falseCheckoutLoginEvent = checkoutLoginEvent.values().filter { $0.loginStatus == "false" }.ignoreValues()
        
        self.isLoginCompleted = checkoutLoginEvent.values()
        
        let finalCheckoutParam = Signal.combineLatest(self.configFormOrderProperty.signal.skipNil(), lastOrderDetailId).switchMap { formOrder, detailId -> SignalProducer<CheckoutGuestParams, NoError> in
            let final = formOrder
                |> CheckoutGuestParams.lens.detailId .~ detailId
                |> CheckoutGuestParams.lens.country .~ "id"
            return SignalProducer(value: final)
        }.materialize()
        
        let checkoutCustomerRequestEnvelope = Signal.combineLatest(checkoutLoginEvent.values().filter { $0.loginStatus == "true" }.ignoreValues(), takeCheckoutCustomer, finalCheckoutParam.values()).switchMap { _, checkout, customer in
                AppEnvironment.current.apiService.checkoutHotelCustomer(url: checkout, params: customer).ck_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler).on(starting: { isLoading.value = true }, completed: { isLoading.value = true },  terminated: { isLoading.value = false }).materialize()
        }
        
        checkoutCustomerRequestEnvelope.values().observe(on: UIScheduler()).observeValues { envelope in
            print("Whats Diangostic Customer Request Envelope: \(envelope)")
        }
        
        let emailPick = checkoutCustomerRequestEnvelope.values().filter { $0.diagnostic.status == .successful }
        let checkoutErrorCustomer = checkoutCustomerRequestEnvelope.values().filter { $0.diagnostic.status != .successful }

        self.errorAlert = Signal.merge(errorCheckoutPage.ignoreValues(), falseCheckoutLoginEvent, checkoutErrorCustomer.ignoreValues(), checkoutCustomerRequestEnvelope.errors().ignoreValues()).map { Localizations.ConfirmerrorTitle }
        self.orderIsLoading = Signal.merge(self.viewDidLoadProperty.signal.mapConst(false), self.remindCheckoutProperty.signal.filter(isTrue), checkoutCustomerRequestEnvelope.values().map { $0.diagnostic.status != .successful })
        self.loadingOverlayIsHidden = Signal.merge(self.viewDidLoadProperty.signal.mapConst(true), self.remindCheckoutProperty.signal.filter(isTrue).map { _ in return false },
                                                   checkoutCustomerRequestEnvelope.values().map { $0.diagnostic.status == .successful })
        
        // Should be Side Effect 'On'
        let decidedOrder = Signal.combineLatest(myOrder, emailPick).on(value: { saveIssuedOrder($0.0.orderId, email: $0.1.loginEmail) }).map(first)
        
        self.goToPayments = decidedOrder.takeWhen(emailPick)
    }
    
    fileprivate let configDataProperty = MutableProperty<(HotelDirect, AvailableRoom, HotelBookingSummary)?>(nil)
    public func configureWith(hotelDirect: HotelDirect, availableRoom: AvailableRoom, booking: HotelBookingSummary) {
        self.configDataProperty.value = (hotelDirect, availableRoom, booking)
    }
    
    fileprivate let formFilledProperty = MutableProperty<Bool?>(nil)
    public func isFormFilled(_ valid: Bool) {
        self.formFilledProperty.value = valid
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
        
        guard let myOrder = env.myOrder?.orderData.last else { return .empty }
        let selectedDetailId = myOrder.orderDetailId
        
        return SignalProducer(value: selectedDetailId)
    }
}

private func getCheckoutLinkRequest() -> SignalProducer<String, CheckoutRetryError> {
    
    return AppEnvironment.current.apiService.fetchHotelOrder().mapError { _ in CheckoutRetryError() }.flatMap { env -> SignalProducer<String, CheckoutRetryError> in
        
        let checkoutLink = env.checkout
        
        return SignalProducer(value: checkoutLink!)
    }
}

private func triggerIssuedEmail(_ email: String) {
    if let index = AppEnvironment.current.userDefaults.emailDetailLogins.index(of: email) {
        print("Trigger Issued Email Detail Logins on Removing")
        AppEnvironment.current.userDefaults.emailDetailLogins.remove(at: index)
    } else {
        print("Appending")
        AppEnvironment.current.userDefaults.emailDetailLogins.append(email)
    }
}

public func saveIssuedOrder(_ orderId: String, email: String) {
    let realm = try! Realm()
    try! realm.write {
        let issue = IssuedOrder()
        issue.orderId = orderId
        issue.email = email
        let issueList = realm.objects(IssuedOrderList.self).first!
        issueList.items.append(issue)
        realm.add(issueList)
        print("Realm Should Write something here \(orderId) \(email)")
    }
    
}
