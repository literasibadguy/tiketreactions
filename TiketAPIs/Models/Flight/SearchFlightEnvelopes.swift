import Argo
import Curry
import Runes
import Swish

public struct SearchFlightEnvelope {
    public let diagnostic: Diagnostic
    public let outputType: String?
    public let roundTrip: Bool
    public let paramSearchFlight: SearchFlightParams
    public let goDeparture: Destination
    public let goReturn: Destination?
    public let flightResults: FlightResults
    //    public let nearbyGoDate: NearbyGoDate
    public let loginStatus: Bool?
    public let token: String
    
    public struct FlightResults {
        public let flights: [Flight]
    }
    
    public struct Destination {
        public let depAirport: Airport
        public let arrAirport: Airport
        public let date: String
        public let formattedDate: String
    }
}

extension SearchFlightEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<SearchFlightEnvelope> {
        let tmp1 = curry(SearchFlightEnvelope.init)
            <^> json <| "diagnostic"
            <*> json <|? "output_type"
            <*> json <| "round_trip"
            <*> json <| "search_queries"
            <*> json <| "go_det"
        
        return tmp1
            <*> json <|? "ret_det"
            <*> json <| "departures"
            //            <*> json <| "nearby_go_date"
            <*> json <|? "false"
            <*> json <| "token"
        
    }
}

extension SearchFlightEnvelope.FlightResults: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<SearchFlightEnvelope.FlightResults> {
        return curry(SearchFlightEnvelope.FlightResults.init)
            <^> json <|| "result"
    }
}

extension SearchFlightEnvelope.Destination: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<SearchFlightEnvelope.Destination> {
        return curry(SearchFlightEnvelope.Destination.init)
            <^> json <| "dep_airport"
            <*> json <| "arr_airport"
            <*> json <| "date"
            <*> json <| "formatted_date"
    }
}

struct SearchFlightAsking: Request {
    typealias ResponseObject = SearchFlightEnvelope
    
    func build() -> URLRequest {
        let url = URL(string: "https://api-sandbox.tiket.com/search/flight?d=CGK&a=DPS&date=2018-01-25&ret_date=0&adult=1&child=0&infant=0&token=7365ed11f6e27d02328686cdaa1a69e4bf804aa5&v=1&output=json")!
        return URLRequest(url: url)
    }
}
