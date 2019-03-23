import Argo
import Curry
import Runes

public struct Diagnostic {
    public enum Status: Int {
        case error = 204
        case timeout = 201
        case failed = 403
        case successful = 200
        case empty = 250
    }
    
    public let errorMessage: String?
    public let status: Status
    public let elapseTime: String?
    public let memoryUsage: String?
    public let unixTimestamp: Int?
    public let confirm: String?
    public let lang: String
    public let currency: String
}

extension Diagnostic: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<Diagnostic> {
        return curry(Diagnostic.init)
            <^> (json <|? "error_msgs" <|> .success(nil))
            <*> json <| "status"
            <*> json <|? "elapsetime"
            <*> json <|? "memoryusage"
            <*> json <|? "unix_timestamp"
            <*> json <|? "confirm"
            <*> json <| "lang"
            <*> json <| "currency"
    }
}

extension Diagnostic.Status: Argo.Decodable {
}


