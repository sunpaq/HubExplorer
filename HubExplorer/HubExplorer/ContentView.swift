//
//  ContentView.swift
//  HubExplorer
//
//  Created by 孙御礼 on 2023/01/21.
//

import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = ViewModelMock()
    
    var body: some View {
        VStack {
            Text("HubExplorer")
            TextField("please input", text: $viewModel.userInput)
            switch viewModel.uistate {
            case .error(let errorMessage):
                Spacer()
                Text(errorMessage)
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
