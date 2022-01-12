# OrionTabbedLocationViewControllerDelegate

The delegate responsible for managing the `OrionTabbedLocationViewController` and
responding to changes in forground context

``` swift
protocol OrionTabbedLocationViewControllerDelegate: AnyObject 
```

## Inheritance

`AnyObject`

## Requirements

### tabWantsForeground(tab:​)

When a tab gets clicked this will fire to our window controller.
Our window will then set its webview to this tabs window

``` swift
func tabWantsForeground(tab: OrionSearchFieldController)
```

### updateToolbarColor()

Whenever there is a change in the current windows webview state
the toolbar background color needs to be updated to ensure that
there are no inconsistencies in the colors of the webpage.

``` swift
func updateToolbarColor()
```

### addWindowResizeEventListener(\_:​)

Called by objects that need to update their sizes whenever the
window they're connected to resizes. This allows views to use the window
width or the new width to their advantage

``` swift
func addWindowResizeEventListener(_ observer: OrionWindowResizeDelegate)
```

### extensionManager

The extension manager reference for the `OrionTabbedLocationViewController` to access

``` swift
var extensionManager: OrionExtensionManager 
```
