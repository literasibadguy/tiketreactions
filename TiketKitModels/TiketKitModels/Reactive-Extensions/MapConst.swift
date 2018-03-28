//
//  MapConst.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 08/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import ReactiveSwift

public extension SignalProtocol {
    
    public func mapConst <U> (_ value: U) -> Signal<U, Error> {
        return self.signal.map { _ in value }
    }
}

public extension SignalProducerProtocol {
    
    public func mapConst <U> (_ value: U) -> SignalProducer<U, Error> {
        return self.producer.lift { $0.mapConst(value) }
    }
}
