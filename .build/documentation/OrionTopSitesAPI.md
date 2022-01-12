# OrionTopSitesAPI

The API class of the mozilla `topSites` api

``` swift
class OrionTopSitesAPI: NSObject, OrionBaseAPI 
```

## Inheritance

`NSObject`, [`OrionBaseAPI`](/OrionBaseAPI)

## Properties

### `apiFunctionNames`

``` swift
let apiFunctionNames: [String] = [
        "topSites.get",
        "topSites.MostVisitedURL"
    ]
```

### `supportingJSFileName`

``` swift
let supportingJSFileName: String = "browserObject"
```

## Methods

### `userContentController(_:didReceive:)`

The handler for a message call that corresponded to one of the `apiFunctionNames` specified on the class

``` swift
func userContentController(
        _ userContentController: WKUserContentController,
        didReceive message: WKScriptMessage
    ) 
```
