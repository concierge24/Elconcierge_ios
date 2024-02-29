//
//  GetCity.swift
//  Sneni
//
//  Created by Mac_Mini17 on 01/04/19.
//  Copyright © 2019 Taran. All rights reserved.
//

enum GetCityKeys : String {
    
    case name = "names"
    case id = "id"
}

class GetCity: NSObject, NSCoding {
    
    var locations: [Locations] = []
    var id:String?
    
    init(data : SwiftyJSONParameter) {
        
        self.id = data?[GetCityKeys.id.rawValue]?.stringValue
        let languages = data?[GetCityKeys.name.rawValue]?.arrayValue
        
        self.locations = [Locations]()
        
        for language in languages ?? [] {
            let loc = Locations(data: language.dictionaryValue)
            self.locations.append(loc)
        }
    }
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(locations, forKey: GetCityKeys.name.rawValue)
        aCoder.encode(id, forKey: GetCityKeys.id.rawValue)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        id =  aDecoder.decodeObject(forKey:GetCityKeys.id.rawValue) as? String
        locations = (aDecoder.decodeObject(forKey: GetCityKeys.name.rawValue) as? [Locations]) ?? []
        
    }
    
    func getArrLocation() -> [Locations] {
        let languageId = GDataSingleton.sharedInstance.languageId
        return self.locations.filter({$0.languageid == languageId})
    }
}

