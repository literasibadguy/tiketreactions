public protocol ClientAuthType {
    var clientId: String { get }
}

public func == (lhs: ClientAuthType, rhs: ClientAuthType) -> Bool {
    return type(of: lhs) == type(of: rhs) &&
        lhs.clientId == rhs.clientId
}

public struct ClientAuth: ClientAuthType {
    public let clientId: String
    
    public init(clientId: String) {
        self.clientId = clientId
    }
    
    public static let production: ClientAuthType = ClientAuth(
        clientId: Secrets.Api.Client.production
    )
    
    public static let development: ClientAuthType = ClientAuth(
        clientId: Secrets.Api.Client.staging
    )
}


