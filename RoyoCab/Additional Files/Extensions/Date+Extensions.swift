//
//  Date+Extentions.swift
//  Auttle
//
//  Created by CodeBrew on 9/18/17.
//  Copyright © 2017 CodeBrew. All rights reserved.
//

import Foundation


//MARK:- DATE Extention

extension String{
    
    func toLocalDate(format:String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
     
    
        formatter.timeZone = TimeZone.current
         formatter.locale = Locale.init(identifier: /UserDefaultsManager.localeIdentifierCustom)
        
        return formatter.date(from: self)
    }
    
}
extension Date {
    
    
    func toLocalTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.timeZone = NSTimeZone.local
        formatter.locale = Locale.current

         return formatter.string(from: self)
    }
    func toLocalDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE,dd MMM"
        formatter.timeZone = NSTimeZone.local
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
    
    func toLocalDateInString(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.timeZone = NSTimeZone.local
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
    
    func toLocalDateAcTOLocale() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE,dd MMM"
        formatter.timeZone = NSTimeZone.local
        formatter.locale = Locale.init(identifier: /UserDefaultsManager.localeIdentifierCustom)
        return formatter.string(from: self)
    }
    func toLocalTimeAcTOLocale() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        formatter.timeZone = NSTimeZone.local
        formatter.locale = Locale.init(identifier: /UserDefaultsManager.localeIdentifierCustom)
        
        return formatter.string(from: self)
    }
    
    func toFormattedDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = TimeZone(identifier: "UTC")
        return formatter.string(from: self)
    }
    
    func toString(format:String)->String{
        
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeZone = NSTimeZone.local
        formatter.dateFormat = format
        return formatter.string(from: self)
    }

    func isGreaterThanDate(dateToCompare: Date) -> Bool {
        //Declare Variables
        var isGreater = false
      
        //Compare Values
        if self.compare(dateToCompare) == .orderedDescending {
            isGreater = true
        }
      
        //Return Result
        return isGreater
    }
  
    func isLessThanDate(dateToCompare: Date) -> Bool {
        //Declare Variables
        var isLess = false
      
        //Compare Values
        if self.compare(dateToCompare as Date) == .orderedAscending {
            isLess = true
        }
      
        //Return Result
        return isLess
    }
  
    func equalToDate(dateToCompare: Date) -> Bool {
        //Declare Variables
        var isEqualTo = false
      
        //Compare Values
        if self.compare(dateToCompare) == .orderedSame {
            isEqualTo = true
        }
        //Return Result
        return isEqualTo
    }
    
    
    
    
    
  
//    func isdateEqual(toDate:Date)->Bool{
//
////      return self.year == toDate.year && self.day == toDate.day && self.month == toDate.month ? true : false
//    }
  
    func subtractDays(daysToAdd: Int) -> Date {
      
        let secondsInDays: TimeInterval = -(Double(daysToAdd) * 60 * 60 * 24)
        let dateWithDaysAdded: Date = self.addingTimeInterval(secondsInDays) as Date
      
        //Return Result
        return dateWithDaysAdded
    }
  
    func addDays(daysToAdd: Int) -> Date {
      
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: Date = self.addingTimeInterval(secondsInDays) as Date
      
        //Return Result
        return dateWithDaysAdded
    }
  
    func addHours(hoursToAdd: Int) -> Date {
      
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: Date = self.addingTimeInterval(secondsInHours) as Date
      
        //Return Result
        return dateWithHoursAdded
    }
    
    func addMinutes(minutesToAdd: Int) -> Date {
      
        let secondsInHours: TimeInterval = Double(minutesToAdd)  * 60
        let dateWithHoursAdded: Date = self.addingTimeInterval(secondsInHours) as Date
      
        //Return Result
        return dateWithHoursAdded
    }
  
    //date to string
    func dateToString(format:String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format //Your New Date format as per requirement change it own
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale(identifier: "en_US")
        let newDate = dateFormatter.string(from: self)
      
        return newDate
    }
  
    func dateToStringWithShortStyle() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.medium
        dateFormatter.timeStyle = DateFormatter.Style.short
        let newDate = dateFormatter.string(from: self)
        return newDate
    }
  
    func addTime(time: Date) -> Date? {
      
        let calendar = NSCalendar.current
      
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: self)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
      
        var mergedComponments = DateComponents()
        mergedComponments.year = dateComponents.year!
        mergedComponments.month = dateComponents.month!
        mergedComponments.day = dateComponents.day!
        mergedComponments.hour = timeComponents.hour!
        mergedComponments.minute = timeComponents.minute!
        mergedComponments.second = timeComponents.second!
      
        return calendar.date(from: mergedComponments)
    }
  
    var millisecondsSince1970:Double {
        return Double((self.timeIntervalSince1970 * 1000.0).rounded())
    }
  
    init(milliseconds:Double) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
  
  
  public func timeAgoSince() -> String {
    
    let calendar = Calendar.current
    let now = Date()
    let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
    let components = (calendar as NSCalendar).components(unitFlags, from: self, to: now, options: [])
    
    if let year = components.year, year >= 2 {
      return "\(year) years ago"
    }
    
    if let year = components.year, year >= 1 {
      return "Last year"
    }
    
    if let month = components.month, month >= 2 {
      return "\(month) months ago"
    }
    
    if let month = components.month, month >= 1 {
      return "Last month"
    }
    
    if let week = components.weekOfYear, week >= 2 {
      return "\(week) weeks ago"
    }
    
    if let week = components.weekOfYear, week >= 1 {
      return "Last week"
    }
    
    if let day = components.day, day >= 2 {
      return "\(day) days ago"
    }
    
    if let day = components.day, day >= 1 {
      return "Yesterday"
    }
    
    if let hour = components.hour, hour >= 2 {
      return "\(hour) hours ago"
    }
    
    if let hour = components.hour, hour >= 1 {
      return "An hour ago"
    }
    
    if let minute = components.minute, minute >= 2 {
      return "\(minute) min ago"
    }
    
    if let minute = components.minute, minute >= 1 {
      return "a min ago"
    }
    
    if let second = components.second, second >= 3 {
      return "\(second) sec ago"
    }
    return "Just now"
  }
  
    public func timePending(endTime : Date) -> String {
      
        let calendar = Calendar.current
        let now = endTime
        let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
        let components = (calendar as NSCalendar).components(unitFlags, from: self, to: now, options: [])
      
        if let year = components.year, year >= 2 {
            return "\(year) years"
        }
      
        if let year = components.year, year >= 1 {
            return "year"
        }
      
        if let month = components.month, month >= 2 {
            return "\(month) months"
        }
      
        if let month = components.month, month >= 1 {
            return "\(month) month"
        }
      
        if let week = components.weekOfYear, week >= 2 {
            return "\(week) weeks"
        }
      
        if let week = components.weekOfYear, week >= 1 {
            return "\(week) week"
        }
      
        if let day = components.day, day >= 2 {
            return "\(day) days ago"
        }
      
        if let day = components.day, day >= 1 {
            return "\(day) day"
        }
      
        if let hour = components.hour, hour >= 2 {
            return "\(hour) hours"
        }
      
        if let hour = components.hour, hour >= 1 {
            return "\(hour) hours"
        }
      
        if let minute = components.minute, minute >= 2 {
            return "\(minute) minutes"
        }
      
        if let minute = components.minute, minute >= 1 {
            return "\(minute) minute"
        }
      
        if let second = components.second, second >= 3 {
            return "\(second) seconds"
        }
        return "\(second) second"
    }
  
}

extension Double {
    func toDate() -> Date {
        return Date(timeIntervalSince1970: TimeInterval(self / 1000))
    }
}

extension Formatter {
    static let monthMedium: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL"
        return formatter
    }()
    static let hour12: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h"
        return formatter
    }()
    static let minute0x: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "mm"
        return formatter
    }()
    static let amPM: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "a"
        return formatter
    }()
}
extension Date {
    var monthMedium: String  { return Formatter.monthMedium.string(from: self) }
    var hour12:  String      { return Formatter.hour12.string(from: self) }
    var minute0x: String     { return Formatter.minute0x.string(from: self) }
    var amPM: String         { return Formatter.amPM.string(from: self) }
}
