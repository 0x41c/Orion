//
//  MozillaExtensionManifest.swift
//  Orion
//
//  Created by Corban Amouzou on 2022-01-03.
//

import Foundation
import WebKit

/// The manifest format for the browser extension
///
/// This is not complete or up to spec.
/// Please see: https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json
/// for a list of all the keys and values
 struct MozillaBrowserExtensionManifest: Codable {

     /// The author of the extension
     let author: String?

     /// The action object that specifies a dropdown tab
     /// on the toolbar of the browser.
     let browserAction: BrowserAction?

     /// The name of the default locale bundle to get localized keys
     /// from. Not required unless `_locale` path exists at the root
     /// of the extension folder
     let defaultLocale: String?

     /// The url leading to the homepage of the author of the extension
     let homepageURL: String?

     /// An array of icon paths keyed by size. Paths are relative to the
     /// extension folder.
     let icons: [String: String]?

     /// The version of the manifest. Latest is `v3`
     let manifestVersion: Int

     /// The name of the extension.
     /// - Localizable
     let name: String

     /// The UI specification for the extension given options page
     let optionsUi: OptionsUI?

     /// A list of permissions the extension has to provide when accessing
     /// browser apis that handle user information
     let permissions: [String]?

     /// Version of the plugin. Created by the author. This is required
     let version: String

     /// Default initialization
     ///
     /// - Parameters:
     ///    - path: The path of the manifest
     /// 
     init(_ path: URL) throws {
         let fileManager: FileManager = FileManager.default
         guard fileManager.fileExists(atPath: path.path) else {
             throw OrionBrowserExtensionError.unableToLoadManifest("Manifest non existant")
         }
         let decoder: JSONDecoder = JSONDecoder()
         decoder.keyDecodingStrategy = .convertFromSnakeCase
         do {
             let data: Data = try Data(contentsOf: path)
             self = try decoder.decode(MozillaBrowserExtensionManifest.self, from: data)
         } catch {
             throw OrionBrowserExtensionError.unableToLoadManifest("Manifest malformed: \(error)")
         }
     }

     /// Gets the extension icon from the main icons array
     ///
     /// - Parameters:
     ///    - manifest: The manifest object to get the image of
     ///
     func getExtensionIcon() -> NSImage? {
         // Defaulting to highest quality
         guard icons != nil && icons!.count > 0 else {
             return nil
         }
         var highestRes: Int = 0
         icons?.forEach({ (key: String, _: String) in
             if let intVal = Int(key), intVal > highestRes {
                highestRes = intVal
             }
         })
         let fileManager: FileManager = FileManager.default
         // swiftlint:ignore:next line_length
         let iconPath = fileManager.applicationSupportDirectory!.appendingPathExtension(icons!["\(highestRes)"]!)
         guard fileManager.fileExists(atPath: iconPath.path) else {
             return nil
         }
         return NSImage(contentsOf: iconPath)
    }
 }

/// The object specifying what gets loaded when the user clicks the popup button
/// corresponding your extension
 struct BrowserAction: Codable {
     /// The style of the popup.
     ///
     /// Defauls to true
     var browserStyle: Bool = true

     /// The icon to use in the popup button in multiple
     /// sizes for compatibility purposes
     let defaultIcon: [String: String]?

     /// The default path of the popups content. Generally is an
     /// html file. Relative to the to the base of the extension.
     /// - Localizable
     let defaultPopup: String?

     /// The defualt title of the popup. Used as the tooltip of the
     /// toolbar button
     let defaultTitle: String?
 }

 struct OptionsUI: Codable {
     /// Determines whether the broweser styles the options
     /// or the extension
     var browserStyle: Bool = true

     /// The path to the settings page within the extension.
     /// This is required
     let page: String
 }
