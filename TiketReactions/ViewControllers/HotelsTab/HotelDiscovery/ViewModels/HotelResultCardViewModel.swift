//
//  HotelResultCardViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 10/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import ReactiveSwift
import Result
import TiketKitModels

public protocol HotelResultCardViewModelInputs {
    func configureWith(hotel: HotelResult)
}

public protocol HotelResultCardViewModelOutputs {
    
    var hotelNameTitleLabelText: Signal<String, NoError> { get }
    var hotelCityTitleLabelText: Signal<String, NoError> { get }
    var hotelPriceTitleLabelText: Signal<String, NoError> { get }
    var ratingImage: Signal<UIImage, NoError> { get }
    var ratingReviewTitleLabelText: Signal<String, NoError> { get }
    var hotelImageURL: Signal<URL?, NoError> { get }
}

public protocol HotelResultCardViewModelType {
    var inputs: HotelResultCardViewModelInputs { get }
    var outputs: HotelResultCardViewModelOutputs { get }
}

public final class HotelResultCardViewModel: HotelResultCardViewModelType, HotelResultCardViewModelInputs, HotelResultCardViewModelOutputs {
    
    public init() {
        let configuredHotel = self.configHotelProperty.signal.skipNil()
        
        self.hotelNameTitleLabelText = configuredHotel.map { $0.name ?? "" }
        self.hotelCityTitleLabelText = configuredHotel.map { $0.provinceName }
        self.hotelPriceTitleLabelText = configuredHotel.map { "\(symbolForCurrency(AppEnvironment.current.apiService.currency)) \(Format.currency($0.metadataHotel.totalPrice, country: AppEnvironment.current.locale.currencyCode ?? "IDR"))" }
        
        print("LOCALE RESULT: \(AppEnvironment.current.locale.identifier)")
        
        self.hotelImageURL = configuredHotel.map { $0.photoPrimary.replacingOccurrences(of: ".sq2", with: ".l") }.map(URL.init(string:))
        self.ratingImage = configuredHotel.map { $0.starRating }.map(ratingForStar(rating:))
        
        self.ratingReviewTitleLabelText = configuredHotel.filter { !$0.rating.isEmpty }.map { "Rating: \($0.rating)" }
    }
    
    fileprivate let configHotelProperty = MutableProperty<HotelResult?>(nil)
    public func configureWith(hotel: HotelResult) {
        self.configHotelProperty.value = hotel
    }
    
    public let hotelNameTitleLabelText: Signal<String, NoError>
    public let hotelCityTitleLabelText: Signal<String, NoError>
    public let hotelPriceTitleLabelText: Signal<String, NoError>
    public let ratingImage: Signal<UIImage, NoError>
    public let ratingReviewTitleLabelText: Signal<String, NoError>
    public let hotelImageURL: Signal<URL?, NoError>
    
    public var inputs: HotelResultCardViewModelInputs { return self }
    public var outputs: HotelResultCardViewModelOutputs { return self }
}

public func symbolForCurrency(_ currency: String) -> String {
    switch currency {
    case "IDR":
        return "Rp"
    default:
        return currency
    }
}

private func ratingForStar(rating: String) -> UIImage {
    switch rating {
    case "5":
        return UIImage(named: "star-rating-five")!
    case "4":
        return UIImage(named: "star-rating-four")!
    case "3":
        return UIImage(named: "star-rating-three")!
    case "2":
        return UIImage(named: "star-rating-two")!
    case "1":
        return UIImage(named: "star-rating-one")!
    default:
        return UIImage(named: "star-rating-one")!
    }
}
