//
//  CblUser.swift
//  Sneni
//
//  Created by Mac_Mini17 on 12/04/19.
//  Copyright © 2019 Taran. All rights reserved.
//



enum CblUserKeys : String {
    case agent_created_id = "agent_created_id"
    case occupation = "occupation"
    case experience = "experience"
    case phone_number = "phone_number"
    case city = "city"
    case email = "email"
    case image = "image"
    case name = "name"
    case id = "id"
    case lat = "latitude"
    case long = "longitude"
    case avg_rating
    case total_review
}
import Foundation


import SwiftyJSON
import RMMapper

class CblUser : NSObject , RMMapping, NSCoding {
    
    var city : String?
    var email : String?
    var experience : String?
    var id : String?
    var image : String?
    var occupation : String?
    var phoneNumber : String?
    var name : String?
    
    var lat : Double?
    var long : Double?
    
    var agent_created_id : String?
    var avg_rating: Double = 0
    var total_review: Int = 0
    var reviewsStr: String {
        if total_review == 1 {
            return "[ 1 \("Review".localized()) ]"
        }
        return "[ \(total_review) \("Reviews".localized()) ]"
    }

    init (attributes : Dictionary<String, JSON>?){
        self.agent_created_id = attributes?["agent_created_id"]?.stringValue
        self.phoneNumber = attributes?[CblUserKeys.phone_number.rawValue]?.stringValue
        self.experience = attributes?[CblUserKeys.experience.rawValue]?.stringValue
        self.occupation = attributes?[CblUserKeys.occupation.rawValue]?.stringValue
        self.city = attributes?[CblUserKeys.city.rawValue]?.stringValue
        self.image = attributes?[CblUserKeys.image.rawValue]?.stringValue
        self.name = attributes?[CblUserKeys.name.rawValue]?.stringValue
        self.id = attributes?[CblUserKeys.id.rawValue]?.stringValue
        
        self.lat = attributes?[CblUserKeys.lat.rawValue]?.double
        self.long = attributes?[CblUserKeys.long.rawValue]?.double
        self.avg_rating = attributes?[CblUserKeys.avg_rating.rawValue]?.double ?? 0
        self.total_review = attributes?[CblUserKeys.total_review.rawValue]?.intValue ?? 0

    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.agent_created_id, forKey: CblUserKeys.agent_created_id.rawValue)
        aCoder.encode(self.phoneNumber, forKey: CblUserKeys.phone_number.rawValue)
        aCoder.encode(self.experience, forKey: CblUserKeys.experience.rawValue)
        aCoder.encode(self.occupation, forKey: CblUserKeys.occupation.rawValue)
        aCoder.encode(self.city, forKey: CblUserKeys.city.rawValue)
        aCoder.encode(self.image, forKey: CblUserKeys.image.rawValue)
        aCoder.encode(self.name, forKey: CblUserKeys.name.rawValue)
        aCoder.encode(self.id, forKey: CblUserKeys.id.rawValue)
        aCoder.encode(self.lat, forKey: CblUserKeys.lat.rawValue)
        aCoder.encode(self.long, forKey: CblUserKeys.long.rawValue)
        aCoder.encode(self.avg_rating, forKey: CblUserKeys.avg_rating.rawValue)
        aCoder.encode(self.total_review, forKey: CblUserKeys.total_review.rawValue)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        self.agent_created_id  = aDecoder.decodeObject(forKey: CblUserKeys.agent_created_id.rawValue) as? String
        self.phoneNumber  = aDecoder.decodeObject(forKey: CblUserKeys.phone_number.rawValue) as? String
        self.experience  = aDecoder.decodeObject(forKey: CblUserKeys.experience.rawValue) as? String
        self.occupation  = aDecoder.decodeObject(forKey: CblUserKeys.occupation.rawValue) as? String
        self.city  = aDecoder.decodeObject(forKey: CblUserKeys.city.rawValue) as? String
        self.image  = aDecoder.decodeObject(forKey: CblUserKeys.image.rawValue) as? String
        self.name  = aDecoder.decodeObject(forKey: CblUserKeys.name.rawValue) as? String
        self.id  = aDecoder.decodeObject(forKey: CblUserKeys.id.rawValue) as? String
        self.lat  = aDecoder.decodeObject(forKey: CblUserKeys.lat.rawValue) as? Double
        self.long  = aDecoder.decodeObject(forKey: CblUserKeys.long.rawValue) as? Double
        self.avg_rating  = aDecoder.decodeObject(forKey: CblUserKeys.avg_rating.rawValue) as? Double ?? 0
        self.total_review  = aDecoder.decodeObject(forKey: CblUserKeys.total_review.rawValue) as? Int ?? 0

    }
    
    override init(){
        super.init()
    }
}



