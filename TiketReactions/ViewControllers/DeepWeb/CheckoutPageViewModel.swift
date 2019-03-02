//
//  CheckoutPageViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 12/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import Result
import TiketKitModels
import WebKit

public protocol CheckoutPageViewModelInputs {
    func cancelButtonTapped()
    func configureWith(initialRequest: URLRequest)
    func failureAlertButtonTapped()
    func webViewConfirm(_ isLoading: Bool)
    func paymentIsFailedOrCompleted(_ callback: Bool)
    func viewDidLoad()
}

public protocol CheckoutPageViewModelOutputs {
    var dismissViewController: Signal<Void, NoError> { get }
    var popViewController: Signal<Void, NoError> { get }
    var showAlert: Signal<String, NoError> { get }
    var webViewLoadRequest: Signal<URLRequest, NoError> { get }
    var paymentCallback: Signal<(), NoError> { get }
    var webIsLoading: Signal<Bool, NoError> { get }
}

public protocol CheckoutPageViewModelType: CheckoutPageViewModelInputs, CheckoutPageViewModelOutputs {
    var inputs: CheckoutPageViewModelInputs { get }
    var outputs: CheckoutPageViewModelOutputs { get }
}

public final class CheckoutPageViewModel: CheckoutPageViewModelType {
    
    public init() {
        let configData = self.configRequestProperty.signal.skipNil().takeWhen(self.viewDidLoadProperty.signal)
        
        configData.observe(on: UIScheduler()).observeValues { data in
            print("VIEW DID LOAD PROPERTY DETECTED: \(data)")
        }
        
        let initialRequest = configData.map { $0 }
        
        self.popViewController = Signal.merge(self.failureAlertButtonTappedProperty.signal,
        self.cancelButtonTappedProperty.signal)
        
        self.webViewLoadRequest = initialRequest
        self.webIsLoading = self.webViewIsLoadingProperty.signal
        
        self.dismissViewController = .empty
        
        self.paymentCallback = self.paymentCallbackConfirmedProperty.signal.filter(isTrue).ignoreValues()
        
        self.showAlert = .empty
    }
    
    fileprivate let cancelButtonTappedProperty = MutableProperty(())
    public func cancelButtonTapped() {
        self.cancelButtonTappedProperty.value = ()
    }
    
    fileprivate let configRequestProperty = MutableProperty<URLRequest?>(nil)
    public func configureWith(initialRequest: URLRequest) {
        self.configRequestProperty.value = initialRequest
    }
    
    fileprivate let failureAlertButtonTappedProperty = MutableProperty(())
    public func failureAlertButtonTapped() {
        self.failureAlertButtonTappedProperty.value = ()
    }
    
    fileprivate let webViewIsLoadingProperty = MutableProperty(false)
    public func webViewConfirm(_ isLoading: Bool) {
        self.webViewIsLoadingProperty.value = isLoading
    }
    
    fileprivate let paymentCallbackConfirmedProperty = MutableProperty(false)
    public func paymentIsFailedOrCompleted(_ callback: Bool) {
        self.paymentCallbackConfirmedProperty.value = callback
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let dismissViewController: Signal<Void, NoError>
    public let popViewController: Signal<Void, NoError>
    public let showAlert: Signal<String, NoError>
    public let webViewLoadRequest: Signal<URLRequest, NoError>
    public let paymentCallback: Signal<(), NoError>
    public let webIsLoading: Signal<Bool, NoError>
    
    public var inputs: CheckoutPageViewModelInputs { return self }
    public var outputs: CheckoutPageViewModelOutputs { return self }
}

private func prepared(request baseRequest: URLRequest) -> URLRequest {
    
    var request = AppEnvironment.current.apiService.preparedRequest(forURL: baseRequest.url!)
    request.allHTTPHeaderFields = (request.allHTTPHeaderFields ?? [:])
    
    return request
}

private struct RequestData {
    fileprivate let request: URLRequest
//    fileprivate let navigation: Navigation?
    fileprivate let shouldStartLoad: Bool
    fileprivate let webViewNavigationType: WKWebViewConfiguration
}

