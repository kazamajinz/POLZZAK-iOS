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
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"//.SSSSSSSSS
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
        let components = calendar.dateComponents([.day], from: endDay, to: startDay)
        guard let day = components.day, day != 0 else {
            return "⏰ D-0"
        }
        
        return "⏰ D\(day)"
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

    func remainingHourTime() -> String? {
        guard let targetDate = dateFromCustomString() else {
            return nil
        }
        
        let currentTime = Date()
        let timeInterval = currentTime.timeIntervalSince(targetDate)
        if timeInterval > 3600 {
            return nil
        }

        let minutesRemaining = 59 - (Int(timeInterval) / 60)
        let secondsRemaining = 59 - (Int(timeInterval) % 60)

        return String(format: "%02d:%02d", minutesRemaining, secondsRemaining)
    }

}
