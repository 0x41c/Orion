//
//  OrionSearchFieldController+OrionSearchFieldDelegate.swift
//  Orion
//
//  Created by Corban Amouzou on 2021-12-31.
//

import Foundation
import Cocoa

extension OrionSearchFieldController: OrionSearchFieldDelegate {

    var tabCount: Int {
        return delegate!.tabCount
    }

    func searchFieldWantsFocus(sender: OrionSearchField) {
        delegate?.tabWantsForeground(tab: self)
        delegate?.tabBecameFirstResponder(tab: self)
    }

    func searchFieldDidStartSearching(_ sender: NSSearchField) {
        goTo(url: sender.stringValue)
    }

    /// Sets up our search fields initial properties and frame
    func setupSearchField() {
        NSLayoutConstraint.activate([
            searchField.heightAnchor.constraint(equalToConstant: 29),
            searchField.widthAnchor.constraint(greaterThanOrEqualToConstant: 300)
        ])
        searchField.delegate = self
        searchField.isEditable = true
        searchField.isBezeled = true
        searchField.isSelectable = true
        searchField.sendsWholeSearchString = true
        searchField.maximumNumberOfLines = 1
        searchField.maximumRecents = 5
        searchField.recentsAutosaveName = "SearchFieldAutoSave"
        searchField.bezelStyle = .squareBezel
        searchField.placeholderString = "Search or enter website name"
        searchField.focusRingType = .exterior
    }

}
