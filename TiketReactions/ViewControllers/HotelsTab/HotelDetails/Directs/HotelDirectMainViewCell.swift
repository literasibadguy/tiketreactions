//
//  HotelDirectViewCell.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 01/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude
import ReactiveSwift
import TiketKitModels
import UIKit

class HotelDirectMainViewCell: UITableViewCell, ValueCell {
    typealias Value = HotelDirect
    
    fileprivate let viewModel: HotelDirectMainCellViewModelType = HotelDirectMainCellViewModel()
    fileprivate let photoSource = HotelPhotosDataSource()

    @IBOutlet fileprivate weak var hotelDirectStackView: UIStackView!
    @IBOutlet fileprivate weak var hotelTitleLabel: UILabel!
    @IBOutlet fileprivate weak var hotelCityLabel: UILabel!
    @IBOutlet fileprivate weak var hotelInfoStackView: UIStackView!
    @IBOutlet fileprivate weak var photosCollectionView: UICollectionView!
    @IBOutlet fileprivate weak var ratingStackView: UIStackView!
    @IBOutlet fileprivate weak var ratingImageView: UIImageView!
    @IBOutlet fileprivate weak var hotelCrumbLabel: UILabel!
    @IBOutlet fileprivate weak var hotelInfoSeparatorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.photosCollectionView.dataSource = photoSource
    }
    
    override func bindStyles() {
        super.bindStyles()
        
        _ = self.hotelInfoStackView
            |> UIStackView.lens.layoutMargins %~~ { _, stackView in
                stackView.traitCollection.isRegularRegular
                    ? .init(topBottom: Styles.grid(6), leftRight: Styles.grid(16))
                    : .init(top: Styles.grid(4), left: Styles.grid(4), bottom: Styles.grid(3), right: Styles.grid(4))
            }
            |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
            |> UIStackView.lens.spacing .~ Styles.grid(2)

        _ = self.hotelTitleLabel
            |> UILabel.lens.numberOfLines .~ 2
            |> UILabel.lens.textColor .~ UIColor.tk_typo_green_grey_600
        
        _ = self.hotelCityLabel
            |> UILabel.lens.font %~~ { _, label in
                label.traitCollection.isRegularRegular
                    ? UIFont.systemFont(ofSize: 20)
                    : UIFont.systemFont(ofSize: 16)
            }
            |> UILabel.lens.textColor .~ UIColor.tk_typo_green_grey_500
        
        _ = self.hotelCrumbLabel
            |> UILabel.lens.font .~ UIFont.systemFont(ofSize: 14.0)
            |> UILabel.lens.textColor .~ UIColor.tk_dark_grey_400
            |> UILabel.lens.numberOfLines .~ 4
        
        _ = self.hotelInfoSeparatorView
            |> UIView.lens.backgroundColor .~ .tk_base_grey_100
    }
    
    override func bindViewModel() {
        super.bindViewModel()
        
        self.hotelTitleLabel.rac.text = self.viewModel.outputs.hotelnameTitleText
        self.hotelCityLabel.rac.text = self.viewModel.outputs.hotelProvinceTitleText
        
        self.viewModel.outputs.starRating
            .observe(on: UIScheduler())
            .observeValues { [weak self] rating in
                self?.ratingImageView.image = rating
        }
        
        self.viewModel.outputs.photos
            .observe(on: UIScheduler())
            .observeValues { [weak self] photos in
                self?.photoSource.load(photos: photos)
                self?.photosCollectionView.reloadData()
        }
        
        self.viewModel.outputs.firstRooms
            .observe(on: UIScheduler())
            .observeValues { [weak self] first in
                self?.hotelCrumbLabel.text = first.roomDescription
        }
        
    }
    
    func configureWith(value: HotelDirect) {
        self.viewModel.inputs.configureWith(hotel: value)
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

extension HotelDirectMainViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.hotelDirectStackView.bounds.width, height: self.photosCollectionView.bounds.height)
    }
}

