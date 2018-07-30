//
//  PhoneCodeListViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 27/06/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

public protocol PhoneCodeListViewModelInputs {
    func searchBarChanged(_ phrase: String)
    func countryCode(_ tapped: Country)
    func viewDidLoad()
}

public protocol PhoneCodeListViewModelOutputs {
    var countries: Signal<[Country], NoError> { get }
    var selectedCountry: Signal<Country, NoError> { get }
}

public protocol PhoneCodeListViewModelType {
    var inputs: PhoneCodeListViewModelInputs { get }
    var outputs: PhoneCodeListViewModelOutputs { get }
}

public final class PhoneCodeListViewModel: PhoneCodeListViewModelType, PhoneCodeListViewModelInputs, PhoneCodeListViewModelOutputs {
    
    public init() {
        
        let listCountry = self.viewDidLoadProperty.signal.switchMap { countryNamesByCode().materialize() }.values()
        
        let lowerCased = self.searchTextChangedProperty.signal.filter { $0 != "" }.map { $0.lowercased() }
        
        let resultSearch = Signal.combineLatest(listCountry, lowerCased).map { listCountry, lowercase in
            listCountry.filter { country in
                return country.name!.lowercased().contains(lowercase.lowercased())
            }
        }
        
        self.countries = Signal.merge(listCountry, resultSearch)
        
        self.selectedCountry = self.countryTappedProperty.signal.skipNil()
    }
    
    fileprivate let searchTextChangedProperty = MutableProperty("")
    public func searchBarChanged(_ phrase: String) {
        self.searchTextChangedProperty.value = phrase
    }
    
    fileprivate let countryTappedProperty = MutableProperty<Country?>(nil)
    public func countryCode(_ tapped: Country) {
        self.countryTappedProperty.value = tapped
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let countries: Signal<[Country], NoError>
    public let selectedCountry: Signal<Country, NoError>
    
    
    public var inputs: PhoneCodeListViewModelInputs { return self }
    public var outputs: PhoneCodeListViewModelOutputs { return self }
}

public struct Country {
    public let code: String?
    public let name: String?
    public let phoneCode: String?
    
    init(code: String?, name: String?, phoneCode: String?) {
        self.code = code
        self.name = name
        self.phoneCode = phoneCode
    }
}

private func countryNamesByCode() -> SignalProducer<[Country], NoError> {
    var countries = [Country]()
    let frameworkBundle = Bundle(for: RootTabBarVC.self)
    guard let jsonPath = frameworkBundle.path(forResource: "CountryPicker.bundle/Data/countryCodes", ofType: "json"), let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
        return SignalProducer(value: countries)
    }
    
    do {
        if let jsonObjects = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray {
            
            for jsonObject in jsonObjects {
                
                guard let countryObj = jsonObject as? NSDictionary else {
                    return SignalProducer(value: countries)
                }
                
                guard let code = countryObj["code"] as? String, let phoneCode = countryObj["dial_code"] as? String, let name = countryObj["name"] as? String else {
                    return SignalProducer(value: countries)
                }
                
                let country = Country(code: code, name: name, phoneCode: phoneCode)
                countries.append(country)
            }
            
        }
    } catch {
        return SignalProducer(value: countries)
    }
    return SignalProducer(value: countries)
}

