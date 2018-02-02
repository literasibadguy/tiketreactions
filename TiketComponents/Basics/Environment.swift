//
//  Environment.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 27/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Foundation
import Result
import TiketAPIs

public struct Environment {
    public let apiDelayInterval: DispatchTimeInterval
    
    public let calendar: Calendar
    
    public let config: Config?
    
    public let cookieStorage: HTTPCookieStorage
    
    public let countryCode: String
    
    public let dateType: Date.Type
    
    public let debounceInterval: DispatchTimeInterval
    
    public let device: UIDevice
    
    public let isVoiceOverRunning: () -> Bool
    
    public let language: Language
    
    public let locale: Locale
    
    public let mainBundle: NSBundleType
    
    public let reachability: Reachability
    
    // Date Scheduler from ReactiveSwift should initialized
    
    public let ubiquitousStore: KeyValueStoreType
    
    public let userDefaults: KeyValueStoreType
    
    init(apiDelayInterval: DispatchTimeInterval = .seconds(0),
         calendar: Calendar = .current,
         config: Config? = nil,
         cookieStorage: HTTPCookieStorage = HTTPCookieStorage.shared,
         countryCode: String = "ID",
         dateType: Date.Type = Date.self,
         debounceInterval: DispatchTimeInterval = .milliseconds(300),
         device: UIDevice = UIDevice.current,
         isVoiceOverRunning: @escaping () -> Bool = UIAccessibilityIsVoiceOverRunning,
         language: Language = Language(languageStrings: Locale.preferredLanguages) ?? Language.id,
         locale: Locale = .current,
         mainBundle: NSBundleType = Bundle.main,
         reachability: Reachability = Reachability.current,
         ubiquitousStore: KeyValueStoreType = NSUbiquitousKeyValueStore.default,
         userDefaults: KeyValueStoreType = UserDefaults.standard) {
        
        self.apiDelayInterval = apiDelayInterval
        self.calendar = calendar
        self.config = config
        self.cookieStorage = cookieStorage
        self.countryCode = countryCode
        self.dateType = dateType
        self.debounceInterval = debounceInterval
        self.device = device
        self.isVoiceOverRunning = isVoiceOverRunning
        self.language = language
        self.locale = locale
        self.mainBundle = mainBundle
        self.reachability = reachability
        self.ubiquitousStore = ubiquitousStore
        self.userDefaults = userDefaults
    }
}
