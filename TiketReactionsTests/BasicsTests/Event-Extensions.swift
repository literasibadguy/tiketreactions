//
//  Event-Extensions.swift
//  TiketSignalTests
//
//  Created by Firas Rafislam on 01/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import ReactiveSwift

internal extension Signal.Event {
    
    internal var isValue: Bool {
        if case .value = self {
            return true
        }
        return false
    }
    
    internal var isFailed: Bool {
        if case .failed = self {
            return true
        }
        return false
    }
    
    internal var isInterrupted: Bool {
        if case .interrupted = self {
            return true
        }
        return false
    }
}
