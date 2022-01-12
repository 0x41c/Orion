# MozillaBrowserExtensionManifest

The manifest format for the browser extension

``` swift
struct MozillaBrowserExtensionManifest: Codable 
```

This is not complete or up to spec.
Please see: https://developer.mozilla.org/en-US/docs/Mozilla/Add-ons/WebExtensions/manifest.json
for a list of all the keys and values

## Inheritance

`Codable`

## Initializers

### `init(_:)`

Default initialization

``` swift
init(_ path: URL) throws 
```

#### Parameters

  - path: The path of the manifest

## Properties

### `author`

The author of the extension

``` swift
let author: String?
```

### `browserAction`

The action object that specifies a dropdown tab
on the toolbar of the browser.

``` swift
let browserAction: BrowserAction?
```

### `defaultLocale`

The name of the default locale bundle to get localized keys
from. Not required unless `_locale` path exists at the root
of the extension folder

``` swift
let defaultLocale: String?
```

### `homepageURL`

The url leading to the homepage of the author of the extension

``` swift
let homepageURL: String?
```

### `icons`

An array of icon paths keyed by size. Paths are relative to the
extension folder.

``` swift
let icons: [String: String]?
```

### `manifestVersion`

The version of the manifest. Latest is `v3`

``` swift
let manifestVersion: Int
```

### `name`

The name of the extension.

``` swift
let name: String
```

  - Localizable

### `optionsUi`

The UI specification for the extension given options page

``` swift
let optionsUi: OptionsUI?
```

### `permissions`

A list of permissions the extension has to provide when accessing
browser apis that handle user information

``` swift
let permissions: [String]?
```

### `version`

Version of the plugin. Created by the author. This is required

``` swift
let version: String
```

## Methods

### `getExtensionIcon(extensionPath:)`

Gets the extension icon from the main icons array

``` swift
func getExtensionIcon(extensionPath path: URL) -> NSImage? 
```

#### Parameters

  - manifest: The manifest object to get the image of
