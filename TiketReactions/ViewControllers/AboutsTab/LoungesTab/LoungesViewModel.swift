//
//  LoungesViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 06/11/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol LoungesViewModelInputs {
    func riwayatBookingRowTapped()
    func currencyRowTapped()
    func currencyHaveChanged(_ currency: CurrencyListEnvelope.Currency)
    func viewDidLoad()
}

public protocol LoungesViewModelOutputs {
    var loadStaticCell: Signal<(), NoError> { get }
    var loadCurrencyCell: Signal<String, NoError> { get }
    var goToCurrencyVC: Signal<String, NoError> { get }
    var goToIssuesVC: Signal<(), NoError> { get }
}

public protocol LoungesViewModelType {
    var inputs: LoungesViewModelInputs { get }
    var outputs: LoungesViewModelOutputs { get }
}

public final class LoungesViewModel: LoungesViewModelType, LoungesViewModelInputs, LoungesViewModelOutputs {
    
    public init() {
        self.loadStaticCell = self.viewDidLoadProperty.signal
        
        let pleaseCurrency = self.viewDidLoadProperty.signal.map { AppEnvironment.current.apiService.currency }
        
        self.loadCurrencyCell = Signal.merge(pleaseCurrency.mapConst("IDR - Indonesia Rupiah"), self.currencyChangedProperty.signal.skipNil().map { $0.name })
        
        self.goToIssuesVC = self.riwayatRowTappedProperty.signal
        self.goToCurrencyVC = pleaseCurrency.takeWhen(self.currencyRowTappedProperty.signal)
    }
    
    fileprivate let configPassengersProperty = MutableProperty<PassengerList?>(nil)
    public func configureWith(_ passengers: PassengerList) {
        self.configPassengersProperty.value = passengers
    }
    
    fileprivate let configIssuesProperty = MutableProperty<IssuedOrderList?>(nil)
    public func configureWith(_ issues: IssuedOrderList) {
        self.configIssuesProperty.value = issues
    }
    
    fileprivate let riwayatRowTappedProperty = MutableProperty(())
    public func riwayatBookingRowTapped() {
        self.riwayatRowTappedProperty.value = ()
    }
    
    fileprivate let currencyRowTappedProperty = MutableProperty(())
    public func currencyRowTapped() {
        self.currencyRowTappedProperty.value = ()
    }
    
    fileprivate let currencyChangedProperty = MutableProperty<CurrencyListEnvelope.Currency?>(nil)
    public func currencyHaveChanged(_ currency: CurrencyListEnvelope.Currency) {
        self.currencyChangedProperty.value = currency
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let loadStaticCell: Signal<(), NoError>
    public let loadCurrencyCell: Signal<String, NoError>
    public let goToIssuesVC: Signal<(), NoError>
    public let goToCurrencyVC: Signal<String, NoError>
    
    public var inputs: LoungesViewModelInputs { return self }
    public var outputs: LoungesViewModelOutputs { return self }
}
