//
//  DetailView+ViewModel.swift
//  HubExplorer
//
//  Created by 孙御礼 on 2023/01/22.
//

import Foundation
import WebKit

extension DetailView {
    
    class ViewModel: ObservableObject {
        
        @Published var loading: Bool = true
        
        let githubBase = "https://github.com"
        
        var repoName: String = ""
        
        var urlString: String {
            "\(githubBase)/\(repoName)"
        }
        
        convenience init(repoName: String) {
            self.init()
            self.repoName = repoName
        }
    }
}
