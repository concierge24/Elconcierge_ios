//
//  Locations.swift
//  Clikat
//
//  Created by cblmacmini on 5/12/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import SwiftyJSON

enum LocationType {
    case Country
    case City
    case Zone
    case Area
}

enum LocationKeys : String {
    
    case arabicList = "arabicList"
    case englishList = "englishList"
    case englistList = "englistList"
    case address = "address"
    case name = "name"
    case names = "names"
    case id = "id"
    case languageid = "language_id"
    case cityData = "cityData"
    case areaData = "areaData"
    
}

class Locations: NSObject, NSCoding {
    
    var id : String?
    var name : String?
    var languageid:String?
    
    init(attributes : SwiftyJSONParameter){
        
        self.name = attributes?[NameLocationKeys.name.rawValue]?.stringValue
        self.languageid = attributes?[NameLocationKeys.languageiId.rawValue]?.stringValue
        self.id = attributes?[NameLocationKeys.id.rawValue]?.stringValue
    }
    
    init(data : SwiftyJSONParameter) {
        
        self.id = data?["id"]?.stringValue
        self.name = data?["name"]?.stringValue
        self.languageid = data?[LocationKeys.languageid.rawValue]?.stringValue
        
    }
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: "id")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(self.languageid, forKey: LocationKeys.languageid.rawValue)
       
    }
 
    required init(coder aDecoder: NSCoder) {
        id = aDecoder.decodeObject(forKey: "id") as? String
        name = aDecoder.decodeObject(forKey: "name") as? String
        self.languageid = aDecoder.decodeObject(forKey:LocationKeys.languageid.rawValue) as? String
       // area_Id = aDecoder.decodeObject(forKey: "area_id") as? String
      //  nameLocation = aDecoder.decodeObject(forKey: LocationKeys.name.rawValue) as? [NameLocation]
        
    }

}

class LocationResults {
    
    var arrLocationEn : [Locations]?
    var arrLocationAr : [Locations]?
    var myAddress : [Address]?
    
    init(data : SwiftyJSONParameter) {
        var englishList = [JSON]()
        if let list = data?[LocationKeys.englishList.rawValue]?.arrayValue {
            englishList = list
        }else if let list  = data?[LocationKeys.englistList.rawValue]?.arrayValue {
            
            englishList = list
        }
        myAddress = []
        for address in data?[LocationKeys.address.rawValue]?.arrayValue ?? [] {
            myAddress?.append(Address(attributes: address.dictionaryValue))
        }
        guard let arabicList = data?[LocationKeys.arabicList.rawValue]?.arrayValue else { return }
        var tempArrEn : [Locations] = []
        var tempArrAr : [Locations] = []
        for (arabic,english) in zip(arabicList,englishList) {
            let locationen = Locations(data: english.dictionaryValue)
            let locationar = Locations(data: arabic.dictionaryValue)
            tempArrAr.append(locationar)
            tempArrEn.append(locationen)
        }
        arrLocationAr = tempArrAr
        arrLocationEn = tempArrEn
    }
    
    func getArrLocation() -> [Locations]? {
        return Localize.currentLanguage() == Languages.Arabic ? arrLocationAr : arrLocationEn
    }
    
}

class ApplicationLocation : NSObject, NSCoding {
    
    var countryAR : Locations?
    var countryEN : Locations? {
        didSet {
            cityEN = nil
            cityAR = nil
            areaAR = nil
            areaEN = nil
        }
    }
    
    var cityEN : Locations?
    var cityAR : Locations? {
        didSet {
            areaAR = nil
            areaEN = nil
        }
    }
    var areaAR : Locations?
    var areaEN : Locations?
    
    var country : Locations? {
        return Localize.currentLanguage() == Languages.Arabic ? countryAR : countryEN
    }
    
    var city : Locations? {
        return Localize.currentLanguage() == Languages.Arabic ? cityAR : cityEN
    }
    
    var area : Locations? {
        return Localize.currentLanguage() == Languages.Arabic ? areaAR : areaEN
    }
    
    init(countryEn : Locations?,cityEn : Locations?,areaEn : Locations?,countryAr : Locations?,cityAr : Locations?,areaAr : Locations?){
        super.init()
        self.countryEN = countryEn
        self.cityEN = cityEn
        self.areaEN = areaEn
        
        self.countryAR = countryAr
        self.cityAR = cityAr
        self.areaAR = areaAr
    }
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(countryEN, forKey: "countryEN")
        aCoder.encode(cityEN, forKey: "cityEN")
        aCoder.encode(areaEN, forKey: "areaEN")
        aCoder.encode(countryAR, forKey: "countryAR")
        aCoder.encode(cityAR, forKey: "cityAR")
        aCoder.encode(areaAR, forKey: "areaAR")
    }
    
    required init(coder aDecoder: NSCoder) {
        countryEN = aDecoder.decodeObject(forKey: "countryEN") as? Locations
        cityEN = aDecoder.decodeObject(forKey: "cityEN") as? Locations
        countryAR = aDecoder.decodeObject(forKey: "countryAR") as? Locations
        areaEN = aDecoder.decodeObject(forKey: "areaEN") as? Locations
        cityAR = aDecoder.decodeObject(forKey: "cityAR") as? Locations
        areaAR = aDecoder.decodeObject(forKey: "areaAR") as? Locations
        
    }
    
    func getCountry() -> Locations? {
        return Localize.currentLanguage() == Languages.Arabic ? countryAR : countryEN
    }
    
    func getCity() -> Locations? {
        return Localize.currentLanguage() == Languages.Arabic ? cityAR : cityEN
    }
    
    func getArea() -> Locations? {
        return Localize.currentLanguage() == Languages.Arabic ? areaAR : areaEN
    }
}


class Results1: NSObject,NSCoding  {
    
    var nameLocation: [Locations] = []
    var cityLocation: [GetCity] = []
    var id : String?
    
    init(sender : SwiftyJSONParameter){
        
        guard let rawData = sender else { return }
        let json = JSON(rawData)
        
        var array:[JSON] = json[APIConstants.DataKey].arrayValue
        if array.isEmpty {
            array = json[APIConstants.DataKey].dictionaryValue[LocationKeys.cityData.rawValue]?.arrayValue ?? []
        }
        if array.isEmpty {
            array = json[APIConstants.DataKey].dictionaryValue[LocationKeys.areaData.rawValue]?.arrayValue ?? []
        }

        for language in array {
            
            let cityData = GetCity(data: language.dictionaryValue)
            self.cityLocation.append(cityData)
            nameLocation += cityData.locations
            
        }
    }
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(nameLocation, forKey: LocationKeys.names.rawValue)
        aCoder.encode(id, forKey: LocationKeys.id.rawValue)
        aCoder.encode(cityLocation, forKey: LocationKeys.cityData.rawValue)

    }
    
    required init?(coder aDecoder: NSCoder) {
        
        nameLocation = (aDecoder.decodeObject(forKey: LocationKeys.names.rawValue) as? [Locations]) ?? []
        id = aDecoder.decodeObject(forKey: LocationKeys.id.rawValue) as? String
        cityLocation = (aDecoder.decodeObject(forKey: LocationKeys.cityData.rawValue) as? [GetCity]) ?? []
        
    }
    
    func getArrLocation() -> [Locations] {
        let languageId = GDataSingleton.sharedInstance.languageId
        return self.nameLocation.filter({$0.languageid == languageId})
    }
}
