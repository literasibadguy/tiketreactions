import Foundation

public enum Trip2ZeroBundleIdentifier: String {
    case beta = "firasrafislam.TiketReactions.TiketReactions.beta"
    case release = "firasrafislam.TiketReactions"
}

public protocol NSBundleType {
    var bundleIdentifier: String? { get }
    static func create(path: String) -> NSBundleType?
    func path(forResource name: String?, ofType ext: String?) -> String?
    func localizedString(forKey key: String, value: String?, table tableName: String?) -> String
    var infoDictionary: [String: Any]? { get }
}

extension NSBundleType {
    public var identifier: String {
        return self.infoDictionary?["CFBundleIdentifier"] as? String ?? "Unknown"
    }
    
    public var shortVersionString: String {
        return self.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    }
    
    public var version: String {
        return self.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    }
    
    public var isBeta: Bool {
        return self.identifier == Trip2ZeroBundleIdentifier.beta.rawValue
    }
    
    public var isRelease: Bool {
        return self.identifier == Trip2ZeroBundleIdentifier.release.rawValue
    }
    
    public static func create(path: String) -> Bundle? {
        return Bundle(path: path)
    }
}

extension Bundle: NSBundleType {
    public static func create(path: String) -> NSBundleType? {
        return Bundle(path: path)
    }
}

/*
 extension Bundle {
 public var identifier: String {
 return self.infoDictionary?["CFBundleIdentifier"] as? String ?? "Unknown"
 }
 
 public var shortVersionString: String {
 return self.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
 }
 
 public var version: String {
 return self.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
 }
 
 public var isBeta: Bool {
 return self.identifier == Trip2ZeroBundleIdentifier.beta.rawValue
 }
 
 public var isRelease: Bool {
 return self.identifier == Trip2ZeroBundleIdentifier.release.rawValue
 }
 
 public static func create(path: String) -> Bundle? {
 return Bundle(path: path)
 }
 }
 */

public struct LanguageDoubler: NSBundleType {
    fileprivate static let mainBundle = Bundle.main
    
    public init() {
    }
    
    public let bundleIdentifier: String? = "com.language.doubler"
    
    public static func create(path: String) -> NSBundleType? {
        return DoublerBundler(path: path) as? NSBundleType
    }
    
    public func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        return LanguageDoubler.mainBundle.localizedString(forKey: key, value: value, table: tableName)
    }
    
    public func path(forResource name: String?, ofType ext: String?) -> String? {
        return LanguageDoubler.mainBundle.path(forResource: name, ofType: ext)
    }
    
    public var infoDictionary: [String: Any]? {
        return [:]
    }
}

public final class DoublerBundler: Bundle {
    public override func localizedString(forKey key: String, value: String?, table tableName: String?) -> String {
        let s = super.localizedString(forKey: key, value: value, table: tableName)
        return "\(s) \(s)"
    }
}
