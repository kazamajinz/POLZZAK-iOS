//
//  TestUtilities.swift
//  POLZZAKTests
//
//  Created by 이정환 on 2023/09/20.
//

import Foundation

enum TestError: Error {
    case fileNotFound
    case invalidURL
    case dataLoadingError
}

class TestUtilities {
    static func loadMockResponse(from fileName: String) throws -> (Data, URLResponse) {
        guard let url = Bundle(for: TestUtilities.self).url(forResource: fileName, withExtension: "json") else {
            throw TestError.fileNotFound
        }

        do {
            let data = try Data(contentsOf: url)
            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            guard let statusCode = json["code"] as? Int else {
                throw TestError.dataLoadingError
            }
            let mockURLResponse = HTTPURLResponse(url: url, statusCode: statusCode, httpVersion: nil, headerFields: nil)!
            return (data, mockURLResponse)
        } catch {
            throw TestError.dataLoadingError
        }
    }
    
    static func loadMockResponseDTO<T: Decodable>(from fileName: String) throws -> T {
            let (data, _) = try loadMockResponse(from: fileName)
            do {
                let dto = try JSONDecoder().decode(T.self, from: data)
                return dto
            } catch {
                throw TestError.dataLoadingError
            }
        }
}
