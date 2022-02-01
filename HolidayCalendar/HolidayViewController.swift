//
//  ViewController.swift
//  HolidayCalendar
//
//  Created by Scott O'Hara on 1/28/22.
//

import Siesta
import SwiftUI
import UIKit

class HolidayViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource {
    // outlets
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var tableViewController: UITableView!
    
    // store date as string in array
    var holidays = [String]()
    var holidayDates = [String]()


    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        // call methods to setup Cal
        setCells()
        generateCalender()
       
        // add observer for api call
        HolidaysAPI.holidaysResource.addObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        HolidaysAPI.holidaysResource.loadIfNeeded()
    }
    
    // set cells view
    func setCells() {
        // padding is 2, and divid by 8 bc 7 days in week then add 1 takes up less of screen set to 7 take up more room.
        let width = (collectionView.frame.size.width - 2) / 8
        let height = (collectionView.frame.size.height - 2) / 8
        
        // set flow layout
        let flowLayout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        flowLayout.itemSize = CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! CalendarCell
        
        let day = days[indexPath.row]
        
        cell.configureCell(day: day, isSelected: day == selectedDate, style: style)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDay = dateFormatter.string(from: day.date)
        print(newDay)
        
        for day in holidayDates{
            if newDay == day{
                print(newDay)
                cell.dayOfMonth.textColor = .red
            }
        }
        
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
  
        let day = days[indexPath.row]
        selectedDate = day
                
        if day.isNextMonth {
            currentMonthIndex += 1
        } else if day.isPreviousMonth {
            currentMonthIndex -= 1
        }
        
        collectionView.reloadData()
    }
    
    // actions
    @IBAction func prevMonth(_ sender: Any) {
//        selectedDate = calendarHelper.minusMonth(date: selectedDate)
//        setMonthView()
        currentMonthIndex -= 1
        selectedDate = nil
    }
    
    @IBAction func nextMonth(_ sender: Any) {
//        selectedDate = calendarHelper.plusMonth(date: selectedDate)
//        setMonthView()
        currentMonthIndex += 1
        selectedDate = nil
    }
    
    // override auto rotate so screen stays in portrait
    override open var shouldAutorotate: Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(holidays.count)
        return holidays.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "holidayCell", for: indexPath) as! HolidayCell

        cell.holidayLabel.text = holidays[indexPath.row]
        cell.holidayLabel.textColor = .red
        return cell
    }
    
    private let calendar = Calendar(identifier: .gregorian)
    var didSelectDate: ((Day?) -> ())?
    private var currentMonth: Date!
    private var days: [Day] = []
    private var isInitial: Bool = true
    var style = CalenderStyle()
    
    private var selectedDate: Day? {
        didSet {
            didSelectDate?(selectedDate)
        }
    }

    private var currentMonthIndex: Int = 0 {
        didSet {
            generateCalender()
            collectionView.reloadData()
        }
    }
}

extension HolidayViewController: ResourceObserver {
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        let holidays = resource.jsonArray
            // return each element of jsonArray as Dict
            .compactMap { $0 as? [String: Any] }
            // traverse thru dict, return string value of holiday name
            .compactMap { $0["name"] as? String }
//        print(holidays)
        
        let holidaysDates = resource.jsonArray
            // return each element of jsonArray as Dict
            .compactMap { $0 as? [String: Any] }
            // traverse thru dict, return string value of holiday date
            .compactMap { $0["date"] as? String }
        
//        print(holidaysDates)
        // update holidays Arrrays w/ new data
        self.holidays = holidays
        holidayDates = holidaysDates
//        print(self.holidays)
//        print(self.holidayDates)
        
//        for day in holidayDates {
//            print(day)
//        }
        
//        for name in self.holidays {
//            print(name)
//        }
    
        collectionView.reloadData()
    }
}

extension HolidayViewController {
    private func generateCalender() {
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
