//
//  XCTestCase+AppEnvironment.swift
//  TiketComponentsTests
//
//  Created by Firas Rafislam on 07/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import XCTest
@testable import TiketAPIs
@testable import TiketComponents
import Foundation
import ReactiveSwift

extension XCTestCase {
    
    func withEnvironment(_ env: Environment, body: () -> Void) {
        AppEnvironment.pushEnvironment(env)
        body()
        AppEnvironment.popEnvironment()
    }
    
    func withEnvironment(
        apiDelayInterval: DispatchTimeInterval = AppEnvironment.current.apiDelayInterval,
        calendar: Calendar = AppEnvironment.current.calendar,
        config: Config? = AppEnvironment.current.config,
        cookieStorage: HTTPCookieStorageProtocol = AppEnvironment.current.cookieStorage,
        countryCode: String = AppEnvironment.current.countryCode,
        dateType: DateProtocol.Type = AppEnvironment.current.dateType,
        debounceInterval: DispatchTimeInterval = AppEnvironment.current.debounceInterval,
        device: UIDeviceType = AppEnvironment.current.device,
        isVoiceOverRunning: @escaping () -> Bool = AppEnvironment.current.isVoiceOverRunning,
        language: Language = AppEnvironment.current.language,
        locale: Locale = AppEnvironment.current.locale,
        mainBundle: NSBundleType = AppEnvironment.current.mainBundle,
        ubiquitousStore: KeyValueStoreType = AppEnvironment.current.ubiquitousStore,
        userDefaults: KeyValueStoreType = AppEnvironment.current.userDefaults,
        body: () -> Void) {
        withEnvironment(
            Environment(
                apiDelayInterval: apiDelayInterval,
                calendar: calendar,
                config: config,
                cookieStorage: cookieStorage,
                countryCode: countryCode,
                dateType: dateType,
                debounceInterval: debounceInterval,
                device: device,
                isVoiceOverRunning: isVoiceOverRunning,
                language: language,
                locale: locale,
                mainBundle: mainBundle,
                ubiquitousStore: ubiquitousStore,
                userDefaults: userDefaults),
            body: body)
    }
}
