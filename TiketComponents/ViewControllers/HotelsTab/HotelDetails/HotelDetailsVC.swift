//
//  HotelDetailsVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 02/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit

protocol HotelDetailsVCDelegate: class {
    func hotelDetails(_ controller: HotelDetailsVC, panGestureRecognizerDidChange recognizer: UIPanGestureRecognizer)
}

class HotelDetailsVC: UIViewController {
    weak var delegate: HotelDetailsVCDelegate?
    
    private let navDetailsVC: HotelDetailsNavVC!
    private let directsHotelVC: HotelDirectsVC!
    
    static func instantiate() -> HotelDetailsVC {
        let vc = Storyboard.HotelDirects.instantiate(HotelDetailsVC.self)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }
    
}
