//
//  HubExplorerApp.swift
//  HubExplorer
//
//  Created by 孙御礼 on 2023/01/21.
//

import SwiftUI

@main
struct HubExplorerApp: App {
    
    let testmode = false
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                if testmode {
                    ListView(viewModel: ListView.ViewModelMock())
                } else {
                    ListView(viewModel: ListView.ViewModel())
                }
            }
            .onAppear {
                APIService.shared.restore()
            }
        }
    }
}
