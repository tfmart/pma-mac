//
//  EntryStatusBar.swift
//  PMA macOS
//
//  Created by Tomas Martins on 02/02/20.
//  Copyright © 2020 Tomas Martins. All rights reserved.
//

import Cocoa

class EntryStatusBarItem {
    let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    
    init() {
        item.button?.title = "⏰"
        item.button?.target = self
        item.action = #selector(statusItemClicked)
        item.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])
    }
    
    @objc func statusItemClicked() {
        let event = NSApp.currentEvent
        setupAction(for: event?.type)
    }
    
    private func setupAction(for event: NSEvent.EventType?) {
        if event == .rightMouseUp {
            let rightClickMenu = setupRightClickMenu()
            item.menu = rightClickMenu
            item.popUpMenu(rightClickMenu)
            item.menu = nil
        } else {
            if SessionManager.shared.hasSession {
                ViewPresenter.shared.presentEntryView()
            } else {
                SessionManager.shared.displayLogin {
                    if !SessionManager.shared.isPreviousUser {
                        ViewPresenter.shared.presentWelcomeView()
                        UserDefaults.standard.set(true, forKey: "isPreviousUser")
                    } else {
                        ViewPresenter.shared.presentEntryView()
                    }
                }
            }

        }
    }
    
    private func setupRightClickMenu() -> NSMenu {
        let rightClickMenu = NSMenu()
        var sessionMenuItem: NSMenuItem
        if SessionManager.shared.hasSession {
            rightClickMenu.addItem(NSMenuItem(title: "Logado como: \(SessionManager.shared.username)", action: nil, keyEquivalent: ""))
            sessionMenuItem = NSMenuItem(title: "Finalizar sessão", action: #selector(endSession), keyEquivalent: "")
        } else {
            sessionMenuItem = NSMenuItem(title: "Iniciar sessão", action: #selector(startSession), keyEquivalent: "")
        }
        sessionMenuItem.target = self
        rightClickMenu.addItem(sessionMenuItem)
        rightClickMenu.addItem(NSMenuItem.separator())
        rightClickMenu.addItem(NSMenuItem(title: "Encerrar o PMA", action: #selector(NSApplication.terminate(_:)), keyEquivalent: ""))
        return rightClickMenu
    }
    
    @objc func endSession() {
        SessionManager.shared.endSession()
    }
    
    @objc func startSession() {
        SessionManager.shared.displayLogin { }
    }
}
