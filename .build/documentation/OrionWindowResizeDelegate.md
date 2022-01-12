# OrionWindowResizeDelegate

Used when the window gets a `windowWillResize` event called on it.
This allows views relying on the windows size to resize their constraints
before anything happens

``` swift
protocol OrionWindowResizeDelegate: AnyObject 
```

## Inheritance

`AnyObject`

## Requirements

### windowWillResize(toSize:​)

A forward call of the `windowWillResize` function implemented on the window
delegate

``` swift
func windowWillResize(toSize: NSSize)
```
