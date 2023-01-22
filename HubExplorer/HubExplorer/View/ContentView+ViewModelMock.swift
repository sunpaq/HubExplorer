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
        
        override func refreshResult(query: String, page: UInt, perPage: UInt) async {
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
            uistate = .success
            loading = true
        }
        
        func testSuccess(query: String) async {
            uistate = .success
            loading = true
            Task(priority: .background) {
                if !userInput.isEmpty {
                    resultList.append(ResultItem(name: query, avator: ""))
                } else {
                    resultList.removeAll()
                }
                uistate = .success
                loading = false
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
