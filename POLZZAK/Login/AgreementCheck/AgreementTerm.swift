//
//  AgreementTerm.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/07/26.
//

import Foundation

enum AgreementTermType {
    case main
    case sub
}

struct AgreementTerm {
    let title: String
    let type: AgreementTermType
    let contentsURL: URL
    var isAccepted: Bool = false
}
