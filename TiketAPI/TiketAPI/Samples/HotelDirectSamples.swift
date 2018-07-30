//
//  HotelDirectSamples.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 07/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation

extension HotelDirect {
    
    internal static let sample = HotelDirect(diagnostic: .sample, primaryPhotos: "https://sandbox.tiket.com/img/business/t/h/business-theedelweisshotelyogyakarta-hotel-1119.s.jpg", breadcrumb: .sample, availableRooms: .sample, addInfo: ["", ""], photos: [.sample], largePhotos: "", availFacilities: [.sample], nearbyAttraction: [.sample])
}

extension HotelDirect.Breadcrumb {
    
    internal static let sample = HotelDirect.Breadcrumb(businessURI: "https://api-sandbox.tiket.com/the-edelweis-hotel-yogyakarta", businessName: "The Edelweiss Hotel Yogyakarta", kelurahanName: " ", kecamatanName: " ", cityName: "Yogyakarta", provinceName: "Daerah Istimewa Yogyakarta", countryName: "Indonesia", continentName: "Asia", kelurahanURI: "https://api-sandbox.tiket.com/search/hotel?uid=city:257", kecamatanURI: "https://api-sandbox.tiket.com/search/hotel?uid=kecamatan:0", provinceURI: "https://api-sandbox.tiket.com/search/hotel?uid=province:16", countryURI: "https://api-sandbox.tiket.com/search/hotel?uid=country:id", contentURI: "https://api-sandbox.tiket.com/search/hotel?uid=continent:1", starRating: "3")
}

extension HotelDirect.HotelRoomResult {
    
    internal static let sample = HotelDirect.HotelRoomResult(roomResults: [.sample])
}

extension HotelDirect.Photo {
    
    internal static let sample = HotelDirect.Photo(fileName: "https://sandbox.tiket.com/img/business/t/h/business-theedelweisshotelyogyakarta-hotel-6189.s.jpg", photoType: "Interior")
}

extension HotelDirect.AvailableFacility {
    
    internal static let sample = HotelDirect.AvailableFacility.init(facilityType: "hotel", facilityName: "Layanan Kamar 24 Jam")
}

extension HotelDirect.NearbyAttraction {
    
    internal static let sample = HotelDirect.NearbyAttraction(distance: 200, businessPrimaryPhoto: "https://api-sandbox.tiket.com/img/business/p/a/business-pancake-tiramisu-topping-ice-cream-vanilla-dixie2.s.jpg", businessName: "Dixie Easy Dinning", businessURI: "https://api-sandbox.tiket.com/attractions/indonesia/daerah-istimewa-yogyakarta/hotel-dekat-dixie-easy-dinning-2")
}
