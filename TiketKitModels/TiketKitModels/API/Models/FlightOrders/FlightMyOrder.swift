//
//  FlightMyOrder.swift
//  TiketKitModels
//
//  Created by Firas Rafislam on 26/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct FlightMyOrder {
    public let orderId: String
    public let orderData: [FlightOrderData]
    public let total: Int
    public let totalTax: Int
    public let totalWithoutTax: Int
    public let countInstallment: Int
}

extension FlightMyOrder: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<FlightMyOrder> {
        let tmp1 = curry(FlightMyOrder.init)
            <^> json <| "order_id"
            <*> json <|| "data"
            <*> json <| "total"
            <*> json <|  "total_tax"
        
        return tmp1
            <*> json <| "total_without_tax"
            <*> json <| "count_installment"
    }
}

