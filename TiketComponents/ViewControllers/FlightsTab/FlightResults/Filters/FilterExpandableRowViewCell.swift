//
//  FilterExpandableRowViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 31/01/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import UIKit

class FilterExpandableRowViewCell: UITableViewCell, ValueCell {
    
    typealias Value = String
    
    @IBOutlet fileprivate weak var expandableStackView: UIStackView!
    @IBOutlet fileprivate weak var expandableTitleLabel: UILabel!
    @IBOutlet fileprivate weak var pickGreenArrow: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self.expandableStackView
            |> UIStackView.lens.layoutMargins .~ .init(left: Styles.grid(2))
    }
    
    
    func configureWith(value: String) {
        
    }
}
