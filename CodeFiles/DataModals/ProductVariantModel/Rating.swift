//
//  rating.swift
//  Sneni
//
//  Created by Mac_Mini17 on 25/03/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation

enum RatingKey:String {
    
    case name = "firstname"
    case user_image = "user_image"
    case reviews = "reviews"
    case created_on = "created_on"
    case value = "value"
    case id = "id"
    case title = "title"
    
    
}

class RatingModel:  NSObject, NSCoding {
    
    var name : String!
    var userImage : String!
    var id : Int!
    var created_on : String!
    var reviews : String!
    var value : Int!
    var title : String!
    
    init(fromDictionary dictionary: [String:Any]){
        
        id = dictionary[RatingKey.id.rawValue] as? Int
        name = dictionary[RatingKey.name.rawValue] as? String
        reviews = dictionary[RatingKey.reviews.rawValue] as? String
        value = dictionary[RatingKey.value.rawValue] as? Int
        userImage = dictionary[RatingKey.user_image.rawValue] as? String
        created_on = dictionary[RatingKey.created_on.rawValue] as? String
          title = dictionary[RatingKey.title.rawValue] as? String
        
        
    }
    
    @objc required init(coder aDecoder: NSCoder){
        
        id = aDecoder.decodeObject(forKey: RatingKey.id.rawValue) as? Int
        name = aDecoder.decodeObject(forKey: RatingKey.name.rawValue) as? String
        userImage = aDecoder.decodeObject(forKey: RatingKey.user_image.rawValue) as? String
        reviews = aDecoder.decodeObject(forKey: RatingKey.reviews.rawValue) as? String
        value = aDecoder.decodeObject(forKey: RatingKey.value.rawValue) as? Int
        created_on = aDecoder.decodeObject(forKey: RatingKey.created_on.rawValue) as? String
         title = aDecoder.decodeObject(forKey: RatingKey.title.rawValue) as? String
    }
    
    @objc func encode(with aCoder: NSCoder)
    {
        if id != nil{
            aCoder.encode(id, forKey: RatingKey.id.rawValue)
        }
        if name != nil{
            aCoder.encode(name, forKey: RatingKey.name.rawValue)
        }
        if userImage != nil{
            aCoder.encode(userImage, forKey: RatingKey.user_image.rawValue)
        }
        
        if reviews != nil{
            aCoder.encode(reviews, forKey: RatingKey.reviews.rawValue)
        }
        
        if value != nil{
            aCoder.encode(value, forKey: RatingKey.value.rawValue)
        }
        if created_on != nil{
            aCoder.encode(created_on, forKey: RatingKey.created_on.rawValue)
        }
        
        if title != nil{
            aCoder.encode(title, forKey: RatingKey.title.rawValue)
        }
        
        
    }
    
    
    
}
