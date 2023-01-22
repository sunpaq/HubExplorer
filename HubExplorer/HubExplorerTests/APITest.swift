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

    func testSingleRequest() async throws {
        debugPrint("SEARCH START")
        do {
            let response = try await SearchRepository(inputQuery: "monkc").fire()
            debugPrint("SEARCH RESULT: \(response)")
        } catch {
            debugPrint("SEARCH FAILED: \(error)")
        }
    }
    
    func testExceedLimit() async throws {
        let queries = [
            "a",
            "ab",
            "abc",
            "abcd",
            "abcde",
            "abcde f",
            "abcde fg",
            "abcde fgh",
            "abcde fghi",
            "abcde fghij",
            "abcde fghij k",
        ]
        do {
            for q in queries {
                let request = SearchRepository(inputQuery: q)
                _ = try await APIService.shared.schedule(request: request)
            }
            XCTFail("didn't throw exceed limit error")
        } catch API.ErrorType.exceedLimit(let freeze) {
            debugPrint("SUCCESS freeze:\(freeze)")
        } catch {
            debugPrint("ERROR: \(error)")
        }
    }
}
