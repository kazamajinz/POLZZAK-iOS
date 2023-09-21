//
//  String+Date.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/02.
//

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
        let components = calendar.dateComponents([.day], from: endDate, to: Date())
        guard let day = components.day, day != 0 else {
            return "⏰ D-0"
        }
        
        return "⏰ D\(day)"
    }
    
    private func formattedDate(_ format: String) -> String {
        guard let date = dateFromCustomString() else {
            return ""
        }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = format
        return outputFormatter.string(from: date)
    }
    
    func shortDateFormat() -> String {
        return formattedDate("yy.MM.dd")
    }
    
    func longDateFormat() -> String {
        return formattedDate("yyyy. MM. dd")
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
        
        let hourInSeconds: TimeInterval = 3600
        
        let currentTime = Date()
        let timeInterval = currentTime.timeIntervalSince(targetDate)
        if timeInterval > hourInSeconds {
            return nil
        }

        let minutesRemaining = 59 - (Int(timeInterval) / 60)
        let secondsRemaining = 59 - (Int(timeInterval) % 60)

        return String(format: "%02d:%02d", minutesRemaining, secondsRemaining)
    }
    
    func remainingTimeToString() -> String? {
        guard let targetDate = dateFromCustomString() else {
            return nil
        }
        
        let minuteInSeconds: TimeInterval = 60
        let hourInSeconds: TimeInterval = 3600
        let dayInSeconds: TimeInterval = 86400
        let threeDaysInSeconds: TimeInterval = 259200
        
        let interval = Date().timeIntervalSince(targetDate)
        switch interval {
        case 0..<minuteInSeconds:
            return "방금 전"
        case minuteInSeconds..<hourInSeconds:
            return "\(Int(interval / minuteInSeconds))분 전"
        case hourInSeconds..<dayInSeconds:
            return "\(Int(interval / hourInSeconds))시간 전"
        case dayInSeconds..<threeDaysInSeconds:
            return "\(Int(interval / dayInSeconds))일 전"
        default:
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM.dd"
            return dateFormatter.string(from: targetDate)
        }
    }

}
