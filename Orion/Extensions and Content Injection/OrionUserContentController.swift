//
//  OrionUserContentController.swift
//  Orion
//
//  Created by Corban Amouzou on 2022-01-02.
//

import Foundation
import WebKit

/// The global `WKUserContentController`.
class OrionUserContentController: WKUserContentController {

    /// Default message handlers that should be loaded into every instance
    /// of a webview
    let defaultMessageHandlers: [String: WKScriptMessageHandler] = [:]
    let userScriptNames: [String] = [
       // "changeDownloadName"
    ]

    /// Creates a WKUserContentController while automatically loading
    /// the javascript given the names provided by the property `userScriptNames`
    override init() {
        super.init()
        for name in userScriptNames {
            addUserScript(WKUserScript(name: name))
        }

        defaultMessageHandlers.forEach { (name, handler) in
            add(handler, name: name)
        }

    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
