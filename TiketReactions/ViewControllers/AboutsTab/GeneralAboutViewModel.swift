//
//  GeneralAboutViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 24/05/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import TiketKitModels

public protocol GeneralAboutViewModelInputs {
    func currencyButtonTapped()
    func contactButtonTapped()
    func currencyHaveChanged(_ currency: CurrencyListEnvelope.Currency)
    func viewDidLoad()
}

public protocol GeneralAboutViewModelOutputs {
    var currencyMainText: Signal<String, NoError> { get }
    var currencySubText: Signal<String, NoError> { get }
    var buildVersionText: Signal<String, NoError> { get }
    var deviceIdText: Signal<String, NoError> { get }
    var goToCurrency: Signal<String, NoError> { get }
    var goToContact: Signal<(), NoError> { get }
}

public protocol GeneralAboutViewModelType {
    var inputs: GeneralAboutViewModelInputs { get }
    var outputs: GeneralAboutViewModelOutputs { get }
}


public final class GeneralAboutViewModel: GeneralAboutViewModelType, GeneralAboutViewModelInputs, GeneralAboutViewModelOutputs {
    
    public init() {
        
        let pleaseCurrency = self.viewDidLoadProperty.signal.map { AppEnvironment.current.apiService.currency }
        
        pleaseCurrency.observe(on: UIScheduler()).observeValues { currency in
            print("CURRENT CURRENCY: \(currency)")
        }
        
        self.currencyMainText = self.viewDidLoadProperty.signal.mapConst("Currency")
        self.currencySubText = Signal.merge(pleaseCurrency.mapConst("IDR - Indonesia Rupiah"), self.currencyChangedProperty.signal.skipNil().map { $0.name })
        
        self.buildVersionText = self.viewDidLoadProperty.signal.map { AppEnvironment.current.mainBundle.version }
        
        self.deviceIdText = self.viewDidLoadProperty.signal.map { AppEnvironment.current.device.identifierForVendor?.description }.skipNil()
        
        
        self.goToCurrency = pleaseCurrency.takeWhen(self.currencyTappedProperty.signal)
        
        self.goToContact = self.contactTappedProperty.signal
    }
    
    fileprivate let currencyTappedProperty = MutableProperty(())
    public func currencyButtonTapped() {
        self.currencyTappedProperty.value = ()
    }
    
    fileprivate let contactTappedProperty = MutableProperty(())
    public func contactButtonTapped() {
        self.contactTappedProperty.value = ()
    }
    
    fileprivate let currencyChangedProperty = MutableProperty<CurrencyListEnvelope.Currency?>(nil)
    public func currencyHaveChanged(_ currency: CurrencyListEnvelope.Currency) {
        self.currencyChangedProperty.value = currency
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let currencyMainText: Signal<String, NoError>
    public let currencySubText: Signal<String, NoError>
    public let buildVersionText: Signal<String, NoError>
    public let deviceIdText: Signal<String, NoError>
    public let goToCurrency: Signal<String, NoError>
    public let goToContact: Signal<(), NoError>
    
    public var inputs: GeneralAboutViewModelInputs { return self }
    public var outputs: GeneralAboutViewModelOutputs { return self }
}
