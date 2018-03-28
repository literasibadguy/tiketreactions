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
import TiketAPIs
import UserNotifications

public protocol AppDelegateViewModelInputs {
    func applicationDidFinishLaunching(application: UIApplication?, launchOptions: [AnyHashable: Any]?)
}

public protocol AppDelegateViewModelOutputs {
    var applicationDidFinishLaunchingReturnValue: Bool { get }
    
    var tokenIntoEnvironment: Signal<GetTokenEnvelope, NoError> { get }
    
    var goToFlight: Signal<(), NoError> { get }
    var goToHotel: Signal<SearchHotelParams?, NoError> { get }
    var goToOrder: Signal<(), NoError> { get }
    var goToAbout: Signal<(), NoError> { get }
    
    var presentViewController: Signal<UIViewController, NoError> { get }
}

public protocol AppDelegateViewModelType {
    var inputs: AppDelegateViewModelInputs { get }
    var outputs: AppDelegateViewModelOutputs { get }
}

public final class AppDelegateViewModel: AppDelegateViewModelType, AppDelegateViewModelInputs, AppDelegateViewModelOutputs {
    
    public init() {
//        self.applicationDidFinishLaunchingReturnValue = true
        
        let clientAuth = ClientAuth(clientId: Secrets.Api.Client.production)
        
        self.tokenIntoEnvironment = self.applicationLaunchOptionsProperty.signal.skipNil().switchMap { _ in
            AppEnvironment.current.apiService.getTokenEnvelope(clientAuth: clientAuth).demoteErrors()
        }
        print("SOMETHING INTO TOKEN INTO ENVIRONMENT: \(self.tokenIntoEnvironment)")
        
        self.goToFlight = .empty
        self.goToHotel = .empty
        self.goToOrder = .empty
        self.goToAbout = .empty
        self.presentViewController = .empty
        
        self.applicationDidFinishLaunchingReturnValueProperty <~ self.applicationLaunchOptionsProperty.signal.skipNil().map { _ , options in
            options?[UIApplicationLaunchOptionsKey.shortcutItem] == nil
        }
    }
    
    fileprivate typealias ApplicationWithOptions = (application: UIApplication?, options: [AnyHashable: Any]?)
    fileprivate let applicationLaunchOptionsProperty = MutableProperty<ApplicationWithOptions?>(nil)
    public func applicationDidFinishLaunching(application: UIApplication?, launchOptions: [AnyHashable : Any]?) {
        self.applicationLaunchOptionsProperty.value = (application, launchOptions)
    }
    
    public let tokenIntoEnvironment: Signal<GetTokenEnvelope, NoError>
    public let goToFlight: Signal<(), NoError>
    public let goToHotel: Signal<SearchHotelParams?, NoError>
    public let goToOrder: Signal<(), NoError>
    public let goToAbout: Signal<(), NoError>
    public let presentViewController: Signal<UIViewController, NoError>
    
    fileprivate let applicationDidFinishLaunchingReturnValueProperty = MutableProperty(true)
    public var applicationDidFinishLaunchingReturnValue: Bool {
        return applicationDidFinishLaunchingReturnValueProperty.value
    }
    
    public var inputs: AppDelegateViewModelInputs { return self }
    public var outputs: AppDelegateViewModelOutputs { return self }
    
}
