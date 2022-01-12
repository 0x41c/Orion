# OrionTabbedLocationViewController

This hold all of our `OrionSearchTabFields` and connects them up by receiving their events
and forwarding them to each-other. As this is like a controlled proxy service however, raw events
are not completely forwarded, but translated into the events needed to allow all of the tabs to update
synchronously.

``` swift
class OrionTabbedLocationViewController: NSViewController 
```

## Inheritance

`NSViewController`, [`OrionSearchFieldControllerDelegate`](/OrionSearchFieldControllerDelegate), [`OrionWindowResizeDelegate`](/OrionWindowResizeDelegate), `WKNavigationDelegate`

## Initializers

### `init(_:_:_:)`

Creates a `OrionTabbedLocationViewController` with a specified delegate to manage it

``` swift
init(
        _ delegate: OrionTabbedLocationViewControllerDelegate?,
        _ mockup: Bool,
        _ window: NSWindow? = nil
    ) 
```

#### Parameters

  - delegate: The owner of this class that manages the current tabs webview

### `init?(coder:)`

``` swift
required init?(coder: NSCoder) 
```

## Properties

### `tabCount`

``` swift
var tabCount: Int 
```

### `mockup`

A value determining if the view gets set up normally on creation
or if only the UI properties are set and the delegation is not needed.

``` swift
let mockup: Bool
```

### `stackView`

Centralized tab collection

``` swift
let stackView: NSStackView 
```

### `tabs`

The list of all the tabs open in the window

``` swift
var tabs: [OrionSearchFieldController] 
```

### `currentTab`

The tab with focused context. Will not be nil

``` swift
var currentTab: OrionSearchFieldController?
```

### `delegate`

The delegate responsible for using the current tabs webview

``` swift
weak var delegate: OrionTabbedLocationViewControllerDelegate?
```

### `userContentController`

The content controller for all the tabs. Not recommended to share this
among all of the webviews.

``` swift
lazy var userContentController: OrionUserContentController 
```

## Methods

### `tabWillClose(sender:)`

``` swift
func tabWillClose(sender: OrionSearchFieldController) 
```

### `tabWantsForeground(tab:)`

``` swift
func tabWantsForeground(tab: OrionSearchFieldController) 
```

### `updateAllTabs(_:_:)`

Calls `OrionSearchField.updateProperties(tabCount:​)` on all of the tab search fields

``` swift
func updateAllTabs(_ sender: OrionSearchFieldController?, _ windowSize: NSSize? = nil) 
```

#### Parameters

  - sender: Optional sender to directly control which tab has focus. If not supplied the focus is assumed to be the current tab.
  - windowSize: Optional size to update the width of the tabs with. Defaults to nil.

### `windowWillResize(toSize:)`

A wrapper for all the tabs to update them without adding them
all to the window resize observers

``` swift
func windowWillResize(toSize: NSSize) 
```

### `webView(_:decidePolicyFor:decisionHandler:)`

``` swift
func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) 
```

### `webView(_:didFinish:)`

``` swift
func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) 
```

### `webView(_:didStartProvisionalNavigation:)`

``` swift
func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) 
```

### `webView(_:didFailProvisionalNavigation:withError:)`

``` swift
func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) 
```

### `setupStackView(window:)`

Sets up the stackView and makes it stretch across the entire toolbar

``` swift
func setupStackView(window: NSWindow?) 
```

### `addTab()`

Creates and adds a new tab the stackView and gives it foreground context

``` swift
func addTab() 
```

### `removeTab(tab:)`

Removes a tab and gives foreground context to the last tab in the tab array

``` swift
func removeTab(tab: OrionSearchFieldController) 
```

#### Parameters

  - tab: The tab to remove from the window
