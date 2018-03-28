//
//  TakeUntil.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 10/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import ReactiveSwift

extension SignalProtocol {
    
    public func takeUntil(_ predicate: @escaping (Value) -> Bool) -> Signal<Value, Error> {
        return Signal { observer in
            return self.signal.observe { event in
                if case let .value(value) = event, predicate(value) {
                    observer.send(value: value)
                    observer.sendCompleted()
                } else {
                    observer.action(event)
                }
            }
        }
    }
}

extension SignalProducerProtocol {
    
    public func takeUntil(_ predicate: @escaping (Value) -> Bool) -> SignalProducer<Value, Error> {
        return producer.lift { $0.takeUntil(predicate) }
    }
}

