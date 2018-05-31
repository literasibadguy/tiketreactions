//
//  GuestRoomPickerVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 18/05/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import Spring
import UIKit

public protocol GuestRoomPickerDelegate: class {
    func guestRoomPickerVC(_ controller: GuestRoomPickerVC, guest: Int, room: Int)
}

public final class GuestRoomPickerVC: UIViewController {
    fileprivate var dataSource: [[String]] = [[String]]()
    fileprivate let viewModel: GuestRoomPickerViewModelType = GuestRoomPickerViewModel()
    
    
    
    @IBOutlet fileprivate weak var guestPickerView: UIPickerView!
    @IBOutlet fileprivate weak var guestInputTitleLabel: UILabel!
    
    @IBOutlet fileprivate weak var navigationPickerView: UIView!
    @IBOutlet fileprivate weak var doneButton: DesignableButton!
    
    @IBOutlet fileprivate weak var topSeparatorView: UIView!
    @IBOutlet fileprivate weak var bottomSeparatorView: UIView!
    
    weak var delegate: GuestRoomPickerDelegate?
    
    public static func configuredWith(guest: Int, room: Int) -> GuestRoomPickerVC {
        let vc = Storyboard.HotelForm.instantiate(GuestRoomPickerVC.self)
        vc.viewModel.inputs.configureWith(guest: guest, room: room)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        self.doneButton.setBackgroundColor(.tk_official_green, forState: .normal)
        self.doneButton.cornerRadius = 8.0
        
        // Do any additional setup after loading the view.
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.viewModel.inputs.viewWillAppear()
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        _ = self
            |> baseControllerStyle()
            |> UIViewController.lens.view.backgroundColor .~ UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
        
        _ = self.guestInputTitleLabel
            |> UILabel.lens.text .~ Localizations.GuestRoomTitleForm
        
        _ = self.navigationPickerView
            |> UIView.lens.backgroundColor .~ .white
        
        _ = self.doneButton
            |> UIButton.lens.title(forState: .normal) .~ Localizations.DonebuttonTitle
        
        _ = self.guestPickerView
            |> UIView.lens.backgroundColor .~ .white
        
        
        _ = topSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        _ = bottomSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
        
        self.viewModel.outputs.dataSource
            .observe(on: UIScheduler())
            .observeValues { [weak self] in
                self?.dataSource = $0
                self?.guestPickerView.reloadAllComponents()
        }
        
        self.viewModel.outputs.selectRow
            .observe(on: UIScheduler())
            .observeValues { [weak self] row in
                self?.guestPickerView.selectRow(row.0, inComponent: 0, animated: true)
                self?.guestPickerView.selectRow(row.1, inComponent: 1, animated: true)
        }
        
        self.viewModel.outputs.notifyDelegateToChoseGuestRoom
            .observe(on: UIScheduler())
            .observeValues { [weak self] guest, room in
                guard let _self = self else { return }
                _self.delegate?.guestRoomPickerVC(_self, guest: guest, room: room)
        }
    }
    
    @objc fileprivate func doneButtonTapped() {
        self.viewModel.inputs.doneButtonTapped()
    }
}

extension GuestRoomPickerVC: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataSource[component].count
    }
}

extension GuestRoomPickerVC: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.dataSource[component][row]
    }
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("WHAT PICKED: \(self.dataSource[component][row])")
        self.viewModel.inputs.pickerView(didSelectRow: row, component: component)
    }
    
    public func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var pickerLabel: UILabel? = (view as? UILabel)
        if pickerLabel == nil {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFont(ofSize: 16.0, weight: .medium)
            pickerLabel?.textAlignment = .center
        }
        pickerLabel?.text = self.dataSource[component][row]
        pickerLabel?.textColor = UIColor.tk_typo_green_grey_600
        
        return pickerLabel!
    }
}

