//
//  MyOrder.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 24/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct MyOrder {
    public let orderId: String
    public let orderData: [OrderData]
    public let total: Int
    public let totalTax: Int
    public let totalWithoutTax: Int
    public let countInstallment: Int
}

extension MyOrder: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<MyOrder> {
        let tmp1 = curry(MyOrder.init)
            <^> json <| "order_id"
            <*> json <|| "data"
            <*> json <| "total"
            <*> json <|  "total_tax"
        
        return tmp1
            <*> json <| "total_without_tax"
            <*> json <| "count_installment"
    }
}
