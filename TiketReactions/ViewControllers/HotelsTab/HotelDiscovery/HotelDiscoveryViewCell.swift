//
//  HotelDiscoveryViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 10/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Spring
import Prelude
import ReactiveSwift
import Result
import TiketKitModels
import UIKit

internal final class HotelDiscoveryViewCell: UITableViewCell, ValueCell {
    typealias Value = HotelResult
    
    fileprivate let viewModel: HotelResultCardViewModelType = HotelResultCardViewModel()
    
    @IBOutlet fileprivate weak var cardView: UIView!
    @IBOutlet fileprivate weak var hotelStackView: UIStackView!
    @IBOutlet fileprivate weak var featuredHotelImageView: UIImageView!
    @IBOutlet fileprivate weak var hotelInfoStackView: UIStackView!
    @IBOutlet fileprivate weak var hotelNameLabel: UILabel!
    @IBOutlet fileprivate weak var hotelCityLabel: UILabel!
    @IBOutlet fileprivate weak var hotelRatingStackView: UIStackView!
    @IBOutlet fileprivate weak var separatorRatingView: UIView!
    @IBOutlet fileprivate weak var reviewRatingLabel: UILabel!
    @IBOutlet fileprivate weak var hotelRatingImageView: UIImageView!
    @IBOutlet fileprivate weak var hotelPriceLabel: UILabel!
    @IBOutlet fileprivate weak var discoverySeparatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    internal override func bindStyles() {
        super.bindStyles()
        
        _ = self
            |> baseTableViewCellStyle()
            |> HotelDiscoveryViewCell.lens.contentView.layoutMargins %~~ { _, cell in
                cell.traitCollection.isRegularRegular
                    ? .init(topBottom: Styles.grid(4), leftRight: Styles.grid(30))
                    : .init(topBottom: Styles.grid(3), leftRight: Styles.grid(2))
        }
        
        _ = self.hotelStackView
            |> UIStackView.lens.spacing .~ Styles.grid(2)
        
        _ = self.hotelInfoStackView
            |> UIStackView.lens.spacing .~ Styles.grid(1)
        
        _ = self.hotelNameLabel
            |> UILabel.lens.font .~ UIFont.boldSystemFont(ofSize: 16.0)
            |> UILabel.lens.numberOfLines .~ 2
            |> UILabel.lens.textColor .~ .black
        
        _ = self.hotelCityLabel
            |> UILabel.lens.font .~ UIFont.systemFont(ofSize: 14.0)
            |> UILabel.lens.textColor .~ .tk_dark_grey_400
        
        _ = self.hotelPriceLabel
            |> UILabel.lens.font .~ UIFont.boldSystemFont(ofSize: 18.0)
            |> UILabel.lens.textColor .~ .tk_official_green
        
        _ = self.discoverySeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.separatorRatingView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
        
        _ = self.reviewRatingLabel
            |> UILabel.lens.textColor .~ .tk_typo_green_grey_600
        
        _ = self.featuredHotelImageView
            |> UIImageView.lens.layer.masksToBounds .~ true
    }
    
    internal override func bindViewModel() {
        super.bindViewModel()
        
        self.hotelNameLabel.rac.text = self.viewModel.outputs.hotelNameTitleLabelText
        self.hotelCityLabel.rac.text = self.viewModel.outputs.hotelCityTitleLabelText
        self.hotelPriceLabel.rac.text = self.viewModel.outputs.hotelPriceTitleLabelText
        self.reviewRatingLabel.rac.text = self.viewModel.outputs.ratingReviewTitleLabelText
        
        self.viewModel.outputs.hotelImageURL
            .observe(on: UIScheduler())
            .on(event: { [weak self] _ in
                print("Some Photos is nil")
                self?.featuredHotelImageView.af_cancelImageRequest()
                self?.featuredHotelImageView.image = nil
            })
            .skipNil()
            .observeValues { [weak self] url in
                print("Some photos is not nil: \(url)")
                self?.featuredHotelImageView.ck_setImageWithURL(url)
        }
        
        self.viewModel.outputs.ratingImage
            .observe(on: UIScheduler())
            .observeValues { [weak self] star in
                self?.hotelRatingImageView.image = star
        }
    }
    
    func configureWith(value: HotelResult) {
        self.viewModel.inputs.configureWith(hotel: value)
    }
    
}
