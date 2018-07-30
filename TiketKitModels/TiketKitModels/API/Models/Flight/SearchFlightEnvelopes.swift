import Argo
import Curry
import Runes

public struct SearchFlightEnvelope {
    public let diagnostic: Diagnostic
    public let roundTrip: Bool?
    public let paramSearchFlight: SearchFlightParams
    public let departResuts: [Flight]
    public let returnResults: FlightResults?
//    public let flightResults: RoundResults
    //    public let nearbyGoDate: NearbyGoDate
    
    public struct RoundResults {
        public let departureResults: FlightResults?
        public let returnResults: FlightResults?
    }
    
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

public struct SearchSingleFlightEnvelope {
    public let diagnostic: Diagnostic
    public let roundTrip: Bool?
    public let paramSearchFlight: SearchSingleFlightParams
    public let departResuts: [Flight]
    //    public let flightResults: RoundResults
    //    public let nearbyGoDate: NearbyGoDate

    
    public struct Destination {
        public let depAirport: Airport
        public let arrAirport: Airport
        public let date: String
        public let formattedDate: String
    }
}

extension SearchFlightEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<SearchFlightEnvelope> {
        
//        let depart: Decoded<FlightResults?> = json <| "departures" <|> .success(nil)
        
        return curry(SearchFlightEnvelope.init)
            <^> json <| "diagnostic"
            <*> json <|? "round_trip"
            <*> json <| "search_queries"
            <*> json <|| ["departures", "result"]
            <*> json <|? "returns"
        
    }
}

extension SearchSingleFlightEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<SearchSingleFlightEnvelope> {
        return curry(SearchSingleFlightEnvelope.init)
            <^> json <| "diagnostic"
            <*> json <|? "round_trip"
            <*> json <| "search_queries"
            <*> json <|| ["departures", "result"]
    }
}

extension SearchFlightEnvelope.RoundResults: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<SearchFlightEnvelope.RoundResults> {
        let create = curry(SearchFlightEnvelope.RoundResults.init)
        
        let nilTemp = create
            <^> .success(nil)
            <*> .success(nil)
        
        let foundTemp = create
            <^> json <| "departures"
            <*> .success(nil)
        
        let roundTemp = create
            <^> json <| "departures"
            <*> json <| "returns"
        
        return nilTemp <|> foundTemp <|> roundTemp
    }
}


extension SearchFlightEnvelope.FlightResults: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<SearchFlightEnvelope.FlightResults> {
        return curry(SearchFlightEnvelope.FlightResults.init)
            <^> (json <|| "result" <|> .success([]))
//            (json <|| "result" <|> .success([]))
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
