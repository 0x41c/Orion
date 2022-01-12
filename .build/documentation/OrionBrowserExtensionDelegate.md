# OrionBrowserExtensionDelegate

The delegate for an `OrionBrowserExtension`. It responds to actions that are called on the
extension if there is an action window button in the toolbar.

``` swift
protocol OrionBrowserExtensionDelegate: AnyObject 
```

## Inheritance

`AnyObject`

## Requirements

### addToolbarItem(\_:​)

The extension is requesting an action window toolbar button to be displayed on the window
toolbar.

``` swift
func addToolbarItem(_ sender: OrionBrowserExtension)
```

### showPopover(\_:​)

This function gets called when the toolbar button has been pressed and the extension is requesting
that its window gets shown to the window

``` swift
func showPopover(_ sender: OrionBrowserExtension)
```
