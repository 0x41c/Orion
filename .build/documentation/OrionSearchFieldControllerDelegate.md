# OrionSearchFieldControllerDelegate

The delegate responsible for managing the `OrionSearchFieldController` and
forwarding foreground requests to a `OrionTabbedLocationViewControllerDelegate`

``` swift
protocol OrionSearchFieldControllerDelegate: AnyObject 
```

## Inheritance

`AnyObject`

## Requirements

### tabWillClose(sender:​)

When a tab needs to close there is some teardown work that needs
to be done by the delegate. Initial things could be saving the history of that
tab for later tab restoration, saving the history to the main history record
and also drawing the animation for the close.

``` swift
func tabWillClose(sender: OrionSearchFieldController)
```

### tabWantsForeground(tab:​)

Called when a tab gets clicked to allow the parent to assign the tabs
webview over to the main window.

``` swift
func tabWantsForeground(tab: OrionSearchFieldController)
```

### tabCount

The amount of tabs so that the search field can refine its shrinking and expanding calculations

``` swift
var tabCount: Int 
```
