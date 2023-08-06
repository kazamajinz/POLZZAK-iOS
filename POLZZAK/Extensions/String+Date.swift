//
//  String+Date.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/08/02.
//

import Foundation

extension String {
    func remainingDays() -> String {
        let dateFormatter = ISO8601DateFormatter()
        guard let endDate = dateFormatter.date(from: self) else {
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
        let dateFormatter = ISO8601DateFormatter()
        guard let date = dateFormatter.date(from: self) else {
            return ""
        }
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yy.MM.dd"
        return outputFormatter.string(from: date)
    }
}
