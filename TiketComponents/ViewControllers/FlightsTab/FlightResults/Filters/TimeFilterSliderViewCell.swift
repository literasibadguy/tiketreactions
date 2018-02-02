//
//  TimeFilterSliderViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 31/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import UIKit

class TimeFilterSliderViewCell: UITableViewCell, ValueCell {
    
    typealias Value = String
    
    @IBOutlet fileprivate weak var valueSlider: UISlider!
    @IBOutlet fileprivate weak var valueTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

    @IBAction fileprivate func sliderValueHaveChanged(_ sender: UISlider) {
        
    }
    
    func configureWith(value: String) {
        
    }
}
