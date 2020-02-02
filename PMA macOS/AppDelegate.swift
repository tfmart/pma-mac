//
//  AppDelegate.swift
//  PMA macOS
//
//  Created by Tomas Martins on 30/01/20.
//  Copyright © 2020 Tomas Martins. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let entryItem = ViewPresenter.shared.entryItem
        let item = entryItem.item
        item.isEnabled = false
        if SessionManager.shared.hasSession {
            SessionManager.shared.performLogin {
                DispatchQueue.main.async { item.isEnabled = true }
            }
        } else {
            SessionManager.shared.displayLogin {}
        }
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        EntryManager.clearDraft()
    }
}
