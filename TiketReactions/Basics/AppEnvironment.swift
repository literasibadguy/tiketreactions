//
//  AppEnvironment.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 27/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Argo
import Foundation
import Prelude
import ReactiveSwift
import Result

public struct AppEnvironment {
    internal static let environmentStorageKey = "firasrafislam.TiketReactions.AppEnvironment.current"
    // GET TOKEN KEY ENVIRONMENT STORAGE KEY
    
    fileprivate static var stack: [Environment] = [Environment()]
    
    public static func getToken(_ envelope: GetTokenEnvelope) {
        replaceCurrentEnvironment(apiService: current.apiService.getToken(TiketToken(token: envelope.token)))
    }
    
    public static func getFirstToken(_ token: String) {
        replaceCurrentEnvironment(apiService: current.apiService.getToken(TiketToken(token: token)))
    }
    
    public static func replaceCurrency(_ currency: String) {
        replaceCurrentEnvironment(apiService: current.apiService.selectedCurrency(currency))
    }
    
    public static var current: Environment! {
        return stack.last
    }
    
    public static func pushEnvironment(_ env: Environment) {
        saveEnvironment(environment: env, ubiquitousStore: env.ubiquitousStore, userDefaults: env.userDefaults)
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
    
    public static func pushEnvironment(
        apiService: TiketServiceType = AppEnvironment.current.apiService,
        apiDelayInterval: DispatchTimeInterval = AppEnvironment.current.apiDelayInterval, calendar: Calendar = AppEnvironment.current.calendar, cookieStorage: HTTPCookieStorageProtocol = AppEnvironment.current.cookieStorage, countryCode: String = AppEnvironment.current.countryCode, dateType: DateProtocol.Type = AppEnvironment.current.dateType, debounceInterval: DispatchTimeInterval = AppEnvironment.current.debounceInterval, device: UIDeviceType = AppEnvironment.current.device, isVoiceOverRunning: @escaping (() -> Bool) = AppEnvironment.current.isVoiceOverRunning, language: Language = AppEnvironment.current.language, locale: Locale = AppEnvironment.current.locale, mainBundle: NSBundleType = AppEnvironment.current.mainBundle, reachability: SignalProducer<Reachability, NoError> = AppEnvironment.current.reachability, scheduler: DateScheduler = AppEnvironment.current.scheduler, ubiquitousStore: KeyValueStoreType = AppEnvironment.current.ubiquitousStore, userDefaults: KeyValueStoreType = AppEnvironment.current.userDefaults) {
        pushEnvironment(Environment(
            apiService: apiService,
            apiDelayInterval: apiDelayInterval,
            calendar: calendar,
            cookieStorage: cookieStorage,
            countryCode: countryCode,
            dateType: dateType,
            debounceInterval: debounceInterval,
            device: device,
            isVoiceOverRunning: isVoiceOverRunning,
            language: language,
            locale: locale,
            mainBundle: mainBundle,
            reachability: reachability,
            ubiquitousStore: ubiquitousStore,
            userDefaults: userDefaults))
    }
    
    public static func replaceCurrentEnvironment(
        apiService: TiketServiceType = AppEnvironment.current.apiService,
        apiDelayInterval: DispatchTimeInterval = AppEnvironment.current.apiDelayInterval, calendar: Calendar = AppEnvironment.current.calendar, cookieStorage: HTTPCookieStorageProtocol = AppEnvironment.current.cookieStorage, countryCode: String = AppEnvironment.current.countryCode, dateType: DateProtocol.Type = AppEnvironment.current.dateType, debounceInterval: DispatchTimeInterval = AppEnvironment.current.debounceInterval, device: UIDeviceType = AppEnvironment.current.device, isVoiceOverRunning: @escaping (() -> Bool) = AppEnvironment.current.isVoiceOverRunning, language: Language = AppEnvironment.current.language, locale: Locale = AppEnvironment.current.locale, mainBundle: NSBundleType = AppEnvironment.current.mainBundle, reachability: SignalProducer<Reachability, NoError> = AppEnvironment.current.reachability, scheduler: DateScheduler = AppEnvironment.current.scheduler, ubiquitousStore: KeyValueStoreType = AppEnvironment.current.ubiquitousStore, userDefaults: KeyValueStoreType = AppEnvironment.current.userDefaults) {
        replaceCurrentEnvironment(Environment(
            apiService: apiService,
            apiDelayInterval: apiDelayInterval,
            calendar: calendar,
            cookieStorage: cookieStorage,
            countryCode: countryCode,
            dateType: dateType,
            debounceInterval: debounceInterval,
            device: device,
            isVoiceOverRunning: isVoiceOverRunning,
            language: language,
            locale: locale,
            mainBundle: mainBundle,
            reachability: reachability,
            ubiquitousStore: ubiquitousStore,
            userDefaults: userDefaults))
    }
    
    public static func fromStorage(ubiquitousStore: KeyValueStoreType, userDefaults: KeyValueStoreType) -> Environment {
        
        let data = userDefaults.dictionary(forKey: environmentStorageKey) ?? [:]
        var service = current.apiService
        
        let config: Config? = data["config"].flatMap(decode)
        
        if let tiketToken = data["apiService.tiketToken.token"] as? String {
            service = service.getToken(TiketToken(token: tiketToken))
            removeLegacyTiketToken(fromUserDefaults: userDefaults)
        } else if let tiketToken = legacyTiketToken(forUserDefaults: userDefaults) {
            service = service.getToken(TiketToken(token: tiketToken))
            removeLegacyTiketToken(fromUserDefaults: userDefaults)
        }

        if let clientId = data["apiService.serverConfig.apiClientAuth.clientId"] as? String {
            service = TiketServices(serverConfig: TiketServerConfig(apiBaseUrl: service.serverConfig.apiBaseUrl, webBaseUrl: service.serverConfig.webBaseUrl, apiClientAuth: ClientAuth(clientId: clientId)), language: current.language.rawValue)
        }
        
        // Try restoring the base urls for the api service
        if let apiBaseUrlString = data["apiService.serverConfig.apiBaseUrl"] as? String, let apiBaseUrl = URL(string: apiBaseUrlString), let webBaseUrlString = data["apiService.serverConfig.webBaseUrl"] as? String, let webBaseUrl = URL(string: webBaseUrlString) {
            
            service = TiketServices(serverConfig: TiketServerConfig(apiBaseUrl: apiBaseUrl, webBaseUrl: webBaseUrl, apiClientAuth: service.serverConfig.apiClientAuth), language: current.language.rawValue)
            print("RESTORING THE BASE URL: \(type(of: apiBaseUrl))")
        }

        return Environment(apiService: service, config: config)
    }
    
    // Saves some key data for the current environment
    internal static func saveEnvironment(environment env: Environment = AppEnvironment.current, ubiquitousStore: KeyValueStoreType, userDefaults: KeyValueStoreType) {
        var data: [String: Any] = [:]
        
        data["apiService.tiketToken.token"] = env.apiService.tiketToken?.token
        data["apiService.serverConfig.apiBaseUrl"] = env.apiService.serverConfig.apiBaseUrl.absoluteString
        data["apiService.serverConfig.apiClientAuth.clientId"] = env.apiService.serverConfig.apiClientAuth.clientId
        data["config"] = env.config?.encode()
        
        userDefaults.set(data, forKey: environmentStorageKey)
    }
}

private func legacyTiketToken(forUserDefaults userDefaults: KeyValueStoreType) -> String? {
    return userDefaults.object(forKey: "firasrafislam.TiketReactions.tiket_token") as? String
}

private func removeLegacyTiketToken(fromUserDefaults userDefaults: KeyValueStoreType) {
    userDefaults.removeObject(forKey: "firasrafislam.TiketReactions.tiket_token")
}

