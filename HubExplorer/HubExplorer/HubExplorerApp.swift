//
//  HubExplorerApp.swift
//  HubExplorer
//
//  Created by 孙御礼 on 2023/01/21.
//

import SwiftUI

@main
struct HubExplorerApp: App {
        
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ContentView()
            }
            .onAppear {
                APIService.shared.restore()
            }
        }
    }
}
