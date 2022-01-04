//
//  FileManager+isDirectory.swift
//  Orion
//
//  Created by Corban Amouzou on 2022-01-03.
//

import Foundation

extension FileManager {
    /// Checks to see if the given path is a directory
    func isDirectory(atPath: String) -> Bool {
        var check: ObjCBool = false
        if fileExists(atPath: atPath, isDirectory: &check) {
            return check.boolValue
        } else {
            return false
        }
    }

    /// Gets the application support directory
    var applicationSupportDirectory: URL? {
        guard let supportURL: URL = self.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first else {
            return nil
        }
        // We're an app, we better have an identifier
        return supportURL.appendingPathComponent(Bundle.main.bundleIdentifier!)
    }
}
