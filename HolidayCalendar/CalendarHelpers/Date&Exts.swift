//
//  Date&Exts.swift
//  HolidayCalendar
//
//  Created by Scott O'Hara on 1/31/22.
//

import Foundation

//extension of date variables we can use to populate and compare dates from api
extension Date {
    
    //get dayIndex for first of week
    var getTheDayIndex: String {
        return String(Calendar.current.component(.day, from: self))
    }
    
    //get day
    var day: Int {
        return Calendar.current.component(.day, from: self)
    }
    
    //get year
    var year: Int {
        return Calendar.current.component(.year, from: self)
    }
    
    //get monthSymbols
    var monthSymbols: String {
        let monthIndex = Calendar.current.component(.month, from: self)
        return Calendar.current.monthSymbols[monthIndex - 1]
    }
    
    //get short date format, matchs api format
    var shortDateFormat: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: self)
    }
   
    static func addingDateIntervalByMonth(month: Int, date: Date) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(byAdding: .month, value: month, to: date) ?? Date()
    }

    static func addingDateIntervalByDay(day: Int, date: Date) -> Date {
        let calendar = Calendar(identifier: .gregorian)
        return calendar.date(byAdding: .day, value: day, to: date) ?? Date()
    }
    
}
