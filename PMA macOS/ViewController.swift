//
//  ViewController.swift
//  PMA macOS
//
//  Created by Tomas Martins on 30/01/20.
//  Copyright © 2020 Tomas Martins. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSTextFieldDelegate {
    
    //MARK: - IBOutlets
    @IBOutlet weak var usernameLabel: NSTextField!
    @IBOutlet weak var startDayPicker: NSDatePicker!
    @IBOutlet weak var startTimePicker: NSDatePicker!
    @IBOutlet weak var endDayPicker: NSDatePicker!
    @IBOutlet weak var endTimePicker: NSDatePicker!
    @IBOutlet weak var projectPicker: NSPopUpButton!
    @IBOutlet weak var acivityPicker: NSPopUpButton!
    @IBOutlet weak var descriptionTextField: NSTextField!
    @IBOutlet weak var saveButton: NSButton!
    
    let todayDate = Date()
    
    //MARK: - IBActions
    @IBAction func saveButtonClicked(_ sender: Any) {
        let startDay = startDayPicker.dateValue.day
        let startTime = startTimePicker.dateValue.time
        let endDay = endDayPicker.dateValue.day
        let endTime = endTimePicker.dateValue.time
        let description = descriptionTextField.stringValue
        let newEntry = NewEntryRequester(start: "\(startDay)%20\(startTime)", end: "\(endDay)%20\(endTime)", projectID: 959, activityID: 8915, description: description.replacingOccurrences(of: " ", with: "%20")) { (entry, error) in
            guard error == nil else {
                self.displayNotification(with: error)
                return
            }
            self.displayNotification()
        }
        newEntry.start()
    }
    
    @IBAction func startDateChanged(_ sender: Any) {
        if endDayPicker.dateValue < startDayPicker.dateValue {
            endDayPicker.dateValue = startDayPicker.dateValue
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        showLoginAlert()
        pickersInitialSetup()
    }
    
    func performLogin() {
        let requester = LoginRequester(username: "tomas.martins", password: "n3wstarthyp3") { (message, error) in
            guard error == nil else {
                self.displayNotification(with: error)
                return
            }
        }
        requester.start()
    }
    
    func pickersInitialSetup() {
        startDayPicker.dateValue = todayDate
        endDayPicker.dateValue = todayDate
        endTimePicker.dateValue = todayDate
    }
    
    func showLoginAlert() {
        let loginAlert = NSAlert()
        loginAlert.messageText = "PMA"
        loginAlert.informativeText = "Faça login"
        loginAlert.alertStyle = .warning
        loginAlert.addButton(withTitle: "Login")
        loginAlert.addButton(withTitle: "Cancelar")
        let response = loginAlert.runModal()
        if response == .alertFirstButtonReturn {
            performLogin()
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
        notification.soundName = NSUserNotificationDefaultSoundName
        NSUserNotificationCenter.default.deliver(notification)
    }
    
    
    //MARK: - NSTextFieldDelegate
    func controlTextDidChange(_ obj: Notification) {
        
    }
}
