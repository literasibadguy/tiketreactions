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
    var banks: Signal<BankTransferPaymentEnvelope, NoError> { get }
    var banksAreAnimating: Signal<Bool, NoError> { get }
}

public protocol BankTransfersViewModelType {
    var inputs: BankTransfersViewModelInputs { get }
    var outputs: BankTransfersViewModelOutputs { get }
}

public final class BankTransfersViewModel: BankTransfersViewModelType, BankTransfersViewModelInputs, BankTransfersViewModelOutputs {
    
    public init() {
        let banksAreLoading = MutableProperty(false)
        let bankTransferEvent = self.viewDidLoadProperty.signal.switchMap { _ in
            AppEnvironment.current.apiService.bankTransferRequest(currency: AppEnvironment.current.apiService.currency, token: AppEnvironment.current.apiService.tiketToken?.token ?? "").on(started: { banksAreLoading.value = true }, terminated: { banksAreLoading.value = false }).materialize()
        }
        
        self.banks = bankTransferEvent.values()
        self.banksAreAnimating = banksAreLoading.signal
    }
    
    fileprivate let configBanksProperty = MutableProperty<[BankTransferPaymentEnvelope.Bank]?>(nil)
    public func configureWith(_ banks: [BankTransferPaymentEnvelope.Bank]) {
        self.configBanksProperty.value = banks
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let banks: Signal<BankTransferPaymentEnvelope, NoError>
    public let banksAreAnimating: Signal<Bool, NoError>
    
    public var inputs: BankTransfersViewModelInputs { return self }
    public var outputs: BankTransfersViewModelOutputs { return self }
}
