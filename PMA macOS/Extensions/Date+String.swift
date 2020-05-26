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
    
    static func sync(dayFrom startDate: Date, to finalDate: Date) -> Date {
        let calendar = NSCalendar(calendarIdentifier: .gregorian)
        let startComponents = calendar?.components([.day, .month, .year], from: startDate);
        var endComponents = calendar?.components([.hour, .minute], from: finalDate);
        endComponents?.day = startComponents?.day
        endComponents?.month = startComponents?.month
        endComponents?.year = startComponents?.year
        return (calendar?.date(from: endComponents!))!
    }
}
