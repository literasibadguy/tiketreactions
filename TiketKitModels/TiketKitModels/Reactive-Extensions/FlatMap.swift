//
//  FlatMap.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 10/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import ReactiveSwift

public extension SignalProtocol {
    func flatMap <U> (_ f: @escaping (Value) -> SignalProducer<U, Error>) -> Signal<U, Error> {
        return self.signal.flatMap(.concat, f)
    }
    
    func flatMap <U> (_ f: @escaping (Value) -> Signal<U, Error>) -> Signal<U, Error> {
        return self.signal.flatMap(.concat, f)
    }
}

public extension SignalProducerProtocol {
    func flatMap <U> (_ f: @escaping (Value) -> SignalProducer<U, Error>) -> SignalProducer<U, Error> {
        return self.producer.flatMap(.concat, f)
    }
    
    func flatMap <U> (_ f: @escaping (Value) -> Signal<U, Error>) -> SignalProducer<U, Error> {
        return self.producer.flatMap(.concat, f)
    }
}
