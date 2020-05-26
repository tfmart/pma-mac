//
//  EntryManager.swift
//  PMA macOS
//
//  Created by Tomas Martins on 02/02/20.
//  Copyright © 2020 Tomas Martins. All rights reserved.
//

import Foundation

class EntryManager {
    static var day: Date? {
        return UserDefaults.standard.value(forKey: "date") as? Date
    }
    
    static var starTime: Date? {
        return UserDefaults.standard.value(forKey: "startTime") as? Date
    }
    
    static var endTime: Date? {
        return UserDefaults.standard.value(forKey: "endTime") as? Date
    }
    
    static var description: String? {
        return UserDefaults.standard.string(forKey: "description")
    }
    
    static var prepareNextEntry: Bool {
        return UserDefaults.standard.bool(forKey: "nextEntry")
    }
    
    static func saveDraft(date: Date, starTime: Date, endTime: Date, description: String) {
        UserDefaults.standard.set(date, forKey: "date")
        UserDefaults.standard.set(starTime, forKey: "startTime")
        UserDefaults.standard.set(endTime, forKey: "endTime")
        UserDefaults.standard.set(description, forKey: "description")
    }
    
    static func clearDraft() {
        UserDefaults.standard.removeObject(forKey: "date")
        UserDefaults.standard.removeObject(forKey: "startTime")
        UserDefaults.standard.removeObject(forKey: "endTime")
        UserDefaults.standard.removeObject(forKey: "description")
    }
    
    static func prepareForNextEntry(date: Date, time: Date) {
        UserDefaults.standard.set(date, forKey: "date")
        UserDefaults.standard.set(time, forKey: "startTime")
        UserDefaults.standard.removeObject(forKey: "endTime")
        UserDefaults.standard.removeObject(forKey: "description")
    }
    
    static func shouldSaveDraft(didCreate: Bool) -> EntryManagerState{
        if EntryManager.prepareNextEntry && !didCreate {
            return .discardDraft
        } else if EntryManager.prepareNextEntry && didCreate {
            return .prepareNextEntry
        } else {
            return .saveDraft
        }
    }
    
    static func createEntryRequest(startDate: Date, endDate: Date, description: String, success: @escaping () -> (), failure: @escaping (PMAError) -> ()) {
        let startDateValue = "\(startDate.day)%20\(startDate.time)"
        let endDateValue = "\(endDate.day)%20\(endDate.time)"
        let descriptionValue = description.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        let newEntryRequester = NewEntryRequester(start: startDateValue, end: endDateValue,
                                                  projectID: 959, activityID: 8915,
                                                  description: descriptionValue ?? "") { (entry, error) in
                                                    DispatchQueue.main.async {
                                                        error == nil ? success() : failure(error!)
                                                    }
        }
        newEntryRequester.start()
    }
}

public enum EntryManagerState {
    case saveDraft
    case discardDraft
    case prepareNextEntry
}
