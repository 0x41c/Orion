//
//  OrionSearchFieldController.swift
//  Orion
//
//  Created by Corban Amouzou on 2021-12-30.
//

import Foundation
import Cocoa
import WebKit

// TODO: Add more search engines

/// The controller that manages and maintains an `OrionSearchField`
class OrionSearchFieldController: NSViewController {

    /// The default user agent used by the webview
    let safariUA = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" // swiftlint:ignore:current line_length

    /// The wrapped search field
    let searchField: OrionSearchField

    /// The tabs user content controller. Manages what gets loaded into the webview alongside
    /// the current webview
    let userContentController: WKUserContentController

    /// The webviews history list. Should be used for the topSites api implementation.
    /// Should be saved on load
    var tabHistory: [URL] = [URL]()

    /// The delegate that manages this controller and maintains the foreground context of the tab
    weak var delegate: OrionSearchFieldControllerDelegate?

    /// The tabs webview object
    lazy var webview: WKWebView = {
        let configuration = WKWebViewConfiguration()
        configuration.userContentController = userContentController
        configuration.allowsAirPlayForMediaPlayback = true
        let webView = WKWebView(frame: .zero, configuration: configuration)
        return webView
    }()

    /// Creates an `OrionSearchFieldController` and sets up the search field and webview
    ///
    ///  - Parameters:
    ///     - delegate: The delegate to manage this instance
    ///     - contentController: The content controller to manage the content of this controllers webview
    ///
    init(delegate: OrionSearchFieldControllerDelegate?, contentController: WKUserContentController) {
        self.delegate = delegate
        self.searchField = OrionSearchField()
        self.userContentController = contentController
        super.init(nibName: nil, bundle: nil)
        searchField.orionDelegate = self
        searchField.delegate = self
        searchField.setupDefaultProperties()
    }

    override func loadView() {
        view = searchField
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Tells the webview to navigate to the url specified and sets the
    /// search fields text to the urls address
    ///
    ///  - Parameters:
    ///     - url: The URL to navigate to
    func goTo(url: URL) {
        tabHistory.append(url)
        let request: URLRequest = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 60)
        searchField.currentURL = url
        webview.load(request)
    }

    /// Wraps the `OrionSearchFieldController.goTo(url: URL)` method and handles search parsing
    /// while also forwarding to a serach engine if needed.
    ///
    ///  - Parameters:
    ///     - url: The url or search to navigate to; Uses a search engine if needed
    func goTo(url: String) {
        webview.customUserAgent = safariUA
        var url = url
        if url.hasPrefix("https://addons.mozilla.org/") {
            webview.customUserAgent = firefoxUA
        }
        if url.isValidURL {
            if !url.hasPrefix("https://") && !url.hasPrefix("http://") {
                url = "https://\(url)"
            }
            goTo(url: URL(string: url)!)
        } else {
            var components: URLComponents = URLComponents()
            components.scheme = "https"
            components.host = "duckduckgo.com"
            components.path = "/"
            components.queryItems = [
                URLQueryItem(name: "q", value: url)
            ]
            goTo(url: components.url!)
        }
    }

    /// Sets up the webviews properties and toggles the needed preferences
    func setupWebView() {
        webview.translatesAutoresizingMaskIntoConstraints = false
        let keys = [
            "offlineApplicationCacheIsEnabled",
            "aggressiveTileRetentionEnabled",
            "screenCaptureEnabled",
            "allowsPictureInPictureMediaPlayback",
            "fullScreenEnabled",
            "largeImageAsyncDecodingEnabled",
            "animatedImageAsyncDecodingEnabled",
            "developerExtrasEnabled",
            "usesPageCache",
            "mediaSourceEnabled",
            "mockCaptureDevicesPromptEnabled",
            "canvasUsesAcceleratedDrawing",
            "videoQualityIncludesDisplayCompositingEnabled",
            "backspaceKeyNavigationEnabled"
        ]
        let preferences = webview.configuration.preferences
        for index in 0..<keys.count {
            guard preferences.value(forKey: keys[index]) != nil else {
                continue
            }
            preferences.setValue(
                index != keys.count-1 ? true : false,
                forKey: keys[index]
            )
        }
        preferences.javaScriptCanOpenWindowsAutomatically = true
        webview.configuration.suppressesIncrementalRendering = true
        webview.customUserAgent = safariUA
    }

}
