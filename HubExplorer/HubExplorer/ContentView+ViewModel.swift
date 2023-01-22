//
//  SearchResultViewModel.swift
//  HubExplorer
//
//  Created by 孙御礼 on 2023/01/21.
//

import UIKit
import Combine

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
            case notfound
            case loading
            case success
            case limit
        }
        
        ///UI
        @Published var uistate: UIState = .success
        @Published var countdown: Int = 0
        
        ///non-UI
        @Published var userInput: String = ""
        
        @Published var resultList: [ResultItem] = []
        
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
                    Task(priority: .userInitiated) {
                        await self.refreshResult(query: newValue)
                    }
                }.store(in: &cancellables)
        }
        
        func refreshResult(query: String) async {
            guard !query.isEmpty else {
                resultList.removeAll()
                uistate = .notfound
                return
            }
            stopFreezeTimer()
            do {
                uistate = .loading
                let request = SearchRepository(inputQuery: query)
                let response = try await APIService.shared.schedule(request: request)
                resultList.removeAll()
                let list = response.items.map({ ResultItem(name: $0.fullName) })
                guard !list.isEmpty else {
                    uistate = .notfound
                    return
                }
                resultList.append(contentsOf: list)
                uistate = .success
            } catch API.ErrorType.exceedLimit(let freeze) {
                countdown = Int(freeze)
                uistate = .limit
                startFreezeTimer()
            } catch {
                debugPrint(error)
                uistate = .error("\(error)")
            }
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
                await refreshResult(query: userInput)
            }
        }
    }
}
