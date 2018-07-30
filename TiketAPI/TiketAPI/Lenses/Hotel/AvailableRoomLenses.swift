//
//  AvailableRoomLenses.swift
//  TiketAPIs
//
//  Created by Firas Rafislam on 07/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import Prelude

extension AvailableRoom {
    public enum lens {
        public static let id = Lens<AvailableRoom, String>(
            view: { view in view.id },
            set:{ view, set in AvailableRoom(
                id: view, roomAvailable: set.roomAvailable, extSource: set.extSource, roomId: set.roomId, currency: set.currency, minimumStays: set.minimumStays, withBreakfasts: set.withBreakfasts, roomDescription: set.roomDescription, allPhotoRoom: set.allPhotoRoom, photoUrl: set.photoUrl, roomName: set.roomName, oldprice: set.oldprice, price: set.price, bookURI: set.bookURI, RoomFacility: set.RoomFacility, additionalSurchargeCurrency: set.additionalSurchargeCurrency) }
        )
        
        public static let roomAvailable = Lens<AvailableRoom, String>(
            view: { view in view.roomAvailable },
            set:{ view, set in AvailableRoom(
                id: set.id, roomAvailable: view, extSource: set.extSource, roomId: set.roomId, currency: set.currency, minimumStays: set.minimumStays, withBreakfasts: set.withBreakfasts, roomDescription: set.roomDescription, allPhotoRoom: set.allPhotoRoom, photoUrl: set.photoUrl, roomName: set.roomName, oldprice: set.oldprice, price: set.price, bookURI: set.bookURI, RoomFacility: set.RoomFacility, additionalSurchargeCurrency: set.additionalSurchargeCurrency) }
        )
        
        public static let extSource = Lens<AvailableRoom, String>(
            view: { view in view.extSource },
            set:{ view, set in AvailableRoom(
                id: set.id, roomAvailable: set.roomAvailable, extSource: view, roomId: set.roomId, currency: set.currency, minimumStays: set.minimumStays, withBreakfasts: set.withBreakfasts, roomDescription: set.roomDescription, allPhotoRoom: set.allPhotoRoom, photoUrl: set.photoUrl, roomName: set.roomName, oldprice: set.oldprice, price: set.price, bookURI: set.bookURI, RoomFacility: set.RoomFacility, additionalSurchargeCurrency: set.additionalSurchargeCurrency) }
        )
        
        public static let roomId = Lens<AvailableRoom, String>(
            view: { view in view.roomId },
            set:{ view, set in AvailableRoom(
                id: set.id, roomAvailable: set.roomAvailable, extSource: set.extSource, roomId: view, currency: set.currency, minimumStays: set.minimumStays, withBreakfasts: set.withBreakfasts, roomDescription: set.roomDescription, allPhotoRoom: set.allPhotoRoom, photoUrl: set.photoUrl, roomName: set.roomName, oldprice: set.oldprice, price: set.price, bookURI: set.bookURI, RoomFacility: set.RoomFacility, additionalSurchargeCurrency: set.additionalSurchargeCurrency) }
        )
        
        public static let currency = Lens<AvailableRoom, String>(
            view: { view in view.currency },
            set:{ view, set in AvailableRoom(
                id: set.id, roomAvailable: set.roomAvailable, extSource: set.extSource, roomId: set.roomId, currency: view, minimumStays: set.minimumStays, withBreakfasts: set.withBreakfasts, roomDescription: set.roomDescription, allPhotoRoom: set.allPhotoRoom, photoUrl: set.photoUrl, roomName: set.roomName, oldprice: set.oldprice, price: set.price, bookURI: set.bookURI, RoomFacility: set.RoomFacility, additionalSurchargeCurrency: set.additionalSurchargeCurrency) }
        )
        
        public static let minimumStays = Lens<AvailableRoom, String>(
            view: { view in view.minimumStays },
            set:{ view, set in AvailableRoom(
                id: set.id, roomAvailable: set.roomAvailable, extSource: set.extSource, roomId: set.roomId, currency: set.currency, minimumStays: view, withBreakfasts: set.withBreakfasts, roomDescription: set.roomDescription, allPhotoRoom: set.allPhotoRoom, photoUrl: set.photoUrl, roomName: set.roomName, oldprice: set.oldprice, price: set.price, bookURI: set.bookURI, RoomFacility: set.RoomFacility, additionalSurchargeCurrency: set.additionalSurchargeCurrency) }
        )
        
        public static let withBreakfasts = Lens<AvailableRoom, String>(
            view: { view in view.withBreakfasts },
            set:{ view, set in AvailableRoom(
                id: set.id, roomAvailable: set.roomAvailable, extSource: set.extSource, roomId: set.roomId, currency: set.currency, minimumStays: set.minimumStays, withBreakfasts: view, roomDescription: set.roomDescription, allPhotoRoom: set.allPhotoRoom, photoUrl: set.photoUrl, roomName: set.roomName, oldprice: set.oldprice, price: set.price, bookURI: set.bookURI, RoomFacility: set.RoomFacility, additionalSurchargeCurrency: set.additionalSurchargeCurrency) }
        )
        
        public static let roomDescription = Lens<AvailableRoom, String>(
            view: { view in view.roomDescription },
            set:{ view, set in AvailableRoom(
                id: set.id, roomAvailable: set.roomAvailable, extSource: set.extSource, roomId: set.roomId, currency: set.currency, minimumStays: set.minimumStays, withBreakfasts: set.withBreakfasts, roomDescription: view, allPhotoRoom: set.allPhotoRoom, photoUrl: set.photoUrl, roomName: set.roomName, oldprice: set.oldprice, price: set.price, bookURI: set.bookURI, RoomFacility: set.RoomFacility, additionalSurchargeCurrency: set.additionalSurchargeCurrency) }
        )
        
        public static let allPhotoRoom = Lens<AvailableRoom, [String]>(
            view: { view in view.allPhotoRoom },
            set:{ view, set in AvailableRoom(
                id: set.id, roomAvailable: set.roomAvailable, extSource: set.extSource, roomId: set.roomId, currency: set.currency, minimumStays: set.minimumStays, withBreakfasts: set.withBreakfasts, roomDescription: set.roomDescription, allPhotoRoom: view, photoUrl: set.photoUrl, roomName: set.roomName, oldprice: set.oldprice, price: set.price, bookURI: set.bookURI, RoomFacility: set.RoomFacility, additionalSurchargeCurrency: set.additionalSurchargeCurrency) }
        )
        
        public static let photoUrl = Lens<AvailableRoom, String>(
            view: { view in view.photoUrl },
            set:{ view, set in AvailableRoom(
                id: set.id, roomAvailable: set.roomAvailable, extSource: set.extSource, roomId: set.roomId, currency: set.currency, minimumStays: set.minimumStays, withBreakfasts: set.withBreakfasts, roomDescription: set.roomDescription, allPhotoRoom: set.allPhotoRoom, photoUrl: view, roomName: set.roomName, oldprice: set.oldprice, price: set.price, bookURI: set.bookURI, RoomFacility: set.RoomFacility, additionalSurchargeCurrency: set.additionalSurchargeCurrency) }
        )
        
        public static let roomName = Lens<AvailableRoom, String>(
            view: { view in view.roomName },
            set:{ view, set in AvailableRoom(
                id: view, roomAvailable: set.roomAvailable, extSource: set.extSource, roomId: set.roomId, currency: set.currency, minimumStays: set.minimumStays, withBreakfasts: set.withBreakfasts, roomDescription: set.roomDescription, allPhotoRoom: set.allPhotoRoom, photoUrl: set.photoUrl, roomName: view, oldprice: set.oldprice, price: set.price, bookURI: set.bookURI, RoomFacility: set.RoomFacility, additionalSurchargeCurrency: set.additionalSurchargeCurrency) }
        )
        
        public static let oldprice = Lens<AvailableRoom, String>(
            view: { view in view.oldprice },
            set:{ view, set in AvailableRoom(
                id: set.id, roomAvailable: set.roomAvailable, extSource: set.extSource, roomId: set.roomId, currency: set.currency, minimumStays: set.minimumStays, withBreakfasts: set.withBreakfasts, roomDescription: set.roomDescription, allPhotoRoom: set.allPhotoRoom, photoUrl: set.photoUrl, roomName: set.roomName, oldprice: view, price: set.price, bookURI: set.bookURI, RoomFacility: set.RoomFacility, additionalSurchargeCurrency: set.additionalSurchargeCurrency) }
        )
        
        public static let price = Lens<AvailableRoom, String>(
            view: { view in view.price },
            set:{ view, set in AvailableRoom(
                id: set.id, roomAvailable: set.roomAvailable, extSource: set.extSource, roomId: set.roomId, currency: set.currency, minimumStays: set.minimumStays, withBreakfasts: set.withBreakfasts, roomDescription: set.roomDescription, allPhotoRoom: set.allPhotoRoom, photoUrl: set.photoUrl, roomName: set.roomName, oldprice: set.oldprice, price: view, bookURI: set.bookURI, RoomFacility: set.RoomFacility, additionalSurchargeCurrency: set.additionalSurchargeCurrency) }
        )
        
        public static let bookURI = Lens<AvailableRoom, String>(
            view: { view in view.price },
            set:{ view, set in AvailableRoom(
                id: set.id, roomAvailable: set.roomAvailable, extSource: set.extSource, roomId: set.roomId, currency: set.currency, minimumStays: set.minimumStays, withBreakfasts: set.withBreakfasts, roomDescription: set.roomDescription, allPhotoRoom: set.allPhotoRoom, photoUrl: set.photoUrl, roomName: set.roomName, oldprice: set.oldprice, price: set.price, bookURI: view, RoomFacility: set.RoomFacility, additionalSurchargeCurrency: set.additionalSurchargeCurrency) }
        )
        
        public static let RoomFacility = Lens<AvailableRoom, [String]>(
            view: { view in view.RoomFacility },
            set:{ view, set in AvailableRoom(
                id: set.id, roomAvailable: set.roomAvailable, extSource: set.extSource, roomId: set.roomId, currency: set.currency, minimumStays: set.minimumStays, withBreakfasts: set.withBreakfasts, roomDescription: set.roomDescription, allPhotoRoom: set.allPhotoRoom, photoUrl: set.photoUrl, roomName: set.roomName, oldprice: set.oldprice, price: set.price, bookURI: set.bookURI, RoomFacility: view, additionalSurchargeCurrency: set.additionalSurchargeCurrency) }
        )
        
        public static let additionalSurchargeCurrency = Lens<AvailableRoom, String>(
            view: { view in view.additionalSurchargeCurrency },
            set:{ view, set in AvailableRoom(
                id: set.id, roomAvailable: set.roomAvailable, extSource: set.extSource, roomId: set.roomId, currency: set.currency, minimumStays: set.minimumStays, withBreakfasts: set.withBreakfasts, roomDescription: set.roomDescription, allPhotoRoom: set.allPhotoRoom, photoUrl: set.photoUrl, roomName: set.roomName, oldprice: set.oldprice, price: set.price, bookURI: set.bookURI, RoomFacility: set.RoomFacility, additionalSurchargeCurrency: view) }
        )
    }
}

