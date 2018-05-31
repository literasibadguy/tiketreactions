//
//  PassengerTitlePickerVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 26/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit
import Prelude
import ReactiveSwift
import Spring

internal protocol PassengerTitlePickerVCDelegate: class {
    func passengerTitlePickerVC(_ controller: PassengerTitlePickerVC, choseTitle: String)
    
    func passengerTitlePickerVCCancelled(_ controller: PassengerTitlePickerVC)
}

internal final class PassengerTitlePickerVC: UIViewController {
    fileprivate var dataSource: [String] = []
    internal weak var delegate: PassengerTitlePickerVCDelegate!
    fileprivate let viewModel: PassengerTitlePickerViewModelType = PassengerTitlePickerViewModel()
    @IBOutlet fileprivate weak var titlePickerView: UIPickerView!
    @IBOutlet fileprivate weak var titleView: UIView!
    @IBOutlet fileprivate weak var titleStackView: UIStackView!
    
    
    @IBOutlet fileprivate weak var titleInputLabel: UILabel!
    @IBOutlet fileprivate weak var doneButton: DesignableButton!
    
    @IBOutlet fileprivate weak var topSeparatorView: UIView!
    @IBOutlet fileprivate weak var bottomSeparatorView: UIView!
    
    static func instantiate(titles: [String], selectedTitle: String, delegate: PassengerTitlePickerVCDelegate) -> PassengerTitlePickerVC {
        let vc = Storyboard.PassengerForm.instantiate(PassengerTitlePickerVC.self)
        let titles = [Localizations.MrFormData, Localizations.MrsFormData, Localizations.MsFormData]
        vc.viewModel.inputs.selectedSalutation(titles: titles, title: selectedTitle)
        vc.delegate = delegate
        return vc
    }
    
    internal override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    internal override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.inputs.viewWillAppear()
    }

    internal override func bindStyles() {
        super.bindStyles()
        
        _ = self
            |> baseControllerStyle()
            |> UIViewController.lens.view.backgroundColor .~ UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        
        _ = self.titleStackView
            |> UIStackView.lens.layoutMargins %~~ { _, stackView in
                stackView.traitCollection.isRegularRegular
                    ? .init(topBottom: Styles.grid(0), leftRight: Styles.grid(4))
                    : .init(top: Styles.grid(0), left: Styles.grid(2), bottom: Styles.grid(0), right: Styles.grid(2))
            }
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
            |> UIStackView.lens.spacing .~ Styles.grid(1)
        
        _ = self.titlePickerView
            |> UIView.lens.backgroundColor .~ .white
        
        self.doneButton.cornerRadius = 8.0
        self.doneButton.backgroundColor = .tk_official_green
        
        _ = self.topSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.bottomSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    internal override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.dataSource
            .observe(on: UIScheduler())
            .observeValues { [weak self]  in
                self?.dataSource = $0
                self?.titlePickerView.reloadAllComponents()
        }
        
        self.viewModel.outputs.selectRow
            .observe(on: UIScheduler())
            .observeValues { [weak self] row in
                self?.titlePickerView.selectRow(row, inComponent: 0, animated: true)
        }
        
        self.viewModel.outputs.notifyDelegateToCancel
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                guard let _self = self else { return }
                print("[NOTIFY DELEGATE TO CANCEL...]")
                _self.delegate?.passengerTitlePickerVCCancelled(_self)
        }
        
        self.viewModel.outputs.notifyDelegateChoseTitle
            .observe(on: UIScheduler())
            .observeValues { [weak self] title in
                guard let _self = self else { return }
                _self.delegate?.passengerTitlePickerVCCancelled(_self)
                _self.delegate?.passengerTitlePickerVC(_self, choseTitle: title)
        }
    }
    
    @objc fileprivate func doneButtonTapped() {
        self.viewModel.inputs.doneButtonTapped()
    }
}

extension PassengerTitlePickerVC: UIPickerViewDataSource {
    internal func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataSource.count
    }
}

extension PassengerTitlePickerVC: UIPickerViewDelegate {
    internal func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.dataSource[row]
    }
    
    internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("DID SELECT ROW ON PICKER")
        self.viewModel.inputs.pickerView(didSelectRow: row)
    }
}
