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

public protocol CheckoutPageViewModelInputs {
    func cancelButtonTapped()
    func configureWith(initialRequest: URLRequest)
    func failureAlertButtonTapped()
    func shouldStartLoad(withRequest request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool
    func viewDidLoad()
}

public protocol CheckoutPageViewModelOutputs {
    var dismissViewController: Signal<Void, NoError> { get }
    var popViewController: Signal<Void, NoError> { get }
    var showAlert: Signal<String, NoError> { get }
    var webViewLoadRequest: Signal<URLRequest, NoError> { get }
}

public protocol CheckoutPageViewModelType: CheckoutPageViewModelInputs, CheckoutPageViewModelOutputs {
    var inputs: CheckoutPageViewModelInputs { get }
    var outputs: CheckoutPageViewModelOutputs { get }
}

public final class CheckoutPageViewModel: CheckoutPageViewModelType {
    
    public init() {
        let configData = self.configRequestProperty.signal.skipNil().takeWhen(self.viewDidLoadProperty.signal)
        
        let initialRequest = configData.map { $0 }
        
        let requestData = self.shouldStartLoadProperty.signal.skipNil()
            .map { request, navigationType -> RequestData in
                return RequestData(request: request, shouldStartLoad: true, webViewNavigationType: navigationType)
        }
        
        let webViewRequest = requestData
            .filter { requestData in
                
                !requestData.shouldStartLoad
            }.map { $0.request }
        
        self.popViewController = Signal.merge(self.failureAlertButtonTappedProperty.signal,
        self.cancelButtonTappedProperty.signal)
        
        self.webViewLoadRequest = Signal.merge(initialRequest, webViewRequest).map(prepared(request:))
        
        self.dismissViewController = .empty
        
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
    
    fileprivate let shouldStartLoadProperty = MutableProperty<(URLRequest, UIWebViewNavigationType)?>(nil)
    fileprivate let shouldStartLoadResponseProperty = MutableProperty(false)
    public func shouldStartLoad(withRequest request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        self.shouldStartLoadProperty.value = (request, navigationType)
        return self.shouldStartLoadResponseProperty.value
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    public let dismissViewController: Signal<Void, NoError>
    public let popViewController: Signal<Void, NoError>
    public let showAlert: Signal<String, NoError>
    public let webViewLoadRequest: Signal<URLRequest, NoError>
    
    public var inputs: CheckoutPageViewModelInputs { return self }
    public var outputs: CheckoutPageViewModelOutputs { return self }
}


private func prepared(request baseRequest: URLRequest) -> URLRequest {
    
    var request = AppEnvironment.current.apiService.preparedRequest(forRequest: baseRequest)
    request.allHTTPHeaderFields = (request.allHTTPHeaderFields ?? [:])
    
    return request
}

private struct RequestData {
    fileprivate let request: URLRequest
//    fileprivate let navigation: Navigation?
    fileprivate let shouldStartLoad: Bool
    fileprivate let webViewNavigationType: UIWebViewNavigationType
}

