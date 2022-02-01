//
//  CalendarHelper.swift
//  HolidayCalendar
//
//  Created by Scott O'Hara on 1/31/22.
//

import Foundation


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
