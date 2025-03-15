//
//  Date+Extension.swift
//  EffectiveMobile
//
//  Created by Irina Muravyeva on 11.03.2025.
//

import Foundation

extension Date {
    /// Converts `Date` to a string in the `dd/MM/yy' format.`
    func formattedString() -> String {
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "dd/MM/yy"
        return outputFormatter.string(from: self)
    }
    
    /// Converts a string to a `Date` with the input format `dd/MM/yy'
    static func fromString(_ dateString: String, format: String = "dd/MM/yy") -> Date? {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = format
        inputFormatter.locale = Locale(identifier: "en_US_POSIX")
        return inputFormatter.date(from: dateString)
    }
}
