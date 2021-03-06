//
//  OrionTabbedLocationViewController.swift
//  Orion
//
//  Created by Corban Amouzou on 2021-12-30.
//

import Foundation
import Cocoa
import WebKit

// TODO: Move the content controller to the individual tabs

/// This hold all of our `OrionSearchTabFields` and connects them up by receiving their events
/// and forwarding them to each-other. As this is like a controlled proxy service however, raw events
/// are not completely forwarded, but translated into the events needed to allow all of the tabs to update
/// synchronously.
class OrionTabbedLocationViewController: NSViewController {

    /// A value determining if the view gets set up normally on creation
    /// or if only the UI properties are set and the delegation is not needed.
    let mockup: Bool

    /// Centralized tab collection
    let stackView: NSStackView = NSStackView()

    /// The list of all the tabs open in the window
    var tabs: [OrionSearchFieldController] = [OrionSearchFieldController]()

    /// The tab with focused context. Will not be nil
    var currentTab: OrionSearchFieldController?

    /// The delegate responsible for using the current tabs webview
    weak var delegate: OrionTabbedLocationViewControllerDelegate?

    /// The content controller for all the tabs. Not recommended to share this
    /// among all of the webviews.
    lazy var userContentController: OrionUserContentController = {
        return OrionUserContentController()
    }()

    /// Creates a `OrionTabbedLocationViewController` with a specified delegate to manage it
    ///
    ///  - Parameters:
    ///     - delegate: The owner of this class that manages the current tabs webview
    init(
        _ delegate: OrionTabbedLocationViewControllerDelegate?,
        _ mockup: Bool,
        _ window: NSWindow? = nil
    ) {
        self.delegate = delegate
        self.mockup = mockup
        super.init(nibName: nil, bundle: nil)
        delegate?.addWindowResizeEventListener(self)
        setupStackView(window: window)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Sets up the stackView and makes it stretch across the entire toolbar
    func setupStackView(window: NSWindow?) {
        stackView.orientation = .horizontal
        stackView.spacing = 15
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.heightAnchor.constraint(equalToConstant: 31)
        ])
        addTab()
    }

    /// Creates and adds a new tab the stackView and gives it foreground context
    func addTab() {
        let tab: OrionSearchFieldController = OrionSearchFieldController(
            delegate: self,
            contentController: userContentController
        )
        tabs.append(tab)
        currentTab = tab
        stackView.addView(tab.searchField, in: .trailing)
        if !mockup {
            tab.setupWebView()
            tab.webview.navigationDelegate = self
            tabWantsForeground(tab: tab)
            if stackView.window != nil {
                stackView.window?.makeFirstResponder(tab.searchField)
            }
            if let controller = delegate as? OrionWindowController {
                controller.tabItemStretchView?.updateCustomSizing()
            }
            tab.goTo(url: "https://duckduckgo.com")
        }
    }

    /// Removes a tab and gives foreground context to the last tab in the tab array
    ///
    ///  - Parameters:
    ///     - tab: The tab to remove from the window
    func removeTab(tab: OrionSearchFieldController) {
        let tabIndex: Int? = tabs.firstIndex(of: tab)
        guard tabIndex != nil else {
            print("[Error] Unable to remove tab, as it is not part of our window")
            return
        }
        tabs.remove(at: tabIndex!)
        updateAllTabs(nil)
        stackView.removeView(tab.searchField)
    }
}
