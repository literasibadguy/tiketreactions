

import Foundation

public protocol KeyValueStoreType: class {
    func set(_ value: Bool, forKey defaultName: String)
    func set(_ value: Int, forKey defaultName: String)
    func set(_ value: Any?, forKey defaultName: String)
    
    func bool(forKey defaultName: String) -> Bool
    func dictionary(forKey defaultName: String) -> [String: Any]?
    func integer(forKey defaultName: String) -> Int
    func object(forKey defaultName: String) -> Any?
    func string(forKey defaultName: String) -> String?
    func synchronize() -> Bool
    
    func removeObject(forKey defaultName: String)
}

extension UserDefaults: KeyValueStoreType {
    
}

extension NSUbiquitousKeyValueStore: KeyValueStoreType {
    public func integer(forKey defaultName: String) -> Int {
        return Int(longLong(forKey: defaultName))
    }
    
    public func set(_ value: Int, forKey defaultName: String) {
        return set(Int64(value), forKey: defaultName)
    }
}

internal class FakeKeyValueStore: KeyValueStoreType {
    
    var store: [String: Any] = [:]
    
    func set(_ value: Int, forKey defaultName: String) {
        self.store[defaultName] = value
    }
    
    func integer(forKey defaultName: String) -> Int {
        return self.store[defaultName] as? Int ?? 0
    }
    
    func set(_ value: Bool, forKey defaultName: String) {
        self.store[defaultName] = value
    }
    
    func set(_ value: Any?, forKey defaultName: String) {
        self.store[defaultName] = value
    }
    
    func bool(forKey defaultName: String) -> Bool {
        return self.store[defaultName] as? Bool ?? false
    }
    
    func dictionary(forKey defaultName: String) -> [String : Any]? {
        return self.object(forKey: defaultName) as? [String: Any]
    }
    
    func object(forKey defaultName: String) -> Any? {
        return self.store[defaultName]
    }
    
    func string(forKey defaultName: String) -> String? {
        return self.store[defaultName] as? String
    }
    
    func removeObject(forKey defaultName: String) {
        self.set(nil, forKey: defaultName)
    }
    
    func synchronize() -> Bool {
        return true
    }
}
