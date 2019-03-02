//
//  AppDelegateViewModel.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 09/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import Result
import UserNotifications
import TiketKitModels

public protocol AppDelegateViewModelInputs {
    
    func applicationDidFinishLaunching(application: UIApplication?, launchOptions: [AnyHashable: Any]?)
    func applicationWillEnterForeground()
    func applicationPerformActionForShortcutItem(_ item: UIApplicationShortcutItem)
}

public protocol AppDelegateViewModelOutputs {
    var applicationDidFinishLaunchingReturnValue: Bool { get }
    
    var tokenIntoEnvironment: Signal<String, NoError> { get }
    var goToFlight: Signal<(), NoError> { get }
    var goToHotel: Signal<(), NoError> { get }
    var goToOrder: Signal<(), NoError> { get }
    var goToAbout: Signal<(), NoError> { get }
    
    var presentViewController: Signal<UIViewController, NoError> { get }
    
    var synchronizeUbiquitousStore: Signal<(), NoError> { get }
}

public protocol AppDelegateViewModelType {
    var inputs: AppDelegateViewModelInputs { get }
    var outputs: AppDelegateViewModelOutputs { get }
}

public final class AppDelegateViewModel: AppDelegateViewModelType, AppDelegateViewModelInputs, AppDelegateViewModelOutputs {
    
    public init() {
//        self.applicationDidFinishLaunchingReturnValue = true
        
        let current = Signal.merge(self.appEnterForegroundProperty.signal, self.applicationLaunchOptionsProperty.signal.ignoreValues())
        let clientAuth = ClientAuth(clientId: Secrets.Api.Client.staging)
        
        let tokenEnvelope = self.applicationLaunchOptionsProperty.signal.ignoreValues().filter { _ in !isTokenStored() }.switchMap { _ in
            AppEnvironment.current.apiService.getTokenEnvelope(clientAuth: clientAuth).materialize()
        }
        let tokenFromStorage = current.signal.map { _ in AppEnvironment.current.userDefaults.object(forKey: AppKeys.tokenSavedActivity.rawValue) as? String }
        self.tokenIntoEnvironment = Signal.merge(tokenEnvelope.values().map { $0.token }.on(value: { saveTokenStored($0) }), tokenFromStorage.skipNil())
        
        self.goToFlight = .empty
        self.goToHotel = .empty
        self.goToOrder = .empty
        self.goToAbout = .empty
        self.presentViewController = .empty
        
        self.synchronizeUbiquitousStore = .empty
        
        self.applicationDidFinishLaunchingReturnValueProperty <~ self.applicationLaunchOptionsProperty.signal.skipNil().map { _ , options in
            options?[UIApplicationLaunchOptionsKey.shortcutItem] == nil
        }
    }
    
    fileprivate typealias ApplicationWithOptions = (application: UIApplication?, options: [AnyHashable: Any]?)
    fileprivate let applicationLaunchOptionsProperty = MutableProperty<ApplicationWithOptions?>(nil)
    public func applicationDidFinishLaunching(application: UIApplication?, launchOptions: [AnyHashable : Any]?) {
        self.applicationLaunchOptionsProperty.value = (application, launchOptions)
    }
    
    fileprivate let appEnterForegroundProperty = MutableProperty(())
    public func applicationWillEnterForeground() {
        self.appEnterForegroundProperty.value = ()
    }
    
    fileprivate let performActionForShortcutItemProperty = MutableProperty<UIApplicationShortcutItem?>(nil)
    public func applicationPerformActionForShortcutItem(_ item: UIApplicationShortcutItem) {
        self.performActionForShortcutItemProperty.value = item
    }
    
    public let tokenIntoEnvironment: Signal<String, NoError>
    public let goToFlight: Signal<(), NoError>
    public let goToHotel: Signal<(), NoError>
    public let goToOrder: Signal<(), NoError>
    public let goToAbout: Signal<(), NoError>
    public let presentViewController: Signal<UIViewController, NoError>
    public let synchronizeUbiquitousStore: Signal<(), NoError>
    
    fileprivate let applicationDidFinishLaunchingReturnValueProperty = MutableProperty(true)
    public var applicationDidFinishLaunchingReturnValue: Bool {
        return applicationDidFinishLaunchingReturnValueProperty.value
    }
    
    public var inputs: AppDelegateViewModelInputs { return self }
    public var outputs: AppDelegateViewModelOutputs { return self }
    
}

private func isTokenStored() -> Bool {
    return AppEnvironment.current.userDefaults.object(forKey: AppKeys.tokenSavedActivity.rawValue) != nil
}

private func saveTokenStored(_ token: String) {
    AppEnvironment.current.userDefaults.set(token, forKey: AppKeys.tokenSavedActivity.rawValue)
}

