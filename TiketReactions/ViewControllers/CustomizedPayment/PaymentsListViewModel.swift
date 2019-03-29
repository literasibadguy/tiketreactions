//
//  PaymentsListViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 13/06/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import RealmSwift
import Result
import TiketKitModels

public protocol PaymentsListViewModelInputs {
    func configureWith(myOrder: MyOrder)
    func configureFlightWith(myOrder: FlightMyOrder)
    func bankTransferTapped()
    func cardCreditTapped()
    func transferATMTapped()
    func klikBCATapped()
    func bcaKlikpayTapped()
    func cimbClicksTapped()
    func epayBriTapped()
    func confirmYourKlikBCA(_ approve: Bool)
    func getYourKlikBCA(_ account: String)
    func viewDidLoad()
}

public protocol PaymentsListViewModelOutputs {
    var orderIdLabelText: Signal<String, NoError> { get }
    var totalPriceLabelText: Signal<String, NoError> { get }
    var availableBankTransfer: Signal<Bool, NoError> { get }
    var goBankTransfer: Signal<(), NoError> { get }
    var goCardCredit: Signal<URLRequest, NoError> { get }
    var goATMTransfer: Signal<(), NoError> { get }
    var alertKlikBCA: Signal<(), NoError> { get }
    var goToKlikBCA: Signal<String, NoError> { get }
    var goBCAKlikpay: Signal<URLRequest, NoError> { get }
    var goCIMBClicks: Signal<URLRequest, NoError> { get }
    var goEpayBRI: Signal<URLRequest, NoError> { get }
}

public protocol PaymentsListViewModelType {
    var inputs: PaymentsListViewModelInputs { get }
    var outputs: PaymentsListViewModelOutputs { get }
}

public final class PaymentsListViewModel: PaymentsListViewModelType, PaymentsListViewModelInputs, PaymentsListViewModelOutputs {
    
    public init() {
        
        let bookedOrder = Signal.combineLatest(self.configOrderProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        let flightBookedOrder = Signal.combineLatest(self.configFlightOrderProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        self.orderIdLabelText = Signal.merge(bookedOrder.map { "Order ID: \($0.orderId)" }, flightBookedOrder.map { "Order ID: \($0.orderId)" })
        self.totalPriceLabelText = Signal.merge(bookedOrder.map { Localizations.PaytotalTitle("\(Format.symbolForCurrency(AppEnvironment.current.apiService.currency)) \(Format.currency($0.totalWithoutTax, country: "Rp"))") }, flightBookedOrder.map { "Total Bayar: \(Format.symbolForCurrency(AppEnvironment.current.apiService.currency)) \(Format.currency($0.totalWithoutTax, country: AppEnvironment.current.apiService.currency))" })
        
        let bankTransferEvent = self.viewDidLoadProperty.signal.switchMap { _ in
            AppEnvironment.current.apiService.bankTransferRequest().materialize()
        }
        
        let sandboxCreditEvent = self.viewDidLoadProperty.signal.switchMap { _ in
            AppEnvironment.current.apiService.sandboxCreditCard(AppEnvironment.current.apiService.tiketToken?.token ?? "").materialize()
        }
        
        /*
        let klikBCAEvent = self.viewDidLoadProperty.signal.switchMap { _ in
            AppEnvironment.current.apiService.klikBCARequest("firasraf").materialize()
        }
        */
        
        let bcaKlikpayEvent = self.viewDidLoadProperty.signal.switchMap { _ in
            AppEnvironment.current.apiService.bcaKlikpayRequest(AppEnvironment.current.apiService.tiketToken?.token ?? "").materialize()
        }
        
        let cimbClicksEvent = self.viewDidLoadProperty.signal.switchMap { _ in
            AppEnvironment.current.apiService.cimbClicksRequest(AppEnvironment.current.apiService.tiketToken?.token ?? "").materialize()
        }
        
        let epayBRIEvent = self.viewDidLoadProperty.signal.switchMap { _ in
            AppEnvironment.current.apiService.epayBRIRequest(AppEnvironment.current.apiService.tiketToken?.token ?? "").materialize()
        }
        
        self.availableBankTransfer = self.viewDidLoadProperty.signal.mapConst(compareAvailablePayment())
        
        self.goBankTransfer = self.bankTransferTappedProperty.signal
        self.goCardCredit = sandboxCreditEvent.values().takeWhen(self.cardCreditTappedProperty.signal)
        self.goATMTransfer = self.transferATMTappedProperty.signal
        
        self.alertKlikBCA = self.klikBCATappedProperty.signal
        self.goToKlikBCA = self.youtKlikBCATappedProperty.signal.skipNil().takeWhen(self.confirmKlikBCAProperty.signal.filter(isTrue))
        self.goBCAKlikpay = bcaKlikpayEvent.values().takeWhen(self.bcaKlikpayTappedProperty.signal)
        
        self.goCIMBClicks = cimbClicksEvent.values().takeWhen(self.cimbClicksTappedProperty.signal)
        self.goEpayBRI = epayBRIEvent.values().takeWhen(self.epayBriTappedProperty.signal)
    }
    
    fileprivate let configOrderProperty = MutableProperty<MyOrder?>(nil)
    public func configureWith(myOrder: MyOrder) {
        self.configOrderProperty.value = myOrder
    }
    
    fileprivate let configFlightOrderProperty = MutableProperty<FlightMyOrder?>(nil)
    public func configureFlightWith(myOrder: FlightMyOrder) {
        self.configFlightOrderProperty.value = myOrder
    }
    
    fileprivate let bankTransferTappedProperty = MutableProperty(())
    public func bankTransferTapped() {
        self.bankTransferTappedProperty.value = ()
    }
    
    fileprivate let cardCreditTappedProperty = MutableProperty(())
    public func cardCreditTapped() {
        self.cardCreditTappedProperty.value = ()
    }
    
    fileprivate let transferATMTappedProperty = MutableProperty(())
    public func transferATMTapped() {
        self.transferATMTappedProperty.value = ()
    }
    
    fileprivate let klikBCATappedProperty = MutableProperty(())
    public func klikBCATapped() {
        self.klikBCATappedProperty.value = ()
    }
    
    fileprivate let bcaKlikpayTappedProperty = MutableProperty(())
    public func bcaKlikpayTapped() {
        self.bcaKlikpayTappedProperty.value = ()
    }
    
    fileprivate let cimbClicksTappedProperty = MutableProperty(())
    public func cimbClicksTapped() {
        self.cimbClicksTappedProperty.value = ()
    }
    
    fileprivate let epayBriTappedProperty = MutableProperty(())
    public func epayBriTapped() {
        self.epayBriTappedProperty.value = ()
    }
    
    fileprivate let confirmKlikBCAProperty = MutableProperty(false)
    public func confirmYourKlikBCA(_ approve: Bool) {
        self.confirmKlikBCAProperty.value = approve
    }
    
    fileprivate let youtKlikBCATappedProperty = MutableProperty<String?>(nil)
    public func getYourKlikBCA(_ account: String) {
        self.youtKlikBCATappedProperty.value = account
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let orderIdLabelText: Signal<String, NoError>
    public let totalPriceLabelText: Signal<String, NoError>
    public let availableBankTransfer: Signal<Bool, NoError>
    public let goBankTransfer: Signal<(), NoError>
    public let goCardCredit: Signal<URLRequest, NoError>
    public let goATMTransfer: Signal<(), NoError>
    public let alertKlikBCA: Signal<(), NoError>
    public let goToKlikBCA: Signal<String, NoError>
    public let goBCAKlikpay: Signal<URLRequest, NoError>
    public let goCIMBClicks: Signal<URLRequest, NoError>
    public let goEpayBRI: Signal<URLRequest, NoError>
    
    public var inputs: PaymentsListViewModelInputs { return self }
    public var outputs: PaymentsListViewModelOutputs { return self }
}

fileprivate func storeOrderIssue(withOrder id: String) {
    if let index = AppEnvironment.current.userDefaults.orderDetailIds.index(of: id) {
        AppEnvironment.current.userDefaults.orderDetailIds.remove(at: index)
    } else {
            AppEnvironment.current.userDefaults.orderDetailIds.append(id)
    }
}

private func compareAvailablePayment() -> Bool {
    let calendar = Calendar.current
    let now = Date()
    let eight_today = calendar.date(
        bySettingHour: 20,
        minute: 0,
        second: 0,
        of: now)!
    
    let seven_thirty_today = calendar.date(
        bySettingHour: 7,
        minute: 0,
        second: 0,
        of: now)!
    
    return now >= seven_thirty_today &&
        now <= eight_today
}

