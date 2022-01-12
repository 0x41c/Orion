//
//  OrionTabbedLocationVIewController+OrionSearchFieldControllerDelegate.swift
//  Orion
//
//  Created by Corban Amouzou on 2021-12-31.
//

import Foundation
import Cocoa

extension OrionTabbedLocationViewController: OrionSearchFieldControllerDelegate {

    var tabCount: Int {
        return tabs.count
    }

    func tabWillClose(sender: OrionSearchFieldController) {
        removeTab(tab: sender)
        updateAllTabs(sender)
    }

    func tabWantsForeground(tab: OrionSearchFieldController) {
        self.currentTab = tab
        guard delegate != nil else {
            return
        }
        delegate!.tabWantsForeground(tab: tab)
        delegate!.updateToolbarColor()
        updateAllTabs(tab)
    }

    /// Calls `OrionSearchField.updateProperties(tabCount:)` on all of the tab search fields
    ///
    ///  - Parameters:
    ///     - sender: Optional sender to directly control which tab has focus. If not supplied
    ///     the focus is assumed to be the current tab.
    ///     - windowSize: Optional size to update the width of the tabs with. Defaults to nil.
    func updateAllTabs(_ sender: OrionSearchFieldController?, _ windowSize: NSSize? = nil) {
        for tab in tabs {
            tab.searchField.updateProperties(
                focused: tab === (sender ?? currentTab!),
                windowSize: windowSize ?? currentTab!.searchField.window?.frame.size
            )
        }
    }
}
