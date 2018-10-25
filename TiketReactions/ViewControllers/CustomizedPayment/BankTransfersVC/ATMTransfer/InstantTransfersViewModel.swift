//
//  InstantTransfersViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 16/10/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import TiketKitModels

public protocol InstantTransfersViewModelInputs {
    func viewDidLoad()
}

public protocol InstantTransfersViewModelOutputs {
    var instantsAreLoading: Signal<Bool, NoError> { get }
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
            AppEnvironment.current.apiService.atmTransferRequest(currency: AppEnvironment.current.apiService.currency, token: "").ck_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler).on(started: { requestLoading.value = true }, terminated: { requestLoading.value = false }).materialize()
        }
        
        self.instantsAreLoading = requestLoading.signal
        self.envelopeInstant = currentRequest.values()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    
    public let instantsAreLoading: Signal<Bool, NoError>
    public let envelopeInstant: Signal<InstantTransferPaymentEnvelope, NoError>
    
    
    public var inputs: InstantTransfersViewModelInputs { return self }
    public var outputs: InstantTransfersViewModelOutputs { return self }
}

