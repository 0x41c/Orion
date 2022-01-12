# OrionSearchField

A custom search field made for responding to navigation like the
safari search fields

``` swift
class OrionSearchField: NSTextField 
```

## Inheritance

`NSTextField`

## Initializers

### `init(delegate:)`

``` swift
convenience init(delegate: OrionSearchFieldDelegate) 
```

## Properties

### `lastWithFocus`

A value describing if this text field was the last tab to be in focus

``` swift
var lastWithFocus: Bool = false
```

### `currentURL`

The current url in the search field after a search if any

``` swift
var currentURL: URL?
```

### `widthConstraint`

A reference to our width constraint corresponding
to the `lessThanOrEqualTo` modifier

``` swift
var widthConstraint: NSLayoutConstraint?
```

### `widthLowBoundConstraint`

When needed, this constraint is create and activated to allow there
to be flexibility

``` swift
var widthLowBoundConstraint: NSLayoutConstraint?
```

### `outsideBoundMonitor`

A pointer to a current monitoring object if `hasFocus` is true

``` swift
var outsideBoundMonitor: Any?
```

### `orionDelegate`

The delegate that manages the search fields state
and foreground context

``` swift
weak var orionDelegate: OrionSearchFieldDelegate?
```

### `hasFocus`

Variable to observe whether or not this search field has focus.
Works all the way back to macOS 10.0

``` swift
var hasFocus: Bool 
```

## Methods

### `viewDidMoveToWindow()`

``` swift
override func viewDidMoveToWindow() 
```

### `mouseDown(with:)`

``` swift
override func mouseDown(with event: NSEvent) 
```

### `draw(_:)`

The overriden draw function that draws our background and/or text

``` swift
override func draw(_ dirtyRect: NSRect) 
```

#### Parameters

  - dirtyRect: The rect to draw the text field content in

### `setupDefaultProperties()`

Sets the preconfigured properties of the search field.

``` swift
func setupDefaultProperties() 
```

### `updateProperties(focused:windowSize:)`

Function to animate and update the properties of the search field and its cell
when a tab loses or gains focus. Called by the delegate.

``` swift
func updateProperties(focused: Bool, windowSize: NSSize?) 
```

#### Parameters

  - focused: An outside value determining whether this search field should update its size with a focused context.
  - windowSize: Regardless of the optional type, this is needed to calculate the size of the field. If not present, nothing will be updated.
