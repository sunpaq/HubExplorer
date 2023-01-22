//
//  APIConst.swift
//  HubExplorer
//
//  Created by 孙御礼 on 2023/01/21.
//

import Foundation

enum API {
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
    
    enum ErrorType: Error {
        case cancel
        case unknownError
        case invalidURL
        case requestFailed(Int)
        case exceedLimit(TimeInterval)
    }
}
