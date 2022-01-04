//
//  OrionWindowController+WKUIDelegate.swift
//  Orion
//
//  Created by Corban Amouzou on 2022-01-01.
//

import Foundation
import Cocoa
import WebKit

extension OrionWindowController: WKUIDelegate {

    func webView(
        _ webView: WKWebView,
        runJavaScriptConfirmPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping (Bool) -> Void
    ) {
        let alert = NSAlert()
        alert.messageText = "\(webView.url!.relativeString) Says:"
        alert.informativeText = message
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        alert.beginSheetModal(for: window!) { response in
            completionHandler(response == .alertFirstButtonReturn)
        }
    }

    func webView(
        _ webView: WKWebView,
        runJavaScriptTextInputPanelWithPrompt prompt: String,
        defaultText: String?,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping (String?) -> Void
    ) {
        let alert = NSAlert()
        alert.messageText = "\(webView.url!.relativeString) Says:"
        alert.informativeText = prompt
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        let textField: NSTextField = NSTextField(frame: NSRect(
            x: 0,
            y: 0,
            width: 200,
            height: 24
        ))
        textField.stringValue = defaultText ?? ""
        alert.accessoryView = textField
        alert.beginSheetModal(for: window!) { response in
            textField.validateEditing()
            completionHandler(response == .alertFirstButtonReturn ? textField.stringValue : nil)
        }
    }

    func webView(
        _ webView: WKWebView,
        runJavaScriptAlertPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler completion: @escaping () -> Void
    ) {
        let alert = NSAlert()
        alert.messageText = "\(webView.url!.relativeString) Says:"
        alert.informativeText = message
        alert.addButton(withTitle: "OK")
        alert.beginSheetModal(for: window!) { _ in
            completion()
        }
    }

    func webViewDidClose(_ webView: WKWebView) {
        let tabs = tabController.tabs
        let nextTab = tabs.last!
        tabController.tabWantsForeground(tab: nextTab)
    }

}
