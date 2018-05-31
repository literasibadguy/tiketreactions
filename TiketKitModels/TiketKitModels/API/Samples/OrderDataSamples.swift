//
//  OrderDataSamples.swift
//  TiketKitModels
//
//  Created by Firas Rafislam on 08/05/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude

extension OrderData {
    internal static let sample = OrderData(expire: 1, orderDetailId: "", orderExpireDatetime: "", orderType: "", orderName: "", orderNameDetail: "", tenor: "", detail: .sample, orderPhoto: "", tax: 0, itemCharge: 0, subtotalAndCharge: "", deleteUri: "")
}

extension OrderData.OrderDataDetail {
    internal static let sample = OrderData.OrderDataDetail(orderDetailId: "", roomId: "", rooms: "1", adult: "2", child: "0", startdate: "2018-05-09", enddate: "2018-05-10", nights: "1", totalCharge: "", startDateOriginal: "", endDateOriginal: "", price: 0, pricePerNight: 0)
}


