import Foundation

public protocol TiketServerConfigType {
    var apiBaseUrl: URL { get }
    var webBaseUrl: URL { get }
    var apiClientAuth: ClientAuthType { get }
}

public func == (lhs: TiketServerConfigType, rhs: TiketServerConfigType) -> Bool {
    return
        type(of: lhs) == type(of: rhs) &&
            lhs.apiBaseUrl == rhs.apiBaseUrl &&
            lhs.webBaseUrl == rhs.webBaseUrl &&
            lhs.apiClientAuth == rhs.apiClientAuth
}

public struct TiketServerConfig: TiketServerConfigType {
    public let apiBaseUrl: URL
    public let webBaseUrl: URL
    public let apiClientAuth: ClientAuthType
    
    public static let production: TiketServerConfigType = TiketServerConfig(
        apiBaseUrl: URL(string: "https://\(Secrets.Api.Endpoint.production)")!,
        webBaseUrl: URL(string: "https://\(Secrets.WebEndPoint.production)")!,
        apiClientAuth: ClientAuth.production
    )
    
    public static let staging: TiketServerConfigType = TiketServerConfig(
        apiBaseUrl: URL(string: "https://\(Secrets.Api.Endpoint.staging)")!,
        webBaseUrl: URL(string: "https://\(Secrets.WebEndPoint.staging)")!,
        apiClientAuth: ClientAuth.development
    )
    
    public init(apiBaseUrl: URL, webBaseUrl: URL, apiClientAuth: ClientAuthType) {
        self.apiBaseUrl = apiBaseUrl
        self.webBaseUrl = webBaseUrl
        self.apiClientAuth = apiClientAuth
    }
}
