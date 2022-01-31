//
//  Day.swift
//  HolidayCalendar
//
//  Created by Scott O'Hara on 1/31/22.
//

import Foundation

//create Day as equatable for date and month operations
struct Day: Equatable {
    let date: Date
    let dayNumber: String
    var isNextMonth: Bool = false
    var isPreviousMonth: Bool = false
}


