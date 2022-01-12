# OrionUserContentController

The global `WKUserContentController`.

``` swift
class OrionUserContentController: WKUserContentController 
```

## Inheritance

`WKUserContentController`

## Initializers

### `init()`

Creates a WKUserContentController while automatically loading
the javascript given the names provided by the property `userScriptNames`

``` swift
override init() 
```

### `init?(coder:)`

``` swift
required init?(coder: NSCoder) 
```

## Properties

### `defaultMessageHandlers`

Default message handlers that should be loaded into every instance
of a webview

``` swift
let defaultMessageHandlers: [String: WKScriptMessageHandler] = [:]
```

### `userScriptNames`

``` swift
let userScriptNames: [String] = [
       // "changeDownloadName"
    ]
```
