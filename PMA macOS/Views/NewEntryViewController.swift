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
    @IBOutlet weak var endDayPicker: NSDatePicker!
    @IBOutlet weak var endTimePicker: NSDatePicker!
    @IBOutlet weak var projectPicker: NSPopUpButton!
    @IBOutlet weak var acivityPicker: NSPopUpButton!
    @IBOutlet weak var descriptionTextField: NSTextField!
    @IBOutlet weak var saveButton: NSButton!
    @IBOutlet weak var usernameLabel: NSTextField!
    
    //MARK: - IBActions
    @IBAction func saveButtonClicked(_ sender: Any) {
        let startDate = "\(startDayPicker.dateValue.day)%20\(startTimePicker.dateValue.time)"
        let endDate = "\(endDayPicker.dateValue.day)%20\(endTimePicker.dateValue.time)"
        let description = descriptionTextField.stringValue.replacingOccurrences(of: " ", with: "%20")
        let newEntryRequester = NewEntryRequester(start: startDate, end: endDate,
                                                  projectID: 959, activityID: 8915,
                                                  description: description) { (entry, error) in
                                                    guard error == nil else {
                                                        if error == .expiredSession {
                                                            UserDefaults.standard.set(false, forKey: "hasSession")
                                                            DispatchQueue.main.async {
                                                                SessionHelper.shared.displayLogin(message: error?.rawValue) {}
                                                            }
                                                        } else {
                                                            self.displayNotification(with: error)
                                                        }
                                                        return
                                                    }
                                                    self.displayNotification()
                                                    self.dismiss(self)
        }
        newEntryRequester.start()
    }
    
    @IBAction func startDateChanged(_ sender: Any) {
        if endDayPicker.dateValue < startDayPicker.dateValue {
            endDayPicker.dateValue = startDayPicker.dateValue
        }
    }
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.usernameLabel.stringValue = SessionHelper.shared.username
        pickersInitialSetup()
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
        startDayPicker.dateValue = Date()
        endDayPicker.dateValue = Date()
        endTimePicker.dateValue = Date()
    }
    
    //MARK: - NSTextFieldDelegate
    func controlTextDidChange(_ obj: Notification) {
        
    }
}
