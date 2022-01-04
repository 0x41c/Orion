//
//  OrionExtensionManager.swift
//  Orion
//
//  Created by Corban Amouzou on 2022-01-02.
//

import Foundation
import ZIPFoundation
import WebKit
import Cocoa

// TODO: Verify Mozilla hashes (META-INF/mozilla.rsa, META-INF/mozilla.rf and META-INF/manifest.rf)

/// Curates and manages the installation, loading, unloading, and deletion of extensions
class OrionExtensionManager: OrionBrowserExtensionDelegate {

    /// The static name of the folder within the application support directory that
    /// contains all of the extensions of the app
    let extensionFolderName: String = "Orion Extensions"

    /// A default filemanager instance
    let fileManager: FileManager = FileManager.default

    /// An array of all the extensions loaded into memory and accessable
    var extensions: [OrionBrowserExtension] = [OrionBrowserExtension]()

    /// A pointer to the window controller for quick UI access
    private weak var windowController: OrionWindowController?

    /// Creates an `OrionExtensionManager` and immediately loads all the extensions
    /// into memory
    ///
    ///  - Parameters:
    ///     - windowController: The window controller to host the extension manager
    ///
    init(windowController: OrionWindowController) {
        self.windowController = windowController
        self.loadExtensions()
    }

    /// Downlodas an extension and passes the data off to the installer
    ///
    ///  - Parameters:
    ///     - extensionURL: The url to download the extension from
    ///
    func downloadExtension(extensionURL: URL) {
        let downloadSessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: downloadSessionConfig)
        var request = URLRequest(url: extensionURL)
        request.httpMethod = "GET"
        session.dataTask(with: request) { extensionData, _, error in
            guard error == nil else {
                print("[Error] Unable to download extension: \(error!)")
                return
            }
            guard extensionData != nil else {
                print("[Error] Received no data!")
                return
            }
            self.unpackAndInstallExtension(extensionData!)
        }.resume()
    }

    /// Installs an extension given the packed file data of the extension
    ///
    ///  - Parameters:
    ///     - extensionData: The raw unpacked data corresponding to the extension
    ///
    func unpackAndInstallExtension(_ extensionData: Data) {
        let extensionIdentifier: String = String.random(32)
        let tempDir: URL = fileManager.temporaryDirectory.appendingPathComponent(extensionIdentifier)
        guard fileManager.createFile(atPath: tempDir.path, contents: extensionData, attributes: nil) else {
            print("[Error] unable to write to temporary directory")
            return
        }
        let newDirectory: URL = getDirectory(extensionFolderName).appendingPathComponent(extensionIdentifier)
        guard ensureDirectory(path: newDirectory) != nil else {
            print("[Error] unable to ensure new extension directory")
            return
        }
        do {
            try fileManager.unzipItem(at: tempDir, to: newDirectory)
        } catch {
            print("[Error] Unable to unzip directory \(tempDir.path) to \(newDirectory.path): \(error)")
            return
        }
        do {
            let manifest = try MozillaBrowserExtensionManifest(newDirectory.appendingPathComponent("manifest.json"))
            DispatchQueue.main.async {
                let alert: NSAlert = NSAlert()
                alert.messageText = "Add: \(manifest.name)"
                alert.informativeText = "Are you sure you want to add the extension \(manifest.name)"
                alert.informativeText += "\nIt accesses the following permissions"
                if manifest.permissions != nil {
                    for permission in manifest.permissions! {
                        alert.informativeText += "\n  • \(permission)"
                    }
                }
                alert.addButton(withTitle: "Add Extension")
                alert.addButton(withTitle: "Cancel")
                alert.beginSheetModal(for: self.windowController!.window!) { response in
                    if response == .alertFirstButtonReturn {
                        // Extension is now in place, time to load it
                        let browserExtension: OrionBrowserExtension = OrionBrowserExtension(
                            extensionPath: newDirectory.path,
                            internalIdentifier: extensionIdentifier,
                            delegate: self
                        )
                        self.extensions.append(browserExtension)
                        print("loaded extension: \(manifest.name)")
                    } else {
                        self.deleteExtension(internalIdentifier: extensionIdentifier, browserExtension: nil)
                    }
                }
            }

        } catch {
            print("[Error] could not load extension: \(error)")
            return
        }

    }

    /// Loads all the extensions locaed in the extension directory of the apps application support
    /// directory. If an extension is malformed, or if there was an error creating an extension
    /// instance, it will not be loaded into memory, but will be skipped.
    func loadExtensions() {
        guard ensureSupportDirectories() else {
            print("[Error] unable to ensure directories and load extension")
            return
        }
        let extensionFolder: URL = getDirectory(extensionFolderName)
        do {
            let paths = try fileManager.contentsOfDirectory(atPath: extensionFolder.path)
            guard paths.count > 0 else {
                print("No extensions to load")
                return
            }
            for path in try fileManager.contentsOfDirectory(atPath: extensionFolder.path) {
                let currentPath: URL = extensionFolder.appendingPathComponent(path)
                guard fileManager.isDirectory(atPath: currentPath.path) else {
                    print("Skipping: \(path)")
                    continue
                }
                let identifier: String = String(path.split(separator: "/").last!)
                let browserExtension = OrionBrowserExtension(
                    extensionPath: currentPath.path,
                    internalIdentifier: identifier,
                    delegate: self
                )
                if let manifest = browserExtension.manifest {
                    print("loaded extension: \(manifest.name)")
                    extensions.append(browserExtension)
                } else {
                    print("[Error] could not load extension: Manifest invalid")
                    return
                }
            }
        } catch {
            print("[Error] Throwed while iterating through extensions: \(error)")
            return
        }
    }

    /// Deletes an extension given an extension instance. It takes the internalIdentifier
    /// from the instance and passes it over to `deleteExtension(internalIdentifier:)`
    ///
    ///  - Parameters:
    ///     - browserExtension: The extension to delete from the filesystem
    ///
    func deleteExtension(browserExtension: OrionBrowserExtension) {
        deleteExtension(
            internalIdentifier: browserExtension.internalIdentifier,
            browserExtension: browserExtension
        )
    }

    /// Deletes an extension given the extensions internal identifier. If the identifier
    /// is invalid, no extensions are deleted.
    ///
    ///  - Parameters:
    ///     - internalIdentifier: The identifier of the extension to remove. This also acts as the pathname
    ///     - browserExtension: An instance of a browser extension. If not nil, this gets removed from the
    ///                         extension list.
    ///
    func deleteExtension(internalIdentifier: String, browserExtension: OrionBrowserExtension?) {
        let extensionPath: URL = getDirectory(extensionFolderName).appendingPathExtension(internalIdentifier)
        guard fileManager.fileExists(atPath: extensionPath.path) else {
            print("[Error] Could not delete browser extension \(internalIdentifier) as it does not exist")
            return
        }
        print("Deleting extension: \(internalIdentifier)")
        do {
            try fileManager.removeItem(at: extensionPath)
            if let browserExtension = browserExtension {
                extensions.removeAll { possibleExtension in
                    possibleExtension === browserExtension
                }
            }
        } catch {
            print("[Error] could not remove extension: \(error)")
            return
        }
    }

    /// Returns a URL of the application support directory with the subpath
    /// appended to it.
    ///
    ///  - Parameters:
    ///     - subPath: The subpath of the directory as a string to get the URL of
    ///
    func getDirectory(_ subpath: String) -> URL {
        return fileManager.applicationSupportDirectory!.appendingPathComponent(subpath)
    }

    /// Ensures that all manditory support directories for the extensions exist.
    /// If any one of the directories do not exist, this returns false.
    func ensureSupportDirectories() -> Bool {
        let extensionsURL = getDirectory(extensionFolderName)
        let unpackedFolderURL = getDirectory(extensionFolderName)
        guard ensureDirectory(path: fileManager.applicationSupportDirectory!) != nil &&
              ensureDirectory(path: unpackedFolderURL) != nil &&
              ensureDirectory(path: extensionsURL) != nil else {
            return false
        }
        return true
    }

    /// Ensures that a directory exists. If the specified directory does not exist,
    /// it is created. In the off chance that a directory cannot be created, its URL is
    /// not returned.
    ///
    ///  - Parameters:
    ///     - path: The directory URL to ensure exists.
    ///
    func ensureDirectory(path: URL) -> URL? {
        if !fileManager.fileExists(atPath: path.absoluteString, isDirectory: nil) {
            guard createDirectory(
                path: path,
                withIntermediateDirectories: true,
                attributes: nil
            ) else {
                return nil
            }
        }
        return path
    }

    /// Wraps `FileManger.createDirectory` and catches any errors that may be thrown.
    /// if the directory fails to be created, this function returns false.
    ///
    ///  - Parameters:
    ///     - path: The path of the directory to create
    ///     - withIntermediateDirectories: Determines whether the file manager should create
    ///         non existent parent directories along with the directory specified.
    ///     - attributes: The file attributes for the new directory to create.
    ///
    func createDirectory(
        path: URL,
        withIntermediateDirectories: Bool,
        attributes: [FileAttributeKey: Any]?
    ) -> Bool {
        do {
            try fileManager.createDirectory(
                at: path,
                withIntermediateDirectories: withIntermediateDirectories,
                attributes: attributes
            )
            return true
        } catch {
            print("[Error] unable to create extension directory (\(path.absoluteString): \(error)")
            return false
        }
    }

    /// Adds an extension toolbar item to the windows toolbar. If the item already exists in the toolbar
    /// the the new item is not created.
    ///
    ///  - Parameters:
    ///     - sender: The browser extension calling the method to add it to the toolbar
    ///
    func addToolbarItem(_ sender: OrionBrowserExtension) {
        let identifier: NSToolbarItem.Identifier = .init(rawValue: sender.internalIdentifier)
        windowController?.window?.toolbar?.items.forEach({ item in
            if item.itemIdentifier == identifier {
                print("Item already in toolbar")
                return
            }
        })
        if !windowController!.allToolbarIdentifiers.contains(identifier) {
            windowController!.allToolbarIdentifiers.append(identifier)
            windowController!.toolbarItemNames[identifier] = sender.manifest!.name
        }
        let item: NSToolbarItem = NSToolbarItem(itemIdentifier: .init(rawValue: sender.internalIdentifier))
        // swiftlint:ignore:next line_length
        item.image = sender.manifest!.getExtensionIcon() ?? NSImage(named: NSImage.actionTemplateName)
        if #available(macOS 10.15, *) {
            item.isBordered = true
        }
        item.autovalidates = true
        item.toolTip = sender.manifest?.name
        item.target = sender
        item.action = Selector(("createPopup"))
        windowController!.preconfiguredToolbarItem = item
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            windowController!.window!.toolbar!.insertItem(
                withItemIdentifier: identifier,
                at: windowController!.window!.toolbar!.items.count - 2
            )
        }
        print("Added item for \(sender.manifest!.name)")
    }

    /// Shows the popover menu on the window in the left corner of the screen
    /// while in windowed mode, and in front of the screen when in full screen mode
    ///
    ///  - Parameters:
    ///     - sender: The browser extension requesting to have its popover shown
    ///
    func showPopover(_ sender: OrionBrowserExtension) {
        if let window = windowController!.window {
            let popover: NSPopover = NSPopover()
            popover.behavior = .transient
            popover.contentViewController = sender
            popover.animates = true
            popover.show(
                relativeTo: NSRect(
                    x: 0,
                    y: 0,
                    width: 0,
                    height: 0
                ),
                of: window.contentView!,
                preferredEdge: .minX
            )
        }
    }
}
