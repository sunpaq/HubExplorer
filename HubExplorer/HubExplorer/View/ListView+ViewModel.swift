//
//  SearchResultViewModel.swift
//  HubExplorer
//
//  Created by 孙御礼 on 2023/01/21.
//

import UIKit
import Combine

extension ListView {
    
    struct ResultItem: Identifiable, Equatable {
        let id = UUID()
        let name: String
        let avator: String
        
        init(name: String, avator: String) {
            self.name = name
            self.avator = avator
        }
    }
    
    @MainActor class ViewModel: ObservableObject {
        
        enum UIState: Equatable {
            case welcome
            case success
            case notfound
            case limit
            case error(String)
        }
        
        ///UI
        @Published var uistate: UIState = .welcome
        @Published var loading: Bool = false
        @Published var countdown: Int = 0
        
        ///non-UI
        @Published var userInput: String = ""
        
        @Published var resultList: [ResultItem] = []
        @Published var resultTotalCount: Int = 0
        
        private var currentPage: UInt = 1
        private let perPage: UInt = 30
        
        private var freezeTimer: Timer? {
            willSet {
                freezeTimer?.invalidate()
            }
        }
        
        private var cancellables = Set<AnyCancellable>()
        
        init() {
            $userInput
                .receive(on: RunLoop.main)
                .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
                .removeDuplicates()
                .sink { [weak self] newValue in
                    guard let self = self else { return }
                    if newValue.isEmpty && self.uistate == .welcome { return }
                    Task(priority: .userInitiated) {
                        await self.refreshResult(query: newValue, page: 1, perPage: self.perPage)
                    }
                }.store(in: &cancellables)
        }
        
        func refreshResult(query: String, page: UInt, perPage: UInt) async {
            guard !query.isEmpty else {
                resultList.removeAll()
                uistate = .notfound
                loading = false
                return
            }
            stopFreezeTimer()
            do {
                if page <= 1 {
                    uistate = .success
                    loading = true
                }
                let request = SearchRepository(inputQuery: query)
                let response = try await APIService.shared.schedule(request: request, page: page, perPage: perPage)
                guard response.totalCount > 0, response.items.count > 0 else {
                    resultList.removeAll()
                    uistate = .notfound
                    loading = false
                    return
                }
                resultTotalCount = response.totalCount
                let list = response.items.map({
                    ResultItem(name: $0.fullName, avator: $0.owner.avatarUrl)
                })
                if page <= 1 {
                    resultList.removeAll()
                }
                resultList.append(contentsOf: list)
                uistate = .success
                loading = false
            } catch API.ErrorType.exceedLimit(let freeze) {
                countdown = Int(freeze)
                uistate = .limit
                loading = false
                startFreezeTimer()
            } catch {
                debugPrint(error)
                uistate = .error("\(error)")
                loading = false
            }
        }
        
        func loadMoreResult() async {
            self.currentPage += 1
            await refreshResult(query: userInput, page: self.currentPage, perPage: self.perPage)
        }
        
        func startFreezeTimer() {
            freezeTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] timer in
                guard let self = self else { return }
                Task(priority: .userInitiated) {
                    await MainActor.run {
                        if self.countdown > 0 {
                            self.countdown -= 1
                        } else {
                            self.handleFreezeEnd()
                        }
                    }
                }
            }
        }
        
        func stopFreezeTimer() {
            freezeTimer = nil
        }
        
        func handleFreezeEnd() {
            stopFreezeTimer()
            Task(priority: .userInitiated) {
                await refreshResult(query: userInput, page: 1, perPage: self.perPage)
            }
        }
    }
}
