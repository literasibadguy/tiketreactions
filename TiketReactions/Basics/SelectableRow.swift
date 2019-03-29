//
//  SelectableRow.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 09/04/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Prelude
import TiketKitModels

public struct SelectableRow {
    public let isSelected: Bool
    public let params: SearchHotelParams
    
    public enum lens {
        public static let isSelected = Lens<SelectableRow, Bool>(
            view: { $0.isSelected },
            set:  { SelectableRow(isSelected: $0, params: $1.params) }
        )
        
        public static let params = Lens<SelectableRow, SearchHotelParams>(
            view: { $0.params },
            set: { SelectableRow(isSelected: $1.isSelected, params: $0) }
        )
    }
}

public extension Lens where Whole == SelectableRow, Part == SearchHotelParams {
    var mainCountry: Lens<SelectableRow, String?> {
        return SelectableRow.lens.params..SearchHotelParams.lens.query
    }
    var startDate: Lens<SelectableRow, String?> {
        return SelectableRow.lens.params..SearchHotelParams.lens.startDate
    }
    var endDate: Lens<SelectableRow, String?> {
        return SelectableRow.lens.params..SearchHotelParams.lens.endDate
    }
    var night: Lens<SelectableRow, Int?> {
        return SelectableRow.lens.params..SearchHotelParams.lens.night
    }
    var room: Lens<SelectableRow, Int?> {
        return SelectableRow.lens.params..SearchHotelParams.lens.room
    }
    var adult: Lens<SelectableRow, String?> {
        return SelectableRow.lens.params..SearchHotelParams.lens.adult
    }
    var child: Lens<SelectableRow, Int?> {
        return SelectableRow.lens.params..SearchHotelParams.lens.child
    }
    var sort: Lens<SelectableRow, SearchHotelParams.Sort?> {
        return SelectableRow.lens.params..SearchHotelParams.lens.sort
    }
    var minStar: Lens<SelectableRow, Int?> {
        return SelectableRow.lens.params..SearchHotelParams.lens.minStar
    }
    var maxStar: Lens<SelectableRow, Int?> {
        return SelectableRow.lens.params..SearchHotelParams.lens.maxStar
    }
    var minPrice: Lens<SelectableRow, String> {
        return SelectableRow.lens.params..SearchHotelParams.lens.minPrice
    }
    var maxPrice: Lens<SelectableRow, String> {
        return SelectableRow.lens.params..SearchHotelParams.lens.maxPrice
    }
    var distance: Lens<SelectableRow, Int?> {
        return SelectableRow.lens.params..SearchHotelParams.lens.distance
    }
}

extension SelectableRow: Equatable {}
public func == (lhs: SelectableRow, rhs: SelectableRow) -> Bool {
    return lhs.isSelected == rhs.isSelected && lhs.params == rhs.params
}

