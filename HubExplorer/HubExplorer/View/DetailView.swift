//
//  DetailView.swift
//  HubExplorer
//
//  Created by 孙御礼 on 2023/01/22.
//

import SwiftUI
import WebKit

struct DetailView: View {
    
    @StateObject var viewModel: ViewModel
    
    var body: some View {
        if let url = URL(string: viewModel.urlString) {
            WebView(url: url, loading: $viewModel.loading)
                .overlay {
                    if viewModel.loading {
                        ProgressView()
                    } else {
                        EmptyView()
                    }
                }
        } else {
            Text("Malformed URL: \(viewModel.urlString)")
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(viewModel: DetailView.ViewModel(repoName: "sunpaq/monkc"))
    }
}
