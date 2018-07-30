//
//  BankTransfersViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 22/06/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol BankTransfersViewModelInputs {
    func viewDidLoad()
}

public protocol BankTransfersViewModelOutputs {
    var banks: Signal<[BankTransferPaymentEnvelope.Bank], NoError> { get }
}

public protocol BankTransfersViewModelType {
    var inputs: BankTransfersViewModelInputs { get }
    var outputs: BankTransfersViewModelOutputs { get }
}

public final class BankTransfersViewModel: BankTransfersViewModelType, BankTransfersViewModelInputs, BankTransfersViewModelOutputs {
    
    public init() {
        let bankTransferEvent = self.viewDidLoadProperty.signal.switchMap { _ in
            AppEnvironment.current.apiService.bankTransferRequest(currency: AppEnvironment.current.apiService.currency, token: AppEnvironment.current.apiService.tiketToken?.token ?? "").materialize()
        }
        
        self.banks = bankTransferEvent.values().map { $0.banks }
    }
    
    fileprivate let configBanksProperty = MutableProperty<[BankTransferPaymentEnvelope.Bank]?>(nil)
    public func configureWith(_ banks: [BankTransferPaymentEnvelope.Bank]) {
        self.configBanksProperty.value = banks
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let banks: Signal<[BankTransferPaymentEnvelope.Bank], NoError>
    
    public var inputs: BankTransfersViewModelInputs { return self }
    public var outputs: BankTransfersViewModelOutputs { return self }
}
