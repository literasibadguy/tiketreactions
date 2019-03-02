import Foundation

public enum AppKeys: String {
    case temporaryCartFlights = "temporary_cart_flights"
    case tokenSavedActivity = "firasrafislam.TiketReactions.KeyValueStoreType.tokenSaved"
    case orderDetailIds = "order_detail_ids"
    case emailDetailLogins = "email_detail_logins"
}

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
    
    var tokenSaved: String { get set }
}


extension KeyValueStoreType {
    
    public var temporaryCartFlights: [Flight] {
        get {
            return self.object(forKey: AppKeys.temporaryCartFlights.rawValue) as? [Flight] ?? []
        }
        set {
            self.set(newValue, forKey: AppKeys.temporaryCartFlights.rawValue)
        }
    }
    
    public var tokenSaved: String {
        get {
            return self.object(forKey: AppKeys.tokenSavedActivity.rawValue) as? String ?? ""
        } set {
            self.set(newValue, forKey: AppKeys.tokenSavedActivity.rawValue)
        }
    }
    
    public var orderDetailIds: [String] {
        get {
            return self.object(forKey: AppKeys.orderDetailIds.rawValue) as? [String] ?? []
        }
        set {
            self.set(newValue, forKey: AppKeys.orderDetailIds.rawValue)
        }
    }
    
    public var emailDetailLogins: [String] {
        get {
            return self.object(forKey: AppKeys.emailDetailLogins.rawValue) as? [String] ?? []
        }
        set {
            return self.set(newValue, forKey: AppKeys.emailDetailLogins.rawValue)
        }
    }
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
