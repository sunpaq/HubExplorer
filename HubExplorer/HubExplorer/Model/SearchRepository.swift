//
//  SearchRepository.swift
//  HubExplorer
//
//  Created by 孙御礼 on 2023/01/21.
//

import Foundation

struct SearchRepository: APIRequest {
    
    struct Owner: Codable {
        let login: String
        let id: UInt64
        let nodeId: String
        let avatarUrl: String
    }

    struct Item: Codable {
        let id: UInt64
        let nodeId: String
        let name: String
        let fullName: String
        let owner: Owner
    }

    struct Response: Codable {
        let totalCount: Int
        let incompleteResults: Bool
        let items: [Item]
    }
    
    typealias ResponseType = Response
    
    var method: API.Method {
        .GET
    }
    
    var base: String {
        "https://api.github.com"
    }
    
    var path: String {
        "search/repositories"
    }
    
    var query: String {
        inputQuery
    }
    
    let inputQuery: String
    
    init(inputQuery: String) {
        self.inputQuery = inputQuery
    }
}
