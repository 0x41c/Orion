# OrionExtensionManager

Curates and manages the installation, loading, unloading, and deletion of extensions

``` swift
class OrionExtensionManager: OrionBrowserExtensionDelegate 
```

## Inheritance

[`OrionBrowserExtensionDelegate`](/OrionBrowserExtensionDelegate)

## Initializers

### `init(windowController:)`

Creates an `OrionExtensionManager` and immediately loads all the extensions
into memory

``` swift
init(windowController: OrionWindowController) 
```

#### Parameters

  - windowController: The window controller to host the extension manager

## Properties

### `extensionFolderName`

The static name of the folder within the application support directory that
contains all of the extensions of the app

``` swift
let extensionFolderName: String = "Orion Extensions"
```

### `fileManager`

A default filemanager instance

``` swift
let fileManager: FileManager = FileManager.default
```

### `extensions`

An array of all the extensions loaded into memory and accessable

``` swift
var extensions: [OrionBrowserExtension] 
```

### `windowController`

A pointer to the window controller for quick UI access

``` swift
private weak var windowController: OrionWindowController?
```

## Methods

### `downloadExtension(extensionURL:)`

Downlodas an extension and passes the data off to the installer

``` swift
func downloadExtension(extensionURL: URL) 
```

#### Parameters

  - extensionURL: The url to download the extension from

### `unpackAndInstallExtension(_:)`

Installs an extension given the packed file data of the extension

``` swift
func unpackAndInstallExtension(_ extensionData: Data) 
```

#### Parameters

  - extensionData: The raw unpacked data corresponding to the extension

### `loadExtensions()`

Loads all the extensions locaed in the extension directory of the apps application support
directory. If an extension is malformed, or if there was an error creating an extension
instance, it will not be loaded into memory, but will be skipped.

``` swift
func loadExtensions() 
```

### `deleteExtension(browserExtension:)`

Deletes an extension given an extension instance. It takes the internalIdentifier
from the instance and passes it over to `deleteExtension(internalIdentifier:​)`

``` swift
func deleteExtension(browserExtension: OrionBrowserExtension) 
```

#### Parameters

  - browserExtension: The extension to delete from the filesystem

### `deleteExtension(internalIdentifier:browserExtension:)`

Deletes an extension given the extensions internal identifier. If the identifier
is invalid, no extensions are deleted.

``` swift
func deleteExtension(internalIdentifier: String, browserExtension: OrionBrowserExtension?) 
```

#### Parameters

  - internalIdentifier: The identifier of the extension to remove. This also acts as the pathname
  - browserExtension: An instance of a browser extension. If not nil, this gets removed from the extension list.

### `getDirectory(_:)`

Returns a URL of the application support directory with the subpath
appended to it.

``` swift
func getDirectory(_ subpath: String) -> URL 
```

#### Parameters

  - subPath: The subpath of the directory as a string to get the URL of

### `ensureSupportDirectories()`

Ensures that all manditory support directories for the extensions exist.
If any one of the directories do not exist, this returns false.

``` swift
func ensureSupportDirectories() -> Bool 
```

### `ensureDirectory(path:)`

Ensures that a directory exists. If the specified directory does not exist,
it is created. In the off chance that a directory cannot be created, its URL is
not returned.

``` swift
func ensureDirectory(path: URL) -> URL? 
```

#### Parameters

  - path: The directory URL to ensure exists.

### `createDirectory(path:withIntermediateDirectories:attributes:)`

Wraps `FileManger.createDirectory` and catches any errors that may be thrown.
if the directory fails to be created, this function returns false.

``` swift
func createDirectory(
        path: URL,
        withIntermediateDirectories: Bool,
        attributes: [FileAttributeKey: Any]?
    ) -> Bool 
```

#### Parameters

  - path: The path of the directory to create
  - withIntermediateDirectories: Determines whether the file manager should create non existent parent directories along with the directory specified.
  - attributes: The file attributes for the new directory to create.

### `addToolbarItem(_:)`

Adds an extension toolbar item to the windows toolbar. If the item already exists in the toolbar
the the new item is not created.

``` swift
func addToolbarItem(_ sender: OrionBrowserExtension) 
```

#### Parameters

  - sender: The browser extension calling the method to add it to the toolbar

### `showPopover(_:)`

Shows the popover menu on the window in the left corner of the screen
while in windowed mode, and in front of the screen when in full screen mode

``` swift
func showPopover(_ sender: OrionBrowserExtension) 
```

#### Parameters

  - sender: The browser extension requesting to have its popover shown
