//
//  HotelDirectMainCellViewModel.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 11/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import SwiftSoup
import TiketKitModels
import UIKit

public protocol HotelDirectMainCellViewModelInputs {
    func configureWith(hotel: HotelDirect)
}

public protocol HotelDirectMainCellViewModelOutputs {
    var hotelnameTitleText: Signal<String, NoError> { get }
    var hotelProvinceTitleText: Signal<String, NoError> { get }
    var photos: Signal<[HotelDirect.Photo], NoError> { get }
    var firstRoomDescription: Signal<String, NoError> { get }
    var photosImage: Signal<[UIImage], NoError> { get }
    var starRating: Signal<UIImage, NoError> { get }
}

public protocol HotelDirectMainCellViewModelType {
    var inputs: HotelDirectMainCellViewModelInputs { get }
    var outputs: HotelDirectMainCellViewModelOutputs { get }
}

public final class HotelDirectMainCellViewModel: HotelDirectMainCellViewModelType, HotelDirectMainCellViewModelInputs, HotelDirectMainCellViewModelOutputs {
    
    public init() {
        let hotelDirect = self.configHotelProperty.signal.skipNil()
        
        self.hotelnameTitleText = hotelDirect.map { $0.breadcrumb.businessName }
        self.hotelProvinceTitleText = hotelDirect.map { $0.breadcrumb.cityName }
        self.starRating = hotelDirect.map { $0.breadcrumb.starRating }.map(ratingForStar(rating:))
        
        self.photos = hotelDirect.map { $0.photos }
        
        self.firstRoomDescription = hotelDirect.map { $0.availableRooms.roomResults.first! }.switchMap {
            parseDescriptionHotel($0.roomDescription).materialize()
        }.values()
        
        self.photosImage = .empty
    }
    
    fileprivate let configHotelProperty = MutableProperty<HotelDirect?>(nil)
    public func configureWith(hotel: HotelDirect) {
        self.configHotelProperty.value = hotel
    }
    
    public let hotelnameTitleText: Signal<String, NoError>
    public let hotelProvinceTitleText: Signal<String, NoError>
    public let photos: Signal<[HotelDirect.Photo], NoError>
    public let firstRoomDescription: Signal<String, NoError>
    public let photosImage: Signal<[UIImage], NoError>
    public let starRating: Signal<UIImage, NoError>
    
    public var inputs: HotelDirectMainCellViewModelInputs { return self }
    public var outputs: HotelDirectMainCellViewModelOutputs { return self }
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

private func parseDescriptionHotel(_ content: String) -> SignalProducer<String, NoError> {
    do {
        let doc: Document = try SwiftSoup.parse(content)
        let parsed = try doc.text()
        return SignalProducer(value: parsed)
    } catch Exception.Error(_, let message) {
        return SignalProducer(value: message)
    } catch {
        return SignalProducer(value: content)
    }
}
