import Argo
import Curry
import Runes

public struct SearchFlightParams {
    public let fromAirport: String?
    public let toAirport: String?
    public let departDate: String?
    public let returnDate: String?
    public let adult: Int?
    public let child: Int?
    public let infant: Int?
    public let sort: Bool?
    
    public static let defaults = SearchFlightParams(fromAirport: nil, toAirport: nil, departDate: nil, returnDate: nil, adult: nil, child: nil, infant: nil, sort: nil)
    
    public var queryParams: [String: String] {
        var params: [String: String] = [:]
        params["d"] = self.fromAirport
        params["a"] = self.toAirport
        params["date"] = self.departDate
        params["ret_date"] = self.returnDate
        params["adult"] = self.adult?.description
        params["child"] = self.child?.description
        params["infant"] = self.infant?.description
        params["sort"] = self.sort == true ? "true" : self.sort == false ? "false" : nil
        
        return params
    }
}

public struct SearchSingleFlightParams {
    public let fromAirport: String?
    public let toAirport: String?
    public let departDate: String?
    public let returnDate: Bool?
    public let adult: Int?
    public let child: Int?
    public let infant: Int?
    public let sort: Bool?
    
    public static let defaults = SearchSingleFlightParams(fromAirport: nil, toAirport: nil, departDate: nil, returnDate: nil, adult: nil, child: nil, infant: nil, sort: nil)
    
    public var queryParams: [String: String] {
        var params: [String: String] = [:]
        params["d"] = self.fromAirport
        params["a"] = self.toAirport
        params["date"] = self.departDate
        params["ret_date"] = self.returnDate?.description
        params["adult"] = self.adult?.description
        params["child"] = self.child?.description
        params["infant"] = self.infant?.description
        params["sort"] = self.sort == true ? "true" : self.sort == false ? "false" : nil
        
        return params
    }
}

extension SearchFlightParams: Equatable {}
public func == (a: SearchFlightParams, b: SearchFlightParams) -> Bool {
    return a.queryParams == b.queryParams
}

extension SearchFlightParams: Hashable {
    public var hashValue: Int {
        return self.description.hash
    }
}

extension SearchSingleFlightParams: Equatable {}
public func == (a: SearchSingleFlightParams, b: SearchSingleFlightParams) -> Bool {
    return a.queryParams == b.queryParams
}

extension SearchFlightParams: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return self.queryParams.description
    }
    
    public var debugDescription: String {
        return self.queryParams.debugDescription
    }
}

extension SearchSingleFlightParams: CustomStringConvertible, CustomDebugStringConvertible {
    public var description: String {
        return self.queryParams.description
    }
    
    public var debugDescription: String {
        return self.queryParams.debugDescription
    }
}

extension SearchFlightParams: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<SearchFlightParams> {
        return curry(SearchFlightParams.init)
            <^> json <|? "from"
            <*> json <|? "to"
            <*> json <|? "date"
            <*> json <|? "ret_date"
            <*> json <|? "adult"
            <*> json <|? "child"
            <*> json <|? "infant"
            <*> json <|? "sort"
    }
}

extension SearchSingleFlightParams: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<SearchSingleFlightParams> {
        return curry(SearchSingleFlightParams.init)
            <^> json <|? "from"
            <*> json <|? "to"
            <*> json <|? "date"
            <*> json <|? "ret_date"
            <*> json <|? "adult"
            <*> json <|? "child"
            <*> json <|? "infant"
            <*> json <|? "sort"
    }
}

private func boolToString(_ bool: Bool?) -> Decoded<String?> {
    guard let bool = bool else { return .success(nil) }
    switch bool {
    case true:
        return .success("true")
    case false:
        return .success("false")
    }
}


