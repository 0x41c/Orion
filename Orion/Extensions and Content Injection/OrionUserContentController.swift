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
    let userScriptNames: [String] = [
        "changeDownloadName"
    ]

    /// Creates a WKUserContentController while automatically loading
    /// the javascript given the names provided by the property `userScriptNames`
    override init() {
        super.init()
        for name in userScriptNames {
            addUserScript(WKUserScript(name: name))
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
