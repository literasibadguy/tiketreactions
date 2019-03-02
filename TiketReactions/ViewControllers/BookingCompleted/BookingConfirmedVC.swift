//
//  BookingConfirmedVC.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 18/10/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import UIKit

public final class BookingConfirmedVC: UIViewController {
    
    fileprivate let viewModel: BookingCompletedViewModelType = BookingCompletedViewModel()
    
    @IBOutlet private weak var noticeThanksContainerView: UIView!
    @IBOutlet private weak var noticeStackView: UIStackView!
    @IBOutlet private weak var thankYouLabel: UILabel!
    @IBOutlet private weak var noticeLabel: UILabel!
    
    @IBOutlet private weak var headIssueStackView: UIStackView!
    @IBOutlet private weak var headHotelLabel: UILabel!
    @IBOutlet private weak var orderIdLabel: UILabel!
    @IBOutlet private weak var headIssueSeparatorView: UIView!
    
    @IBOutlet private weak var detailIssueStackView: UIStackView!
    
    @IBOutlet private weak var guestNameStackView: UIStackView!
    @IBOutlet private weak var guestNameTitleLabel: UILabel!
    @IBOutlet private weak var guestNameLabel: UILabel!
    
    @IBOutlet private weak var checkInStackView: UIStackView!
    @IBOutlet private weak var checkInTitleLabel: UILabel!
    @IBOutlet private weak var checkInLabel: UILabel!
    
    @IBOutlet private weak var roomStackView: UIStackView!
    @IBOutlet private weak var roomTitleLabel: UILabel!
    @IBOutlet private weak var roomLabel: UILabel!
    
    @IBOutlet private weak var breakfastStackView: UIStackView!
    @IBOutlet private weak var breakfastTitleLabel: UILabel!
    @IBOutlet private weak var breakfastLabel: UILabel!
    
    @IBOutlet private weak var printVoucherButton: UIButton!
    
    public static func instantiate()  -> BookingConfirmedVC {
        let vc = Storyboard.BookingCompleted.instantiate(BookingConfirmedVC.self)
        return vc
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.viewModel.inputs.viewDidLoad()
    }
    
    public override func bindStyles() {
        super.bindStyles()
        
        
    }
    
    public override func bindViewModel() {
        super.bindViewModel()
    }
}
