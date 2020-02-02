//
//  ViewPresenter.swift
//  PMA macOS
//
//  Created by Tomas Martins on 02/02/20.
//  Copyright © 2020 Tomas Martins. All rights reserved.
//

import Cocoa

class ViewPresenter {
    static public let shared = ViewPresenter()
    private init() {}
    
    let statusBar = EntryStatusBarItem()
    var presentedView: NSViewController? = nil
    
    @objc func presentEntryView() {
        DispatchQueue.main.async {
            let storyboard = NSStoryboard(name: "Main", bundle: nil)
            guard let pmaViewController = storyboard.instantiateController(withIdentifier: "ViewController") as? NewEntryViewController else {
                fatalError("Unable to find PMA View Controller in the storyboard")
            }
            self.popUp(pmaViewController)
        }
    }
    
    @objc func presentWelcomeView() {
        DispatchQueue.main.async {
            let storyboard = NSStoryboard(name: "Main", bundle: nil)
            guard let welcomeView = storyboard.instantiateController(withIdentifier: "welcomePopUp") as? WelcomePopUp else {
                self.presentEntryView()
                return
            }
            self.popUp(welcomeView)
        }
    }
    
    private func popUp(_ viewController: NSViewController) {
        DispatchQueue.main.async {
            let statusBarItem = self.statusBar.item
            let popOverView = NSPopover()
            popOverView.contentViewController = viewController
            self.presentedView = viewController
            popOverView.behavior = .transient
            popOverView.show(relativeTo: statusBarItem.button!.bounds, of: statusBarItem.button!, preferredEdge: .maxY)
        }
    }
}
