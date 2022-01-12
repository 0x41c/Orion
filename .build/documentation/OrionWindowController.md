# OrionWindowController

The main window controller for the application. Handles all interactions between the user and
the webview and toolbar.

``` swift
class OrionWindowController: NSWindowController, NSWindowDelegate 
```

## Inheritance

`NSToolbarDelegate`, `NSWindowController`, `NSWindowDelegate`, [`OrionTabbedLocationViewControllerDelegate`](/OrionTabbedLocationViewControllerDelegate), `WKScriptMessageHandler`, `WKUIDelegate`

## Initializers

### `init(window:)`

Creates an OrionWindowController with a window and sets itself up

``` swift
override init(window: NSWindow?) 
```

### `init(_:)`

Creates an OrionWindowController with a window and sets itself up

``` swift
init(_ windowType: OrionWindowType) 
```

### `init?(coder:)`

``` swift
required init?(coder: NSCoder) 
```

## Properties

### `windowType`

The type of the window. When a window is normally created,
the type is `OrionWindowType.regularWindow`

``` swift
let windowType: OrionWindowType
```

### `toolbarBackgroundView`

A view that acts as a backing layer for the toolbar. It controls
the background of the toolbar and borders off the webview to not
appear behind the toolbar.

``` swift
let toolbarBackgroundView: NSView 
```

### `visualEffectView`

The visual effect view that is responsible for being the default background of the window
when the window is empty (ie:​ no webview)

``` swift
let visualEffectView: NSVisualEffectView 
```

### `tabItemStretchView`

The view responsible for creating the max amount of space possible
for the search field

``` swift
var tabItemStretchView: OrionTabStretcherView?
```

### `tabControllerItem`

The toolbar item responsible to managing the tabs

``` swift
var tabControllerItem: NSToolbarItem?
```

### `webview`

The windows current webview depending on the the current tab

``` swift
var webview: WKWebView?
```

### `allToolbarIdentifiers`

All the possible identifiers the toolbar is able to use and display

``` swift
var allToolbarIdentifiers: [NSToolbarItem.Identifier] 
```

### `toolbarItemNames`

The names of all the toolbar items to show when in the customization palette

``` swift
var toolbarItemNames: [NSToolbarItem.Identifier: String] = [:]
```

### `allDefaultItemIdentifiers`

The default identifiers to show in the customization palette. In order

``` swift
var allDefaultItemIdentifiers: [NSToolbarItem.Identifier] 
```

### `dynamicItems`

A swap variable that may contain an externally created toolbar item to add to the toolbar.
As soon as it is added, this variable resets to `nil`

``` swift
var dynamicItems: [NSToolbarItem.Identifier: NSToolbarItem] = [:]
```

### `windowResizeEventListeners`

A collection of resize events to be called when the main window resizes

``` swift
var windowResizeEventListeners: [OrionWindowResizeDelegate] 
```

### `tabControllerReady`

A Boolean value representing wether the tabController is able to be called

``` swift
@objc var tabControllerReady: Bool = false
```

### `tabController`

The object that manages all the tabs of the window

``` swift
lazy var tabController: OrionTabbedLocationViewController 
```

### `extensionManager`

The object that manages all of the extension loaded into the application

``` swift
lazy var extensionManager: OrionExtensionManager 
```

## Methods

### `toolbarAllowedItemIdentifiers(_:)`

Gets the variable allToolbarIdentifiers and returns it. If the identifiers have not been
set up yet, the variable gets populated.

``` swift
func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] 
```

#### Parameters

  - toolbar: The `NSToolbar` object calling this function

### `toolbarDefaultItemIdentifiers(_:)`

Gets the variable AllDefaultItemIdentifiers and returns it. If the identifiers have not
been set up yet, the variable gets populated.

``` swift
func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] 
```

#### Parameters

  - toolbar: The `NSToolbar` object calling this function

### `configureItem(identifier:image:action:)`

Creates and configures an `NSToolbarItem` given the identifier.

``` swift
func configureItem(
        identifier: NSToolbarItem.Identifier,
        image: NSImage?,
        action: Selector?
    ) -> NSToolbarItem 
```

#### Parameters

  - identifier: The identifier of the item to add to the toolbar. Must not be nil
  - image: An image to add to the `NSToolbarItem`
  - action: The action to execute when the `NSToolbarItem` is pressed. The target is always set to self

### `toolbar(_:itemForItemIdentifier:willBeInsertedIntoToolbar:)`

The toolbar contructor function called by the `NSToolbar` attached to the window

``` swift
func toolbar(
        _ toolbar: NSToolbar,
        itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
        willBeInsertedIntoToolbar flag: Bool
    ) -> NSToolbarItem? 
```

#### Parameters

  - toolbar: The toolbar calling this function
  - itemForItemIdentifier: The item identifier used to create the wanted `NSToolbarItem`
  - willBeInsertedIntoToolbar: A boolean value signifying whether the item created will be inserted

### `windowWillResize(_:to:)`

``` swift
func windowWillResize(_ sender: NSWindow, to frameSize: NSSize) -> NSSize 
```

### `newTab(sender:)`

Calls `tabController.addTab()` on the tabController

``` swift
@objc func newTab(sender: NSToolbarItem) 
```

#### Parameters

  - sender: The toolbar item that corresponded to the `addTab` `NSToolbarItem.Identifier`

### `navigate(sender:)`

Tells the current tabs webview to navigate either forwards or backwards
depending on the identifier of the NSToolbarItem that was pressed

``` swift
@objc func navigate(sender: NSSegmentedControl) 
```

#### Parameters

  - sender: The toolbar item that corresponded to either the `backward` or `forward` `NSToolbarItem.Identifier`

### `reloadPage(sender:)`

Tells the current tabs webview to reload the current page

``` swift
@objc func reloadPage(sender: NSToolbarItem) 
```

#### Parameters

  - sender: The toolbar item that corresponded to the `reload` `NSToolbarItem.Identifier`

### `tabWantsForeground(tab:)`

Called by a search field controller to make a tab have foreground context

``` swift
func tabWantsForeground(tab: OrionSearchFieldController) 
```

#### Parameters

  - tab: The tab to bring to the foreground

### `addWindowResizeEventListener(_:)`

A shortcut for adding event listeners on the fly from other classes

``` swift
func addWindowResizeEventListener(_ observer: OrionWindowResizeDelegate) 
```

#### Parameters

  - observer: The observer to add to the event listener list

### `userContentController(_:didReceive:)`

``` swift
func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) 
```

### `webView(_:runJavaScriptConfirmPanelWithMessage:initiatedByFrame:completionHandler:)`

``` swift
func webView(
        _ webView: WKWebView,
        runJavaScriptConfirmPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping (Bool) -> Void
    ) 
```

### `webView(_:runJavaScriptTextInputPanelWithPrompt:defaultText:initiatedByFrame:completionHandler:)`

``` swift
func webView(
        _ webView: WKWebView,
        runJavaScriptTextInputPanelWithPrompt prompt: String,
        defaultText: String?,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler: @escaping (String?) -> Void
    ) 
```

### `webView(_:runJavaScriptAlertPanelWithMessage:initiatedByFrame:completionHandler:)`

``` swift
func webView(
        _ webView: WKWebView,
        runJavaScriptAlertPanelWithMessage message: String,
        initiatedByFrame frame: WKFrameInfo,
        completionHandler completion: @escaping () -> Void
    ) 
```

### `webViewDidClose(_:)`

``` swift
func webViewDidClose(_ webView: WKWebView) 
```

### `setupWindow()`

Creates the window for the controller and sets up initial properties
for the toolbar and the visual effect view.

``` swift
func setupWindow() 
```

### `updateToolbarColor()`

``` swift
func updateToolbarColor() 
```

### `setToolbarBGHeight(_:)`

``` swift
private func setToolbarBGHeight(_ setZero: Bool = false) 
```
