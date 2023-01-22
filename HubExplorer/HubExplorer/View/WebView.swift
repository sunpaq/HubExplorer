//
//  WebView.swift
//  HubExplorer
//
//  Created by 孙御礼 on 2023/01/22.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    
    typealias UIViewType = WKWebView
    
    let url: URL
    @Binding var loading: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        let webview = WKWebView(frame: .zero)
        webview.navigationDelegate = context.coordinator
        webview.load(URLRequest(url: url))
        return webview
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {}
    
    func makeCoordinator() -> WebViewCoordinator {
        WebViewCoordinator {
            loading = true
        } didFinishAction: {
            loading = false
        }
    }
}

class WebViewCoordinator: NSObject, WKNavigationDelegate {
    
    let didStartAction: () -> Void
    let didFinishAction: () -> Void
    
    init(didStartAction: @escaping () -> Void, didFinishAction: @escaping () -> Void) {
        self.didStartAction = didStartAction
        self.didFinishAction = didFinishAction
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        didStartAction()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        didFinishAction()
    }
}
