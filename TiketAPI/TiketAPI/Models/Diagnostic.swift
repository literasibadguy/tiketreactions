import Argo
import Curry
import Runes

public struct Diagnostic {
    public let status: Int
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
            <^> json <| "status"
            <*> json <|? "elapsetime"
            <*> json <|? "memoryusage"
            <*> json <|? "unix_timestamp"
            <*> json <|? "confirm"
            <*> json <| "lang"
            <*> json <| "currency"
    }
}

