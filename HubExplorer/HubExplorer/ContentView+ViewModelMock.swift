//
//  ContentView+ViewModelMock.swift
//  HubExplorer
//
//  Created by 孙御礼 on 2023/01/21.
//

import UIKit

extension ContentView {
    
    class ViewModelMock: ViewModel {
        
        enum TestCase {
            case loading
            case success
            case error
            case nodata
        }
        
        let testcase: TestCase = .success
        
        override func refreshResult(query: String) async {
            switch testcase {
            case .loading:
                await testLoading()
            case .success:
                await testSuccess(query: query)
            case .error:
                await testError()
            case .nodata:
                await testNoData()
            }
        }
        
        func testLoading() async {
            uistate = .loading
        }
        
        func testSuccess(query: String) async {
            uistate = .loading
            Task(priority: .background) {
                if !userInput.isEmpty {
                    resultList.append(ResultItem(name: query))
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
        
        func testNoData() async {
            let errorText = "No Data"
            uistate = .error(errorText)
        }
    }
}
