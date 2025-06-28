//
//  DateFormatterUtility.swift
//  SafeAndBrave
//
//  Created by Akif Emre Bozdemir on 6/28/25.
//
import Foundation

/// Centralized date formatting utility for consistent date handling across the app
struct DateFormatterUtility {
    
    // MARK: - Shared Formatters
    
    /// Format: "2025-06-28T14:30:15.123Z"
    static let iso8601Formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC
        return formatter
    }()
    
    /// Format: "2025-06-28T14:30:15Z"
    static let iso8601FormatterSimple: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(secondsFromGMT: 0) // UTC
        return formatter
    }()
    
    /// Format: "2025-06-28"
    static let dateOnlyFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    /// Format: "June 28, 2025"
    static let displayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    /// Format: "June 28, 2025 at 2:30 PM"
    static let displayFormatterWithTime: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter
    }()
    
    
    /// Convert Date to ISO8601 string for API requests
    static func toAPIString(from date: Date) -> String {
        return iso8601Formatter.string(from: date)
    }
    
    /// Convert ISO8601 string from API to Date
    static func fromAPIString(_ dateString: String) -> Date? {
        if let date = iso8601Formatter.date(from: dateString) {
            return date
        }
        return iso8601FormatterSimple.date(from: dateString)
    }
    
    static func toDateOnlyString(from date: Date) -> String {
        return dateOnlyFormatter.string(from: date)
    }
    
    static func fromDateOnlyString(_ dateString: String) -> Date? {
        return dateOnlyFormatter.date(from: dateString)
    }
    
    static func toDisplayString(from date: Date, includeTime: Bool = false) -> String {
        if includeTime {
            return displayFormatterWithTime.string(from: date)
        } else {
            return displayFormatter.string(from: date)
        }
    }
    
    static func calculateAge(from birthDate: Date, to currentDate: Date = Date()) -> Int {
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: currentDate)
        return ageComponents.year ?? 0
    }
}

// JSONEncoder/JSONDecoder Extensions
extension JSONEncoder {
    static var apiEncoder: JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .formatted(DateFormatterUtility.iso8601Formatter)
        return encoder
    }
}

extension JSONDecoder {
    static var apiDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateString = try container.decode(String.self)
            
            guard let date = DateFormatterUtility.fromAPIString(dateString) else {
                throw DecodingError.dataCorruptedError(
                    in: container,
                    debugDescription: "Cannot decode date string \(dateString)"
                )
            }
            return date
        }
        return decoder
    }
}

extension Date {
    /// Convert to API string format
    var apiString: String {
        return DateFormatterUtility.toAPIString(from: self)
    }
    
    /// Convert to display string
    var displayString: String {
        return DateFormatterUtility.toDisplayString(from: self)
    }
    
    /// Convert to display string with time
    var displayStringWithTime: String {
        return DateFormatterUtility.toDisplayString(from: self, includeTime: true)
    }
    
    /// Convert to date-only string
    var dateOnlyString: String {
        return DateFormatterUtility.toDateOnlyString(from: self)
    }
    
    /// Calculate age from this date to now
    var ageFromNow: Int {
        return DateFormatterUtility.calculateAge(from: self)
    }
}

extension String {
    /// Convert API date string to Date
    var apiDate: Date? {
        return DateFormatterUtility.fromAPIString(self)
    }
    
    /// Convert date-only string to Date
    var dateOnlyDate: Date? {
        return DateFormatterUtility.fromDateOnlyString(self)
    }
}
