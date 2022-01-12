//
//  OrionTabbedLocationViewController+OrionWindowResizeDelegate.swift
//  Orion
//
//  Created by Corban Amouzou on 2022-01-10.
//

import Foundation

extension OrionTabbedLocationViewController: OrionWindowResizeDelegate {
    /// A wrapper for all the tabs to update them without adding them
    /// all to the window resize observers
    func windowWillResize(toSize: NSSize) {
        updateAllTabs(nil, toSize)
    }
}
