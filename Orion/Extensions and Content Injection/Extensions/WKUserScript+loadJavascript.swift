//
//  WKUserScript+loadJavascript.swift
//  Orion
//
//  Created by Corban Amouzou on 2022-01-02.
//

import Foundation
import WebKit

extension WKUserScript {

    /// Creates a new WKUserScript while automaticall loading the contents of
    /// the passed in javascript file name
    ///
    /// - Parameters:
    ///    - name: The file name of the javascript to load
    ///    - contentWorldName: The name of the content world to load the javascript in
    ///
    @available(macOS 11, *)
    convenience init(name: String, contentWorldName: String) {
        self.init(
            source: WKUserScript.ensureInternalResource(withName: name),
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true,
            in: .world(name: contentWorldName)
        )
    }

    /// Creates a new WKUserScript while automaticall loading the contents of
    /// the passed in javascript file name
    ///
    /// - Parameters:
    ///    - name: The file name of the javascript to load
    ///
    convenience init (name: String) {
        self.init(
            source: WKUserScript.ensureInternalResource(withName: name),
            injectionTime: .atDocumentEnd,
            forMainFrameOnly: true
        )
    }

    /// Loads javascript given the file name. If the javascript file does not exist,
    /// it returns a script containing a `console.error` with the name of the
    /// failed file to load.
    ///
    /// - Parameters:
    ///    - withName: The name of the javascript file to load
    ///
    static func ensureInternalResource(withName name: String) -> String {
        var sourceCode: String? = WKUserScript.loadJavascript(withName: name)
        if sourceCode == nil {
            sourceCode = "console.error('Could not load internal resource \(name)')"
        }
        return sourceCode!
    }

    /// Loads javascript given the file name. If the requested file does not
    /// exist, it instead returns `nil`
    ///
    /// - Parameters:
    ///    - withName: The name of the javascript file to load
    ///
    static func loadJavascript(withName name: String) -> String? {
        if let path = Bundle.main.path(forResource: name, ofType: "js") {
            do {
                let sourceCode: String = try String(contentsOfFile: path)
                return sourceCode
            } catch {
                print("[Error] Couldn't load javascript resource: \(error)")
                return nil
            }
        } else {
            return nil
        }
    }

}
