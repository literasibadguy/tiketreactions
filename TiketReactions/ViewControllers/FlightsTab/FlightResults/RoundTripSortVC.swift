//
//  RoundTripNavVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 30/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

internal protocol RoundTripSortViewDelegate: class {
    func sortButtons(_ viewController: UIViewController, selectedSort sort: SearchFlightParams)
}

internal final class RoundTripSortVC: UIViewController {
    fileprivate let viewModel: RoundTripSortViewModelType = RoundTripSortViewModel()
    internal weak var delegate: RoundTripSortViewDelegate?
    
    @IBOutlet fileprivate weak var borderView: UIView!
    
    @IBOutlet fileprivate weak var roundTripStackView: UIStackView!
    @IBOutlet fileprivate weak var separatorSelectedView: UIView!
    
    @IBOutlet fileprivate weak var separatorSelectedLeadingConstraint: NSLayoutConstraint!
    
    @IBOutlet fileprivate weak var separatorSelectedWidthConstraint: NSLayoutConstraint!
    
    @IBOutlet fileprivate weak var departButton: UIButton!
    @IBOutlet fileprivate weak var returnButton: UIButton!
    
    internal func configureWith(sorts: [SearchFlightParams]) {
        self.viewModel.inputs.configureWith(sorts: sorts)
    }
    
    internal func select(sort: SearchFlightParams) {
        self.viewModel.inputs.select(sort: sort)
    }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.departButton.addTarget(self, action: #selector(departButtonTapped), for: .touchUpInside)
        self.returnButton.addTarget(self, action: #selector(returnButtonTapped), for: .touchUpInside)
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.inputs.viewWillAppear()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.viewModel.inputs.viewDidAppear()
    }
    
    internal override func bindStyles() {
        super.bindStyles()
        
        _ = self.departButton
            |> UIButton.lens.tag .~ 0
        
        _ = self.returnButton
            |> UIButton.lens.tag .~ 1
    }
    
    internal override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.setSelectedButton
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.selectButton(atIndex: $0)
        }
        
        self.viewModel.outputs.notifyDelegateOfSelectedSort
            .observe(on: UIScheduler())
            .observeValues { [weak self] sort in
                guard let _self = self else { return }
                print("NOTIFY DELEGATE OF SELECTED SORT: \(sort)")
                _self.delegate?.sortButtons(_self, selectedSort: sort)
        }
    }
    
    fileprivate func selectButton(atIndex index: Int) {
        for (idx, button) in self.roundTripStackView.arrangedSubviews.enumerated() {
            _ = (button as? UIButton)
                ?|> UIButton.lens.isSelected .~ (idx == index)
        }
    }
    
    fileprivate func pinSelectedIndicator(toPage page: Int, animated: Bool) {
        guard let button = self.roundTripStackView.arrangedSubviews[page] as? UIButton else { return }
        
        let leadingConstant = self.roundTripStackView.frame.origin.x
        let widthConstant = button.frame.width
        
        self.separatorSelectedLeadingConstraint.constant = leadingConstant
        self.separatorSelectedWidthConstraint.constant = widthConstant
    }
    
    /*
    fileprivate func updateSortStyle(sorts: [SearchFlightParams], animated: Bool) {
        let zipped = zip(sorts, self.roundTripStackView.arrangedSubviews)
    }
    */
    
    @objc fileprivate func departButtonTapped() {
        self.viewModel.inputs.departureButtonTapped(index: 0)
    }
    
    
    @objc fileprivate func returnButtonTapped() {
        self.viewModel.inputs.arrivalButtonTapped(index: 1)
    }
}
