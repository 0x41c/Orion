//
//  OrionTabbedLocationVIewController+OrionSearchFieldControllerDelegate.swift
//  Orion
//
//  Created by Corban Amouzou on 2021-12-31.
//

import Foundation
import Cocoa

// TODO: Animate the changes if necessary

extension OrionTabbedLocationViewController: OrionSearchFieldControllerDelegate {

    var tabCount: Int {
        return tabs.count
    }

    func tabBecameFirstResponder(tab: OrionSearchFieldController) {
        for otherTab in tabs where otherTab !== tab {
            otherTab.searchField.updateProperties(tabCount: tabs.count)
        }
    }

    func tabWillClose(sender: OrionSearchFieldController) {
        removeTab(tab: sender)
        for otherTab in tabs {
            otherTab.searchField.updateProperties(tabCount: tabs.count)
        }
    }

    func tabWantsForeground(tab: OrionSearchFieldController) {
        self.currentTab = tab
        guard delegate != nil else {
            return
        }
        delegate!.tabWantsForeground(tab: tab)
    }

}
