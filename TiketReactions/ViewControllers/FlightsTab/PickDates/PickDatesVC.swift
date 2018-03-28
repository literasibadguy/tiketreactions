//
//  PickDatesVC.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 29/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import Spring
import UIKit

class PickDatesVC: UIViewController {
    
    let dataSource = PickDatesDataSource()
    
    @IBOutlet fileprivate weak var headDateTitleLabel: UILabel!
    @IBOutlet fileprivate weak var cancelButton: UIButton!
    @IBOutlet fileprivate weak var dateCollectionView: UICollectionView!
    @IBOutlet fileprivate weak var flightFindButton: DesignableButton!

    @IBOutlet fileprivate weak var headTitleStackView: UIStackView!
    
    
    static func instantiate() -> PickDatesVC {
        let vc = Storyboard.PickDates.instantiate(PickDatesVC.self)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.dateCollectionView.dataSource = dataSource
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self.headTitleStackView
            |> UIStackView.lens.layoutMargins .~ .init(top: Styles.grid(2))
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
    }
}
