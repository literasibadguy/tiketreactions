//
//  Environment.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 27/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Foundation
import ReactiveSwift
import Result

public struct Environment {
    
    public let apiService: TiketServiceType
    
    public let apiDelayInterval: DispatchTimeInterval
    
    public let calendar: Calendar
    
    public let config: Config?
    
    public let cookieStorage: HTTPCookieStorageProtocol
    
    public let countryCode: String
    
    public let dateType: DateProtocol.Type
    
    public let debounceInterval: DispatchTimeInterval
    
    public let device: UIDeviceType
    
    public let isVoiceOverRunning: () -> Bool
    
    public let language: Language
    
    public let locale: Locale
    
    public let mainBundle: NSBundleType
    
    public let reachability: SignalProducer<Reachability, NoError>
    
    // Date Scheduler from ReactiveSwift should initialized
    public let scheduler: DateScheduler
    
    public let ubiquitousStore: KeyValueStoreType
    
    public let userDefaults: KeyValueStoreType
    
    init(
        apiService: TiketServiceType = TiketServices(),
        apiDelayInterval: DispatchTimeInterval = .seconds(0),
         calendar: Calendar = .current,
         config: Config? = nil,
         cookieStorage: HTTPCookieStorageProtocol = HTTPCookieStorage.shared,
         countryCode: String = "ID",
         dateType: DateProtocol.Type = Date.self,
         debounceInterval: DispatchTimeInterval = .milliseconds(300),
         device: UIDeviceType = UIDevice.current,
         isVoiceOverRunning: @escaping () -> Bool = UIAccessibilityIsVoiceOverRunning,
         language: Language = Language(languageStrings: Locale.preferredLanguages) ?? Language.id,
         locale: Locale = .current,
         mainBundle: NSBundleType = Bundle.main,
         reachability: SignalProducer<Reachability, NoError> = Reachability.signalProducer,
         scheduler: DateScheduler = QueueScheduler.main,
         ubiquitousStore: KeyValueStoreType = NSUbiquitousKeyValueStore.default,
         userDefaults: KeyValueStoreType = UserDefaults.standard) {
        
        self.apiService = apiService
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
        self.scheduler = scheduler
        self.ubiquitousStore = ubiquitousStore
        self.userDefaults = userDefaults
    }
}
