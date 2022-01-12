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
            if webview != nil {
                tab.webview.setFrameSize(webview!.frame.size)
                webview!.removeFromSuperview()
                webview!.uiDelegate = nil
            }
            webview = tab.webview
        } else {
            return
        }

        if webview!.uiDelegate !== self {
            webview!.uiDelegate = self
        }

        visualEffectView.addSubview(webview!)

        if webview?.constraints.filter({ constraint in
            constraint.firstAnchor == toolbarBackgroundView.bottomAnchor
        }).count == 0 {
            NSLayoutConstraint.activate([
                webview!.topAnchor.constraint(equalTo: toolbarBackgroundView.bottomAnchor),
                webview!.bottomAnchor.constraint(equalTo: visualEffectView.bottomAnchor),
                webview!.leadingAnchor.constraint(equalTo: visualEffectView.leadingAnchor),
                webview!.trailingAnchor.constraint(equalTo: visualEffectView.trailingAnchor)
            ])
        }
    }

    /// A shortcut for adding event listeners on the fly from other classes
    ///
    ///  - Parameters:
    ///     - observer: The observer to add to the event listener list
    func addWindowResizeEventListener(_ observer: OrionWindowResizeDelegate) {
        windowResizeEventListeners.append(observer)
    }

}
