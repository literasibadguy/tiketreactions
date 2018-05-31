//
//  Format.swift
//  TiketReactions
//
//  Created by Firas Rafislam on 09/03/18.
//  Copyright © 2018 Firas Rafislam. All rights reserved.
//

import Foundation
import Prelude

public let UTCTimeZone = TimeZone(secondsFromGMT: 0)!

public enum Format {
    
    public static func wholeNumber(_ x: Int, env: Environment = AppEnvironment.current) -> String {
        let formatter = NumberFormatterConfig.cachedFormatter(forConfig: .defaultWholeNumberConfig |> NumberFormatterConfig.lens.locale .~ env.locale
        )
        return formatter.string(for: x) ?? String(x)
    }
    
    public static func date(secondsInUTC seconds: TimeInterval, dateStyle: DateFormatter.Style = .medium, timeStyle: DateFormatter.Style = .medium, timeZone: TimeZone? = nil, env: Environment = AppEnvironment.current) -> String {
        let formatter = DateFormatterConfig.cachedFormatter(forConfig: .init(template: nil, dateStyle: dateStyle, locale: env.locale, timeStyle: timeStyle, timeZone: timeZone ?? env.calendar.timeZone))
        
        return formatter.string(from: env.dateType.init(timeIntervalSince1970: seconds).date)
    }
    
    public static func date(secondsInUTC seconds: TimeInterval, template: String, timeZone: TimeZone? = nil) -> String? {
        let formatter = DateFormatterConfig.cachedFormatter(forConfig: .init(template: template, dateStyle: nil, locale: AppEnvironment.current.locale, timeStyle: nil, timeZone: timeZone ?? AppEnvironment.current.calendar.timeZone))
        
        return formatter.string(from: AppEnvironment.current.dateType.init(timeIntervalSince1970: seconds).date)
    }
    
    public static func currency(_ amount: Int, country: String, omitCurrencyCode: Bool = false, env: Environment = AppEnvironment.current) -> String {
        let formatter = NumberFormatterConfig.cachedFormatter(forConfig: .defaultCurrencyConfig
            |> NumberFormatterConfig.lens.locale .~ env.locale
        )
        
        return formatter.string(for: amount)?.trimmed()
            .replacingOccurrences(of: String.nbsp + String.nbsp, with: String.nbsp)
            ?? (country + String(amount))
    }
    
    public static func currency(_ amount: Double, country: String, omitCurrencyCode: Bool = false, env: Environment = AppEnvironment.current) -> String {
        let formatter = NumberFormatterConfig.cachedFormatter(forConfig: .defaultCurrencyConfig
            |> NumberFormatterConfig.lens.locale .~ env.locale
        )
        
        return formatter.string(for: amount)?.trimmed()
            .replacingOccurrences(of: String.nbsp + String.nbsp, with: String.nbsp)
            ?? (country + String(amount))
    }
    
    public static func symbolForCurrency(_ currency: String? = "IDR") -> String {
        switch currency {
        case "IDR":
            return "Rp"
        case "USD":
            return "$"
        default:
            return currency ?? ""
        }
    }
}

private let defaultThresholdInDays = 30  // days

private struct DateFormatterConfig {
    fileprivate let template: String?
    fileprivate let dateStyle: DateFormatter.Style?
    fileprivate let locale: Locale
    fileprivate let timeStyle: DateFormatter.Style?
    fileprivate let timeZone: TimeZone
    
    fileprivate func formatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.locale = self.locale
        formatter.timeZone = self.timeZone
        if let template = self.template {
            formatter.dateFormat = template
            formatter.date(from: "2018-03-23")
            
        }
        if let dateStyle = self.dateStyle {
            formatter.dateStyle = dateStyle
        }
        if let timeStyle = self.timeStyle {
            formatter.timeStyle = timeStyle
        }
        
        return formatter
    }
    
    fileprivate static var formatters: [DateFormatterConfig: DateFormatter] = [:]
    
    fileprivate static func cachedFormatter(forConfig config: DateFormatterConfig) -> DateFormatter {
        let formatter = self.formatters[config] ?? config.formatter()
        self.formatters[config] = formatter
        return formatter
    }
}

private struct NumberFormatterConfig {
    fileprivate let numberStyle: NumberFormatter.Style
    fileprivate let roundingMode: NumberFormatter.RoundingMode
    fileprivate let maximumFractionDigits: Int
    fileprivate let generatesDecimalNumbers: Bool
    fileprivate let locale: Locale
    fileprivate let currencySymbol: String
    
    fileprivate func formatter() -> NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = self.numberStyle
        formatter.roundingMode = self.roundingMode
        formatter.maximumFractionDigits = self.maximumFractionDigits
        formatter.generatesDecimalNumbers = self.generatesDecimalNumbers
        formatter.locale = self.locale
        formatter.currencySymbol = self.currencySymbol
        return formatter
    }
    
    fileprivate static var formatters: [NumberFormatterConfig: NumberFormatter] = [:]
    
    fileprivate static let defaultWholeNumberConfig = NumberFormatterConfig(numberStyle: .decimal, roundingMode: .down, maximumFractionDigits: 0, generatesDecimalNumbers: false, locale: .current, currencySymbol: "Rp")
    
    fileprivate static let defaultPercentageConfig = NumberFormatterConfig(numberStyle: .decimal, roundingMode: .down, maximumFractionDigits: 0, generatesDecimalNumbers: false, locale: .current, currencySymbol: "Rp")
    
    fileprivate static let defaultCurrencyConfig = NumberFormatterConfig(numberStyle: .decimal, roundingMode: .down, maximumFractionDigits: 0, generatesDecimalNumbers: false, locale: .current, currencySymbol: "Rp")
    
    
    fileprivate static func cachedFormatter(forConfig config: NumberFormatterConfig) -> NumberFormatter {
        let formatter = self.formatters[config] ?? config.formatter()
        self.formatters[config] = formatter
        return formatter
    }
}

extension NumberFormatterConfig: Hashable {
    fileprivate var hashValue: Int {
        return
            self.numberStyle.hashValue
                ^ self.roundingMode.hashValue
                ^ self.maximumFractionDigits.hashValue
                ^ self.generatesDecimalNumbers.hashValue
                ^ self.locale.hashValue
                ^ self.currencySymbol.hashValue
    }
}

private func == (lhs: NumberFormatterConfig, rhs: NumberFormatterConfig) -> Bool {
    return
        lhs.numberStyle == rhs.numberStyle
            && lhs.roundingMode == rhs.roundingMode
            && lhs.maximumFractionDigits == rhs.maximumFractionDigits
            && lhs.generatesDecimalNumbers == rhs.generatesDecimalNumbers
            && lhs.locale == rhs.locale
            && lhs.currencySymbol == rhs.currencySymbol
}

private func currencySymbol(forCountry diagnostic: Diagnostic) -> String {
    
    if diagnostic.currency == "IDR" {
        return "Rp"
    }
    
    return diagnostic.currency
}

extension DateFormatterConfig: Hashable {
    fileprivate var hashValue: Int {
        return (self.template?.hashValue ?? 0) ^ (self.dateStyle?.hashValue ?? 0) ^ self.locale.hashValue ^ (self.timeStyle?.hashValue ?? 0) ^ self.timeZone.hashValue
    }
}

private func == (lhs: DateFormatterConfig, rhs: DateFormatterConfig) -> Bool {
    return lhs.template == rhs.template && lhs.dateStyle == rhs.dateStyle && lhs.locale == rhs.locale && lhs.timeStyle == rhs.timeStyle && lhs.timeZone == rhs.timeZone
}

extension NumberFormatterConfig {
    fileprivate enum lens {
        fileprivate static let numberStyle = Lens<NumberFormatterConfig, NumberFormatter.Style>(
            view: { $0.numberStyle },
            set: { .init(numberStyle: $0, roundingMode: $1.roundingMode,
                         maximumFractionDigits: $1.maximumFractionDigits, generatesDecimalNumbers: $1.generatesDecimalNumbers,
                         locale: $1.locale, currencySymbol: $1.currencySymbol) }
        )
        
        fileprivate static let roundingMode = Lens<NumberFormatterConfig, NumberFormatter.RoundingMode>(
            view: { $0.roundingMode },
            set: { .init(numberStyle: $1.numberStyle, roundingMode: $0,
                         maximumFractionDigits: $1.maximumFractionDigits, generatesDecimalNumbers: $1.generatesDecimalNumbers,
                         locale: $1.locale, currencySymbol: $1.currencySymbol) }
        )
        
        fileprivate static let maximumFractionDigits = Lens<NumberFormatterConfig, Int>(
            view: { $0.maximumFractionDigits },
            set: { .init(numberStyle: $1.numberStyle, roundingMode: $1.roundingMode, maximumFractionDigits: $0,
                         generatesDecimalNumbers: $1.generatesDecimalNumbers, locale: $1.locale,
                         currencySymbol: $1.currencySymbol) }
        )
        
        fileprivate static let generatesDecimalNumbers = Lens<NumberFormatterConfig, Bool>(
            view: { $0.generatesDecimalNumbers },
            set: { .init(numberStyle: $1.numberStyle, roundingMode: $1.roundingMode,
                         maximumFractionDigits: $1.maximumFractionDigits, generatesDecimalNumbers: $0, locale: $1.locale,
                         currencySymbol: $1.currencySymbol) }
        )
        
        fileprivate static let locale = Lens<NumberFormatterConfig, Locale>(
            view: { $0.locale },
            set: { .init(numberStyle: $1.numberStyle, roundingMode: $1.roundingMode,
                         maximumFractionDigits: $1.maximumFractionDigits, generatesDecimalNumbers: $1.generatesDecimalNumbers,
                         locale: $0, currencySymbol: $1.currencySymbol) }
        )
        
        fileprivate static let currencySymbol = Lens<NumberFormatterConfig, String>(
            view: { $0.currencySymbol },
            set: { .init(numberStyle: $1.numberStyle, roundingMode: $1.roundingMode,
                         maximumFractionDigits: $1.maximumFractionDigits, generatesDecimalNumbers: $1.generatesDecimalNumbers,
                         locale: $1.locale, currencySymbol: $0) }
        )
    }
}


