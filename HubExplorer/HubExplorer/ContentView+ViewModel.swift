//
//  SearchResultViewModel.swift
//  HubExplorer
//
//  Created by 孙御礼 on 2023/01/21.
//

import Foundation

extension ContentView {
    
    struct ResultItem: Identifiable {
        let id = UUID()
        let name: String
        
        init(name: String) {
            self.name = name
        }
    }
    
    @MainActor class ViewModel: ObservableObject {
        
        enum UIState {
            case error(String)
            case loading
            case success
        }
        
        ///UI
        @Published var uistate: UIState = .success
        
        ///non-UI
        @Published var userInput: String = "" {
            didSet {
                Task {
                    await refreshResult()
                }
            }
        }
        
        @Published var resultList: [ResultItem] = []
        
        func refreshResult() async {
            //TODO
        }
    }
}
