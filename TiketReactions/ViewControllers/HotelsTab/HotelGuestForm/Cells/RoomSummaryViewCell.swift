//
//  RoomSummaryViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 15/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import TiketAPIs
import UIKit

class RoomSummaryViewCell: UITableViewCell, ValueCell {
    
    typealias Value = AvailableRoom
    
    @IBOutlet fileprivate weak var roomSummaryStackView: UIStackView!
    @IBOutlet fileprivate weak var roomStackView: UIStackView!
    @IBOutlet fileprivate weak var roomImageView: UIImageView!
    @IBOutlet fileprivate weak var roomNameLabel: UILabel!
    @IBOutlet fileprivate weak var breakfastStatusLabel: UILabel!
    
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
        
        _ = self.roomSummaryStackView
            |> UIStackView.lens.layoutMargins %~~ { _, stackView in
                stackView.traitCollection.isRegularRegular
                    ? .init(topBottom: Styles.grid(6), leftRight: Styles.grid(4))
                    : .init(top: Styles.grid(4), left: Styles.grid(4), bottom: Styles.grid(3), right: Styles.grid(2))
            }
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
            |> UIStackView.lens.spacing .~ 6
    }
    
    func configureWith(value: AvailableRoom) {
        _ = self.roomNameLabel
            |> UILabel.lens.text .~ value.roomName
        
        self.roomImageView.ck_setImageWithURL(URL(string: value.photoUrl)!)
        
    }
}
