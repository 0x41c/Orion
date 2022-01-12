//
//  OrionWindowController.swift
//  Orion
//
//  Created by Corban Amouzou on 2021-12-30.
//
import Foundation
import Cocoa
import WebKit

/// Orion window types
enum OrionWindowType {
    /// The private type. History is not saved here
    case privateWindow
    /// Public type with window resizes
    case regularWindow
}

/// The main window controller for the application. Handles all interactions between the user and
/// the webview and toolbar.
class OrionWindowController: NSWindowController, NSWindowDelegate {

    /// The type of the window. When a window is normally created,
    /// the type is `OrionWindowType.regularWindow`
    let windowType: OrionWindowType

    /// A view that acts as a backing layer for the toolbar. It controls
    /// the background of the toolbar and borders off the webview to not
    /// appear behind the toolbar.
    let toolbarBackgroundView: NSView = NSView()

    /// The visual effect view that is responsible for being the default background of the window
    /// when the window is empty (ie: no webview)
    let visualEffectView: NSVisualEffectView = NSVisualEffectView()

    /// The view responsible for creating the max amount of space possible
    /// for the search field
    var tabItemStretchView: OrionTabStretcherView?

    /// The toolbar item responsible to managing the tabs
    var tabControllerItem: NSToolbarItem?

    /// The windows current webview depending on the the current tab
    var webview: WKWebView?

    /// All the possible identifiers the toolbar is able to use and display
    var allToolbarIdentifiers: [NSToolbarItem.Identifier] = [NSToolbarItem.Identifier]()

    /// The names of all the toolbar items to show when in the customization palette
    var toolbarItemNames: [NSToolbarItem.Identifier: String] = [:]

    /// The default identifiers to show in the customization palette. In order
    var allDefaultItemIdentifiers: [NSToolbarItem.Identifier] = [NSToolbarItem.Identifier]()

    /// A swap variable that may contain an externally created toolbar item to add to the toolbar.
    /// As soon as it is added, this variable resets to `nil`
    var dynamicItems: [NSToolbarItem.Identifier: NSToolbarItem] = [:]

    /// A collection of resize events to be called when the main window resizes
    var windowResizeEventListeners: [OrionWindowResizeDelegate] = [OrionWindowResizeDelegate]()

    /// A Boolean value representing wether the tabController is able to be called
    @objc var tabControllerReady: Bool = false

    /// The object that manages all the tabs of the window
    lazy var tabController: OrionTabbedLocationViewController = {
        let controller = OrionTabbedLocationViewController(self, false, window)
        tabControllerReady = true
        return controller
    }()

    /// The object that manages all of the extension loaded into the application
    lazy var extensionManager: OrionExtensionManager = {
        return OrionExtensionManager(windowController: self)
    }()

    /// Creates an OrionWindowController with a window and sets itself up
    override init(window: NSWindow?) {
        windowType = .regularWindow
        super.init(window: nil)
        setupWindow()
    }

    /// Creates an OrionWindowController with a window and sets itself up
    init(_ windowType: OrionWindowType) {
        self.windowType = windowType
        super.init(window: nil)
        setupWindow()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Creates the window for the controller and sets up initial properties
    /// for the toolbar and the visual effect view.
    func setupWindow() {
        window = NSWindow()
        if let window = window {
            // FALLBACK VIEW
            visualEffectView.blendingMode = .behindWindow

            if #available(macOS 11, *) {
                visualEffectView.material = .hudWindow
            } else {
                visualEffectView.material = .dark
            }

            visualEffectView.state = .active
            visualEffectView.isEmphasized = true

            window.contentView = visualEffectView
            window.contentView!.addSubview(toolbarBackgroundView)

            // TOOLBAR BACKGROUND VIEW
            toolbarBackgroundView.wantsLayer = true
            toolbarBackgroundView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                toolbarBackgroundView.widthAnchor.constraint(lessThanOrEqualToConstant: 10_000),
                toolbarBackgroundView.heightAnchor.constraint(equalToConstant: 52),
                toolbarBackgroundView.topAnchor.constraint(equalTo: visualEffectView.topAnchor)
            ])

            // WINDOW
            window.delegate = self
            window.styleMask.insert([
                .resizable,
                .miniaturizable,
                .closable,
                .fullSizeContentView
            ])
            window.setFrame(
                NSRect(
                    origin: .zero,
                    size: CGSize(width: 1000, height: 700)
                ),
                display: true
            )
            window.minSize = NSSize(width: 575, height: 200) // Safari minSize
            window.titleVisibility = .hidden
            window.titlebarAppearsTransparent = true
            window.center()

            // TOOLBAR
            let toolbar: NSToolbar = NSToolbar(identifier: "Orion Toolbar")
            toolbar.delegate = self
            if #available(macOS 11, *) {
                window.toolbarStyle = .unified
            }
            toolbar.allowsUserCustomization = true
            toolbar.autosavesConfiguration = true
            toolbar.showsBaselineSeparator = false
            toolbar.displayMode = .iconOnly
            window.toolbar = toolbar

            updateToolbarColor()
            if #available(macOS 10.14, *) {
                _ = NSApp.observe(\.effectiveAppearance) { _, _ in
                    self.updateToolbarColor()
                }
            }
            _ = extensionManager

            // Allow the stretch view to then position it
            tabItemStretchView?.windowWillResize(toSize: window.frame.size)

            // Make the field adjust to the new width
            tabController.currentTab?.searchField.updateProperties(
                focused: true,
                windowSize: window.frame.size
            )
        }
    }

    func updateToolbarColor() {
        guard tabControllerReady else {
            return
        }
        tabController.currentTab?.webview.evaluateJavaScript("""
        document.querySelectorAll("meta[name=theme-color]")[0]
        ? document.querySelectorAll("meta[name=theme-color]")[0].content
        : window.getComputedStyle(document.body)["background-color"]
        """
        ) { value, error in
            guard error == nil else {
                print("Could not get background color of window: \(error!)")
                self.setToolbarBGHeight(true)
                return
            }
            if let stringValue = value as? String {
                var color: NSColor?
                if stringValue.hasPrefix("#") {
                    color = NSColor(hex: stringValue)
                } else {
                    color = NSColor(webRGB: stringValue)
                }
                if color != nil {
                    if color!.isLight {
                        if NSColor.textColor.isDark {
                            self.setToolbarBGHeight()
                            self.toolbarBackgroundView.layer!.backgroundColor = color!.cgColor
                        } else {
                            self.setToolbarBGHeight(true)
                        }
                    } else if color!.isDark { // Yeah ik ambiguous
                        if NSColor.textColor.isLight {
                            self.setToolbarBGHeight()
                            self.toolbarBackgroundView.layer!.backgroundColor = color!.cgColor
                        } else {
                            self.setToolbarBGHeight(true)
                        }
                    }
                } else {
                    self.setToolbarBGHeight(true)
                }
            }
        }
    }

    private func setToolbarBGHeight(_ setZero: Bool = false) {
        if !setZero {
            if toolbarBackgroundView.frame.height == 0 {
                toolbarBackgroundView.constraints.first { constraint in
                    constraint.firstAnchor == toolbarBackgroundView.heightAnchor
                }?.constant = 52
            }
            return
        }
        self.window?.titlebarAppearsTransparent = false
        toolbarBackgroundView.constraints.first { constraint in
            constraint.firstAnchor == toolbarBackgroundView.heightAnchor
        }?.constant = 0
        toolbarBackgroundView.isHidden = true
    }
}
