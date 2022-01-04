//
//  OrionWindowController+OrionTabbedLocationViewControllerDelegate.swift
//  Orion
//
//  Created by Corban Amouzou on 2021-12-31.
//

import Foundation
import Cocoa

extension OrionWindowController: OrionTabbedLocationViewControllerDelegate {

    /// Called by a search field controller to make a tab have foreground context
    ///
    ///  - Parameters:
    ///     - tab: The tab to bring to the foreground
    func tabWantsForeground(tab: OrionSearchFieldController) {
        if webview !== tab.webview {
            if self.webview != nil {
                webview!.removeFromSuperview()
                webview!.uiDelegate = nil
                tab.webview.setFrameSize(webview!.frame.size)
                tab.webview.setFrameOrigin(webview!.frame.origin)
            }
            webview = tab.webview
        } else {
            return
        }
        if webview!.uiDelegate !== self {
            webview!.uiDelegate = self
        }
        visualEffectView.addSubview(webview!)
        window!.makeFirstResponder(tab)
    }

}
