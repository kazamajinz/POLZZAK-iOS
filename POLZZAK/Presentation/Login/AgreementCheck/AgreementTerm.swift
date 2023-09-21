//
//  AgreementTerm.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/07/26.
//

import Foundation
import UIKit

enum AgreementTermType {
    case main
    case sub
}

struct AgreementTerm {
    let title: String
    let contentsURL: URL?
    let type: AgreementTermType
    let font: UIFont
    let normalTextColor: UIColor
    let selectedTextColor: UIColor
    let backgroundColor: UIColor
    var isAccepted: Bool = false
    
    init(
        title: String,
        contentsURL: URL? = nil,
        type: AgreementTermType,
        font: UIFont = .body15Md,
        normalTextColor: UIColor = .gray500,
        selectedTextColor: UIColor = .gray800,
        backgroundColor: UIColor = .clear
    ) {
        self.title = title
        self.contentsURL = contentsURL
        self.type = type
        self.font = font
        self.normalTextColor = normalTextColor
        self.selectedTextColor = selectedTextColor
        self.backgroundColor = backgroundColor
    }
}
