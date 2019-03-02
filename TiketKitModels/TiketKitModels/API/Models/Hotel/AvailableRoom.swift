import Argo
import Curry
import Runes

public struct AvailableRoom {
    public let id: String
    public let roomAvailable: String
    public let extSource: String
    public let roomId: String
    public let currency: String
    
    public let minimumStays: String
    public let withBreakfasts: String
    public let roomDescription: String
    public let allPhotoRoom: [String]
    
    public let photoUrl: String
    public let roomName: String
    public let oldprice: String?
    public let price: Double
    
    public let bookURI: String
    public let RoomFacility: [String]
    public let additionalSurchargeCurrency: String?
}

extension AvailableRoom: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<AvailableRoom> {
        let tmp1 = curry(AvailableRoom.init)
            <^> json <| "id"
            <*> ((json <| "room_available" >>- intToString) <|> (json <| "room_available"))
            <*> json <| "ext_source"
            <*> json <| "room_id"
            <*> json <| "currency"
        
        let tmp2 = tmp1
            <*> json <| "minimum_stays"
            <*> json <| "with_breakfasts"
            <*> json <| "room_description"
            <*> json <|| "all_photo_room"
        
        let tmp3 = tmp2
            <*> json <| "photo_url"
            <*> json <| "room_name"
            <*> json <|? "oldprice"
            <*> (json <| "price" >>- stringToDouble)
        
        return tmp3
            <*> json <| "bookUri"
            <*> json <|| "room_facility"
            <*> json <|? "additional_surcharge"
    }
}

private func stringToDouble(_ string: String) -> Decoded<Double> {
    return Double(string).map(Decoded.success) ?? .success(0)
}


