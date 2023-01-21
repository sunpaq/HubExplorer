//
//  SearchResultModel.swift
//  HubExplorer
//
//  Created by 孙御礼 on 2023/01/21.
//

import Foundation

//SR = search result

enum Search {
    enum Repository {
        
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
    }
}

class SearchResultModel {
    
    func search(input: String) async -> Search.Repository.Response? {
        do {
            let response = try await APIService<Search.Repository.Response>().request(method: .GET,
                               base: "https://api.github.com",
                               path: "search/repositories",
                               query: input)
            return response
        } catch {
            debugPrint(error)
            return nil
        }
    }
}
