# OrionBrowserExtension

The class representing a browser extension installed by the user.
Wraps a `MozillaBrowserExtensionManifest`

``` swift
class OrionBrowserExtension: NSViewController 
```

## Inheritance

`NSViewController`, `WKNavigationDelegate`, `WKURLSchemeHandler`

## Initializers

### `init(extensionPath:internalIdentifier:delegate:)`

Creates a browser extension object and sets up the toolbar

``` swift
init(extensionPath path: String, internalIdentifier identifier: String, delegate: OrionBrowserExtensionDelegate) 
```

### `init?(coder:)`

``` swift
required init?(coder: NSCoder) 
```

## Properties

### `manifestName`

The name of a default manifest. Per mozilla specifications
this name is `manifest.json`

``` swift
let manifestName = "manifest.json"
```

### `extensionPath`

The base path of the extension within the application support directory
of the app. Used for all actions that take place within the extension

``` swift
let extensionPath: URL
```

### `internalIdentifier`

The identifier of the extension used for `WKContentWorld`s and
folder location. This is a random 32 charector string

``` swift
let internalIdentifier: String
```

### `enabled`

Boolean value determining whether the extension is enabled or not

``` swift
var enabled: Bool = true
```

Defaults to true

### `toolbarItem`

The toolbar item that corresponds to the action declared in the manifest
if existant.

``` swift
var toolbarItem: NSToolbarItem?
```

### `delegate`

The delegate of the browser. This spot is usually filled by the `OrionExtensionManager`

``` swift
weak var delegate: OrionBrowserExtensionDelegate?
```

### `contentWorld`

The content world object of the extension.

``` swift
@available(macOS 11, *)
    var contentWorld: WKContentWorld 
```

### `manifest`

The manifest of the browser extension. If the json content of the
manifest file is malformed or invalid, this will return nil.

``` swift
lazy var manifest: MozillaBrowserExtensionManifest? 
```

## Methods

### `webView(_:start:)`

``` swift
func webView(_ webView: WKWebView, start urlSchemeTask: WKURLSchemeTask) 
```

### `webView(_:stop:)`

``` swift
func webView(_ webView: WKWebView, stop urlSchemeTask: WKURLSchemeTask) 
```

### `webView(_:didStartProvisionalNavigation:)`

``` swift
func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) 
```

### `webView(_:decidePolicyFor:decisionHandler:)`

``` swift
func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) 
```

### `canExecute(url:)`

Determines whether or not the extension can be executed on a certain web page

``` swift
func canExecute(url: URL) -> Bool 
```

> 

#### Parameters

  - url: The url the extension checks to see if it can run on

### `loadView()`

Loads the `WKWebView` of the popup as the `view` property of the object
while also setting its configuration

``` swift
override func loadView() 
```

### `createPopup()`

Called by the delegate. Loads the extension browser action popup url
into the webview and sets the base path to the base of the extension.
Finally, it tells the delegate to show the popup

``` swift
@objc func createPopup() 
```
