//
//  DateProtocol.swift
//  TiketComponents
//
//  Created by Firas Rafislam on 07/02/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

public protocol DateProtocol {
    var date: Date { get }
    func addingTimeInterval(_: TimeInterval) -> Self
    init()
    init(timeIntervalSince1970: TimeInterval)
    var timeIntervalSince1970: TimeInterval { get }
}

extension Date: DateProtocol {
    
    public var date: Date {
        return self
    }
    
    func getFirstDate(_ minimum: Date) -> Date {
        var components = Calendar.current.dateComponents([.month, .year], from: minimum)
        components.day = 1
        return Calendar.current.date(from: components)!
    }
    
    func getFirstDateForSection(section: Int, minimum: Date) -> Date {
        return Calendar.current.date(byAdding: .month, value: section, to: getFirstDate(minimum))!
    }
    
    func getMonthLabel(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    func getWeekdayLabel(weekday: Int) -> String {
        var components = DateComponents()
        components.calendar = Calendar.current
        components.weekday = weekday
        let date = Calendar.current.nextDate(after: Date(), matching: components, matchingPolicy: Calendar.MatchingPolicy.strict)
        if date == nil {
            return "E"
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEEE"
        return dateFormatter.string(from: date!)
    }
    
    func getWeekday(date: Date) -> Int {
        return Calendar.current.dateComponents([.weekday], from: date).weekday!
    }
    
    func getNumberOfDaysInMonth(date: Date) -> Int {
        return Calendar.current.range(of: .day, in: .month, for: date)!.count
    }
    
    func getDate(dayOfMonth: Int, section: Int, minimum: Date) -> Date {
        var components = Calendar.current.dateComponents([.month, .year], from: getFirstDateForSection(section: section, minimum: minimum))
        components.day = dayOfMonth
        return Calendar.current.date(from: components)!
    }
    
    func areSameDay(dateA: Date, dateB: Date) -> Bool {
        return Calendar.current.compare(dateA, to: dateB, toGranularity: .day) == ComparisonResult.orderedSame
    }
    
    func isBefore(dateA: Date, dateB: Date) -> Bool {
        return Calendar.current.compare(dateA, to: dateB, toGranularity: .day) == ComparisonResult.orderedAscending
    }
}

internal struct MockDate: DateProtocol {
    private let time: TimeInterval
    
    internal init() {
        self.time = 1475361315
    }
    
    internal init(timeIntervalSince1970 time: TimeInterval) {
        self.time = time
    }
    
    internal var timeIntervalSince1970: TimeInterval {
        return self.time
    }
    
    internal var date: Date {
        return Date(timeIntervalSince1970: self.time)
    }
    
    internal func addingTimeInterval(_ interval: TimeInterval) -> MockDate {
        return MockDate(timeIntervalSince1970: self.time + interval)
    }
}
