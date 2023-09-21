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
    var headers: [String : String]? {
        return ["Content-Type": "multipart/form-data; charset=UTF-8"]
    }
    
    func getURLRequest() throws -> URLRequest {
        let boundary = UUID().uuidString
        let url = try url()
        var urlRequest = URLRequest(url: url)

        // httpBody
        if let formData = try formData {
            var data = Data()
            for formData in formData {
                data.append(Self.formData(formData: formData, using: boundary))
            }
            data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            
            urlRequest.httpBody = data
        }

        // httpMethod
        urlRequest.httpMethod = method.rawValue

        // header
        headers?.forEach {
            let value = $0 == "Content-Type" ? $1 + "; boundary=\(boundary)": $1
            urlRequest.setValue(value, forHTTPHeaderField: $0)
        }
        
        return urlRequest
    }
    
    static func formData(formData: FormData, using boundary: String) -> Data {
        var fieldString = ""
        fieldString += "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\(formData.name); filename=\(formData.filename)\r\n"
        fieldString += "Content-Type: \(formData.contentType)\r\n"
        fieldString += "\r\n"
        
        var fdata = fieldString.data(using: .utf8)!
        fdata.append(formData.data)
        fdata.append("\r\n".data(using: .utf8)!)
        
        return fdata
    }
}
