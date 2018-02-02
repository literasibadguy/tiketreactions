
import Foundation

public protocol EncodableType {
    func encode() -> [String: Any]
}

public extension EncodableType {
    
    public func toJSONData() -> Data? {
        return try? JSONSerialization.data(withJSONObject: encode(), options: [])
    }
    
    public func toJSONString() -> String? {
        return self.toJSONData().flatMap { String(data: $0, encoding: .utf8) }
    }
}
