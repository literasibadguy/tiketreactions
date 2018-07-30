//
//  Realm+Setup.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 16/07/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import RealmSwift

private var deduplicationNotificationToken: NotificationToken!

public func setDefaultRealmForTiket() {
    var config = Realm.Configuration()
    
    // Use the default directory, but replace the filename with the username
    config.fileURL = config.fileURL!.deletingLastPathComponent().appendingPathComponent("triptozero.realm")
    config.objectTypes = [IssuedOrderList.self, IssuedOrder.self]
    config.readOnly = false
    
    // Set this as the configuration used for the default Realm
    Realm.Configuration.defaultConfiguration = config
    
    let realm = try! Realm()
    if realm.isEmpty {
        try! realm.write {
            let listLists = IssuedOrderList()
            realm.add(listLists)
        }
    }

    
    print("Is there any occured something on Default Realm Configuration")
    /*
    deduplicationNotificationToken = realm.observe { _, realm in
        let items = realm.objects(IssuedOrderList.self).first!.items
        guard items.count > 1 && !realm.isInWriteTransaction else { return }
        let itemsReference = ThreadSafeReference(to: items)
        // Deduplicate
        print("Deduplicate Notification Token")
        DispatchQueue(label: "io.realm.RealmTasks.bg").async {
            let realm = try! Realm(configuration: realm.configuration)
            guard let items = realm.resolve(itemsReference), items.count > 1 else {
                return
            }
            realm.beginWrite()
            let listReferenceIDs = NSCountedSet(array: items.map { $0.orderId })
            for id in listReferenceIDs where listReferenceIDs.count(for: id) > 1 {
                let id = id as! String
                let indexesToRemove = items.enumerated().compactMap { index, element in
                    return element.orderId == id ? index : nil
                }
                indexesToRemove.dropFirst().reversed().forEach(items.remove)
            }
            try! realm.commitWrite()
        }
    }
    */
}

public func isDefaultRealmConfigured() -> Bool {
    return try! !Realm().isEmpty
}


