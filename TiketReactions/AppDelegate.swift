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
        
        AppEnvironment.replaceCurrentEnvironment(
            AppEnvironment.fromStorage(ubiquitousStore: NSUbiquitousKeyValueStore.default, userDefaults: UserDefaults.standard)
        )
        
        self.viewModel.outputs.tokenIntoEnvironment
            .observe(on: UIScheduler())
            .observeValues { tokenEnvelope in
                print("WHATS IN TOKEN ENVELOPE: \(tokenEnvelope)")
                AppEnvironment.getToken(tokenEnvelope)
                GMSPlacesClient.provideAPIKey("AIzaSyDY06nW1UVnDikX07QDJfJYkPIqVVofxtM")
                GMSServices.provideAPIKey("AIzaSyDY06nW1UVnDikX07QDJfJYkPIqVVofxtM")
        }
        
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

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([Any]?) -> Void) -> Bool {
        return true
    }


}

