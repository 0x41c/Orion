//
//  OrionDelegates.swift
//  Orion
//
//  Created by Corban Amouzou on 2021-12-31.
//

import Foundation
import Cocoa

/// The delegate responsible for managing the `OrionTabbedLocationViewController` and
/// responding to changes in forground context
protocol OrionTabbedLocationViewControllerDelegate: AnyObject {

    /// When a tab gets clicked this will fire to our window controller.
    /// Our window will then set its webview to this tabs window
    func tabWantsForeground(tab: OrionSearchFieldController)

    /// Whenever there is a change in the current windows webview state
    /// the toolbar background color needs to be updated to ensure that
    /// there are no inconsistencies in the colors of the webpage.
    func updateToolbarColor()

    /// Called by objects that need to update their sizes whenever the
    /// window they're connected to resizes. This allows views to use the window
    /// width or the new width to their advantage
    func addWindowResizeEventListener(_ observer: OrionWindowResizeDelegate)

    /// The extension manager reference for the `OrionTabbedLocationViewController` to access
    var extensionManager: OrionExtensionManager { get }

}

/// The delegate responsible for managing the `OrionSearchFieldController` and
/// forwarding foreground requests to a `OrionTabbedLocationViewControllerDelegate`
protocol OrionSearchFieldControllerDelegate: AnyObject {

    /// When a tab needs to close there is some teardown work that needs
    /// to be done by the delegate. Initial things could be saving the history of that
    /// tab for later tab restoration, saving the history to the main history record
    /// and also drawing the animation for the close.
    func tabWillClose(sender: OrionSearchFieldController)

    /// Called when a tab gets clicked to allow the parent to assign the tabs
    /// webview over to the main window.
    func tabWantsForeground(tab: OrionSearchFieldController)

    /// The amount of tabs so that the search field can refine its shrinking and expanding calculations
    var tabCount: Int { get }
}

/// The delegate responsible for responding to the `OrionSearchField` being tapped
/// and forwarding the event out to parent delegates
protocol OrionSearchFieldDelegate: NSTextFieldDelegate {

    /// When a search field gets tapped, it will call this function signifying that
    /// it was tapped and needs to be focused for the user.
    func searchFieldWantsFocus(sender: OrionSearchField)

    /// The amount of tabs so that the search field can refine its shrinking and expanding calculations
    var tabCount: Int { get }
}

/// The delegate for an `OrionBrowserExtension`. It responds to actions that are called on the
/// extension if there is an action window button in the toolbar.
protocol OrionBrowserExtensionDelegate: AnyObject {

    /// The extension is requesting an action window toolbar button to be displayed on the window
    /// toolbar.
    func addToolbarItem(_ sender: OrionBrowserExtension)

    /// This function gets called when the toolbar button has been pressed and the extension is requesting
    /// that its window gets shown to the window
    func showPopover(_ sender: OrionBrowserExtension)

}

/// Used when the window gets a `windowWillResize` event called on it.
/// This allows views relying on the windows size to resize their constraints
/// before anything happens
protocol OrionWindowResizeDelegate: AnyObject {
    /// A forward call of the `windowWillResize` function implemented on the window
    /// delegate
    func windowWillResize(toSize: NSSize)
}
