//
//  OrionTabStretcherView.swift
//  Orion
//
//  Created by Corban Amouzou on 2022-01-09.
//

import Foundation
import Cocoa

/// The view that stretches the background of the tab item to allow it to be centered in
/// older operating systems but also to auto resize whenever needed as well
class OrionTabStretcherView: NSView, OrionWindowResizeDelegate {

    /// A window that gets set to the view before the view gets
    /// added to the window to allow the view to iterate the toolbar items
    var beforeLoadWindow: NSWindow?

    /// The controlled width constraint that determines that width
    /// needed for the tab item
    var widthConstraint: NSLayoutConstraint?

    /// A swap variable for the new sizes to be implemented
    private var newSize: NSSize?

    /// A boolean value indicating whether the subview has had its
    /// centerXAnchor constraint set
    private var setSubviewConstraint: Bool = false

    /// Called by the window, alerts the TabStretcherView to resize its
    /// constraints
    func windowWillResize(toSize: NSSize) {
        newSize = toSize
        updateCustomSizing()
    }

    /// Called by the `OrionWindowController`, this resizes the constraints for
    /// on this view corresponding to the amount of size the search field item
    /// should take up.
    @objc func updateCustomSizing() {
        if widthConstraint == nil {
            widthConstraint = widthAnchor.constraint(greaterThanOrEqualToConstant: calculateWidth())
            NSLayoutConstraint.activate([
                widthConstraint!
            ])
        } else {
            widthConstraint?.constant = calculateWidth()
        }
    }

    /// Calculates the width for the view depending on where it is located in the
    /// toolbar and expands accordingly
    func calculateWidth() -> CGFloat {
        // Ha you like? <3
        var window: NSWindow?
        window = self.window ?? beforeLoadWindow
        if let window = window {
            if let toolbar = window.toolbar {
                let ourIndex = toolbar.items.firstIndex { item in
                    item.view === self
                }
                if ourIndex != -1 {
                    var occupiedWidth: CGFloat = 0.0
                    var beforeWidth: CGFloat = 0.0
                    var foundSelf: Bool = false
                    for item in toolbar.items {
                        if !foundSelf {
                            if item.view != nil {
                                if item.view === self {
                                    foundSelf = true
                                    continue
                                } else {
                                    beforeWidth += item.view!.frame.width
                                }
                            } else {
                                beforeWidth += 42.0
                            }
                        } else {
                            if item.view != nil {
                                occupiedWidth += item.view!.frame.width
                            } else {
                                occupiedWidth += 42.0
                            }
                        }
                    }
                    occupiedWidth += beforeWidth
                    let widthToRequest = (newSize!.width - occupiedWidth - 88.0) - 38.0
                    let view = subviews[0]
                    if let controller = window.windowController as? OrionWindowController {
                        let amountOfTabs = controller.tabController.tabCount
                        if amountOfTabs > 1 {
                            var offset = newSize!.width / 2
                            offset -= CGFloat(view.frame.width / 2)
                            view.setFrameOrigin(NSPoint(
                                x: offset,
                                y: view.frame.origin.y
                            ))
                        } else {
                            // Magic number. Linear offset calculated as a function of the window width
                            // `f(x) = mx + b`
                            // or in this case `f(x) = xm + b`
                            let offset = window.frame.width * 0.295 - 242
                            view.setFrameOrigin(NSPoint(
                                x: offset,
                                y: view.frame.origin.y
                            ))
                        }
                    }
                    return widthToRequest
                }
            }
        }
        return 0.0
    }
}
