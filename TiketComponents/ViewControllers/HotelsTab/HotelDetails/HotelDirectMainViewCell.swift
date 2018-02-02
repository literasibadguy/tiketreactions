//
//  HotelDirectViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 01/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import UIKit


class HotelDirectMainViewCell: UITableViewCell, ValueCell {
    
    typealias Value = String

    @IBOutlet fileprivate weak var hotelDirectStackView: UIStackView!
    
    @IBOutlet fileprivate weak var hotelMainImageView: UIImageView!
    @IBOutlet fileprivate weak var hotelTitleLabel: UILabel!
    
    func configureWith(value: String) {
        self.hotelTitleLabel.text = value
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = hotelMainImageView
            |> UIImageView.lens.contentMode .~ .scaleAspectFit
            |> UIImageView.lens.backgroundColor .~ .gray
        
        _ = self.hotelTitleLabel
            |> UILabel.lens.font %~~ { _, label in
                label.traitCollection.isRegularRegular
                    ? UIFont.boldSystemFont(ofSize: 28)
                : UIFont.boldSystemFont(ofSize: 20)
            }
            |> UILabel.lens.numberOfLines .~ 0
        
        _ = self.hotelDirectStackView
            |> UIStackView.lens.spacing .~ Styles.grid(15)
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
            |> UIStackView.lens.layoutMargins %~~ { _, view in
                view.traitCollection.isRegularRegular
                    ? .init(top: Styles.grid(6), left: Styles.grid(16), bottom: Styles.grid(18), right: Styles.grid(16)) : .init(top: Styles.grid(4), left: Styles.grid(4), bottom: Styles.grid(16), right: Styles.grid(4))
        }
    }
}
