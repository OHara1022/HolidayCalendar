//
//  HolidaysAPI.swift
//  HolidayCalendar
//
//  Created by Scott O'Hara on 1/28/22.
//

import Foundation
import Siesta

struct HolidaysAPI {
  
    private static let service = Service(baseURL: "https://date.nager.at/api/v2")
    
    static let holidaysResource: Resource = {
        HolidaysAPI.service
            .resource("/publicholidays")
            .child("2022")
            .child("US")
    }()
    
}
