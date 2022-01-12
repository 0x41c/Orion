# OrionSearchFieldController

The controller that manages and maintains an `OrionSearchField`

``` swift
class OrionSearchFieldController: NSViewController 
```

## Inheritance

`NSViewController`, [`OrionSearchFieldDelegate`](/OrionSearchFieldDelegate)

## Initializers

### `init(delegate:contentController:)`

Creates an `OrionSearchFieldController` and sets up the search field and webview

``` swift
init(delegate: OrionSearchFieldControllerDelegate?, contentController: WKUserContentController) 
```

#### Parameters

  - delegate: The delegate to manage this instance
  - contentController: The content controller to manage the content of this controllers webview

### `init?(coder:)`

``` swift
required init?(coder: NSCoder) 
```

## Properties

### `tabCount`

``` swift
var tabCount: Int 
```

### `safariUA`

The default user agent used by the webview

``` swift
let safariUA = "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/15.1 Safari/605.1.15" 
```

### `searchField`

The wrapped search field

``` swift
let searchField: OrionSearchField
```

### `userContentController`

The tabs user content controller. Manages what gets loaded into the webview alongside
the current webview

``` swift
let userContentController: WKUserContentController
```

### `tabHistory`

The webviews history list. Should be used for the topSites api implementation.
Should be saved on load

``` swift
var tabHistory: [URL] 
```

### `delegate`

The delegate that manages this controller and maintains the foreground context of the tab

``` swift
weak var delegate: OrionSearchFieldControllerDelegate?
```

### `webview`

The tabs webview object

``` swift
lazy var webview: WKWebView 
```

## Methods

### `searchFieldWantsFocus(sender:)`

``` swift
func searchFieldWantsFocus(sender: OrionSearchField) 
```

### `control(_:textView:doCommandBy:)`

``` swift
func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool 
```

### `loadView()`

``` swift
override func loadView() 
```

### `goTo(url:)`

Tells the webview to navigate to the url specified and sets the
search fields text to the urls address

``` swift
func goTo(url: URL) 
```

#### Parameters

  - url: The URL to navigate to

### `goTo(url:)`

Wraps the `OrionSearchFieldController.goTo(url:​ URL)` method and handles search parsing
while also forwarding to a serach engine if needed.

``` swift
func goTo(url: String) 
```

#### Parameters

  - url: The url or search to navigate to; Uses a search engine if needed

### `setupWebView()`

Sets up the webviews properties and toggles the needed preferences

``` swift
func setupWebView() 
```
