//
//  OrionWindowController.swift
//  Orion
//
//  Created by Corban Amouzou on 2021-12-30.
//
import Foundation
import Cocoa
import WebKit

enum OrionWindowType {
    case privateWindow
    case regularWindow
}

/// The main window controller for the application. Handles all interactions between the user and
/// the webview and toolbar.
class OrionWindowController: NSWindowController {

    /// The type of the window. When a window is normally created,
    /// the type is `OrionWindowType.regularWindow`
    let windowType: OrionWindowType

    /// The visual effect view that is responsible for being the default background of the window
    /// when the window is empty (ie: no webview)
    let visualEffectView: NSVisualEffectView = NSVisualEffectView()

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
    var preconfiguredToolbarItem: NSToolbarItem?

    /// The object that manages all the tabs of the window
    lazy var tabController: OrionTabbedLocationViewController = {
      return OrionTabbedLocationViewController(self)
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

    override func windowDidLoad() {
        super.windowDidLoad()
    }

    /// Creates the window for the controller and sets up initial properties
    /// for the toolbar and the visual effect view.
    func setupWindow() {
        window = NSWindow()
        if let window = window {
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

            visualEffectView.blendingMode = .behindWindow

            if #available(macOS 11, *) {
                visualEffectView.material = .hudWindow
            } else {
                visualEffectView.material = .dark
            }

            visualEffectView.state = .active
            visualEffectView.isEmphasized = true

            window.contentView = visualEffectView
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
            window.center()
            finishSetup()
        }
    }

    /// Calls the lazy variables in our window controller and lets them
    /// set themselves up
    func finishSetup() {
        _ = tabController
        _ = extensionManager
    }
}
