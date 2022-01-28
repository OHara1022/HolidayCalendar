//
//  CalendarHelper.swift
//  HolidayCalendar
//
//  Created by Scott O'Hara on 1/28/22.
//

import Foundation

class CalendarHelper {
    let calendar = Calendar.current
    
    // from any day add one month, handle nextMomnth
    func plusMonth(date: Date) -> Date {
        // add 1 from month
        return calendar.date(byAdding: .month, value: 1, to: date)!
    }
    
    // from any day remove month, handle prevMonth
    func minusMonth(date: Date) -> Date {
        // minus 1 from month
        return calendar.date(byAdding: .month, value: -1, to: date)!
    }
    
    // format month, return month in text
    func monthString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "LLLL"
        return dateFormatter.string(from: date)
    }
    
    // format year, return month in text
    func yearString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter.string(from: date)
    }
    
    // return the days in each month, some have 30 or 31 days
    func daysInMonth(date: Date) -> Int {
        let range = calendar.range(of: .day, in: .month, for: date)!
        return range.count
    }
    
    // get day of any month
    func daysOfMonth(date: Date) -> Int {
        let components = calendar.dateComponents([.day], from: date)
        return components.day!
    }
    
    // get first of month for each month
    func firstOfMonth(date: Date) -> Date {
        let components = calendar.dateComponents([.year, .month], from: date)
        return calendar.date(from: components)!
    }
    
    // get weekdays
    func weekDay(date: Date) -> Int {
        let components = calendar.dateComponents([.weekday], from: date)
        return components.weekday! - 1
    }
}
