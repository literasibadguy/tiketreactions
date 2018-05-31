//
//  HotelPhotosDataSource.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 11/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import TiketKitModels
import UIKit

public final class HotelPhotosDataSource: ValueCellDataSource {
    
    func load(photos: [HotelDirect.Photo]) {
        self.set(values: photos, cellClass: HotelPhotoViewCell.self, inSection: 0)
    }
    
    public override func configureCell(collectionCell cell: UICollectionViewCell, withValue value: Any) {
        switch (cell, value) {
        case let (cell as HotelPhotoViewCell, value as HotelDirect.Photo):
            cell.configureWith(value: value)
        default:
            fatalError()
        }
    }
}
