//
//  DateExtensions.swift
//  AgentApp
//
//  Created by Sandeep Kumar on 01/05/19.
//  Copyright © 2019 Mac_Mini17. All rights reserved.
//

import Foundation

class SKDateFormatter: DateFormatter {
    override init() {
        super.init()
        locale = Locale(identifier: "en_US_POSIX")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

enum Formatters: String {
    
    case ZZ = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    case Z
    //    case UTC = "yyyy-MM-dd HH:mm:ss"
    //    case ddMMyyyy = "dd MMM, yyyy"
    //    case ddMM = "dd MMM"
    //    case yyyyMMdd = "yyyy-MM-dd"
    //    case mmmddyyyy = "MMM dd, yyyy"
    //    case mmdd = "MMM dd"
    //    case ddMMEEE = "dd MMM (EEE)"
    //    case ddMMEEEHHMM = "dd-MM-yyyy · hh:mm aa"
    
    //Common
//    case MMMYYYY = "MMM, yyyy"
//    case MMMM = "MMMM"
    case DD = "dd"
    case MMMyy = "MMM’yy"
    case HHMMA = "hh:mma"

    case EEEE = "EEEE"
    case yyyyMM = "yyyy-MM"
    case DDMMMYYATHHMMA = "dd MMM’yy 'at' hh:mma"
    case EEEddMMMM = "EEE, dd MMMM"

    ///Main
    case ZZZZZ
    case date = "yyyy-MM-dd"
    case time = "HH:mm:ss"
    case dateTime = "yyyy-MM-dd HH:mm:ss"
    case YYYYMMDDHHMMSSZZZZZ = "yyyy-MM-dd HH:mm:ss ZZZZZ"//"2019-09-12 09:00:00 +05:30"

}

//MARK:- ======== Extension String To Date ========
extension String {
    
    func toDate(format: Formatters) -> Date? {
        return toDate(strFormat: format.rawValue)
    }
    
    func toDate(strFormat: String) -> Date? {
        
        let formatter = SKDateFormatter()
        formatter.dateFormat =  strFormat
        
        if !strFormat.contains("Z") {
            formatter.timeZone = TimeZone.current
        }
        return formatter.date(from: self)
    }
}

//MARK:- ======== Extension Date To String ========
extension Date {
    
    var startOfMonth: Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }

    var endOfMonth: Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startOfMonth)!
    }
    
    func dayNumberOfWeek() -> Int {
        return /Calendar.current.dateComponents([.weekday], from: self).weekday - 1
    }
    
    func startDate() -> Date? {
        
        let date = toStringDate().toDate(format: .date)
        return date
    }
    
    func endDate() -> Date? {
        let date = toStringDate().toDate(format: .date)?.add(days: 1).add(seconds: -1)
        return date
    }
    
    func add(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
    
    func add(seconds: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .second, value: seconds, to: self)!
    }
    
    func toStringDateTime() -> String {
        return toString(format: .dateTime)
    }
    
    func toStringDate() -> String {
        return toString(format: .date)
    }
    
    func toStringTime() -> String {
        return toString(format: .time)
    }
    
    func toString(format: Formatters, timeZone: TimeZone? = nil) -> String {
        return toString(strFormat: format.rawValue, timeZone: timeZone)
    }
    
    func toString(strFormat: String, timeZone: TimeZone? = nil) -> String {
        
        let formatter = SKDateFormatter()
        formatter.dateFormat =  strFormat
        
        if !strFormat.contains("Z") {
            formatter.timeZone = TimeZone.current
        }
        
        if let timeZone = timeZone {
            formatter.timeZone = timeZone
        }
        return formatter.string(from: self)
    }
    
    var timeMilliSecondsSince1970: Double {
        return Double(Int64(self.timeIntervalSince1970 * 1000.0))
    }
    
    var timeZone: String {
        return toString(format: .ZZZZZ)
    }
}

//MARK:- ======== Currency ========
class Constants
{
    static var currency: String {
        return AgentCodeClass.shared.loggedCurrency?.currency_symbol ?? "₹"
    }
    static var currencyName: String {
        return AgentCodeClass.shared.loggedCurrency?.currency_name ?? "INR"
    }
}
extension Double {
    
    func decimal(min: Int, upto: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = min
        formatter.maximumFractionDigits = upto
        return /formatter.string(for: self)
    }
    
    var addCurrencyLocale: String {
        return Constants.currency + " " + decimal(min: 2, upto: 2)
    }
    
}


