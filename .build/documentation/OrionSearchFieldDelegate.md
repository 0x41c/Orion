# OrionSearchFieldDelegate

The delegate responsible for responding to the `OrionSearchField` being tapped
and forwarding the event out to parent delegates

``` swift
protocol OrionSearchFieldDelegate: NSTextFieldDelegate 
```

## Inheritance

`NSTextFieldDelegate`

## Requirements

### searchFieldWantsFocus(sender:​)

When a search field gets tapped, it will call this function signifying that
it was tapped and needs to be focused for the user.

``` swift
func searchFieldWantsFocus(sender: OrionSearchField)
```

### tabCount

The amount of tabs so that the search field can refine its shrinking and expanding calculations

``` swift
var tabCount: Int 
```
