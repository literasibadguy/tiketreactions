//
//  CheckoutPageVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 12/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

internal final class CheckoutPageVC: LatestWebViewController {
    
    fileprivate let viewModel: CheckoutPageViewModelType = CheckoutPageViewModel()
    
    internal static func configuredWith(initialRequest: URLRequest) -> CheckoutPageVC {
        let vc = Storyboard.CheckoutPage.instantiate(CheckoutPageVC.self)
        vc.viewModel.inputs.configureWith(initialRequest: initialRequest)
        return vc
    }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    internal override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.popViewController
            .observe(on: UIScheduler())
            .observeValues { [weak self] _ in
                self?.popViewController()
        }
        
        self.viewModel.outputs.webViewLoadRequest
            .observe(on: UIScheduler())
            .observeValues { [weak self] request in
                self?.webView.loadRequest(request)
        }
    }

    @objc fileprivate func cancelButtonTapped() {
        self.viewModel.inputs.cancelButtonTapped()
    }
    
    fileprivate func popViewController() {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
}
