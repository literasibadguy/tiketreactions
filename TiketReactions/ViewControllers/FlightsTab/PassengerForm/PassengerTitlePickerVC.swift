//
//  PassengerTitlePickerVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 26/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit
import Prelude

internal protocol PassengerTitlePickerVCDelegate: class {
    func passengerTitlePickerVC(_ controller: PassengerTitlePickerVC, choseTitle: String)
    
    func passengerTitlePickerVCCancelled(_ controller: PassengerTitlePickerVC)
}

class PassengerTitlePickerVC: UIViewController {
    fileprivate var dataSource: [String] = []
    internal weak var delegate: PassengerTitlePickerVCDelegate!
    @IBOutlet fileprivate weak var titlePickerView: UIPickerView!
    @IBOutlet fileprivate weak var titleView: UIView!
    @IBOutlet fileprivate weak var cancelButton: UIButton!
    @IBOutlet fileprivate weak var doneButton: UIButton!
    
    static func instantiate(delegate: PassengerTitlePickerVCDelegate) -> PassengerTitlePickerVC {
        let vc = Storyboard.PassengerForm.instantiate(PassengerTitlePickerVC.self)
        vc.delegate = delegate
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.cancelButton.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        self.doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
    }

    override func bindStyles() {
        super.bindStyles()
        
        _ = self
            |> UIViewController.lens.view.backgroundColor .~ .clear
    }
    
    @objc fileprivate func cancelButtonTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc fileprivate func doneButtonTapped() {
        self.dismiss(animated: true, completion: nil)
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
    }
}
