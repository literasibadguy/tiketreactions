//
//  RootTabBarVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 08/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

public final class RootTabBarVC: UITabBarController {
    fileprivate let viewModel: RootViewModelType = RootViewModel()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    override public func bindStyles() {
        super.bindStyles()
        
        _ = self.tabBar
            |> UITabBar.lens.tintColor .~ .tk_official_green
        
    }
    
    override public func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.setViewControllers
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.setViewControllers($0, animated: false)
        }
        
        self.viewModel.outputs.selectedIndex
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.selectedIndex = $0
        }
        
        self.viewModel.outputs.tabBarItemsData
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
//                self?.setTab
                print("Tab Bar Items Data: \($0)")
                self?.setTabBarItemsStyles(withData: $0)
        }
    }
    
    /*
    public func switchToFlight() {
        self.viewModel.inputs.switchToFlight()
    }
    */
    
    public func switchToHotelForm() {
        self.viewModel.inputs.switchToHotelForm()
    }
    
    public func switchToOrder() {
        self.viewModel.inputs.switchToOrder()
    }
    
    public func switchToAbout() {
        self.viewModel.inputs.switchToAbout()
    }
    
    fileprivate func setTabBarItemsStyles(withData data: TabBarItemsData) {
        data.items.forEach { item in
            switch item {
            case let .hotelForm(index):
                _ = tabBarItem(atIndex: index) ?|> hotelTabBarItemStyle()
            case let .order(index):
                _ = tabBarItem(atIndex: index) ?|> orderTabBarItemStyle()
            case let .about(index):
                _ = tabBarItem(atIndex: index) ?|> aboutTabBarItemStyle()
            }
        }
    }
    
    fileprivate func tabBarItem(atIndex index: Int) -> UITabBarItem? {
        if (self.tabBar.items?.count ?? 0) > index {
            if let item = self.tabBar.items?[index] {
                return item
            }
        }
        return nil
    }
}

extension RootTabBarVC: UITabBarControllerDelegate {
    public func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        self.viewModel.inputs.didSelectIndex(tabBarController.selectedIndex)
    }
}
