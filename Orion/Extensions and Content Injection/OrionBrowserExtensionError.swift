//
//  OrionBrowserExtensionError.swift
//  Orion
//
//  Created by Corban Amouzou on 2022-01-03.
//

import Foundation

// TODO: Handle all errors through this object

/// A generic error object for use when loading and managing a browser extension
enum OrionBrowserExtensionError: Error {

    /// If the extension manifest is malformed or invalid, this error is called
    /// with a message saying specifically what happened
    case unableToLoadManifest(_ message: String)
}
