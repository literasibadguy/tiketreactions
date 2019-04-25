//
//  TakeWhen.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 15/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import ReactiveSwift
import Result

public extension SignalProtocol {
    
    /**
     Emits the most recent value of `self` when `other` emits.
     
     - parameter other: Another signal.
     
     - returns: A new signal.
     */
    func takeWhen <U> (_ other: Signal<U, Error>) -> Signal<Value, Error> {
        return other.withLatest(from: self.signal as! Signal<Value, NoError>).map { tuple in tuple.1 }
    }
    
    /**
     Emits the most recent value of `self` and `other` when `other` emits.
     
     - parameter other: Another signal.
     
     - returns: A new signal.
     */
    func takePairWhen <U> (_ other: Signal<U, Error>) -> Signal<(Value, U), Error> {
        return other.withLatest(from: self.signal as! Signal<Value, NoError>).map { ($0.1, $0.0) }
    }
}
