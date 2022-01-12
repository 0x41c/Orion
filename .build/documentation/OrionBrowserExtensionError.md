# OrionBrowserExtensionError

A generic error object for use when loading and managing a browser extension

``` swift
enum OrionBrowserExtensionError: Error 
```

## Inheritance

`Error`

## Enumeration Cases

### `unableToLoadManifest`

If the extension manifest is malformed or invalid, this error is called
with a message saying specifically what happened

``` swift
case unableToLoadManifest(_ message: String)
```
