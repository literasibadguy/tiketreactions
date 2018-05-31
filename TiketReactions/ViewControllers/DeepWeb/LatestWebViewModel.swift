//
//  LatestWebViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 12/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import ReactiveSwift
import Result

public protocol LatestWebViewModelInputs {
    func viewDidLoad()
    func webViewDidFail(withError error: Error?)
    func webViewDidFinishLoad()
    func webViewDidStartLoad()
}

public protocol LatestWebViewModelOutputs {
    var loadingOverlayIsHiddenAndAnimate: Signal<(isHidden: Bool, animate: Bool), NoError> { get }
}

public protocol LatestWebViewModelType {
    var inputs: LatestWebViewModelInputs { get }
    var outputs: LatestWebViewModelOutputs { get }
}

public final class latestWebViewModel: LatestWebViewModelType, LatestWebViewModelInputs, LatestWebViewModelOutputs {
    
    public init() {
        self.loadingOverlayIsHiddenAndAnimate = Signal.merge(
        
            // Hide when first starting out.
            self.viewDidLoadProperty.signal.mapConst((true, false)),
            
            // Show loading when a request starts
            self.webViewDidStartLoadProperty.signal.mapConst((false, true)),
            
            // Hide loading when a request ends
            self.webViewDidFinishLoadProperty.signal.mapConst((true, true)),
            
            self.webViewDidFailErrorProperty.signal
                .filter { ($0 as NSError?)?.code != .some(102) }
                .mapConst((true, true))
        )
        .skipRepeats(==)
    }
    
    fileprivate let viewDidLoadProperty = MutableProperty(())
    public func viewDidLoad() {
        self.viewDidLoadProperty.value = ()
    }
    
    fileprivate let webViewDidFailErrorProperty = MutableProperty<Error?>(nil)
    public func webViewDidFail(withError error: Error?) {
        self.webViewDidFailErrorProperty.value = error
    }
    
    fileprivate let webViewDidFinishLoadProperty = MutableProperty(())
    public func webViewDidFinishLoad() {
        self.webViewDidFinishLoadProperty.value = ()
    }
    
    fileprivate let webViewDidStartLoadProperty = MutableProperty(())
    public func webViewDidStartLoad() {
        self.webViewDidStartLoadProperty.value = ()
    }
    
    public let loadingOverlayIsHiddenAndAnimate: Signal<(isHidden: Bool, animate: Bool), NoError>
    
    public var inputs: LatestWebViewModelInputs { return self }
    public var outputs: LatestWebViewModelOutputs { return self }
}

