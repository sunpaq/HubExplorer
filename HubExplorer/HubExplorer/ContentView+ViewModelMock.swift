//
//  ContentView+ViewModelMock.swift
//  HubExplorer
//
//  Created by 孙御礼 on 2023/01/21.
//

import Foundation

extension ContentView {
    
    class ViewModelMock: ViewModel {
        
        enum TestCase {
            case loading
            case success
            case error
        }
        
        let testcase: TestCase = .success
        
        override func refreshResult() async {
            switch testcase {
            case .loading:
                await testLoading()
            case .success:
                await testSuccess()
            case .error:
                await testError()
            }
        }
        
        func testLoading() async {
            uistate = .loading
        }
        
        func testSuccess() async {
            uistate = .loading
            Task(priority: .background) {
                if !userInput.isEmpty {
                    resultList.append(ResultItem(name: userInput))
                } else {
                    resultList.removeAll()
                }
                uistate = .success
            }
        }
        
        func testError() async {
            let errorText = "Oops... 404"
            uistate = .error(errorText)
        }
    }
}
