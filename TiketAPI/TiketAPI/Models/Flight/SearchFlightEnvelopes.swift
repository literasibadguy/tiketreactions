import Argo
import Curry
import Runes

public struct SearchFlightEnvelope {
    public let diagnostic: Diagnostic
    public let roundTrip: Bool
    public let paramSearchFlight: SearchFlightParams
    public let departureResults: FlightResults
    public let returnsResults: FlightResults?
    //    public let nearbyGoDate: NearbyGoDate
    public let loginStatus: String
    
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
        return curry(SearchFlightEnvelope.init)
            <^> json <| "diagnostic"
            <*> json <| "round_trip"
            <*> json <| "search_queries"
            <*> json <| "departures"
            <*> json <|? "returns"
            <*> json <| "login_status"
        
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
