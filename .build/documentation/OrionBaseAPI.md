# OrionBaseAPI

The base API interface that is used to register with a webview

``` swift
protocol OrionBaseAPI: NSObject, WKScriptMessageHandler 
```

> 

## Inheritance

`NSObject`, `WKScriptMessageHandler`

## Requirements

### supportingJSFileName

The file name of the js file that handles the javascript interface
of the api

``` swift
var supportingJSFileName: String 
```

### apiFunctionNames

The names of the messages that get passed back along to the object

``` swift
var apiFunctionNames: [String] 
```
