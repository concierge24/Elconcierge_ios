//
//  TimeZone+Extension.swift
//  Sneni
//
//  Created by Mac_Mini17 on 27/03/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation

extension TimeZone {
    
    func offsetFromUTC() -> String{
        let localTimeZoneFormatter = DateFormatter()
        localTimeZoneFormatter.timeZone = self
        localTimeZoneFormatter.dateFormat = "Z"
        return localTimeZoneFormatter.string(from: Date())
    }
    
    func offsetInHours() -> String{
        
        let hours = secondsFromGMT()/3600
        let minutes = abs(secondsFromGMT()/60) % 60
        let tz_hr = String(format: "%+.2d:%.2d", hours, minutes) // "+hh:mm"
        return tz_hr
    }
}
