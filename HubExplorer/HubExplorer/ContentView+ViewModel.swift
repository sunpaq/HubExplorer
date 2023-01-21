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
    
    class ViewModel: ObservableObject {
        @Published var userInput: String = "" {
            didSet {
                refreshResult()
            }
        }
        
        @Published var resultList: [ResultItem] = []
        
        func refreshResult() {
            //TODO
        }
    }
    
    class ViewModelMock: ViewModel {
        
        override func refreshResult() {
            resultList.append(ResultItem(name: userInput))
        }
    }
}
