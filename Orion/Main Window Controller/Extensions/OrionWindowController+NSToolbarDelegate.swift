//
//  OrionWindowController+NSToolbarDelegate.swift
//  Orion
//
//  Created by Corban Amouzou on 2021-12-30.
//

// swiftlint:disable  function_body_length cyclomatic_complexity

import Foundation
import Cocoa

// TODO: Get the "How did we get here" acheivement

extension OrionWindowController: NSToolbarDelegate {

    /// Gets the variable allToolbarIdentifiers and returns it. If the identifiers have not been
    /// set up yet, the variable gets populated.
    ///
    ///  - Parameters:
    ///     - toolbar: The `NSToolbar` object calling this function
    ///
    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        if allToolbarIdentifiers.count == 0 {
            allToolbarIdentifiers = [
                .addTab,
                .reload,
                .flexibleSpace,
                .backwordForwardGroup,
                .tabs
            ]
        }
        return allToolbarIdentifiers
    }

    /// Gets the variable AllDefaultItemIdentifiers and returns it. If the identifiers have not
    /// been set up yet, the variable gets populated.
    ///
    ///  - Parameters:
    ///     - toolbar: The `NSToolbar` object calling this function
    ///
    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        if allDefaultItemIdentifiers.count == 0 {
            allDefaultItemIdentifiers = [
                .backwordForwardGroup,
                .addTab,
                .tabs,
                .reload
            ]
        }
        return allDefaultItemIdentifiers
    }

    // MARK: Configuration
    /// Creates and configures an `NSToolbarItem` given the identifier.
    ///
    ///  - Parameters:
    ///     - identifier: The identifier of the item to add to the toolbar. Must not be nil
    ///     - image: An image to add to the `NSToolbarItem`
    ///     - action: The action to execute when the `NSToolbarItem` is pressed. The target is always set to self
    ///
    func configureItem(
        identifier: NSToolbarItem.Identifier,
        image: NSImage?,
        action: Selector?
    ) -> NSToolbarItem {
        if tabControllerItem != nil && identifier == .tabs {
            return tabControllerItem!
        }
        var item: NSToolbarItem = NSToolbarItem(itemIdentifier: identifier)
        let customIDs: [NSToolbarItem.Identifier] = [
            .tabs,
            .flexibleSpace,
            .backwordForwardGroup
        ]
        if #available(macOS 11, *) {
            if identifier == .addTab {
                item.isNavigational = true
            }
        }
        if !customIDs.contains(identifier) {
            item.image = image
            if #available(macOS 10.15, *) {
                item.isBordered = true
            }
            item.target = self
            item.action = action
        } else {
            switch identifier {
            case .tabs:
                item.view = tabController.stackView
                tabControllerItem = item
            case .flexibleSpace:
                return item
            case .backwordForwardGroup:
                item = NSToolbarItemGroup(itemIdentifier: identifier)
                if let itemGroup = item as? NSToolbarItemGroup {
                    let leftItem = NSToolbarItem(itemIdentifier: .backward)
                    let rightItem = NSToolbarItem(itemIdentifier: .forward)
                    leftItem.target = self
                    rightItem.target = self
                    leftItem.action = action
                    rightItem.action = action
                    itemGroup.subitems = [
                        leftItem,
                        rightItem
                    ]
                    if #available(macOS 10.15, *) {
                        leftItem.isBordered = true
                        rightItem.isBordered = true
                        itemGroup.controlRepresentation = .expanded
                        itemGroup.selectionMode = .momentary
                    }
                    if #available(macOS 11, *) {
                        leftItem.image = NSImage(
                            systemSymbolName: "chevron.backward",
                            accessibilityDescription: "Go Back"
                        )
                        rightItem.image = NSImage(
                            systemSymbolName: "chevron.forward",
                            accessibilityDescription: "Go Forward"
                        )
                        itemGroup.isNavigational = true
                    } else {
                        leftItem.image = NSImage(named: NSImage.goBackTemplateName)
                        rightItem.image = NSImage(named: NSImage.goForwardTemplateName)
                    }
                }
            default:
                break
            }
        }

        if toolbarItemNames.keys.contains(identifier) {
            let name = toolbarItemNames[identifier]!
            item.label = name
            item.paletteLabel = name
            item.toolTip = name
        }
        return item
    }

    // MARK: Toolbar
    /// The toolbar contructor function called by the `NSToolbar` attached to the window
    ///
    ///  - Parameters:
    ///     - toolbar: The toolbar calling this function
    ///     - itemForItemIdentifier: The item identifier used to create the wanted `NSToolbarItem`
    ///     - willBeInsertedIntoToolbar: A boolean value signifying whether the item created will be inserted
    func toolbar(
        _ toolbar: NSToolbar,
        itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
        willBeInsertedIntoToolbar flag: Bool
    ) -> NSToolbarItem? {
        if toolbarItemNames.count == 0 {
            toolbarItemNames = [
                .addTab: "New Tab",
                .reload: "Refresh",
                .tabs: "Address, Search, and tabs",
                .backwordForwardGroup: "Back/Forward"
            ]
        }
        if preconfiguredToolbarItem != nil {
            if itemIdentifier == preconfiguredToolbarItem!.itemIdentifier {
                let copy = preconfiguredToolbarItem
                preconfiguredToolbarItem = nil
                return copy
            }
        }

        var defaultItems: [NSToolbarItem.Identifier: NSToolbarItem] {
            var toolbarItems: [NSToolbarItem] = [
                configureItem(
                    identifier: .flexibleSpace,
                    image: nil,
                    action: #selector(unimplementedAction(sender:))
                ), // Quickfix
                configureItem(
                    identifier: .tabs,
                    image: nil,
                    action: nil
                ),
                configureItem(
                    identifier: .backwordForwardGroup,
                    image: nil,
                    action: #selector(navigate(sender:))
                )
            ]
            if #available(macOS 11, *) {
                toolbarItems.append(contentsOf: [
                    configureItem(
                        identifier: .addTab,
                        image: NSImage(
                            systemSymbolName: "plus",
                            accessibilityDescription: "New Tab"
                        ),
                        action: #selector(newTab(sender:))
                    ),
                    configureItem(
                        identifier: .reload,
                        image: NSImage(
                            systemSymbolName: "arrow.clockwise",
                            accessibilityDescription: "Reload Page"
                        ),
                        action: #selector(reloadPage(sender:))
                    )
                ])
            } else {
                toolbarItems.append(contentsOf: [
                    configureItem(
                        identifier: .addTab,
                        image: NSImage(named: NSImage.addTemplateName),
                        action: #selector(newTab(sender:))
                    ),
                    configureItem(
                        identifier: .reload,
                        image: NSImage(named: NSImage.refreshTemplateName),
                        action: #selector(reloadPage(sender:))
                    )
                ])
            }

            let mapped = Dictionary(uniqueKeysWithValues: toolbarItems.map { item in
                return (item.itemIdentifier, item)
            })
            return mapped
        }

        if defaultItems.keys.contains(itemIdentifier) {
            return defaultItems[itemIdentifier]
        } else {
            return nil
        }
    }

    // MARK: NSToolbarItem actions

    /// When an action is unimplemented a warning gets put into the console
    ///
    ///  - Parameters:
    ///     - sender: The toolbar item that was pressed
    ///
    @objc func unimplementedAction(sender: NSToolbarItem) {
        print("[*] WARNING: Action unimplemented on item: \(sender.itemIdentifier.rawValue)")
    }

    /// Calls `tabController.addTab()` on the tabController
    ///
    ///  - Parameters:
    ///     - sender: The toolbar item that corresponded to the `addTab` `NSToolbarItem.Identifier`
    ///
    @objc func newTab(sender: NSToolbarItem) {
        tabController.addTab()
    }

    /// Tells the current tabs webview to navigate either forwards or backwards
    /// depending on the identifier of the NSToolbarItem that was pressed
    ///
    ///  - Parameters:
    ///     - sender: The toolbar item that corresponded to either the `backward` or `forward`
    ///               `NSToolbarItem.Identifier`
    ///
    @objc func navigate(sender: NSToolbarItem) {
        if sender.itemIdentifier == .backward {
            if tabController.currentTab!.webview.canGoBack {
                tabController.currentTab!.webview.goBack()
            }
        } else if sender.itemIdentifier == .forward {
            if tabController.currentTab!.webview.canGoForward {
                tabController.currentTab!.webview.goForward()
            }
        }
        if let currentTab = tabController.currentTab {
            currentTab.searchField.stringValue = currentTab.webview.url!.absoluteString
        }
    }

    /// Tells the current tabs webview to reload the current page
    ///
    /// - Parameters:
    ///     - sender: The toolbar item that corresponded to the `reload` `NSToolbarItem.Identifier`
    ///
    @objc func reloadPage(sender: NSToolbarItem) {
        if let currentTab = tabController.currentTab {
            if currentTab.webview.url != nil {
                currentTab.webview.reload()
            }
        }
    }

}
