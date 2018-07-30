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
    func bankTransferTapped()
    func cardCreditTapped()
    func transferATMTapped()
    func klikBCATapped()
    func bcaKlikpayTapped()
    func cimbClicksTapped()
    func epayBriTapped()
    func viewDidLoad()
}

public protocol PaymentsListViewModelOutputs {
    var orderIdLabelText: Signal<String, NoError> { get }
    var totalPriceLabelText: Signal<String, NoError> { get }
    var goBankTransfer: Signal<(), NoError> { get }
    var goCardCredit: Signal<URLRequest, NoError> { get }
    var goATMTransfer: Signal<URLRequest, NoError> { get }
    var goKlikBCA: Signal<URLRequest, NoError> { get }
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
        
        self.orderIdLabelText = bookedOrder.map { "Order ID: \($0.orderId)" }
        self.totalPriceLabelText = bookedOrder.map { "Total Bayar: \(Format.symbolForCurrency(AppEnvironment.current.apiService.currency)) \(String($0.total))" }
        
        let cardCreditEvent = self.viewDidLoadProperty.signal.switchMap { _ in
            AppEnvironment.current.apiService.createCreditCardRequest(token: AppEnvironment.current.apiService.tiketToken?.token ?? "").materialize()
        }
        
        let sandboxCreditEvent = self.viewDidLoadProperty.signal.switchMap { _ in
            AppEnvironment.current.apiService.sandboxCreditCard(AppEnvironment.current.apiService.tiketToken?.token ?? "").materialize()
        }
        
        cardCreditEvent.values().observe(on: UIScheduler()).observeValues { request in
            print("CARD CREDIT EVENT: \(request.url!)")
        }
        
        let klikBCAEvent = self.viewDidLoadProperty.signal.switchMap { _ in
            AppEnvironment.current.apiService.klikBCARequest("").materialize()
        }
        
        let bcaKlikpayEvent = self.viewDidLoadProperty.signal.switchMap { _ in
            AppEnvironment.current.apiService.bcaKlikpayRequest(AppEnvironment.current.apiService.tiketToken?.token ?? "").materialize()
        }
        
        let cimbClicksEvent = self.viewDidLoadProperty.signal.switchMap { _ in
            AppEnvironment.current.apiService.cimbClicksRequest(AppEnvironment.current.apiService.tiketToken?.token ?? "").materialize()
        }
        
        let epayBRIEvent = self.viewDidLoadProperty.signal.switchMap { _ in
            AppEnvironment.current.apiService.epayBRIRequest(AppEnvironment.current.apiService.tiketToken?.token ?? "").materialize()
        }
        
        self.goBankTransfer = self.bankTransferTappedProperty.signal
        self.goCardCredit = sandboxCreditEvent.values().takeWhen(self.cardCreditTappedProperty.signal)
        self.goATMTransfer = .empty
        self.goKlikBCA = klikBCAEvent.values().takeWhen(self.klikBCATappedProperty.signal)
        self.goBCAKlikpay = bcaKlikpayEvent.values().takeWhen(self.bcaKlikpayTappedProperty.signal)
        self.goCIMBClicks = cimbClicksEvent.values().takeWhen(self.cimbClicksTappedProperty.signal)
        self.goEpayBRI = epayBRIEvent.values().takeWhen(self.epayBriTappedProperty.signal)
    }
    
    fileprivate let configOrderProperty = MutableProperty<MyOrder?>(nil)
    public func configureWith(myOrder: MyOrder) {
        self.configOrderProperty.value = myOrder
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
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let orderIdLabelText: Signal<String, NoError>
    public let totalPriceLabelText: Signal<String, NoError>
    public let goBankTransfer: Signal<(), NoError>
    public let goCardCredit: Signal<URLRequest, NoError>
    public let goATMTransfer: Signal<URLRequest, NoError>
    public let goKlikBCA: Signal<URLRequest, NoError>
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

