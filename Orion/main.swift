//
//  main.swift
//  Orion
//
//  Created by Corban Amouzou on 2021-12-30.
//

import Foundation
import Cocoa

let app = NSApplication.shared
let delegate = OrionDelegate()
let menu = OrionMenu()
app.delegate = delegate
app.mainMenu = menu
_ = NSApplicationMain(CommandLine.argc, CommandLine.unsafeArgv)
