//
//  OrionBrowserExtension.swift
//  Orion
//
//  Created by Corban Amouzou on 2022-01-02.
//

import Foundation
import WebKit

// TODO: Use pattern matching

/// The class representing a browser extension installed by the user.
/// Wraps a `MozillaBrowserExtensionManifest`
class OrionBrowserExtension: NSViewController {

    /// The name of a default manifest. Per mozilla specifications
    /// this name is `manifest.json`
    let manifestName = "manifest.json"

    /// The base path of the extension within the application support directory
    /// of the app. Used for all actions that take place within the extension
    let extensionPath: URL

    /// The identifier of the extension used for `WKContentWorld`s and
    /// folder location. This is a random 32 charector string
    let internalIdentifier: String

    /// Boolean value determining whether the extension is enabled or not
    ///
    /// Defaults to true
    var enabled: Bool = true

    /// The toolbar item that corresponds to the action declared in the manifest
    /// if existant.
    var toolbarItem: NSToolbarItem?

    /// The delegate of the browser. This spot is usually filled by the `OrionExtensionManager`
    weak var delegate: OrionBrowserExtensionDelegate?

    /// The content world object of the extension.
    @available(macOS 11, *)
    var contentWorld: WKContentWorld {
        return .world(name: internalIdentifier)
    }

    /// The manifest of the browser extension. If the json content of the
    /// manifest file is malformed or invalid, this will return nil.
    lazy var manifest: MozillaBrowserExtensionManifest? = {
        do {
            return try MozillaBrowserExtensionManifest(extensionPath.appendingPathComponent(manifestName))
        } catch {
            print("[Error] Unable to load manifest: \(error)")
            return nil
        }
    }()

    /// Creates a browser extension object and sets up the toolbar
    init(extensionPath path: String, internalIdentifier identifier: String, delegate: OrionBrowserExtensionDelegate) {
        self.extensionPath = URL(fileURLWithPath: path, isDirectory: true)
        self.internalIdentifier = identifier
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
        _ = manifest
        if manifest?.optionsUi != nil {
            delegate.addToolbarItem(self)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Determines whether or not the extension can be executed on a certain web page
    /// - Note: Defaults to true until matching is properly implemented
    /// - Parameters:
    ///    - url: The url the extension checks to see if it can run on
    ///
    func canExecute(url: URL) -> Bool {
        return true
    }

    /// Loads the `WKWebView` of the popup as the `view` property of the object
    /// while also setting its configuration
    override func loadView() {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = WKUserContentController()
        configuration.preferences.setValue(true, forKey: "developerExtrasEnabled")
        configuration.preferences.setValue(true, forKey: "allowFileAccessFromFileURLs")
        let webview = WKWebView(
            frame: NSRect(
                x: 0,
                y: 0,
                width: 300,
                height: 450
            ),
            configuration: configuration
        )
        webview.navigationDelegate = self
        view = webview
    }

    /// Called by the delegate. Loads the extension browser action popup url
    /// into the webview and sets the base path to the base of the extension.
    /// Finally, it tells the delegate to show the popup
    @objc func createPopup() {
        if let webview = view as? WKWebView {
            let filePath = extensionPath.appendingPathComponent(manifest!.browserAction!.defaultPopup!)
            do {
                let htmlContent = try String(contentsOf: filePath)
                webview.loadHTMLString(htmlContent, baseURL: extensionPath)
            } catch {
                print("[Error] Could not load the extension popover content from the filesystem. Does the extension still exist?")
            }
            // webview.loadFileURL(filePath, allowingReadAccessTo: extensionPath)
        }
        delegate!.showPopover(self)
    }
}
