//
//  OrionTabbedLocationViewController+WKNavigationDelegate.swift
//  Orion
//
//  Created by Corban Amouzou on 2022-01-02.
//

import Foundation
import WebKit

extension OrionTabbedLocationViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy
        ) -> Void) {
        if let scheme: NSURLComponents = NSURLComponents(url: webView.url!, resolvingAgainstBaseURL: false) {
            if scheme.host == "addons.cdn.mozilla.net" {
                decisionHandler(.cancel)
                delegate!.extensionManager.downloadExtension(extensionURL: webView.url!)
                return
            }
        }
        currentTab?.searchField.stringValue = webView.url!.absoluteString
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
        currentTab?.searchField.stringValue = webView.url!.absoluteString
    }
}
