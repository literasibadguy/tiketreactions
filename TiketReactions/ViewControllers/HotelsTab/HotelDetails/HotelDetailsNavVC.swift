//
//  HotelDetailsNavVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 02/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

public final class HotelDetailsNavVC: UIViewController {
    
    fileprivate let viewModel: HotelDetailsNavViewModelType = HotelDetailsNavViewModel()
    
    @IBOutlet fileprivate weak var cancelButton: UIButton!
    @IBOutlet fileprivate weak var navSeparatorView: UIView!
    @IBOutlet fileprivate weak var titleDetailLabel: UILabel!
    
    internal func configureWith(selected: HotelResult) {
        self.viewModel.inputs.configureWith(hotel: selected)
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    override public func bindStyles() {
        super.bindStyles()
        
        _ = self.navSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.titleDetailLabel
            |> UILabel.lens.textColor .~ .tk_dark_grey_500
    }

    override public func bindViewModel() {
        super.bindViewModel()
        
        self.titleDetailLabel.rac.text = self.viewModel.outputs.hotelNameText
        
        self.viewModel.outputs.dismissViewController
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.dismiss(animated: true, completion: nil)
        }
    }
    
    
    @objc fileprivate func cancelButtonTapped() {
        self.viewModel.inputs.tappedButtonCancel()
    }
    
}
