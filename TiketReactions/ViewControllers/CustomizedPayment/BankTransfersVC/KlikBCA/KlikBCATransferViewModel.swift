//
//  KlikBCATransferViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 22/10/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol KlikBCATransferViewModelInputs {
    func configureWith(klikBCAId: String)
    func confirmDoneButtonTapped()
    func klikBCADone(_ confirm: Bool)
    func viewDidLoad()
}

public protocol KlikBCATransferViewModelOutputs {
    var orderIdText: Signal<String, NoError> { get }
    var totalPriceText: Signal<String, NoError> { get }
    var messageText: Signal<String, NoError> { get }
    var stepsText: Signal<[String], NoError> { get }
    var klikBCALoading: Signal<Bool, NoError> { get }
    var klikBCAErrors: Signal<String, NoError> { get }
    var doneConfirm: Signal<(), NoError> { get }
    var klikBCADone: Signal<(), NoError> { get }
}

public protocol KlikBCATransferViewModelType {
    var inputs: KlikBCATransferViewModelInputs { get }
    var outputs: KlikBCATransferViewModelOutputs { get }
}

public final class KlikBCATransferViewModel: KlikBCATransferViewModelType, KlikBCATransferViewModelInputs, KlikBCATransferViewModelOutputs {
    
    public init() {
        let current = Signal.combineLatest(self.configKlikBCAIDProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        let defaultText = current.signal.mapConst("")
        
        let isLoading = MutableProperty(false)
        let klikBCAEvent = current.switchMap { klikBCAAccount in
            AppEnvironment.current.apiService.klikBCARequest(klikBCAAccount).ck_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler).on(started: { isLoading.value = true }, terminated: { isLoading.value = false }).materialize()
        }
        
        self.klikBCALoading = isLoading.signal
        
        self.orderIdText = Signal.merge(defaultText, klikBCAEvent.values().map { "Order ID: \($0.orderId)" })
        self.totalPriceText = Signal.merge(defaultText, klikBCAEvent.values().map { "\(Format.symbolForCurrency(AppEnvironment.current.apiService.currency)) \(Format.currency($0.grandTotal, country: AppEnvironment.current.apiService.currency ))" })
        self.messageText = Signal.merge(defaultText, klikBCAEvent.values().map { $0.message })
        self.stepsText = klikBCAEvent.values().map { $0.steps }
        
        self.doneConfirm = self.doneButtonTappedProperty.signal
        
        self.klikBCAErrors = klikBCAEvent.errors().map { _ in Localizations.KlikbcaNoticeerror }
        self.klikBCADone = self.klikBCAConfirmedProperty.signal.filter(isTrue).ignoreValues()
    }
    
    fileprivate let configKlikBCAIDProperty = MutableProperty<String?>(nil)
    public func configureWith(klikBCAId: String) {
        self.configKlikBCAIDProperty.value = klikBCAId
    }
    
    fileprivate let doneButtonTappedProperty = MutableProperty(())
    public func confirmDoneButtonTapped() {
        self.doneButtonTappedProperty.value = ()
    }
    
    fileprivate let klikBCAConfirmedProperty = MutableProperty(false)
    public func klikBCADone(_ confirm: Bool) {
        self.klikBCAConfirmedProperty.value = confirm
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let orderIdText: Signal<String, NoError>
    public let totalPriceText: Signal<String, NoError>
    public let messageText: Signal<String, NoError>
    public let stepsText: Signal<[String], NoError>
    public let klikBCALoading: Signal<Bool, NoError>
    public let klikBCAErrors: Signal<String, NoError>
    public let doneConfirm: Signal<(), NoError>
    public let klikBCADone: Signal<(), NoError>
    
    public var inputs: KlikBCATransferViewModelInputs { return self }
    public var outputs: KlikBCATransferViewModelOutputs { return self }
}
