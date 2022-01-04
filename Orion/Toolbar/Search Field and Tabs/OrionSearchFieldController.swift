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

    /// The user agent to use when accessing a firefox extension download page
    let firefoxUA = "Mozilla/5.0 (Macintosh; Intel Mac OS X 12.0; rv:87.0) Gecko/20100101 Firefox/87.0"

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
        self.searchField.orionDelegate = self
        setupSearchField()
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
        let request: URLRequest = URLRequest(url: url)
        webview.load(request)
        searchField.stringValue = url.absoluteString

    }

    /// Wraps the `OrionSearchFieldController.goTo(url: URL)` method and handles search parsing
    /// while also forwarding to a serach engine if needed.
    ///
    ///  - Parameters:
    ///     - url: The url or search to navigate to; Uses a search engine if needed
    func goTo(url: String) {
        if url.hasPrefix("https://addons.mozilla.org/") {
            webview.customUserAgent = firefoxUA
        }
        if url.isValidURL {
            goTo(url: URL(string: url)!)
        } else {
            if "https://\(url)/".isValidURL {
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
    }

    /// Sets up the webviews properties and toggles the needed preferences
    func setupWebView() {
        webview.autoresizingMask = [.height, .width]
        webview.configuration.preferences.setValuesForKeys([
            "offlineApplicationCacheIsEnabled": true,
            "aggressiveTileRetentionEnabled": true,
            "screenCaptureEnabled": true,
            "allowsPictureInPictureMediaPlayback": true,
            "fullScreenEnabled": true,
            "largeImageAsyncDecodingEnabled": true,
            "animatedImageAsyncDecodingEnabled": true,
            "developerExtrasEnabled": true,
            "usesPageCache": true,
            "mediaSourceEnabled": true,
            "mockCaptureDevicesPromptEnabled": true,
            "canvasUsesAcceleratedDrawing": true,
            "videoQualityIncludesDisplayCompositingEnabled": true,
            "backspaceKeyNavigationEnabled": false
        ])
        webview.configuration.preferences.javaScriptCanOpenWindowsAutomatically = true
    }

}
