//
//  AppEnvironment.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 27/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude
import ReactiveSwift
import Result

public struct AppEnvironment {
    internal static let environmentStorageKey = "firasrafislam.TiketReactions.AppEnvironment.current"
    // GET TOKEN KEY ENVIRONMENT STORAGE KEY
    
    fileprivate static var stack: [Environment] = [Environment()]
    
    public static var current: Environment! {
        return stack.last
    }
    
    public static func pushEnvironment(_ env: Environment) {
        stack.append(env)
    }
    
    @discardableResult
    public static func popEnvironment() -> Environment? {
        let last = stack.popLast()
        let next = current ?? Environment()
        saveEnvironment(environment: next, ubiquitousStore: next.ubiquitousStore, userDefaults: next.userDefaults)
        return last
    }
    
    public static func replaceCurrentEnvironment(_ env: Environment) {
        pushEnvironment(env)
        stack.remove(at: stack.count - 2)
    }
    
    public static func pushEnvironment(apiDelayInterval: DispatchTimeInterval = AppEnvironment.current.apiDelayInterval, calendar: Calendar = AppEnvironment.current.calendar, cookieStorage: HTTPCookieStorage = AppEnvironment.current.cookieStorage, countryCode: String = AppEnvironment.current.countryCode, dateType: Date.Type = AppEnvironment.current.dateType, debounceInterval: DispatchTimeInterval = AppEnvironment.current.debounceInterval, device: UIDevice = AppEnvironment.current.device, isVoiceOverRunning: @escaping (() -> Bool) = AppEnvironment.current.isVoiceOverRunning, language: Language = AppEnvironment.current.language, locale: Locale = AppEnvironment.current.locale, mainBundle: NSBundleType = AppEnvironment.current.mainBundle, reachability: Reachability = AppEnvironment.current.reachability, ubiquitousStore: KeyValueStoreType = AppEnvironment.current.ubiquitousStore, userDefaults: KeyValueStoreType = AppEnvironment.current.userDefaults) {
        pushEnvironment(Environment(apiDelayInterval: apiDelayInterval, calendar: calendar, cookieStorage: cookieStorage, countryCode: countryCode, dateType: dateType, debounceInterval: debounceInterval, device: device, isVoiceOverRunning: isVoiceOverRunning, language: language, locale: locale, mainBundle: mainBundle, reachability: reachability, ubiquitousStore: ubiquitousStore, userDefaults: userDefaults))
    }
    
    public static func replaceCurrentEnvironment(apiDelayInterval: DispatchTimeInterval = AppEnvironment.current.apiDelayInterval, calendar: Calendar = AppEnvironment.current.calendar, cookieStorage: HTTPCookieStorage = AppEnvironment.current.cookieStorage, countryCode: String = AppEnvironment.current.countryCode, dateType: Date.Type = AppEnvironment.current.dateType, debounceInterval: DispatchTimeInterval = AppEnvironment.current.debounceInterval, device: UIDevice = AppEnvironment.current.device, isVoiceOverRunning: @escaping (() -> Bool) = AppEnvironment.current.isVoiceOverRunning, language: Language = AppEnvironment.current.language, locale: Locale = AppEnvironment.current.locale, mainBundle: NSBundleType = AppEnvironment.current.mainBundle, reachability: Reachability = AppEnvironment.current.reachability, ubiquitousStore: KeyValueStoreType = AppEnvironment.current.ubiquitousStore, userDefaults: KeyValueStoreType = AppEnvironment.current.userDefaults) {
        replaceCurrentEnvironment(Environment(apiDelayInterval: apiDelayInterval, calendar: calendar, cookieStorage: cookieStorage, countryCode: countryCode, dateType: dateType, debounceInterval: debounceInterval, device: device, isVoiceOverRunning: isVoiceOverRunning, language: language, locale: locale, mainBundle: mainBundle, reachability: reachability, ubiquitousStore: ubiquitousStore, userDefaults: userDefaults))
    }
    
    // Saves some key data for the current environment
    internal static func saveEnvironment(environment env: Environment = AppEnvironment.current, ubiquitousStore: KeyValueStoreType, userDefaults: KeyValueStoreType) {
        var data: [String: Any] = [:]
        
        data["config"] = env.config?.encode()
        
        userDefaults.set(data, forKey: environmentStorageKey)
    }
}

