//
//  OrionBrowserExtension+WKNavigationDelegate.swift
//  Orion
//
//  Created by Corban Amouzou on 2022-01-05.
//

import Foundation
import WebKit

extension OrionBrowserExtension: WKNavigationDelegate, WKURLSchemeHandler {
    func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) {
        print("called")
    }

    func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) {
        print("called")
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        let patchJS = """
        document.head.innerHTML = "<base href='\(extensionPath.path)'/>" + document.head.innerHTML
        """
        webView.evaluateJavaScript(patchJS) { _, err in
            guard err == nil else {
                print("Got error: \(err)")
                return
            }
        }
    }

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        decisionHandler(.allow)
    }
}
