//
//  Values.swift
//  TiketKitModels
//
//  Created by Firas Rafislam on 14/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import ReactiveSwift
import Result

extension SignalProtocol where Value: EventProtocol, Error == NoError {
    public func values() -> Signal<Value.Value, NoError> {
        return self.signal.map { $0.event.value }.skipNil()
    }
}

extension SignalProducerProtocol where Value: EventProtocol, Error == NoError {
    public func values() -> SignalProducer<Value.Value, NoError> {
        return self.producer.lift { $0.values() }
    }
}
