//
//  CurrencyListViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 24/05/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import TiketKitModels

public protocol CurrencyListViewModelInputs {
    func configureWith(_ code: String)
    func selected(currency: CurrencyListEnvelope.Currency)
    func searchBarChanged(_ text: String)
    func cancelButtonTapped()
    func viewDidLoad()
}

public protocol CurrencyListViewModelOutputs {
    var currenciesAreLoading: Signal<Bool, NoError> { get }
    var currencies: Signal<[CurrencyListEnvelope.Currency], NoError> { get }
    var selectedCurrency: Signal<CurrencyListEnvelope.Currency, NoError> { get }
    var dismissList: Signal<(), NoError> { get }
}

public protocol CurrencyListViewModelType {
    var inputs: CurrencyListViewModelInputs { get }
    var outputs: CurrencyListViewModelOutputs { get }
}

public final class CurrencyListViewModel: CurrencyListViewModelType, CurrencyListViewModelInputs, CurrencyListViewModelOutputs {
    
    public init() {
        
        let serviceAreLoading = MutableProperty(false)
        
        let currentService = self.viewDidLoadProperty.signal.switchMap { _ in AppEnvironment.current.apiService.listCurrencyEnvelope().on(starting: { serviceAreLoading.value = true }, started: { serviceAreLoading.value = true }, interrupted: { serviceAreLoading.value = false }).materialize()
        }
        self.currenciesAreLoading = serviceAreLoading.signal
        
        let currencies = currentService.values().map { $0.currencies }
        
        let lowerCased = self.searchBarTextProperty.signal.filter { $0 != "" }.map { $0.lowercased() }
        
        let resultSearch = Signal.combineLatest(currencies, lowerCased).map { currencies, lowercase in
            currencies.filter { currency in
                return currency.name.lowercased().contains(lowercase.lowercased())
            }
        }
        
        self.currencies = Signal.merge(currencies, resultSearch)
        
        self.selectedCurrency = self.selectedCurrencyProperty.signal.skipNil()
        
        self.dismissList = self.cancelTappedProperty.signal
    }
    
    fileprivate let configCodeProperty = MutableProperty<String?>(nil)
    public func configureWith(_ code: String) {
        self.configCodeProperty.value = code
    }
    
    fileprivate let selectedCurrencyProperty = MutableProperty<CurrencyListEnvelope.Currency?>(nil)
    public func selected(currency: CurrencyListEnvelope.Currency) {
        self.selectedCurrencyProperty.value = currency
    }
    
    fileprivate let searchBarTextProperty = MutableProperty("")
    public func searchBarChanged(_ text: String) {
        self.searchBarTextProperty.value = text
    }
    
    fileprivate let cancelTappedProperty = MutableProperty(())
    public func cancelButtonTapped() {
        self.cancelTappedProperty.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let currenciesAreLoading: Signal<Bool, NoError>
    public let currencies: Signal<[CurrencyListEnvelope.Currency], NoError>
    public let selectedCurrency: Signal<CurrencyListEnvelope.Currency, NoError>
    public let dismissList: Signal<(), NoError>
    
    public var inputs: CurrencyListViewModelInputs { return self }
    public var outputs: CurrencyListViewModelOutputs { return self }
}
