//
//  ReponseDataProtocol.swift
//  POLZZAK
//
//  Created by 이정환 on 2023/09/17.
//

import Foundation

protocol ResponseDataProtocol {
    associatedtype DataType
    var code: Int { get }
    var messages: [String]? { get }
    var data: DataType? { get }
}
