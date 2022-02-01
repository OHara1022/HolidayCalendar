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
//    @IBOutlet var tableViewController: UITableView!
    @IBOutlet var holidayLabel: UILabel!
    
    // store date as string in array
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
            self.holidayLabel.text = selectedDate?.date.shortDateFormat
        }

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
        // get string from date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        newDay = dateFormatter.string(from: day.date)
//        print(newDay)
        
        // config cell
        cell.configureCell(day: day, isSelected: day == selectedDate, style: style)

        // loop thru dates retrieved from api
        for day in holidayDates {
            // check if day within current month has a holiday, set to red
            if newDay == day {
//                print(newDay)
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
        currentMonthIndex -= 1
        selectedDate = nil
    }
    
    @IBAction func nextMonth(_ sender: Any) {
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
        
//        for day in holidayDates {
//            print(day)
//        }
        
//        for name in self.holidays {
//            print(name)
//            holidayName = name
//        }
    
        collectionView.reloadData()
    }
}
