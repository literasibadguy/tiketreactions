//
//  FlightOrderListVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 02/10/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import UIKit

internal final class FlightOrderListVC: UIViewController {
    
    fileprivate let viewModel: FlightOrderListViewModelType = FlightOrderListViewModel()
    
    @IBOutlet fileprivate weak var orderTableView: UITableView!
    @IBOutlet fileprivate weak var loadingOverlayView: UIView!
    @IBOutlet fileprivate weak var activityIndicatorView: UIActivityIndicatorView!
    
    @IBOutlet fileprivate weak var navigationPaymentView: UIView!
    @IBOutlet fileprivate weak var navigationSeparatorView: UIView!
    
    @IBOutlet fileprivate weak var paymentMethodButton: UIButton!
    
    internal static func instantiate() -> FlightOrderListVC {
        let vc = Storyboard.OrderList.instantiate(FlightOrderListVC.self)
        return vc
    }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.inputs.viewWillAppear(animated)
    }
    
    internal override func bindStyles() {
        super.bindStyles()
        
        _ = self.orderTableView
            |> UITableView.lens.rowHeight .~ UITableViewAutomaticDimension
            |> UITableView.lens.estimatedRowHeight .~ 160.0
            |> UITableView.lens.separatorStyle .~ .none
        
        _ = self.activityIndicatorView
            |> baseActivityIndicatorStyle
        
        _ = self.loadingOverlayView
            |> UIView.lens.backgroundColor .~ UIColor(white: 1.0, alpha: 0.99)
            |> UIView.lens.isHidden .~ false
        
        _ = self.paymentMethodButton
            |> UIButton.lens.backgroundColor(forState: .normal) .~ .tk_official_green
            |> UIButton.lens.backgroundColor(forState: .disabled) .~ .tk_base_grey_100
        
        _ = self.navigationSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
}
