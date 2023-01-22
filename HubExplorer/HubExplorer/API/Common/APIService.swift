//
//  APIService.swift
//  HubExplorer
//
//  Created by 孙御礼 on 2023/01/21.
//

import Foundation

class APIService {
    
    static let shared = APIService()
    
    private var queue = [TimeInterval]()
    
    func nowTimestamp() -> TimeInterval {
        Date().timeIntervalSince1970
    }
    
    private func execute<Request: APIRequest>(request: Request) async throws -> Request.ResponseType {
        do {
            let response = try await request.fire()
            return response
        } catch {
            throw error
        }
    }
    
    func schedule<Request: APIRequest>(request: Request) async throws -> Request.ResponseType {
        if queue.count >= 10 {
            let now = nowTimestamp()
            let interval = now - queue.first!
            if interval <= 60 {
                let wait = 60.0 - floor(interval)
                throw API.ErrorType.exceedLimit(wait)
            } else {
                queue.removeFirst()
                queue.append(now)
                return try await execute(request: request)
            }
        } else {
            queue.append(nowTimestamp())
            return try await execute(request: request)
        }
    }
}
