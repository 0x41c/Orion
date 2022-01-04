//
//  AppDelegate.swift
//  Orion
//
//  Created by Corban Amouzou on 2021-12-30.
//

import Cocoa
import WebKit

// TODO: Welcome banner or message when first launch (At least a walkthrough of sorts)
// TODO: Pack up and save the current session when the application terminates for reuse

class OrionDelegate: NSObject, NSApplicationDelegate {
    private var orionWindowControllers: [OrionWindowController] = [OrionWindowController]()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        openNewWindow()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }

    func openNewWindow() {
        let controller: OrionWindowController = OrionWindowController(.regularWindow)
        orionWindowControllers.append(controller)
        controller.window!.makeKeyAndOrderFront(nil)
    }

    func openNewPrivateWindow() {
        let controller: OrionWindowController = OrionWindowController(.privateWindow)
        orionWindowControllers.append(controller)
        controller.window?.makeKeyAndOrderFront(nil)
    }

}
