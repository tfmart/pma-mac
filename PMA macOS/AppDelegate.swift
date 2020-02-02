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
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        statusItem.button?.title = "⏰"
        statusItem.button?.target = self
        statusItem.button?.action = #selector(statusItemClicked)
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    @objc func statusItemClicked() {
        if SessionHelper.shared.hasSession {
            presentEntryView()
        } else {
            SessionHelper.shared.displayLogin {
                if !SessionHelper.shared.isPreviousUser {
                    self.presentWelcomeView()
                    UserDefaults.standard.set(true, forKey: "isPreviousUser")
                } else {
                    self.presentEntryView()
                }
            }
        }
    }
    
    private func popUp(view viewController: NSViewController) {
        let popOverView = NSPopover()
        popOverView.contentViewController = viewController
        popOverView.behavior = .transient
        popOverView.show(relativeTo: self.statusItem.button!.bounds, of: self.statusItem.button!, preferredEdge: .maxY)
    }
    
    private func presentEntryView() {
        DispatchQueue.main.async {
            let storyboard = NSStoryboard(name: "Main", bundle: nil)
            guard let pmaViewController = storyboard.instantiateController(withIdentifier: "ViewController") as? ViewController else {
                fatalError("Unable to find PMA View Controller in the storyboard")
            }
            self.popUp(view: pmaViewController)
        }
    }
    
    private func presentWelcomeView() {
        DispatchQueue.main.async {
            let storyboard = NSStoryboard(name: "Main", bundle: nil)
            guard let welcomeView = storyboard.instantiateController(withIdentifier: "welcomePopUp") as? WelcomePopUp else {
                self.presentEntryView()
                return
            }
            self.popUp(view: welcomeView)
        }
    }
}
