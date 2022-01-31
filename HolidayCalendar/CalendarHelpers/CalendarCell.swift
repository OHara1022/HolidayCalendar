//
//  CalendarCell.swift
//  HolidayCalendar
//
//  Created by Scott O'Hara on 1/28/22.
//

import Foundation
import UIKit

// class to handle cell functionality
class CalendarCell: UICollectionViewCell {
    @IBOutlet var dayOfMonth: UILabel!
    
    // get cal style and properties for each cell
    private var style: CalenderStyle!
    private var day: Day!
    let holidayViewController = HolidayViewController()
    
    func configureCell(day: Day, isSelected: Bool, style: CalenderStyle) {
        self.day = day // set day
        self.style = style // set style
        dayOfMonth.text = day.dayNumber // set day of month
        dayOfMonth.textColor = !self.day.isNextMonth && !self.day.isPreviousMonth ? style.activeDate.textColor : style.outOfRangeDate // set text color solid if within month else grey pre or next month dates
        setupLabelState(isSelected: isSelected)
    }
    
    // override isSelected, set up cell state for
    override var isSelected: Bool {
        didSet {
            setupLabelState(isSelected: isSelected)
        }
    }
    
    // set up label state
    private func setupLabelState(isSelected: Bool) {
        UIView.animate(withDuration: 0.2) { [self] in
            // if selected and active, textColor blue
            if isSelected {
                let style = self.style.activeDate
                self.dayOfMonth.layer.backgroundColor = style.backgroundColor.cgColor
                self.dayOfMonth.textColor = style.textColor
            } else {
                // else ifnext or prev month is in view display inActive in grey text
                guard !self.day.isNextMonth, !self.day.isPreviousMonth else { return }
                let style = self.style.inActiveDate
                self.dayOfMonth.textColor = style.textColor
                self.dayOfMonth.layer.backgroundColor = style.backgroundColor.cgColor
                
                // highlight todays day with blue text
                if self.day.date.shortDateFormat == Date().shortDateFormat {
                    self.dayOfMonth.textColor = self.style.activeDate.backgroundColor
                }
            }
        }
    }
}
