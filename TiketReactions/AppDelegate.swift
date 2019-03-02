//
//  AppDelegate.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 25/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import GoogleMaps
import GooglePlaces
import UIKit
import Prelude
import ReactiveSwift
import RealmSwift
import Result
import TiketKitModels
import UIKit


@UIApplicationMain
internal final class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    fileprivate let viewModel: AppDelegateViewModelType = AppDelegateViewModel()
    
    internal var rootTabBarController: RootTabBarVC? {
        return self.window?.rootViewController as? RootTabBarVC
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UIView.doBadSwizzleStuff()
        UIViewController.doBadSwizzleStuff()
        
        self.window?.tintColor = .tk_official_green
        self.setDefaultRealmForTiket()
        
        AppEnvironment.replaceCurrentEnvironment(
            AppEnvironment.fromStorage(ubiquitousStore: NSUbiquitousKeyValueStore.default, userDefaults: UserDefaults.standard)
        )
        
        self.viewModel.outputs.tokenIntoEnvironment
            .observe(on: UIScheduler())
            .observeValues { token in
                AppEnvironment.getFirstToken(token)
                print("Is there any token: \(token)")
                GMSPlacesClient.provideAPIKey(Secrets.googleMapKeys)
                GMSServices.provideAPIKey(Secrets.googleMapKeys)
        }
//
        self.viewModel.outputs.presentViewController
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.rootTabBarController?.dismiss(animated: true, completion: nil)
                self?.rootTabBarController?.present($0, animated: true, completion: nil)
        }
        
        self.viewModel.outputs.goToHotel
            .observe(on: UIScheduler())
            .observeValues { [weak self] param in
                self?.rootTabBarController?.switchToHotelForm()
        }
        
        self.viewModel.outputs.goToOrder
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.rootTabBarController?.switchToOrder()
        }
        
        self.viewModel.outputs.goToAbout
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.rootTabBarController?.switchToAbout()
        }
        
        self.viewModel.outputs.synchronizeUbiquitousStore
            .observe(on: UIScheduler())
            .observeValues {
                _ = AppEnvironment.current.ubiquitousStore.synchronize()
        }
        
        self.viewModel.inputs.applicationDidFinishLaunching(application: application, launchOptions: launchOptions)
        
        return self.viewModel.outputs.applicationDidFinishLaunchingReturnValue
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        self.viewModel.inputs.applicationWillEnterForeground()
    }
    
    func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        self.viewModel.inputs.applicationPerformActionForShortcutItem(shortcutItem)
        completionHandler(true)
    }
    
    
    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        return true
    }
    
    private var deduplicationNotificationToken: NotificationToken!
    
    private func setDefaultRealmForTiket() {
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
    
    private func isDefaultRealmConfigured() -> Bool {
        return try! !Realm().isEmpty
    }
}

