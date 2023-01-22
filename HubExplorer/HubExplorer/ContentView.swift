//
//  ContentView.swift
//  HubExplorer
//
//  Created by 孙御礼 on 2023/01/21.
//

import SwiftUI

struct ContentView: View {
    
    //@StateObject var viewModel = ViewModelMock()
    @StateObject var viewModel = ViewModel()

    var body: some View {
        VStack {
            Text("HubExplorer")
            TextField("please input", text: $viewModel.userInput)
            switch viewModel.uistate {
            case .error(let errorMessage):
                Spacer()
                Text(errorMessage)
                Spacer()
            case .notfound:
                Spacer()
                Text("Not found")
                Spacer()
            case .loading:
                Spacer()
                ProgressView()
                Spacer()
            case .success:
                List {
                    ForEach(viewModel.resultList) { item in
                        Text(item.name)
                    }
                }
                .listStyle(.plain)
            case .limit:
                Spacer()
                Text("Please wait \(viewModel.countdown) seconds")
                Spacer()
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
