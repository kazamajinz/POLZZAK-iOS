//
//  EmptyStyleProtocol.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/06/19.
//

import UIKit

protocol EmptyStyleProtocol {
    var labelStyle: LabelStyleProtocol { get }
    var topConstraint: CGFloat { get } //0일 경우 Center 
    var emptyImage: UIImage? { get }
}
