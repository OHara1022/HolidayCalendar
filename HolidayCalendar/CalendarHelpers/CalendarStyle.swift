//
//  CalendarStyle.swift
//  HolidayCalendar
//
//  Created by Scott O'Hara on 1/31/22.
//

import Foundation
import UIKit

struct CalenderStyle {
    var outOfRangeDate: UIColor = .systemGray
    var activeDate = ActiveDate()
    var inActiveDate = InActiveDate()

    struct ActiveDate {
        var textColor: UIColor = .systemBackground
        var backgroundColor: UIColor = .systemBlue
    }

    struct InActiveDate {
        var textColor: UIColor = .label
        var backgroundColor: UIColor = .systemBackground
    }
}
