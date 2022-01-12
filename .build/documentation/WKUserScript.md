# Extensions on WKUserScript

## Initializers

### `init(name:contentWorldName:)`

Creates a new WKUserScript while automaticall loading the contents of
the passed in javascript file name

``` swift
@available(macOS 11, *)
    convenience init(name: String, contentWorldName: String) 
```

#### Parameters

  - name: The file name of the javascript to load
  - contentWorldName: The name of the content world to load the javascript in

### `init(name:)`

Creates a new WKUserScript while automaticall loading the contents of
the passed in javascript file name

``` swift
convenience init (name: String) 
```

#### Parameters

  - name: The file name of the javascript to load

## Methods

### `ensureInternalResource(withName:)`

Loads javascript given the file name. If the javascript file does not exist,
it returns a script containing a `console.error` with the name of the
failed file to load.

``` swift
static func ensureInternalResource(withName name: String) -> String 
```

#### Parameters

  - withName: The name of the javascript file to load

### `loadJavascript(withName:)`

Loads javascript given the file name. If the requested file does not
exist, it instead returns `nil`

``` swift
static func loadJavascript(withName name: String) -> String? 
```

#### Parameters

  - withName: The name of the javascript file to load
