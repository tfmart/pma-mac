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
        let newEntry = NewEntryRequester(start: "\(startDay)%20\(startTime)", end: "\(endDay)%20\(endTime)", projectID: 959, activityID: 8915, description: description.replacingOccurrences(of: " ", with: "%20"))
        newEntry.start()
    }
    
    @IBAction func startDateChanged(_ sender: Any) {
        if endDayPicker.dateValue < startDayPicker.dateValue {
            endDayPicker.dateValue = startDayPicker.dateValue
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        startDayPicker.dateValue = todayDate
        endDayPicker.dateValue = todayDate
        endTimePicker.dateValue = todayDate
        let req = LoginRequester(username: "", password: "")
        req.start()
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    //MARK: - NSTextFieldDelegate
    func controlTextDidChange(_ obj: Notification) {
        
    }
}
