//
//  HotelSummaryViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 01/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import UIKit

class HotelSummaryViewCell: UITableViewCell, ValueCell {
    
    typealias Value = String
    
    @IBOutlet fileprivate weak var summaryStackView: UIStackView!
    @IBOutlet fileprivate weak var endingView: UIView!
    
    @IBOutlet fileprivate weak var hotelImageContainerView: UIView!
    @IBOutlet fileprivate weak var metadataView: UIView!
    @IBOutlet fileprivate weak var contentMetadataStackView: UIStackView!
    
    @IBOutlet fileprivate weak var hotelNameLabel: UILabel!
    @IBOutlet fileprivate weak var blurbStackView: UIStackView!
    @IBOutlet fileprivate weak var hotelBlurbLabel: UILabel!
    
    @IBOutlet fileprivate weak var readMoreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func scrollContentOffset(_ offset: CGFloat) {
        let height = self.hotelImageContainerView.bounds.height
        let translation = offset / 2
        
        let scale: CGFloat
        if offset < 0 {
            scale = (height + abs(offset)) / height
        } else {
            scale = max(1, 1 - 0.5 * offset / height)
        }
        
        self.hotelImageContainerView.transform = CGAffineTransform(a: scale, b: 0, c: 0, d: scale, tx: 0, ty: translation)
    }

    override func bindStyles() {
        super.bindStyles()
        
        _ = self.blurbStackView
            |> UIStackView.lens.spacing .~ 0
        
        _ = self.contentMetadataStackView
            |> UIStackView.lens.layoutMargins %~~ { _, stackView in
                stackView.traitCollection.isRegularRegular ? .init(topBottom: Styles.grid(16), leftRight: Styles.grid(16)) : .init(top: Styles.grid(4), left: Styles.grid(4), bottom: Styles.grid(3), right: Styles.grid(4))
                }
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
            |> UIStackView.lens.spacing .~ Styles.grid(4)
    }
    
    func configureWith(value: String) {
        
    }
}
