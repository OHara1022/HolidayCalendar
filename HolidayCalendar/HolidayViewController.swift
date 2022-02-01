//
//  ViewController.swift
//  HolidayCalendar
//
//  Created by Scott O'Hara on 1/28/22.
//

import Siesta
import SwiftUI
import UIKit

class HolidayViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    // outlets
    @IBOutlet var monthLabel: UILabel!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var holidayLabel: UILabel!
    
    // stored properties for calendar
    var holidays = [String]()
    var holidayDates = [String]()
    var newDay = String()
    let calendar = Calendar(identifier: .gregorian)
    var didSelectDate: ((Day?) -> ())?
    var currentMonth: Date!
    var days: [Day] = []
    var isInitial: Bool = true
    var style = CalenderStyle()
    var holidayName = String()
    var hasHolidays = false
    var holidayDict = [String: String]()

    // set optional Day obj to selected date
    var selectedDate: Day? {
        didSet {
            didSelectDate?(selectedDate)
        }
    }

    // get index for each month, populate calendar
    var currentMonthIndex: Int = 0 {
        didSet {
            generateCalender()
            collectionView.reloadData()
        }
    }

    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        // call methods to setup Cal
        setCells()
        generateCalender()
        
        // MARK: set text to date or holiday info on selection -TODO, get holidays to populate on selection!!!(last step)

        didSelectDate = { [weak self] selectedDate in
            guard let self = self else { return }
            // if it is not a holiday show date selected
            self.holidayLabel.text = selectedDate?.date.shortDateFormat
        }
            
        // add observer for api call
        HolidaysAPI.holidaysResource.addObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // load if resuorce is not up to date, this will notify before the UI loads so our data is available to show
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
        // get string from date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        newDay = dateFormatter.string(from: day.date)
//        print(newDay)
        
        // config cell
        cell.configureCell(day: day, isSelected: day == selectedDate, style: style)

        // loop thru dates retrieved from api
        for days in holidayDates {
            // check if day within current month has a holiday, set to red
            if newDay == days {
//                print(newDay)
                // set holidays to display as red on cal
                cell.dayOfMonth.textColor = .red
                hasHolidays = true
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // get all days in array
        return days.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // get index of selected day
        let day = days[indexPath.row]
        selectedDate = day
//        print(selectedDate!.date.description)
        
        // check the selected day has a holiday
        if selectedDate!.date == day.date, hasHolidays == true {
            print("hit")
            print(selectedDate!.date.description)
            print(day.date)
            // loop thru dict to match holiday with selected day
            for (key, value) in holidayDict {
                print("\(key) = \(value)")
                // format date obj as string to compare
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                newDay = dateFormatter.string(from: day.date)
                // if selected day equals value from dict
                if newDay == value {
                    print("WORKING")
                    // display holiday
                    holidayLabel.text = key
                }
            }
        }
        // reload collection
        collectionView.reloadData()
    }
    
    // actions
    @IBAction func prevMonth(_ sender: Any) {
        // remove month from index
        currentMonthIndex -= 1
        selectedDate = nil
    }
    
    @IBAction func nextMonth(_ sender: Any) {
        // add month to index
        currentMonthIndex += 1
        selectedDate = nil
    }
    
    // override auto rotate so screen stays in portrait
    override open var shouldAutorotate: Bool {
        return false
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
        // loop thru holiday names and dates, populate dict with key,value pair [name:holiday]
        for i in 0 ..< min(self.holidays.count, holidayDates.count) {
            holidayDict[self.holidays[i]] = holidayDates[i]
        }
        
//        print(holidayDict)
        // reload collectionView
        collectionView.reloadData()
    }
}
