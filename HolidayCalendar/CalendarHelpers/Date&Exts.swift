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

extension HolidayViewController {
     func generateCalender() {
        let initialDate = calendar.date(byAdding: .month, value: currentMonthIndex, to: Date())!
        currentMonth = initialDate
        
        let components = calendar.dateComponents([.year, .month], from: initialDate)
        
        let firstDayOfMonth = calendar.date(from: components)!
        let firstDayOfWeekday = calendar.dateComponents([.weekday], from: firstDayOfMonth).weekday ?? 0
        let totalDayInMonth = calendar.range(of: .day, in: .month, for: initialDate)?.count ?? 0
                
        days.removeAll()
        var offset: Int = 35

        for i in 1..<firstDayOfWeekday {
            let date = Date.addingDateIntervalByDay(day: -(firstDayOfWeekday - i), date: firstDayOfMonth)
            let day = Day(
                date: Date.addingDateIntervalByMonth(month: 0, date: date),
                dayNumber: date.getTheDayIndex,
                isPreviousMonth: true
            )
            days.append(day)
            offset -= 1
        }
        
        for i in 0..<totalDayInMonth {
            let date = Date.addingDateIntervalByDay(day: i, date: firstDayOfMonth)
            let day = Day(
                date: date,
                dayNumber: date.getTheDayIndex
            )
            days.append(day)
            offset -= 1
        }
        
        if offset > 0 {
            for i in 0..<offset {
                let date = Date.addingDateIntervalByDay(day: i, date: firstDayOfMonth)
                let day = Day(
                    date: Date.addingDateIntervalByMonth(month: 1, date: date),
                    dayNumber: date.getTheDayIndex,
                    isNextMonth: true
                )
                days.append(day)
                offset -= 1
            }
        }
        
        monthLabel.text = "\(initialDate.monthSymbols) \(initialDate.year)"
        
        if isInitial {
            selectedDate = days.filter { $0.date.shortDateFormat == Date().shortDateFormat }.first
            isInitial = false
        }
        
        selectedDate = days.filter { $0.date.shortDateFormat == selectedDate?.date.shortDateFormat }.first
    }
}
