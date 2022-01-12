# BrowserAction

The object specifying what gets loaded when the user clicks the popup button
corresponding your extension

``` swift
struct BrowserAction: Codable 
```

## Inheritance

`Codable`

## Properties

### `browserStyle`

The style of the popup.

``` swift
var browserStyle: Bool = true
```

Defauls to true

### `defaultIcon`

The icon to use in the popup button in multiple
sizes for compatibility purposes

``` swift
let defaultIcon: [String: String]?
```

### `defaultPopup`

The default path of the popups content. Generally is an
html file. Relative to the to the base of the extension.

``` swift
let defaultPopup: String?
```

  - Localizable

### `defaultTitle`

The defualt title of the popup. Used as the tooltip of the
toolbar button

``` swift
let defaultTitle: String?
```
