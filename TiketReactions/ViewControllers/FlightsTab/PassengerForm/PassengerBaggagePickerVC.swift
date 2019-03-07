//
//  PassengerBaggagePickerVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 02/03/19.
//  Copyright © 2019 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import UIKit
import TiketKitModels

internal protocol PassengerDepartBaggagePickerDelegate: class {
    func passengerBaggagePicker(_ controller: PassengerBaggagePickerVC, choseBaggage: ResourceBaggage)
    func passengerBaggageCanceled(_ controller: PassengerBaggagePickerVC)
}

internal protocol PassengerReturnBaggagePickerDelegate: class {
    func passengerReturnBaggagePicker(_ controller: PassengerBaggagePickerVC, choseBaggage: ResourceBaggage)
    func passengerReturnBaggageCanceled(_ controller: PassengerBaggagePickerVC)
}

internal final class PassengerBaggagePickerVC: UIViewController {
    fileprivate var dataSource: [ResourceBaggage] = []
    
    fileprivate let viewModel: PassengerBaggagePickerViewModelType = PassengerBaggagePickerViewModel()
    
    @IBOutlet fileprivate weak var baggagePickerView: UIPickerView!
    @IBOutlet fileprivate weak var topSeparatorView: UIView!
    @IBOutlet fileprivate weak var baggageStackView: UIStackView!
    @IBOutlet fileprivate weak var baggageInputLabel: UILabel!
    @IBOutlet fileprivate weak var doneButton: UIButton!
    @IBOutlet fileprivate weak var baggageView: UIView!
    
    internal weak var departDelegate: PassengerDepartBaggagePickerDelegate!
    internal weak var returnDelegate: PassengerReturnBaggagePickerDelegate!
    
    static func configureWith(_ baggages: [ResourceBaggage]) -> PassengerBaggagePickerVC {
        let vc = Storyboard.PassengerForm.instantiate(PassengerBaggagePickerVC.self)
        vc.viewModel.inputs.configureBaggage(baggages)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        self.baggagePickerView.dataSource = self
        self.baggagePickerView.delegate = self
        
        // Do any additional setup after loading the view.
        self.viewModel.inputs.viewDidLoad()
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self
            |> baseControllerStyle()
            |> UIViewController.lens.view.backgroundColor .~ UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        
        _ = self.baggageStackView
            |> UIStackView.lens.layoutMargins %~~ { _, stackView in
                stackView.traitCollection.isRegularRegular ? .init(topBottom: Styles.grid(0), leftRight: Styles.grid(4)) : .init(top: Styles.grid(0), left: Styles.grid(2), bottom: Styles.grid(0), right: Styles.grid(2))
                
            }
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
            |> UIStackView.lens.spacing .~ Styles.grid(1)
        
        _ = self.baggagePickerView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.doneButton
            |> UIButton.lens.backgroundColor .~ .tk_official_green
        
        _ = self.topSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.dataSource
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] in
                self?.dataSource = $0
                self?.baggagePickerView.reloadAllComponents()
        }
        
        self.viewModel.outputs.notifyDelegateChoseBaggage
            .observe(on: QueueScheduler.main)
            .observeValues { [weak self] baggage in
                guard let _self = self else { return }
                _self.departDelegate?.passengerBaggageCanceled(_self)
                _self.departDelegate?.passengerBaggagePicker(_self, choseBaggage: baggage)
                _self.returnDelegate?.passengerReturnBaggageCanceled(_self)
                _self.returnDelegate?.passengerReturnBaggagePicker(_self, choseBaggage: baggage)
        }
    }
    
    @objc fileprivate func doneButtonTapped() {
        self.viewModel.inputs.doneButtonTapped()
    }
}

extension PassengerBaggagePickerVC: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataSource.count
    }
}

extension PassengerBaggagePickerVC: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.dataSource[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.viewModel.inputs.pickerView(didSelectRow: row)
    }
}
