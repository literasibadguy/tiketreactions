//
//  CheckOrderFormViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 29/06/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol CheckOrderFormViewModelInputs {
    func configureWith(_ orderId: String, email: String)
    func orderIdTextFieldReturn()
    func orderIdTextFieldChange(_ order: String)
    func emailTextFieldReturn()
    func emailTextFieldChange(_ email: String)
    func checkOrderButtonTapped()
    func viewDidLoad()
}

public protocol CheckOrderFormViewModelOutputs {
    var orderIdTextFieldBecomeFirstResponder: Signal<(), NoError> { get }
    var orderIdText: Signal<String, NoError> { get }
    var emailText: Signal<String, NoError> { get }
    var isCheckOrderEnabled: Signal<Bool, NoError> { get }
    var orderIssueIsLoading: Signal<Bool, NoError> { get }
    var loadingOverlayIsHidden: Signal<Bool, NoError> { get }
    var goToCheckOrder: Signal<HistoryOrderResult, NoError> { get }
    var showError: Signal<String, NoError> { get }
}

public protocol CheckOrderFormViewModelType {
    var inputs: CheckOrderFormViewModelInputs { get }
    var outputs: CheckOrderFormViewModelOutputs { get }
}

public final class CheckOrderFormViewModel: CheckOrderFormViewModelType, CheckOrderFormViewModelInputs, CheckOrderFormViewModelOutputs {
    
    public init() {
        let current = Signal.combineLatest(self.configDataProperty.signal.skipNil(), self.viewDidLoadProperty.signal).map(first)
        
        let orderId = Signal.merge(self.orderTextChangedProperty.signal, current.map { $0.0 })
        let email = Signal.merge(self.emailTextChangedProperty.signal, current.map { $0.1 })
        
        self.orderIdTextFieldBecomeFirstResponder = self.viewDidLoadProperty.signal
        
        self.orderIdText = current.signal.map { $0.0 }
        self.emailText = current.signal.map { $0.1 }
        
        let attemptCheck = Signal.merge(self.checkOrderPropertyTapped.signal, self.emailFieldReturnProperty.signal)
        
        let checkOrderLoading = MutableProperty(false)
        self.orderIssueIsLoading = checkOrderLoading.signal
        let checkOrderEvent = Signal.combineLatest(orderId, email).takeWhen(attemptCheck).switchMap {
            AppEnvironment.current.apiService.checkHistoryOrder($0.0, email: $0.1).on(started: { checkOrderLoading.value = true }, terminated: { checkOrderLoading.value = false }).materialize()
        }
        
        self.loadingOverlayIsHidden = Signal.merge(self.viewDidLoadProperty.signal.mapConst(true), checkOrderLoading.signal.negate())
        
        let checkOrderError = checkOrderEvent.errors().map { _ in "Tidak Ada Issued Pesanan Ini" }
        
        self.goToCheckOrder = checkOrderEvent.values().map { $0.result }
        
        self.isCheckOrderEnabled = Signal.combineLatest(orderId, email).map { !$0.0.isEmpty && !$0.1.isEmpty }.skipRepeats()
        
        self.showError = checkOrderError
    }
    
    
    fileprivate let configDataProperty = MutableProperty<(String, String)?>(nil)
    public func configureWith(_ orderId: String, email: String) {
        self.configDataProperty.value = (orderId, email)
    }
    
    fileprivate let orderFieldReturnProperty = MutableProperty(())
    public func orderIdTextFieldReturn() {
        self.orderFieldReturnProperty.value = ()
    }
    
    fileprivate let orderTextChangedProperty = MutableProperty("")
    public func orderIdTextFieldChange(_ order: String) {
        self.orderTextChangedProperty.value = order
    }
    
    fileprivate let emailFieldReturnProperty = MutableProperty(())
    public func emailTextFieldReturn() {
        self.emailFieldReturnProperty.value = ()
    }
    
    fileprivate let emailTextChangedProperty = MutableProperty("")
    public func emailTextFieldChange(_ email: String) {
        self.emailTextChangedProperty.value = email
    }
    
    fileprivate let checkOrderPropertyTapped = MutableProperty(())
    public func checkOrderButtonTapped() {
        self.checkOrderPropertyTapped.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let orderIdTextFieldBecomeFirstResponder: Signal<(), NoError>
    public let orderIdText: Signal<String, NoError>
    public let emailText: Signal<String, NoError>
    public let isCheckOrderEnabled: Signal<Bool, NoError>
    public let orderIssueIsLoading: Signal<Bool, NoError>
    public let loadingOverlayIsHidden: Signal<Bool, NoError>
    public let goToCheckOrder: Signal<HistoryOrderResult, NoError>
    public let showError: Signal<String, NoError>
    
    public var inputs: CheckOrderFormViewModelInputs { return self }
    public var outputs: CheckOrderFormViewModelOutputs { return self }
}
