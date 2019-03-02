//
//  NationalityPickViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 28/01/19.
//  Copyright © 2019 Firas Rafislam. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import TiketKitModels

public protocol NationalityPickViewModelInputs {
    func selected(country: CountryListEnvelope.ListCountry)
    func searchBarChanged(_ text: String)
    func cancelButtonTapped()
    func viewDidLoad()
}

public protocol NationalityPickViewModelOutputs {
    var countriesAreLoading: Signal<Bool, NoError> { get }
    var countries: Signal<[CountryListEnvelope.ListCountry], NoError> { get }
    var selectedCountry: Signal<CountryListEnvelope.ListCountry, NoError> { get }
    var dismissList: Signal<(), NoError> { get }
}

public protocol NationalityPickViewModelType {
    var inputs: NationalityPickViewModelInputs { get }
    var outputs: NationalityPickViewModelOutputs { get }
}

public final class NationalityPickViewModel: NationalityPickViewModelType, NationalityPickViewModelInputs, NationalityPickViewModelOutputs {
    
    public init() {
        
        let serviceAreLoading = MutableProperty(false)
        let countryService = self.viewDidLoadProperty.signal.switchMap { _ in
            AppEnvironment.current.apiService.listCountryEnvelope().on(starting: { serviceAreLoading.value = true }, started: { serviceAreLoading.value = true }, interrupted: { serviceAreLoading.value = false }).materialize()
        }

        let countries = countryService.values().map { $0.listCountries }
        
        let lowerCased = self.searchChangedProperty.signal.filter { $0 != "" }.map { $0.lowercased() }
        
        let resultSearch = Signal.combineLatest(countries, lowerCased).map { countries, lowercase in
            countries.filter { country in
                return country.countryName.lowercased().contains(lowercase.lowercased())
            }
        }
        
        self.countriesAreLoading = serviceAreLoading.signal
        self.countries = Signal.merge(countries, resultSearch)
        self.selectedCountry = self.selectedCountryProperty.signal.skipNil()
        self.dismissList = self.cancelButtonTappedProperty.signal
    }
    
    fileprivate let selectedCountryProperty = MutableProperty<CountryListEnvelope.ListCountry?>(nil)
    public func selected(country: CountryListEnvelope.ListCountry) {
        self.selectedCountryProperty.value = country
    }
    
    fileprivate let searchChangedProperty = MutableProperty("")
    public func searchBarChanged(_ text: String) {
        self.searchChangedProperty.value = text
    }
    
    fileprivate let cancelButtonTappedProperty = MutableProperty(())
    public func cancelButtonTapped() {
        self.cancelButtonTappedProperty.value = ()
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let countriesAreLoading: Signal<Bool, NoError>
    public let countries: Signal<[CountryListEnvelope.ListCountry], NoError>
    public let selectedCountry: Signal<CountryListEnvelope.ListCountry, NoError>
    public let dismissList: Signal<(), NoError>
    
    public var inputs: NationalityPickViewModelInputs { return self }
    public var outputs: NationalityPickViewModelOutputs { return self }
}
