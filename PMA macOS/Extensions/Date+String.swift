//
//  Date+String.swift
//  PMA macOS
//
//  Created by Tomás Feitoza Martins  on 31/01/20.
//  Copyright © 2020 Tomas Martins. All rights reserved.
//

import Foundation

extension Date {
    var time: String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        let timeString = timeFormatter.string(from: self)
        return timeString
    }
    
    var day: String {
        let dayFormatter = DateFormatter()
        dayFormatter.dateFormat = "yyyy-MM-dd"
        let dayString = dayFormatter.string(from: self)
        return dayString
    }
}
