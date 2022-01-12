# OrionTabStretcherView

The view that stretches the background of the tab item to allow it to be centered in
older operating systems but also to auto resize whenever needed as well

``` swift
class OrionTabStretcherView: NSView, OrionWindowResizeDelegate 
```

## Inheritance

`NSView`, [`OrionWindowResizeDelegate`](/OrionWindowResizeDelegate)

## Properties

### `beforeLoadWindow`

A window that gets set to the view before the view gets
added to the window to allow the view to iterate the toolbar items

``` swift
var beforeLoadWindow: NSWindow?
```

### `widthConstraint`

The controlled width constraint that determines that width
needed for the tab item

``` swift
var widthConstraint: NSLayoutConstraint?
```

### `newSize`

A swap variable for the new sizes to be implemented

``` swift
private var newSize: NSSize?
```

### `setSubviewConstraint`

A boolean value indicating whether the subview has had its
centerXAnchor constraint set

``` swift
private var setSubviewConstraint: Bool = false
```

## Methods

### `windowWillResize(toSize:)`

Called by the window, alerts the TabStretcherView to resize its
constraints

``` swift
func windowWillResize(toSize: NSSize) 
```

### `updateCustomSizing()`

Called by the `OrionWindowController`, this resizes the constraints for
on this view corresponding to the amount of size the search field item
should take up.

``` swift
@objc func updateCustomSizing() 
```

### `calculateWidth()`

Calculates the width for the view depending on where it is located in the
toolbar and expands accordingly

``` swift
func calculateWidth() -> CGFloat 
```
