//
//  NewEntryViewController.swift
//  PMA macOS
//
//  Created by Tomas Martins on 30/01/20.
//  Copyright © 2020 Tomas Martins. All rights reserved.
//

import Cocoa

class NewEntryViewController: NSViewController, NSTextFieldDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet weak var startDayPicker: NSDatePicker!
    @IBOutlet weak var startTimePicker: NSDatePicker!
    @IBOutlet weak var endTimePicker: NSDatePicker!
    @IBOutlet weak var projectPicker: NSPopUpButton!
    @IBOutlet weak var acivityPicker: NSPopUpButton!
    @IBOutlet weak var descriptionTextField: NSTextField!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var usernameLabel: NSTextField!
    
    //MARK: - Properties
    var hasCreatedEntry: Bool = false
    
    var startDate: Date {
        return Date.sync(dayFrom: startDayPicker.dateValue, to: startTimePicker.dateValue)
    }
    
    var endDate: Date {
        return Date.sync(dayFrom: startDate, to: endTimePicker.dateValue)
    }
    
    //MARK: - IBActions
    @IBAction func saveButtonClicked(_ sender: Any) {
        self.createEntry(sender)
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameLabel.stringValue = SessionManager.shared.username
        self.descriptionTextField.delegate = self
        pickersInitialSetup()
    }
    
    override func viewWillDisappear() {
        let state = EntryManager.shouldSaveDraft(didCreate: self.hasCreatedEntry)
        switch state{
        case .saveDraft:
            EntryManager.saveDraft(date: self.startDayPicker.dateValue, starTime: self.startTimePicker.dateValue, endTime: self.endTimePicker.dateValue, description: self.descriptionTextField.stringValue)
        case .discardDraft:
            EntryManager.clearDraft()
            UserDefaults.standard.set(false, forKey: "nextEntry")
        case .prepareNextEntry:
            EntryManager.prepareForNextEntry(date: self.startDayPicker.dateValue, time: self.endTimePicker.dateValue)
        }
    }
    
    //MARK: - Methods
    func displayNotification(with error: PMAError? = nil) {
        let notification = NSUserNotification()
        if let error = error {
            notification.title = "Erro ao apontar o PMA"
            notification.informativeText = error.rawValue
        } else {
            notification.title = "PMA"
            notification.informativeText = "Apontamento criado com sucesso"
        }
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    func pickersInitialSetup() {
        let startTimeValue = startTimePicker.dateValue
        startDayPicker.dateValue = EntryManager.day ?? Date()
        startTimePicker.dateValue = EntryManager.starTime ?? startTimeValue
        endTimePicker.dateValue = EntryManager.endTime ?? Date()
        descriptionTextField.stringValue = EntryManager.description ?? ""
    }
    
    private func createEntry(_ sender: Any) {
        EntryManager.createEntryRequest(startDate: startDate, endDate: endDate, description: descriptionTextField.stringValue, success: {
            self.newEntryCreated()
            self.view.window?.performClose(sender)
        }) { (error) in
            self.handleError(error)
        }
    }
    
    private func newEntryCreated() {
        self.displayNotification()
        self.hasCreatedEntry = true
        UserDefaults.standard.set(true, forKey: "nextEntry")
    }
    
    private func handleError(_ error: PMAError) {
        self.hasCreatedEntry = false
        EntryManager.saveDraft(date: self.startDayPicker.dateValue, starTime: self.startTimePicker.dateValue, endTime: self.endTimePicker.dateValue, description: self.descriptionTextField.stringValue)
        if error == .expiredSession {
            UserDefaults.standard.set(false, forKey: "hasSession")
            SessionManager.shared.displayLogin(message: error.rawValue) {}
        } else {
            self.displayNotification(with: error)
        }
    }
    
    //MARK: - NSTextFieldDelegate
    func controlTextDidChange(_ obj: Notification) {
        
    }
    
    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        if (commandSelector == #selector(NSResponder.insertNewline(_:))) {
            self.createEntry(textView)
            return true
        }
        return false
    }
}
