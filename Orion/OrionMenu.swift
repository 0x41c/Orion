//
//  Menubar.swift
//  Orion
//
//  Created by Corban Amouzou on 2021-12-30.
//

import Foundation
import Cocoa

// TODO: Get the menu setup
class OrionMenu: NSMenu {
    init() {
        super.init(title: "Orion")
        // Main panels
       let mainItems = [
            "File",
            "Edit",
            "View",
            "History"
       ].map { title -> NSMenuItem in
           let item = NSMenuItem(title: title, action: #selector(stub), keyEquivalent: "")
           item.target = self

           switch title {
           case "File":
               break
           case "Edit":
               break
           case "View":
               break
           case "History":
               break
           default:
               break
           }

           addItem(item)
           return item
        }
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
    }

    @objc func stub() {}
}
