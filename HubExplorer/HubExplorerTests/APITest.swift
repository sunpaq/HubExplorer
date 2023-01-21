//
//  APITest.swift
//  HubExplorerTests
//
//  Created by 孙御礼 on 2023/01/21.
//

import XCTest

final class APITest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testSearch() async throws {
        do {
            debugPrint("SEARCH START")
            let response = await SearchResultModel().search(input: "monkc")
            XCTAssertNotNil(response)
            debugPrint("SEARCH RESULT: \(response!)")
        } catch {
            throw error
        }
    }
}
