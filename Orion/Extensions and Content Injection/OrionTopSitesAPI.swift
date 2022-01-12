//
//  OrionTopSitesAPI.swift
//  Orion
//
//  Created by Corban Amouzou on 2022-01-02.
//

import Foundation
import Cocoa
import WebKit

/// The API class of the mozilla `topSites` api
class OrionTopSitesAPI: NSObject, OrionBaseAPI {
    let apiFunctionNames: [String] = [
        "topSites.get",
        "topSites.MostVisitedURL"
    ]

    let supportingJSFileName: String = "browserObject"

    /// The handler for a message call that corresponded to one of the `apiFunctionNames` specified on the class
    func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) {

    }
}
