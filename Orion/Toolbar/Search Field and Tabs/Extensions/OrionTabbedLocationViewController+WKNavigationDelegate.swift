//
//  OrionTabbedLocationViewController+WKNavigationDelegate.swift
//  Orion
//
//  Created by Corban Amouzou on 2022-01-02.
//

import Foundation
import WebKit

/// The user agent to use when accessing a firefox extension download page
let firefoxUA = "Mozilla/5.0 (Macintosh; Intel Mac OS X 12.0; rv:87.0) Gecko/20100101 Firefox/87.0"

extension OrionTabbedLocationViewController: WKNavigationDelegate {
    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let components = NSURLComponents(url: navigationAction.request.url!, resolvingAgainstBaseURL: false) {
            if components.host == "addons.mozilla.org" {
                webView.customUserAgent = firefoxUA
                if components.path!.contains(".xpi") {
                    delegate?.extensionManager.downloadExtension(extensionURL: components.url!)
                    decisionHandler(.cancel)
                    return
                }
            }
        }
        currentTab?.searchField.stringValue = webView.url!.absoluteString
        decisionHandler(.allow)
    }

    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if let components = NSURLComponents(url: webView.url!, resolvingAgainstBaseURL: true) {
            if components.host == "addons.mozilla.org" {
                let buttonReplacerJS = WKUserScript.ensureInternalResource(withName: "changeDownloadName")
                webView.evaluateJavaScript(buttonReplacerJS) { _, _ in}
            }
        }
        if let controller = webView.window!.windowController as? OrionWindowController {
            controller.updateToolbarColor()
        }
    }

    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        if let controller = webView.window!.windowController as? OrionWindowController {
            controller.updateToolbarColor()
        }
    }

    func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
        if let errorPageURL = Bundle.main.url(forResource: "error", withExtension: "html") {
            do {
                var errorPageHTML: String = try String(contentsOfFile: errorPageURL.path)
                errorPageHTML = errorPageHTML.replacingOccurrences(
                    of: "__URL__",
                    with: currentTab!.searchField.currentURL!.absoluteString
                )
                errorPageHTML = errorPageHTML.replacingOccurrences(
                    of: "__MESSAGE__",
                    with: error.localizedDescription
                )
                if let components = URLComponents(
                    url: currentTab!.searchField.currentURL!,
                    resolvingAgainstBaseURL: false
                ) {
                    if components.host != nil {
                        errorPageHTML = errorPageHTML.replacingOccurrences(
                            of: "__URL_HOST__",
                            with: components.host!
                        )
                    }
                }
                errorPageHTML = errorPageHTML.replacingOccurrences(of: "__URL_HOST__", with: "")
                webView.loadHTMLString(errorPageHTML, baseURL: nil)
            } catch {
                print("[Error] Could not load error page! (how ironic)")
            }
        }
    }
}
