//
//  OrionSearchField.swift
//  Orion
//
//  Created by Corban Amouzou on 2021-12-31.
//

import Foundation
import Cocoa

// swiftlint:ignore cyclomatic_complexity function_body_length

/// A custom search field made for responding to navigation like the
/// safari search fields
class OrionSearchField: NSTextField {

    /// A value describing if this text field was the last tab to be in focus
    var lastWithFocus: Bool = false

    /// The current url in the search field after a search if any
    var currentURL: URL?

    /// A reference to our width constraint corresponding
    /// to the `lessThanOrEqualTo` modifier
    var widthConstraint: NSLayoutConstraint?

    /// When needed, this constraint is create and activated to allow there
    /// to be flexibility
    var widthLowBoundConstraint: NSLayoutConstraint?

    /// A pointer to a current monitoring object if `hasFocus` is true
    var outsideBoundMonitor: Any?

    /// The delegate that manages the search fields state
    /// and foreground context
    weak var orionDelegate: OrionSearchFieldDelegate?

    convenience init(delegate: OrionSearchFieldDelegate) {
        self.init()
        orionDelegate = delegate
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

    override func viewDidMoveToWindow() {
        super.viewDidMoveToWindow()
    }

    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        orionDelegate?.searchFieldWantsFocus(sender: self)
        appearance = .init(named: NSColor.textColor.isLight ? .vibrantDark : .vibrantLight)
    }

    /// The overriden draw function that draws our background and/or text
    ///
    ///  - Parameters:
    ///     - dirtyRect: The rect to draw the text field content in
    override func draw(_ dirtyRect: NSRect) {

        guard window != nil else {
            return
        }

        // Draw background
        let newRect = NSRect(
            x: dirtyRect.minX,
            y: dirtyRect.minY,
            width: dirtyRect.width,
            height: dirtyRect.height - 1
        )
        let inside: NSBezierPath = NSBezierPath(
            roundedRect: newRect.insetBy(dx: 1.2, dy: 1.2),
            xRadius: 6,
            yRadius: 6
        )
        if let windowController = window!.windowController as? OrionWindowController {
            if windowController.toolbarBackgroundView.layer!.backgroundColor != nil, let color: NSColor = NSColor(
                cgColor: windowController.toolbarBackgroundView.layer!.backgroundColor!
            ) {
                // Custom Background
                if color.isDark {
                    // Dark mode
                    if hasFocus {
                        NSColor.underPageBackgroundColor.withAlphaComponent(1.0).set()
                    } else {
                        if lastWithFocus {
                            NSColor.gray.withAlphaComponent(0.6).set()
                        } else {
                            NSColor.gray.withAlphaComponent(0.2).set()
                        }
                    }
                } else {
                    // Light mode
                    NSColor.gray.withAlphaComponent(hasFocus ? 0.6 : 0.3).set()
                }
            } else {
                // No Custom Background
                if NSColor.textColor.isDark {
                    // Light mode
                    NSColor.gray.withAlphaComponent(hasFocus ? 0.6 : 0.3).set()
                } else {
                    // Dark mode
                    NSColor.white.withAlphaComponent(hasFocus ? 0.6 : 0.3).set()
                }
            }
        }
        inside.fill()

        if !hasFocus {
            // Draw text
            var renderedTextValue: String?

            if currentURL != nil {
                if let components = NSURLComponents(url: currentURL!, resolvingAgainstBaseURL: false) {
                    if components.host != nil {
                        renderedTextValue = components.host
                    } else {
                        renderedTextValue = placeholderString
                    }
                } else {
                    renderedTextValue = placeholderString
                }
            } else {
                renderedTextValue = placeholderString
            }

            let ourText: NSAttributedString = NSAttributedString(
                string: renderedTextValue!,
                attributes: [
                    .foregroundColor: NSColor.white,
                    .font: NSFont.systemFont(ofSize: 13)
                ]
            )

            // Off by two points
            ourText.draw(in: NSRect(
                origin: CGPoint(
                    x: newRect.midX - (ourText.size().width / 2),
                    y: newRect.midY - (ourText.size().height / 2)
                ),
                size: ourText.size()
            ))
        }
    }

    /// Sets the preconfigured properties of the search field.
    func setupDefaultProperties() {
        isEditable = true
        isSelectable = true
        isBordered = false
        wantsLayer = true
        drawsBackground = false
        maximumNumberOfLines = 1
        placeholderString = "Search or enter website name"
        focusRingType = .exterior
        bezelStyle = .squareBezel
        textColor = .labelColor
        font = .systemFont(ofSize: 13)
        widthConstraint = widthAnchor.constraint(greaterThanOrEqualToConstant: 0)
        NSLayoutConstraint.activate([
            heightAnchor.constraint(equalToConstant: 31),
            widthConstraint!
        ])
    }

    /// Function to animate and update the properties of the search field and its cell
    /// when a tab loses or gains focus. Called by the delegate.
    ///
    ///  - Parameters:
    ///     - focused: An outside value determining whether this search field should update
    ///     its size with a focused context.
    ///     - windowSize: Regardless of the optional type, this is needed to calculate the size
    ///     of the field. If not present, nothing will be updated.
    ///
    func updateProperties(focused: Bool, windowSize: NSSize?) {

        guard windowSize != nil else {
            return
        }

        let timingConstant: Double = 0.3
        let scrunchOffsetConstant: CGFloat = 120
        let maxFocusedMultipleTabWidth: CGFloat = 480
        let minimumFocusedMultipleTabWidth: CGFloat = 148
        let maxUnfocusedMultipleTabWidth: CGFloat = 148
        let minimumUnfocusedMultipleTabWidth: CGFloat = 60
        let perfectWidth: CGFloat = (windowSize!.width * 0.408)

        if focused {
            if orionDelegate!.tabCount == 1 {
                if widthLowBoundConstraint != nil && widthLowBoundConstraint!.isActive {
                    NSLayoutConstraint.deactivate([widthLowBoundConstraint!])
                }
                if !lastWithFocus {
                    NSAnimationContext.runAnimationGroup { context in
                        context.duration = timingConstant
                        context.timingFunction = .init(name: .easeOut)
                        widthConstraint!.animator().constant = perfectWidth
                    }
                } else {
                    widthConstraint!.constant = perfectWidth
                }
            } else {
                if currentURL != nil {
                    stringValue = currentURL!.absoluteString
                }
                if let textEditor = currentEditor() {
                    textEditor.selectAll(self)
                }

                if frame.minX > scrunchOffsetConstant {
                    if widthLowBoundConstraint != nil && widthLowBoundConstraint!.isActive {
                        NSLayoutConstraint.deactivate([widthLowBoundConstraint!])
                    }
                    if !lastWithFocus {
                        NSAnimationContext.runAnimationGroup { context in
                            context.duration = timingConstant
                            widthConstraint!.animator().constant = maxFocusedMultipleTabWidth
                        }
                    } else {
                        widthConstraint!.constant = maxFocusedMultipleTabWidth
                    }
                } else {
                    if widthLowBoundConstraint == nil {
                        widthLowBoundConstraint = widthAnchor.constraint(
                            greaterThanOrEqualToConstant: minimumFocusedMultipleTabWidth
                        )
                        NSLayoutConstraint.activate([widthLowBoundConstraint!])
                        widthConstraint?.constant = maxFocusedMultipleTabWidth - -(frame.minX - scrunchOffsetConstant)
                    }
                }
            }
        } else {
            if frame.minX > scrunchOffsetConstant {
                if widthLowBoundConstraint != nil && widthLowBoundConstraint!.isActive {
                    NSLayoutConstraint.deactivate([widthLowBoundConstraint!])
                }
                if lastWithFocus {
                    NSAnimationContext.runAnimationGroup { context in
                        context.duration = timingConstant
                        context.timingFunction = .init(name: .easeOut)
                        widthConstraint!.animator().constant = maxUnfocusedMultipleTabWidth
                    }
                } else {
                    widthConstraint!.constant = maxUnfocusedMultipleTabWidth
                }
            } else {
                if widthLowBoundConstraint == nil {
                    widthLowBoundConstraint = widthAnchor.constraint(
                        greaterThanOrEqualToConstant: minimumUnfocusedMultipleTabWidth
                    )
                    NSLayoutConstraint.activate([widthLowBoundConstraint!])
                    widthConstraint?.constant = maxUnfocusedMultipleTabWidth - -(frame.minX - scrunchOffsetConstant)
                }
            }
        }

        lastWithFocus = focused
        guard window != nil else {
            return
        }
        if let windowController = window!.windowController as? OrionWindowController {
            windowController.tabItemStretchView?.updateCustomSizing()
        }
    }
}
