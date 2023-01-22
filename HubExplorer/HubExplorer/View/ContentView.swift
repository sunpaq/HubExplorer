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
                            NavigationLink {
                                DetailView(viewModel: DetailView.ViewModel(repoName: item.name))
                            } label: {
                                ItemView(item: item, viewModel: viewModel, loadingMore: $loadingMore)
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

struct ItemView: View {
    
    let item: ContentView.ResultItem
    @StateObject var viewModel: ContentView.ViewModel
    @Binding var loadingMore: Bool
    
    var body: some View {
        HStack {
            AsyncImage(url: URL(string: item.avator)) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFill()
            }
            .frame(width: 44, height: 44)
            .background(.gray)
            .clipShape(Circle())
            Text(item.name)
            Spacer()
        }
        .onAppear {
            if item == viewModel.resultList.last {
                handleLastItemAppear()
            }
        }
    }
    
    func handleLastItemAppear() {
        Task(priority: .background) {
            loadingMore = true
            await viewModel.loadMoreResult()
            loadingMore = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
