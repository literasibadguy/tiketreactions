import Argo
import Curry
import Runes

public struct GetTokenEnvelope {
    public let diagnostic: Diagnostic
    public let loginStatus: String?
    public let token: String
}

extension GetTokenEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<GetTokenEnvelope> {
        return curry(GetTokenEnvelope.init)
            <^> json <| "diagnostic"
            <*> json <|? "login_status"
            <*> json <| "token"
    }
}

