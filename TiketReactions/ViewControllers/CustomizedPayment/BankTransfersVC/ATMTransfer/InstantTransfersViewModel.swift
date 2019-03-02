//
//  InstantTransfersViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 16/10/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol InstantTransfersViewModelInputs {
    func doneButtonItemTapped()
    func prepareToDismiss(_ confirm: Bool)
    func viewDidLoad()
}

public protocol InstantTransfersViewModelOutputs {
    var instantsAreLoading: Signal<Bool, NoError> { get }
    var doneEnabled: Signal<Bool, NoError> { get }
    var confirmOrder: Signal<(), NoError> { get }
    var dismissToIssue: Signal<(), NoError> { get }
    var envelopeInstant: Signal<InstantTransferPaymentEnvelope, NoError> { get }
}

public protocol InstantTransfersViewModelType {
    var inputs: InstantTransfersViewModelInputs { get }
    var outputs: InstantTransfersViewModelOutputs { get }
}

public final class InstantTransfersViewModel: InstantTransfersViewModelType, InstantTransfersViewModelInputs, InstantTransfersViewModelOutputs {
    
    public init() {
        let requestLoading = MutableProperty(false)
        let currentRequest = self.viewDidLoadProperty.signal.switchMap { _ in
            AppEnvironment.current.apiService.atmTransferRequest(currency: AppEnvironment.current.apiService.currency).ck_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler).on(started: { requestLoading.value = true }, terminated: { requestLoading.value = false }).materialize()
        }
        
        self.doneEnabled = requestLoading.signal
        self.confirmOrder = self.doneButtonTappedProperty.signal
        self.dismissToIssue = self.preparedToDismissProperty.signal.filter(isTrue).ignoreValues()
        
        self.instantsAreLoading = requestLoading.signal
        self.envelopeInstant = currentRequest.values()
    }
    
    fileprivate let doneButtonTappedProperty = MutableProperty(())
    public func doneButtonItemTapped() {
        self.doneButtonTappedProperty.value = ()
    }
    
    fileprivate let preparedToDismissProperty = MutableProperty(false)
    public func prepareToDismiss(_ confirm: Bool) {
        self.preparedToDismissProperty.value = confirm
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    
    public let instantsAreLoading: Signal<Bool, NoError>
    public let doneEnabled: Signal<Bool, NoError>
    public let confirmOrder: Signal<(), NoError>
    public let dismissToIssue: Signal<(), NoError>
    public let envelopeInstant: Signal<InstantTransferPaymentEnvelope, NoError>
    
    
    public var inputs: InstantTransfersViewModelInputs { return self }
    public var outputs: InstantTransfersViewModelOutputs { return self }
}

