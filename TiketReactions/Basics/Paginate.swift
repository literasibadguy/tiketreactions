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

public func paginate <Cursor, Value: Equatable, Envelope, ErrorEnvelope, RequestParams>(requestFirstPageWith requestFirstPage: Signal<RequestParams, NoError>,
                                                                                        requestNextPageWhen requestNextPage: Signal<(), NoError>,
                                                                                        clearOnNewRequest: Bool,
                                                                                        skipRepeats: Bool = true,
                                                                                        valuesFromEnvelope: @escaping ((Envelope) -> [Value]),
                                                                                        cursorFromEnvelope: @escaping ((Envelope) -> Cursor),
                                                                                        requestFromParams: @escaping ((RequestParams) -> SignalProducer<Envelope, ErrorEnvelope>),
                                                                                        requestFromCursor: @escaping ((Cursor) -> SignalProducer<Envelope, ErrorEnvelope>),
                                                                                        concater: @escaping (([Value], [Value]) -> [Value]) = (+))
    ->
    (paginatedValues: Signal<[Value], NoError>, isLoading: Signal<Bool, NoError>, pageCount: Signal<Int, NoError>) {
        
        let cursor = MutableProperty<Cursor?>(nil)
        let isLoading = MutableProperty<Bool>(false)
        
        let cursorOnNextPage = cursor.producer.skipNil().sample(on: requestNextPage)
//        let apiDelayInterval = DispatchTimeInterval.seconds(0)
        let scheduler = QueueScheduler.main
        
        let paginatedValues = requestFirstPage
            .switchMap { requestParams in
                // Request First Page Switch Map
                cursorOnNextPage.map(Either.right)
                    .prefix(value: .left(requestParams))
                    .switchMap { paramsOrCursor in
                        paramsOrCursor.ifLeft(requestFromParams, ifRight: requestFromCursor)
                            .ck_delay(AppEnvironment.current.apiDelayInterval, on: scheduler)
                            .on(
                                starting: {
                                    isLoading.value = true
                            },
                                terminated: {
                                    print("Terminated Request")
                                    isLoading.value = false
                            },
                                value: { env in
                                    print("Got Value Paginate")
                                    cursor.value = cursorFromEnvelope(env)
                            })
                            .map(valuesFromEnvelope)
                            .demoteErrors()
                    }
                    .takeUntil { $0.isEmpty }
                    .mergeWith(clearOnNewRequest ? .init(value: []) : .empty)
                    .scan([], concater)
            }
            .skip(first: clearOnNewRequest ? 1 : 0)
        
        let pageCount = Signal.merge(paginatedValues, requestFirstPage.mapConst([]))
            .scan(0) { accum, values in values.isEmpty ? 0 : accum + 1 }
            .filter { $0 > 0 }
        
        return (
            (skipRepeats ? paginatedValues.skipRepeats(==) : paginatedValues),
            isLoading.signal,
            pageCount
        )
}
