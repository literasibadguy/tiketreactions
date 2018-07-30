//
//  OrderData.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 24/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct OrderData {
    public let expire: Int
    public let orderDetailId: String
    public let orderExpireDatetime: String
    public let orderType: String
    public let orderName: String
    public let orderNameDetail: String
    public let tenor: String
    public let detail: OrderDataDetail
    
    public struct OrderDataDetail {
        public let orderDetailId: String
        public let roomId: String
        public let rooms: String
        public let adult: String
        public let child: String
        public let startdate: String
        public let enddate: String
        public let nights: String
        public let totalCharge: String
        public let startDateOriginal: String
        public let endDateOriginal: String
        public let price: Int
        public let pricePerNight: Int
    }
    
    public let orderPhoto: String
    public let tax: Int
    public let itemCharge: Int
    public let subtotalAndCharge: String
    public let deleteUri: String
}

extension OrderData: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<OrderData> {
        let tmp1 = curry(OrderData.init)
            <^> json <| "expire"
            <*> json <| "order_detail_id"
            <*> json <| "order_expire_datetime"
            <*> json <| "order_type"
            <*> json <| "order_name"
        
        let tmp2 = tmp1
            <*> json <| "order_name_detail"
            <*> json <| "tenor"
            <*> json <| "detail"
            <*> json <| "order_photo"
        
        return tmp2
            <*> json <| "tax"
            <*> json <| "item_charge"
            <*> json <| "subtotal_and_charge"
            <*> json <| "delete_uri"
    }
}

extension OrderData.OrderDataDetail: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<OrderData.OrderDataDetail> {
        let tmp1 = curry(OrderData.OrderDataDetail.init)
            <^> json <| "order_detail_id"
            <*> json <| "room_id"
            <*> json <| "rooms"
            <*> json <| "adult"
        
        let tmp2 = tmp1
            <*> json <| "child"
            <*> json <| "startdate"
            <*> json <| "enddate"
            <*> json <| "nights"
            <*> json <| "total_charge"
        
        return tmp2
            <*> json <| "startdate_original"
            <*> json <| "enddate_original"
            <*> json <| "price"
            <*> json <| "price_per_night"
    }
}
