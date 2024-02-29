//
//  GetArea.swift
//  Sneni
//
//  Created by Mac_Mini17 on 28/03/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation
enum GetAreaKeys : String {
    
    case name = "name"
    case areaid = "area_id"
    case id = "id"
    case locEN
    case locAR
    
}

class GetArea: NSObject, NSCoding {
    
    var area_Id : String?
    var nameLocation:[Locations]?
    
    var locEN : Locations?
    var locAR : Locations?
    
    var id:String?
    
    init(data : SwiftyJSONParameter) {
        
        self.area_Id = data?[GetAreaKeys.areaid.rawValue]?.stringValue
        self.id = data?[GetAreaKeys.id.rawValue]?.stringValue
        //        self.locEN = data?[GetAreaKeys.locEN.rawValue]
        //        self.locAR = data?[GetAreaKeys.locAR.rawValue]?.stringValue
        
        let languages = data?[GetAreaKeys.name.rawValue]?.arrayValue
        
        self.nameLocation = [Locations]()
        
        for language in languages ?? [] {
            
            let lang = Locations(attributes: language.dictionaryValue)
            if lang.languageid == GDataSingleton.sharedInstance.languageEnId {
                locEN = lang
                locEN?.id = area_Id
            } else if lang.languageid == GDataSingleton.sharedInstance.languageArId {
                locAR = lang
                locAR?.id = area_Id
            }
            self.nameLocation?.append(lang)
        }
        
    }
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(area_Id, forKey: GetAreaKeys.areaid.rawValue)
        aCoder.encode(nameLocation, forKey: GetAreaKeys.name.rawValue)
        aCoder.encode(id, forKey: GetAreaKeys.id.rawValue)
        aCoder.encode(locEN, forKey: GetAreaKeys.locEN.rawValue)
        aCoder.encode(locAR, forKey: GetAreaKeys.locAR.rawValue)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        id =  aDecoder.decodeObject(forKey:GetAreaKeys.id.rawValue) as? String
        area_Id = aDecoder.decodeObject(forKey:GetAreaKeys.areaid.rawValue) as? String
        nameLocation = aDecoder.decodeObject(forKey: GetAreaKeys.name.rawValue) as? [Locations]
        
        locEN = aDecoder.decodeObject(forKey: GetAreaKeys.locEN.rawValue) as? Locations
        locAR = aDecoder.decodeObject(forKey: GetAreaKeys.locAR.rawValue) as? Locations
        
    }
}
