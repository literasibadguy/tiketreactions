import ReactiveSwift

public extension SignalProtocol {
    
    func ck_delay(_ interval: @autoclosure @escaping () -> DispatchTimeInterval, on scheduler: @autoclosure @escaping () -> DateScheduler) -> Signal<Value, Error> {
        
        return self.signal.delay(interval().timeInterval, on: scheduler())
    }
}

public extension SignalProducerProtocol {
    
    func ck_delay(_ interval: @autoclosure @escaping () -> DispatchTimeInterval, on scheduler: @autoclosure @escaping () -> DateScheduler) -> SignalProducer<Value, Error> {
        
        return self.producer.delay(interval().timeInterval, on: scheduler())
    }
}

