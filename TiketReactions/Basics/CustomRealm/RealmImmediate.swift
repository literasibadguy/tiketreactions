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
import TiketKitModels

protocol ListPresentable {
    associatedtype Item: Object, IssuedOrderCellPresentable
    var items: List<Item> { get }
}

protocol PassengerListPresentable {
    associatedtype Item: Object, PassengerCellPresentable
    var items: List<Item> { get }
}

protocol IssuedOrderCellPresentable {
    var orderId: String { get set }
    var email: String { get set }
}

protocol PassengerCellPresentable {
    var title: String { get set }
    var firstname: String { get set }
    var lastname: String { get set }
}

public final class IssuedOrderList: Object, ListPresentable {
    @objc dynamic var id = NSUUID().uuidString
    let items = List<IssuedOrder>()
    
    public override static func primaryKey() -> String? {
        return "id"
    }
}

public final class PassengerList: Object, PassengerListPresentable {
    @objc dynamic var id = NSUUID().uuidString
    let items = List<PassengerData>()
    
    public override static func primaryKey() -> String? {
        return "id"
    }
}

public final class IssuedOrder: Object, IssuedOrderCellPresentable {
    @objc dynamic var orderId = ""
    @objc dynamic var email = ""
}

public final class ContactPersonData: Object {
    @objc dynamic var title = ""
    @objc dynamic var firstname = ""
    @objc dynamic var lastname = ""
    @objc dynamic var email = ""
    @objc dynamic var phone = ""
}

public final class PassengerData: Object, PassengerCellPresentable {
    @objc dynamic var title = ""
    @objc dynamic var firstname = ""
    @objc dynamic var lastname = ""
}
