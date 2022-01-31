//
//  HolidaysAPI.swift
//  HolidayCalendar
//
//  Created by Scott O'Hara on 1/28/22.
//

import Foundation
/* siesta framework to take the heavy lifting when calling from API. I did not import the UI option and I built the UI myself using collectionView (https://github.com/bustoutsolutions/siesta) */
import Siesta

struct HolidaysAPI {
    // get base url for api call
    private static let service = Service(baseURL: "https://date.nager.at/api/v2")

    // append API end points to get this years holidays
    static let holidaysResource: Resource = {
        HolidaysAPI.service
            .resource("/publicholidays")
            .child("2022")
            .child("US")
    }()

    /* full url of data after appended https://date.nager.at/api/v2/publicholidays/2022/US this API and the example API limit Holidays to one yr. You can pay for more parmeters, methods are dynamic and will support if upgrade API */
}
