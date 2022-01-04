//
//  OrionSearchField.swift
//  Orion
//
//  Created by Corban Amouzou on 2021-12-31.
//

import Foundation
import Cocoa

/// A custom search field made for responding to navigation like the
/// safari search fields
class OrionSearchField: NSSearchField {

    /// The delegate that manages the search fields state and foreground context
    weak var orionDelegate: OrionSearchFieldDelegate?

    /// A swap variable for the last tab count to prohibit recalculation of the sizes when
    /// not strictly necessary
    var lastTabCount: Int = 0

    /// A fix for the .roundedBezel cell having the text top aligned on macOS 11
    ///
    /// This is a hotfix, but a better solution would be to change the alignment of
    /// the text within the `NSSearchFieldCell`
    @available(macOS 11.0, *)
    override var searchTextBounds: NSRect {
        var origBounds = super.searchTextBounds
        origBounds.origin.y += 3.5
        return origBounds
    }

    /// Variable to observe whether or not this search field has focus.
    /// Works all the way back to macOS 10.0
    var hasFocus: Bool {
        guard let window = window,
              let firstResponder = window.firstResponder as? NSText,
                firstResponder.delegate === self
        else {
            return false
        }
        return true
    }

    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        orionDelegate?.searchFieldWantsFocus(sender: self)
        self.updateProperties(tabCount: orionDelegate!.tabCount)
        if let textEditor = currentEditor() {
            textEditor.selectAll(self)
        }
    }

    /// Function to animate and update the properties of the search field and its cell
    /// when a tab loses or gains focus. Called by the delegate.
    ///
    ///  - Parameters:
    ///     - tabCount: The amount of tabs visible to the user.
    ///                 Used to refine width measurements
    ///
    func updateProperties(tabCount: Int) {
        if lastTabCount != tabCount {
           lastTabCount = tabCount
            if hasFocus {
                print("Making self focused")
            } else {
                print("Shrinking self")
            }
        }
    }

}
