//
//  String+BoldTag.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/13.
//

import Foundation

extension String {
    func boldTagRemove() -> String {
        var text = self
        text = text.replacingOccurrences(of: "<b>", with: "")
        text = text.replacingOccurrences(of: "</b>", with: "")
        return text
    }
    
    func boldTagRanges() -> [NSRange]? {
           let pattern = "<b>(.*?)</b>"
           
           guard let regex = try? NSRegularExpression(pattern: pattern) else {
               return nil
           }
           
           let matches = regex.matches(in: self, options: [], range: NSRange(location: 0, length: self.utf16.count))
           
           if matches.isEmpty {
               return nil
           }
           
           var results: [NSRange] = []
           
           for match in matches {
               let fullRange = match.range(at: 0)
               let innerRange = match.range(at: 1)
               let actualRange = NSRange(location: fullRange.location, length: innerRange.length)
               results.append(actualRange)
           }
           
           return results
       }
}
