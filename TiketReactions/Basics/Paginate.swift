//
//  Paginate.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 10/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//
import ReactiveSwift
import Result
import Prelude

/*
public func paginateHotel<Cursor, Value: Equatable, SearchHotelEnvelopes, ErrorEnvelope, RequestParams>(requestFirstPageWith requestFirstPage: Signal<RequestParams, NoError>) {
    
}
 */
public func paginate(
    requestFirstPageWith requestFirstPage: Signal<SearchHotelParams, NoError>,
    requestNextPageWhen requestNextPage: Signal<(), NoError>,
    clearOnNewRequest: Bool,
    skipRepeats: Bool = true,
    valuesFromEnvelope: @escaping ((SearchHotelEnvelopes) -> [HotelResult]),
    cursorFromEnvelope: @escaping ((SearchHotelEnvelopes) -> SearchHotelParams),
    requestFromParams: @escaping ((SearchHotelParams) -> SignalProducer<SearchHotelEnvelopes, ErrorEnvelope>),
    requestFromCursor: @escaping ((SearchHotelParams) -> SignalProducer<SearchHotelEnvelopes, ErrorEnvelope>),
    concater: @escaping (([HotelResult], [HotelResult]) -> [HotelResult]) = (+))
    ->
    (paginatedValues: Signal<[HotelResult], NoError>,
    isLoading: Signal<Bool, NoError>,
    pageCount: Signal<Int, NoError>) {
    
    let cursor = MutableProperty<SearchHotelParams?>(nil)
    let isLoading = MutableProperty<Bool>(false)
        
        let cursorOnNextPage = cursor.producer.skipNil().switchMap { params -> SignalProducer<SearchHotelParams, NoError> in
            let customized = params
                |> SearchHotelParams.lens.page .~ (1 + 1)
            
            return SignalProducer(value: customized)
        }.sample(on: requestNextPage)
    
        
    let paginatedValues = requestFirstPage.switchMap { requestParams in
        
        cursorOnNextPage.map(Either.right).prefix(value: .left(requestParams)).switchMap {
            paramsOrCursor in
            
            
            paramsOrCursor.ifLeft(requestFromParams, ifRight: requestFromCursor).ck_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
                .on(
                    starting: {
                        isLoading.value = true
                },
                    terminated: {
                        isLoading.value = false
                },
                    value: { env in
                        cursor.value = cursorFromEnvelope(env)
                })
                .map(valuesFromEnvelope)
                .demoteErrors()
        }
            .takeUntil { $0.isEmpty }
            .mergeWith(clearOnNewRequest ? .init(value: []) : .empty)
            .scan([], concater)
    }.skip(first: clearOnNewRequest ? 1 : 0)
        
    let pageCount = Signal.merge(paginatedValues, requestFirstPage.mapConst([])).scan(0) {
            accum, values in values.isEmpty ? 0 : accum + 1 }.filter { $0 > 0 }
        
    return (
        (skipRepeats ? paginatedValues.skipRepeats(==) : paginatedValues),
            isLoading.signal,
            pageCount
        )
}
