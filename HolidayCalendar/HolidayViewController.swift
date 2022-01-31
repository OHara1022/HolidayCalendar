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
    
    // get todays date
    var selectedDate = Date()
    // store date as string in array
    var totalSquares = [String]()
    var holidays = [String]()
    var holidayDates = [String]()
    let calendarHelper = CalendarHelper()

    // MARK: viewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        // call methods to setup Cal
        setCells()
        setMonthView()
       
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
    
    // set monthView
    func setMonthView() {
        // remove all elements from array
        totalSquares.removeAll()
        
        // define days in month, first day of month, and start of week
        let daysInMonth = calendarHelper.daysInMonth(date: selectedDate)
        let firstDayOfMonth = calendarHelper.firstOfMonth(date: selectedDate)
        let startingSpaces = calendarHelper.weekDay(date: firstDayOfMonth)
        var count: Int = 1
        
        // 42 is the number of sqaures we will loop thru, we need 6 rows if month starts  on sat, 6x7=42
        while count <= 42 {
            // check number of spaces, add 6 blank spaces
            if count <= startingSpaces || count - startingSpaces > daysInMonth {
                totalSquares.append("")
            } else {
                totalSquares.append(String(count - startingSpaces))
            }
            count += 1
        }
        
        // set month label with proper month & year
        monthLabel.text = calendarHelper.monthString(date: selectedDate) + " " + calendarHelper.yearString(date: selectedDate)
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dateCell", for: indexPath) as! CalendarCell
        let date = totalSquares[indexPath.item]
        cell.dayOfMonth.text = date
       
        if holidayDates.contains(date) {
            print(date)
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return totalSquares.count
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // display holiday in tableView
        // convert string to date
//        let date = totalSquares[indexPath.item]
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "dd-MM-yyyy"
//        print(date)
     
        // MARK: figure out last step!

        /* crate full date from string??? still working on this logic
         i need to get the calendar days as a date.... the helper class methods take a date or string, but the total squares array doesnt contain, year and month. research Date obj and restructure to get proper info to compare calendar days vs holidays and color code holidays*/
        print(holidays.description + " " + "HIT")
    
        // reload data
        collectionView.reloadData()
        tableViewController.reloadData()
    }
    
    // actions
    @IBAction func prevMonth(_ sender: Any) {
        selectedDate = calendarHelper.minusMonth(date: selectedDate)
        setMonthView()
        tableViewController.reloadData()
    }
    
    @IBAction func nextMonth(_ sender: Any) {
        selectedDate = calendarHelper.plusMonth(date: selectedDate)
        setMonthView()
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
        
        for day in holidaysDates {
            print(day)
        }
        
        for name in holidays {
            print(name)
        }
    
        collectionView.reloadData()
    }
}
