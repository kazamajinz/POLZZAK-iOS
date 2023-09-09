//
//  String+Date.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/02.
//

import Foundation

import Foundation

extension String {
    private var customDateFormatter: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        return dateFormatter
    }
    
    private func dateFromCustomString() -> Date? {
        return customDateFormatter.date(from: self)
    }

    func remainingDays() -> String {
        guard let endDate = dateFromCustomString() else {
            return "⏰ D-0"
        }
        let calendar = Calendar.current
        let startDay = calendar.startOfDay(for: Date())
        let endDay = calendar.startOfDay(for: endDate)
        let components = calendar.dateComponents([.day], from: startDay, to: endDay)
        guard let day = components.day else {
            return "⏰ D-0"
        }
        return "⏰ D-\(day)"
    }
    
    func shortDateFormat() -> String {
        guard let date = dateFromCustomString() else {
            return ""
        }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yy.MM.dd"
        return outputFormatter.string(from: date)
    }
    
    func longDateFormat() -> String {
        guard let date = dateFromCustomString() else {
            return ""
        }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy. MM. dd"
        return outputFormatter.string(from: date)
    }
    
    func daysDifference(from startDateString: String) -> String {
        guard let startDate = startDateString.dateFromCustomString(),
              let endDate = self.dateFromCustomString() else {
            return "0"
        }
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        return String(components.day ?? 0)
    }
}
