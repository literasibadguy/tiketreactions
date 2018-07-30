//
//  RealmImmediate.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 16/07/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import ReactiveSwift
import Realm
import RealmSwift
import Result

protocol ListPresentable {
    associatedtype Item: Object, IssuedOrderCellPresentable
    var items: List<Item> { get }
}

protocol IssuedOrderCellPresentable {
    var orderId: String { get set }
    var email: String { get set }
}

public final class IssuedOrderList: Object, ListPresentable {
    @objc dynamic var id = NSUUID().uuidString
    let items = List<IssuedOrder>()
    
    public override static func primaryKey() -> String? {
        return "id"
    }
}

public final class IssuedOrder: Object, IssuedOrderCellPresentable {
    @objc dynamic var orderId = ""
    @objc dynamic var email = ""
}
