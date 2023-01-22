//
//  ContentView.swift
//  HubExplorer
//
//  Created by 孙御礼 on 2023/01/21.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject var viewModel = ViewModel()
    
    @State var loadingMore: Bool = false
    
    var body: some View {
        VStack {
            Text("HubExplorer")
            HStack {
                TextField("please input", text: $viewModel.userInput)
                if viewModel.loading {
                    Spacer()
                    ProgressView()
                }
            }
            switch viewModel.uistate {
            case .welcome:
                Spacer()
                Text("Welcome to HubExplorer")
                Spacer()
            case .error(let errorMessage):
                Spacer()
                Text(errorMessage)
                Spacer()
            case .notfound:
                Spacer()
                Text("Not found")
                Spacer()
            case .success:
                List {
                    Section {
                        ForEach(viewModel.resultList) { item in
                            HStack {
                                Text(item.name)
                                Spacer()
                            }
                            .onAppear {
                                if item == viewModel.resultList.last {
                                    Task(priority: .userInitiated) {
                                        loadingMore = true
                                        await viewModel.loadMoreResult()
                                        loadingMore = false
                                    }
                                }
                            }
                        }
                    } header: {
                        HStack {
                            Text("Results(\(viewModel.resultList.count)/\(viewModel.resultTotalCount))")
                            Spacer()
                        }
                    }
                }
                .listStyle(.plain)
                if loadingMore {
                    ProgressView()
                }
            case .limit:
                Spacer()
                Text("Please wait \(viewModel.countdown) seconds")
                Spacer()
            }
        }
        .padding()
        .onChange(of: scenePhase) { phase in
            if phase == .inactive {
                APIService.shared.persist()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
