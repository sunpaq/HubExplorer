//
//  APIRequest.swift
//  HubExplorer
//
//  Created by 孙御礼 on 2023/01/21.
//

import Foundation

protocol APIRequest {
    
    associatedtype ResponseType: Decodable
    
    var method: API.Method { get }
    
    var base: String { get }

    var path: String { get }
    
    var query: String { get }
        
    func fire(page: UInt, perPage: UInt) async throws -> ResponseType
}

extension APIRequest {
    
    func fire(page: UInt, perPage: UInt) async throws -> ResponseType {
        guard var url = URL(string: base + "/" + path) else {
            throw API.ErrorType.invalidURL
        }
        url.append(queryItems: [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "per_page", value: "\(perPage)")
        ])
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let status = (response as? HTTPURLResponse)?.statusCode else {
                throw API.ErrorType.unknownError
            }
            guard status == 200 else {
                throw API.ErrorType.requestFailed(status)
            }
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decoded = try decoder.decode(ResponseType.self, from: data)
            return decoded
        } catch {
            throw error
        }
    }
}
