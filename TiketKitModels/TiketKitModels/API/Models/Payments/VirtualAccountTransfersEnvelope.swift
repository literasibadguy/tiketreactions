//
//  VirtualAccountTransfersEnvelope.swift
//  TiketKitModels
//
//  Created by Firas Rafislam on 27/03/19.
//  Copyright © 2019 Firas Rafislam. All rights reserved.
//

import Argo
import Curry
import Runes

public struct VirtualAccountTransfersEnvelope {
    public let diagnostic: Diagnostic
    public let vaResult: VirtualResult
    
    public struct VirtualResult {
        public let orderId: String
        public let grandTotal: Double
        public let grandSubtotal: Double
        public let vaMultiplePayment: [VirtualAccountPayment]
    }
}

public struct VirtualAccountPayment {
    public let link: String
    public let text: String
    public let message: String
    public let numType: Int
}

extension VirtualAccountTransfersEnvelope: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<VirtualAccountTransfersEnvelope> {
        return curry(VirtualAccountTransfersEnvelope.init)
            <^> json <| "diagnostic"
            <*> json <| "result"
    }
}

extension VirtualAccountTransfersEnvelope.VirtualResult: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<VirtualAccountTransfersEnvelope.VirtualResult> {
        return curry(VirtualAccountTransfersEnvelope.VirtualResult.init)
            <^> json <| "order_id"
            <*> json <| "grand_total"
            <*> json <| "grand_subtotal"
            <*> json <|| "virtual_account_multiple_payment"
    }
}

extension VirtualAccountPayment: Argo.Decodable {
    public static func decode(_ json: JSON) -> Decoded<VirtualAccountPayment> {
        return curry(VirtualAccountPayment.init)
            <^> json <| "link"
            <*> json <| "text"
            <*> json <| "message"
            <*> json <| "num_type"
    }
}
