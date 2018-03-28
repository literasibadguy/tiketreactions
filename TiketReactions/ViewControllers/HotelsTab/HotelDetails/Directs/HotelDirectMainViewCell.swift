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
    
    typealias Value = HotelDirect

    @IBOutlet fileprivate weak var hotelDirectStackView: UIStackView!
    
    @IBOutlet fileprivate weak var hotelMainImageView: UIImageView!
    @IBOutlet fileprivate weak var hotelTitleLabel: UILabel!
    @IBOutlet fileprivate weak var hotelCityLabel: UILabel!
    @IBOutlet fileprivate weak var starImageView: UIImageView!
    @IBOutlet fileprivate weak var hotelDescriptionLabel: UILabel!
    @IBOutlet fileprivate weak var readMoreButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = hotelMainImageView
            |> UIImageView.lens.contentMode .~ .scaleAspectFill
            |> UIImageView.lens.backgroundColor .~ .gray
        
        _ = self.hotelTitleLabel
            |> UILabel.lens.font %~~ { _, label in
                label.traitCollection.isRegularRegular
                    ? UIFont.boldSystemFont(ofSize: 28)
                : UIFont.boldSystemFont(ofSize: 24)
            }
            |> UILabel.lens.numberOfLines .~ 0
        
        _ = self.hotelDescriptionLabel
            |> UILabel.lens.font %~~ { _, label in
                label.traitCollection.isRegularRegular
                    ? UIFont.systemFont(ofSize: 18)
                    : UIFont.systemFont(ofSize: 15)
            }
            |> UILabel.lens.numberOfLines .~ 0
        
        _ = self.hotelDirectStackView
            |> UIStackView.lens.spacing .~ Styles.grid(4)
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
            |> UIStackView.lens.layoutMargins %~~ { _, view in
                view.traitCollection.isRegularRegular
                    ? .init(top: Styles.grid(6), left: Styles.grid(16), bottom: Styles.grid(18), right: Styles.grid(16)) : .init(top: Styles.grid(4), left: Styles.grid(4), bottom: Styles.grid(16), right: Styles.grid(4))
        }
        
        _ = self.readMoreButton
            |> UIButton.lens.titleColor(forState: .normal) .~ UIColor.tk_official_green
            |> UIButton.lens.titleLabel.font .~ UIFont.boldSystemFont(ofSize: 15.0)
            |> UIButton.lens.title(forState: .normal) .~ "Baca lebih"
            |> UIButton.lens.contentEdgeInsets .~ .init(top: Styles.grid(3) - 1, left: 0, bottom: Styles.grid(4) - 1, right: 0)
        
    }
    
    func configureWith(value: HotelDirect) {
        
        _ = self.hotelTitleLabel
            |> UILabel.lens.text .~ value.breadcrumb.businessName
        self.hotelMainImageView.ck_setImageWithURL(URL(string: value.largePhotos)!)
        
        _ = self.hotelCityLabel
            |> UILabel.lens.text .~ value.breadcrumb.cityName
        
        _ = self.starImageView
            |> UIImageView.lens.image .~ UIImage(named: ratingForStar(rating: value.breadcrumb.starRating))
        
        _ = self.hotelDescriptionLabel
            |> UILabel.lens.text .~ "Don't forget this is the best hotel in the world, How can you discomfort yourself in your room when this hotel is trying be the best experience without any public matters. When we speak 'only you', not everyone anymore It's you somehow you need to catch these situations without take another opportunities"
        
        
    }
    
    private func ratingForStar(rating: String) -> String {
        switch rating {
        case "5":
            return "star-rating-five"
        case "4":
            return "star-rating-four"
        case "3":
            return "star-rating-three"
        case "2":
            return "star-rating-two"
        case "1":
            return "star-rating-one"
        default:
            return "Tidak ada bintang"
        }
    }
}
