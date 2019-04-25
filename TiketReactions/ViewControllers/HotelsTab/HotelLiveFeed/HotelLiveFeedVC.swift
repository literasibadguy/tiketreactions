//
//  HotelLiveFeedVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 06/05/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import UIKit
import TiketKitModels

internal final class HotelLiveFeedVC: UIViewController {
    
    fileprivate let viewModel: HotelLiveFeedViewModelType = HotelLiveFeedViewModel()
    
    private weak var navigationHeaderVC: HotelLiveFeedNavVC!
    private weak var contentVC: HotelLiveFeedContentVC!
    
    internal static func instantiate() -> HotelLiveFeedVC {
        return Storyboard.HotelLiveFeed.instantiate(HotelLiveFeedVC.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationHeaderVC = self.children.compactMap { $0 as? HotelLiveFeedNavVC }.first
        self.navigationHeaderVC.delegate = self
        self.contentVC = self.children.compactMap { $0 as? HotelLiveFeedContentVC }.first
//        self.navigationHeaderVC.delegate = self
        
        self.viewModel.inputs.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.inputs.viewWillAppear(animated: animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.configureNavigationHeader
            .observe(on: UIScheduler())
            .observeValues { [weak self] navigation in
                print("WHATS CURRENT NAVIGATION: \(navigation)")
                self?.navigationHeaderVC.configureWith(params: navigation)
        }
        
        self.viewModel.outputs.loadFilterIntoDataSource
            .observe(on: UIScheduler())
            .observeValues { [weak self] filter in
                self?.contentVC.change(filter: filter)
        }
    }
    
    internal func filter(with params: SearchHotelParams) {
        self.viewModel.inputs.filter(withParams: params)
    }
}

extension HotelLiveFeedVC: HotelLiveFeedNavViewDelegate {
    func hotelLiveFeedNavigationFilterSelectedParams(_ params: SearchHotelParams) {
        self.viewModel.inputs.filter(withParams: params)
    }
}

