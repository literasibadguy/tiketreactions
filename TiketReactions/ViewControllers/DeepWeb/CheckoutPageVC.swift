//
//  CheckoutPageVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 12/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import KINWebBrowser
import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit
import WebKit

internal final class CheckoutPageVC: CurrentWebViewController {
    
    fileprivate let activityIndicator = UIActivityIndicatorView()
    
    fileprivate let viewModel: CheckoutPageViewModelType = CheckoutPageViewModel()
    
    internal static func configuredWith(initialRequest: URLRequest) -> CheckoutPageVC {
        let vc = Storyboard.CheckoutPage.instantiate(CheckoutPageVC.self)
        vc.viewModel.inputs.configureWith(initialRequest: initialRequest)
        return vc
    }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(self.activityIndicator)
        
        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(cancelButtonTapped))
        
        self.activityIndicator.center = self.view.center
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    internal override func bindStyles() {
        super.bindStyles()
        
        _ = self.activityIndicator
            |> baseActivityIndicatorStyle
    }
    
    internal override func bindViewModel() {
        super.bindViewModel()
        
        self.activityIndicator.rac.animating = self.viewModel.outputs.webIsLoading
        
        self.viewModel.outputs.popViewController
            .observe(on: UIScheduler())
            .observeValues { [weak self] _ in
                self?.popViewController()
        }
        
        self.viewModel.outputs.webViewLoadRequest
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] request in
                self?.webView.load(request)
                self?.viewModel.inputs.webViewConfirm(self?.webView.isLoading ?? false)
        }
    }
    
    internal func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        self.viewModel.inputs.webViewConfirm(false)
    }
    
    internal func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        self.viewModel.inputs.webViewConfirm(false)
    }
    
    @objc fileprivate func cancelButtonTapped() {
        self.viewModel.inputs.cancelButtonTapped()
    }

    fileprivate func popViewController() {
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
    
}
