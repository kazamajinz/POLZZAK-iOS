//
//  MultipartFormTargetType.swift
//  POLZZAK
//
//  Created by Jinyoung Kim on 2023/06/19.
//

import Foundation

struct FormData {
    let name: String
    let filename: String
    let contentType: String
    let data: Data
}

protocol MultipartFormTargetType: TargetType {
    var formData: [FormData]? { get throws }
}

extension MultipartFormTargetType {
    func getURLRequest() throws -> URLRequest {
        let url = try url()
        var urlRequest = URLRequest(url: url)

        // httpBody
        if let formData = try formData {
            var data = Data()
            let boundary = UUID().uuidString
            for formData in formData {
                data.append("--\(boundary)".data(using: .utf8)!)
                data.append(Self.formData(formData: formData))
            }
            data.append("--\(boundary)--".data(using: .utf8)!)
            urlRequest.httpBody = data
        }

        // httpMethod
        urlRequest.httpMethod = method.rawValue

        // header
        headers?.forEach { urlRequest.setValue($1, forHTTPHeaderField: $0) }

        return urlRequest
    }
}

extension MultipartFormTargetType {
    static func formData(formData: FormData) -> Data {
        var fieldString = ""
        fieldString += "Content-Disposition: form-data; name=\(formData.name); filename=\(formData.filename)\r\n"
        fieldString += "Content-Type: \(formData.contentType)"
        fieldString += "\r\n"
        
        var fdata = fieldString.data(using: .utf8)!
        fdata.append(formData.data)
        
        return fdata
    }
}
