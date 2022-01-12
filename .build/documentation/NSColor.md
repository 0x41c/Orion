# Extensions on NSColor

## Initializers

### `init?(webRGB:)`

Takes a CSS `rgb` or `rgba` value, parses it, and if valid, returns
a new color from it. If not valid returns nil

``` swift
convenience init?(webRGB colorString: String) 
```

#### Parameters

  - webRGB: The `rgb` or `rgba` value representing a color

### `init(hex:)`

Creates self with

``` swift
convenience init(hex: String) 
```

## Properties

### `isDark`

Returns whether the color is a generally dark color

``` swift
var isDark: Bool 
```

### `isLight`

Returns whether the color is a generally light color

``` swift
var isLight: Bool 
```

## Methods

### `getBrightness()`

``` swift
private func getBrightness() -> Float 
```

### `toHex(alpha:)`

``` swift
func toHex(alpha: Bool = false) -> String? 
```
