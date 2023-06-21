//
//  AlertStyleProtocol.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/15.
//

import UIKit

protocol AlertStyleProtocol {
    var emphasisLabelStyle: EmphasisLabelStyle { get }
    var buttonStyle: ButtonCountStyle { get }
    var buttons: [LabelStyle] { get }
    var borderStyle: BorderStyle { get }
    var buttonBorderStyle: BorderStyle { get }
    var buttonSpacing: CGFloat { get }
    var isLoading: Bool { get }
}


enum ButtonCountStyle {
    case single
    case double
}

