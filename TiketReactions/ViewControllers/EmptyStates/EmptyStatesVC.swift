//
//  EmptyStatesVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 25/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import UIKit

internal final class EmptyStatesVC: UIViewController {
    
    @IBOutlet fileprivate weak var titleLabel: UILabel!
    @IBOutlet fileprivate weak var subtitleLabel: UILabel!
    
    fileprivate let viewModel: EmptyStatesViewModelType = EmptyStatesViewModel()
    
    internal static func configuredWith(emptyState: EmptyState?) -> EmptyStatesVC {
        let vc = Storyboard.EmptyStates.instantiate(EmptyStatesVC.self)
        vc.viewModel.inputs.configureWith(emptyState: emptyState)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.inputs.viewWillAppear()
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.titleLabel.rac.text = self.viewModel.outputs.titleLabelText
        self.subtitleLabel.rac.text = self.viewModel.outputs.subtitleLabelText
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self.view
            |> UIView.lens.backgroundColor .~ .white
            |> UIView.lens.layoutMargins .~ (self.traitCollection.isRegularRegular ? .init(top: 0, left: Styles.grid(4), bottom: Styles.grid(5), right: Styles.grid(4)) : .init(top: 0, left: Styles.grid(2), bottom: Styles.grid(3), right: Styles.grid(2)))
    }
    
    internal func setEmptyState(_ emptyState: EmptyState) {
        self.viewModel.inputs.setEmptyState(emptyState)
    }
}
