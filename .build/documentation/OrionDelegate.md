# OrionDelegate

``` swift
class OrionDelegate: NSObject, NSApplicationDelegate 
```

## Inheritance

`NSApplicationDelegate`, `NSObject`

## Properties

### `orionWindowControllers`

``` swift
private var orionWindowControllers: [OrionWindowController] 
```

## Methods

### `applicationDidFinishLaunching(_:)`

``` swift
func applicationDidFinishLaunching(_ aNotification: Notification) 
```

### `applicationWillTerminate(_:)`

``` swift
func applicationWillTerminate(_ aNotification: Notification) 
```

### `applicationSupportsSecureRestorableState(_:)`

``` swift
func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool 
```

### `openNewWindow()`

``` swift
func openNewWindow() 
```

### `openNewPrivateWindow()`

``` swift
func openNewPrivateWindow() 
```
