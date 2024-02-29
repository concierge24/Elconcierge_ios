//
//  brands.swift
//  Sneni
//
//  Created by Mac_Mini17 on 20/03/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation
import SwiftyJSON

enum brandsKey:String {
    case description = "description"
    case id = "id"
    case image = "image"
    case name = "name"
}


class Brands: NSObject, NSCoding {
    
    var id : Int!
    var descriptionBrands : String!
    var image : String!
    var name :String!
    
    init(fromJson json: JSON!){
        if json.isEmpty{
            return
        }
        id = json[brandsKey.id.rawValue].intValue
        descriptionBrands = json[brandsKey.description.rawValue].stringValue
        image = json[brandsKey.image.rawValue].stringValue
        name = json[brandsKey.name.rawValue].stringValue
        
    }
    
    
    
    @objc required init(coder aDecoder: NSCoder){
        id = aDecoder.decodeObject(forKey: brandsKey.id.rawValue) as? Int
        descriptionBrands = aDecoder.decodeObject(forKey: brandsKey.description.rawValue) as? String
        image = aDecoder.decodeObject(forKey: brandsKey.image.rawValue) as? String
        name = aDecoder.decodeObject(forKey: brandsKey.name.rawValue) as? String
        
    }
    
 
    func encode(with aCoder: NSCoder){
        if id != nil{
            aCoder.encode(id, forKey:brandsKey.id.rawValue)
        }
        if descriptionBrands != nil{
            aCoder.encode(descriptionBrands, forKey: brandsKey.description.rawValue)
        }
        
        if image != nil{
            
            aCoder.encode(image, forKey: brandsKey.image.rawValue)
        }
        
        if name != nil{
            aCoder.encode(name, forKey: brandsKey.name.rawValue)
        }
        
        
    }

    
}
