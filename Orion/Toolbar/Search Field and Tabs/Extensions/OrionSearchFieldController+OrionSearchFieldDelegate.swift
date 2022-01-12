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
    }

    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if commandSelector == #selector(NSResponder.insertNewline(_:)) {
            goTo(url: searchField.stringValue) // Reliable as heck
            searchField.resignFirstResponder()
            return true
        }
        return false
    }
}
