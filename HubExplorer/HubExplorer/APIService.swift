//
//  APIService.swift
//  HubExplorer
//
//  Created by 孙御礼 on 2023/01/21.
//

import Foundation

class APIService<T: Decodable> {
    
    enum Method: String {
        case GET
        case POST
        case PUT
        case DELETE
    }
    
    enum StatusCode: Int {
        case notModified = 304
        case forbidden = 403
        case validationFailed = 422
        case serviceUnavailable = 503
    }
    
    enum APIError: Error {
        case unknownError
        case invalidURL
        case requestFailed(Int)
    }
    
    func request(method: Method, base: String, path: String, query: String) async throws -> T {
        guard var url = URL(string: base + "/" + path + "?q=\(query)") else {
            throw APIError.invalidURL
        }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let status = (response as? HTTPURLResponse)?.statusCode else {
                throw APIError.unknownError
            }
            guard status == 200 else {
                throw APIError.requestFailed(status)
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decoded = try decoder.decode(T.self, from: data)
            return decoded
        } catch {
            throw error
        }
    }
}
