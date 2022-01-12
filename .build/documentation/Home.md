# Types

  - [OrionDelegate](/OrionDelegate)
  - [OrionBrowserExtension](/OrionBrowserExtension):
    The class representing a browser extension installed by the user.
    Wraps a `MozillaBrowserExtensionManifest`
  - [OrionExtensionManager](/OrionExtensionManager):
    Curates and manages the installation, loading, unloading, and deletion of extensions
  - [OrionTopSitesAPI](/OrionTopSitesAPI):
    The API class of the mozilla `topSites` api
  - [OrionUserContentController](/OrionUserContentController):
    The global `WKUserContentController`.
  - [OrionTabStretcherView](/OrionTabStretcherView):
    The view that stretches the background of the tab item to allow it to be centered in
    older operating systems but also to auto resize whenever needed as well
  - [OrionWindowController](/OrionWindowController):
    The main window controller for the application. Handles all interactions between the user and
    the webview and toolbar.
  - [OrionMenu](/OrionMenu)
  - [OrionSearchField](/OrionSearchField):
    A custom search field made for responding to navigation like the
    safari search fields
  - [OrionSearchFieldController](/OrionSearchFieldController):
    The controller that manages and maintains an `OrionSearchField`
  - [OrionTabbedLocationViewController](/OrionTabbedLocationViewController):
    This hold all of our `OrionSearchTabFields` and connects them up by receiving their events
    and forwarding them to each-other. As this is like a controlled proxy service however, raw events
    are not completely forwarded, but translated into the events needed to allow all of the tabs to update
    synchronously.
  - [OrionBrowserExtensionError](/OrionBrowserExtensionError):
    A generic error object for use when loading and managing a browser extension
  - [OrionWindowType](/OrionWindowType):
    Orion window types
  - [MozillaBrowserExtensionManifest](/MozillaBrowserExtensionManifest):
    The manifest format for the browser extension
  - [BrowserAction](/BrowserAction):
    The object specifying what gets loaded when the user clicks the popup button
    corresponding your extension
  - [OptionsUI](/OptionsUI)

# Protocols

  - [OrionTabbedLocationViewControllerDelegate](/OrionTabbedLocationViewControllerDelegate):
    The delegate responsible for managing the `OrionTabbedLocationViewController` and
    responding to changes in forground context
  - [OrionSearchFieldControllerDelegate](/OrionSearchFieldControllerDelegate):
    The delegate responsible for managing the `OrionSearchFieldController` and
    forwarding foreground requests to a `OrionTabbedLocationViewControllerDelegate`
  - [OrionSearchFieldDelegate](/OrionSearchFieldDelegate):
    The delegate responsible for responding to the `OrionSearchField` being tapped
    and forwarding the event out to parent delegates
  - [OrionBrowserExtensionDelegate](/OrionBrowserExtensionDelegate):
    The delegate for an `OrionBrowserExtension`. It responds to actions that are called on the
    extension if there is an action window button in the toolbar.
  - [OrionWindowResizeDelegate](/OrionWindowResizeDelegate):
    Used when the window gets a `windowWillResize` event called on it.
    This allows views relying on the windows size to resize their constraints
    before anything happens
  - [OrionBaseAPI](/OrionBaseAPI):
    The base API interface that is used to register with a webview

# Global Variables

  - [firefoxUA](/firefoxUA):
    The user agent to use when accessing a firefox extension download page
  - [app](/app)
  - [delegate](/delegate)
  - [menu](/menu)

# Extensions

  - [FileManager](/FileManager)
  - [NSColor](/NSColor)
  - [NSToolbarItem.Identifier](/NSToolbarItem_Identifier)
  - [String](/String)
  - [WKUserScript](/WKUserScript)
