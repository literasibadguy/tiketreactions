import ReactiveSwift
import Result

public extension SignalProtocol {
    
    func demoteErrors(replaceErrorWith value: Value? = nil) -> Signal<Value, NoError> {
        
        return self.signal.flatMapError { _ in
            if let value = value {
                return SignalProducer(value: value)
            }
            return SignalProducer.empty
        }
    }
}

public extension SignalProducerProtocol {
    
    func demoteErrors(replaceErrorWith value: Value? = nil) -> SignalProducer<Value, NoError> {
        return self.producer.lift {
            $0.demoteErrors(replaceErrorWith: value)
        }
    }
}

