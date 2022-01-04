//
//  OrionBaseApi.swift
//  Orion
//
//  Created by Corban Amouzou on 2022-01-02.
//

import Foundation
import Cocoa
import WebKit

/// The base API interface that is used to register with a webview
///
/// - Note:
///     This is heavily uncompleted and is not properly implemented
protocol OrionBaseAPI: NSObject, WKScriptMessageHandler {

    /// The file name of the js file that handles the javascript interface
    /// of the api
    var supportingJSFileName: String { get }

    /// The names of the messages that get passed back along to the object
    var apiFunctionNames: [String] { get }

}
