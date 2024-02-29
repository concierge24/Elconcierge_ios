//
//  AvailabilityModel.swift
//  Sneni
//
//  Created by Sandeep Kumar on 13/05/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation

import SwiftyJSON
import RMMapper

enum DayofWeekType: Int {
    case sun = 0
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat
    
    var title: String{
        switch self {
        case .sun : return "Sun"
        case .mon : return "Mon"
        case .tue : return "Tue"
        case .wed : return "Wed"
        case .thu : return "Thu"
        case .fri : return "Fri"
        case .sat : return "Sat"
        }
    }
}

class AvailabilityModel: NSObject, RMMapping, NSCoding {
    
    var name: String?
    var cbl_user_availablities: [AvailabilityDayModel] = []
    var cbl_user_times: [AvailabilityTimeModel] = []
    var cbl_user_avail_dates: [AvailabilityDateModel] = []
    
    init(sender : SwiftyJSONParameter){
        super.init()
        
        guard let rawData = sender else { return }
        let json = JSON(rawData)
        
        if let dict = json[APIConstants.DataKey].array?.first?.dictionaryValue {
            self.setData(attributes: dict)
        }
    }
    
    override init(){
        super.init()
    }
    
    func setData(attributes : Dictionary<String, JSON>?){
        
        self.name = attributes?["name"]?.stringValue

        
        if let array =  attributes?["cbl_user_availablities"]?.array {
            
            for  dict in array {

            let obj = AvailabilityDayModel(attributes: dict.dictionaryValue)
                self.cbl_user_availablities.append(obj)
            }
        }
        
        if let array =  attributes?["cbl_user_times"]?.array {
            for  dict in array {

                let obj = AvailabilityTimeModel(attributes: dict.dictionaryValue)
                self.cbl_user_times.append(obj)
            }
        }
        
        if let array =  attributes?["cbl_user_avail_dates"]?.array {
            for  dict in array {

                let obj = AvailabilityDateModel(attributes: dict.dictionaryValue)
                self.cbl_user_avail_dates.append(obj)
            }
        }
        
    }
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.name, forKey: "name")
        aCoder.encode(self.cbl_user_availablities, forKey: "cbl_user_availablities")
        aCoder.encode(self.cbl_user_times, forKey: "cbl_user_times")
        aCoder.encode(self.cbl_user_avail_dates, forKey: "cbl_user_avail_dates")

    }
    
    required init(coder aDecoder: NSCoder) {
        
        self.name  = aDecoder.decodeObject(forKey: "name") as? String
        self.cbl_user_availablities  = (aDecoder.decodeObject(forKey: "cbl_user_availablities") as? [AvailabilityDayModel]) ?? []
        self.cbl_user_times  = (aDecoder.decodeObject(forKey: "cbl_user_times") as? [AvailabilityTimeModel]) ?? []
        self.cbl_user_avail_dates  = (aDecoder.decodeObject(forKey: "cbl_user_avail_dates") as? [AvailabilityDateModel]) ?? []
    }
    
    func getWeekD() -> [DayofWeekType] {
        
        var arDays = [DayofWeekType]()
        for objDate in cbl_user_availablities where objDate.status == 1 {
            
            if let type = DayofWeekType(rawValue: /objDate.day_id) {
                arDays.append(type)
            }
        }
        return arDays
    }
    
    func getAllDates() -> [Date] {
        
        var arrayDates: [Date] = []
        var arrayStrDates: [String] = []
        let arr = cbl_user_availablities.filter({ $0.status == 1 })
        
        for objDate in arr
        {
            let day = /objDate.day_id
            
            var startWeek = Date().add(seconds: -1)
            while true {
                if startWeek.dayNumberOfWeek() == day {
                    break
                }
                startWeek = startWeek.add(days: 1)
            }
            for i in 0..<4 {
                let objDate = startWeek.add(days: i*7)
                if objDate.compare(Date()) != .orderedAscending {
                    arrayDates.append(objDate)
                    arrayStrDates.append(objDate.toString(format: Formatters.date))
                }

            }
        }
        
        for objDate in cbl_user_avail_dates
        {
            let stsD = /objDate.from_date
            if !arrayStrDates.contains(stsD) {
                guard let date = "\(/objDate.from_date) 00:00:00 +0000".toDate(format: .YYYYMMDDHHMMSSZZZZZ) else { continue }
                if date.compare(Date()) != .orderedAscending {
                    arrayDates.append(date)
                }
            }
        }
        return arrayDates.sorted()
    }

}


class AvailabilityDayModel: NSObject, RMMapping, NSCoding {
    
    var id : Int?
    var day_id : Int?
    var status : Int?
    
    override init(){
        super.init()
    }
    
    init (attributes : Dictionary<String, JSON>?){
        
        self.id = attributes?["id"]?.intValue
        self.day_id = attributes?["day_id"]?.intValue
        self.status = attributes?["status"]?.intValue
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.day_id, forKey: "day_id")
        aCoder.encode(self.status, forKey: "status")
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        self.id  = aDecoder.decodeObject(forKey: "id") as? Int
        self.day_id  = aDecoder.decodeObject(forKey: "day_id") as? Int
        self.status  = aDecoder.decodeObject(forKey: "status") as? Int
        
    }
}

class AvailabilityTimeModel: NSObject, RMMapping, NSCoding {
    
    var id : Int?//27
    var start_time : String?//"09:00:00"
    var end_time : String?//"16:00:00"
    var offset : String? = "+05:30"
    var date_id : Int?
    
    
    override init(){
        super.init()
    }
    
    init (attributes : Dictionary<String, JSON>?){
        
        self.id = attributes?["id"]?.intValue
        self.start_time = attributes?["start_time"]?.stringValue
        self.end_time = attributes?["end_time"]?.stringValue
        self.offset = attributes?["offset"]?.stringValue
        self.date_id = attributes?["date_id"]?.intValue

    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.start_time, forKey: "start_time")
        aCoder.encode(self.end_time, forKey: "end_time")
        aCoder.encode(self.offset, forKey: "offset")
        aCoder.encode(self.date_id, forKey: "date_id")
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        self.id  = aDecoder.decodeObject(forKey: "id") as? Int
        self.start_time  = aDecoder.decodeObject(forKey: "start_time") as? String
        self.end_time  = aDecoder.decodeObject(forKey: "end_time") as? String
        self.offset  = aDecoder.decodeObject(forKey: "offset") as? String
        self.date_id  = aDecoder.decodeObject(forKey: "date_id") as? Int

    }
}

class AvailabilityDateModel: NSObject, RMMapping, NSCoding {
    
    var id : Int?//8
    var status : Int?//1
    var from_date : String?//"2019-09-12"
    var to_date : String?//"2019-09-12"
    
    override init(){
        super.init()
    }
    
    init (attributes : Dictionary<String, JSON>?){
        
        self.id = attributes?["id"]?.intValue
        self.status = attributes?["status"]?.intValue
        self.from_date = attributes?["from_date"]?.stringValue
        self.to_date = attributes?["to_date"]?.stringValue

    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.id, forKey: "id")
        aCoder.encode(self.status, forKey: "status")
        aCoder.encode(self.from_date, forKey: "from_date")
        aCoder.encode(self.to_date, forKey: "to_date")
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        self.id  = aDecoder.decodeObject(forKey: "id") as? Int
        self.status  = aDecoder.decodeObject(forKey: "status") as? Int
        self.from_date  = aDecoder.decodeObject(forKey: "from_date") as? String
        self.to_date  = aDecoder.decodeObject(forKey: "to_date") as? String
        
    }
    
    
    
}
