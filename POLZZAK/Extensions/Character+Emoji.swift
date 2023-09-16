//
//  Character+Emoji.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/15.
//

import Foundation

extension String {
    var startsWithEmoji: Bool {
        guard let firstCharacter = self.first else {
            return false
        }
        
        for scalar in firstCharacter.unicodeScalars {
            switch scalar.value {
            case 0x1F600...0x1F64F,  // Emoticons
                 0x1F300...0x1F5FF,  // Misc Symbols and Pictographs
                 0x1F680...0x1F6FF,  // Transport and Map
                 0x1F700...0x1F77F,  // Alchemical Symbols
                 0x1F780...0x1F7FF,  // Geometric Shapes Extended
                 0x1F800...0x1F8FF,  // Supplemental Arrows-C
                 0x1F900...0x1F9FF,  // Supplemental Symbols and Pictographs
                 0x2600...0x26FF,    // Misc symbols
                 0x2700...0x27BF,    // Dingbats
                 0xE0020...0xE007F,  // Tags
                 0xFE00...0xFE0F,    // Variation Selectors
                 0x1F004,            // Mahjong Tile Red Dragon
                 0x1F0CF,            // Playing Card Black Joker
                 0x1F170...0x1F251,  // Enclosed Alphanumeric Supplement
                 0x1F300...0x1F3FA:  // Misc Symbols and Pictographs
                return true
            default:
                continue
            }
        }
        return false
    }
}
