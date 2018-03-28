//
//  IgnoreValues.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 08/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import ReactiveSwift

public extension SignalProtocol {
    
    public func ignoreValues() -> Signal<Void, Error> {
        return signal.map { _ in () }
    }
}

