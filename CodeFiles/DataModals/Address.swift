//
//  Address.swift
//  Clikat
//
//  Created by cblmacmini on 5/2/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import SwiftyJSON

enum AddressKeys : String {
    
    case id = "id"
    case address_line_1 = "address_line_1"
    case pincode = "pincode"
    case directions_for_delivery = "directions_for_delivery"
    case address_line_2 = "address_line_2"
    case landmark = "landmark"
    case is_deleted = "is_deleted"
    case name = "name"
    case address_link = "address_link"
    case customer_address = "customer_address"
    case area_id = "area_id"
    case latitude = "latitude"
    case longitude = "longitude"
    case userID = "user_id"
}

class Address: NSObject {

    var name : String?
    var landMark : String?
    var houseNo : String?
    var buildingName : String?
    var address : String?
    var area : String?
    var city : String?
    var country : String?
    var id : String?
    var isDeleted : String?
    var userID: Int?
    var lat : Double?
    var long : Double?
    
    var latitude: String?
    var longitude: String?
    
    var placeLink : String? {
        didSet {
            let array = placeLink?.components(separatedBy: "?q=")
            
            if /array?.count > 1, let str = array?.last {
                let arrayLats = str.components(separatedBy: ",")
                if arrayLats.count == 2, let strLat = arrayLats.first, let strLong = arrayLats.last {
                    lat = Double(strLat)
                    long = Double(strLong)
                }
            }
        }
    }
    var customerAddress : String?
    
    var areaId : String?
    
    var addressString : String?

    init(attributes : SwiftyJSONParameter) {
        
        self.latitude = attributes?[AddressKeys.latitude.rawValue]?.stringValue
        self.longitude = attributes?[AddressKeys.longitude.rawValue]?.stringValue

        self.name = attributes?[AddressKeys.name.rawValue]?.stringValue
        self.landMark = attributes?[AddressKeys.landmark.rawValue]?.stringValue
        self.address = attributes?[AddressKeys.customer_address.rawValue]?.stringValue
        self.area = attributes?[AddressKeys.address_line_1.rawValue]?.stringValue
        
        let pincodeStrings = attributes?[AddressKeys.pincode.rawValue]?.stringValue.components(separatedBy: ",@#")
        self.houseNo = pincodeStrings?.first
        self.buildingName = pincodeStrings?.last
        self.id = attributes?[AddressKeys.id.rawValue]?.stringValue
        self.isDeleted = attributes?[AddressKeys.is_deleted.rawValue]?.stringValue
        self.placeLink = attributes?[AddressKeys.address_link.rawValue]?.stringValue
        self.userID = attributes?[AddressKeys.userID.rawValue]?.intValue
        let array = placeLink?.components(separatedBy: "?q=")
        
        if /array?.count > 1, let str = array?.last {
            let arrayLats = str.components(separatedBy: ",")
            if arrayLats.count == 2, let strLat = arrayLats.first, let strLong = arrayLats.last {
                lat = Double(strLat)
                long = Double(strLong)
            }
        }
        
        let addressLineSecond = attributes?[AddressKeys.address_line_2.rawValue]?.stringValue.components(separatedBy: ",@#")
        self.city = addressLineSecond?.first
        self.country = addressLineSecond?.last
        
        self.addressString = UtilityFunctions.appendOptionalStrings(withArray: [landMark,houseNo,buildingName,city,country])
        
        self.areaId = attributes?[AddressKeys.area_id.rawValue]?.stringValue
    }
    
    init(name : String?,addressString : String?) {
        self.addressString = addressString
        self.name = name
    }
    
    init(name : String?,address : String?,landmark : String?,houseNo : String?,buildingName : String?,city : String?,country : String?,placeLink : String?,area : String?,lat: String?,long:String?,id:String?) {
        
        self.id = id
        self.address = address
        self.name = name
        self.landMark = landmark
        self.houseNo = houseNo
        self.buildingName = buildingName
        self.area = area
        self.city = city
        self.country = country
        self.placeLink = placeLink
        self.latitude = lat
        self.longitude = long
        self.addressString = UtilityFunctions.appendOptionalStrings(withArray: [landMark,houseNo,buildingName,area,city,country])
    }
    
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(name, forKey: "name")
        aCoder.encode(landMark, forKey: "landMark")
        aCoder.encode(houseNo, forKey: "houseNo")
        aCoder.encode(buildingName, forKey: "buildingName")
        aCoder.encode(address, forKey: "address")
        aCoder.encode(area, forKey: "area")
        aCoder.encode(city, forKey: "city")
        aCoder.encode(country, forKey: "country")
        aCoder.encode(id, forKey: "id")
        
        aCoder.encode(isDeleted, forKey: "isDeleted")
        aCoder.encode(placeLink, forKey: "placeLink")
        aCoder.encode(customerAddress, forKey: "customerAddress")
        aCoder.encode(areaId, forKey: "areaId")
        aCoder.encode(addressString, forKey: "addressString")
        
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(userID, forKey: "userID")
    }
    
    required init(coder aDecoder: NSCoder) {
        
        name = aDecoder.decodeObject(forKey: "name") as? String
        landMark = aDecoder.decodeObject(forKey: "landMark") as? String
        houseNo = aDecoder.decodeObject(forKey: "houseNo") as? String
        buildingName = aDecoder.decodeObject(forKey: "buildingName") as? String
        address = aDecoder.decodeObject(forKey: "address") as? String
        area = aDecoder.decodeObject(forKey: "area") as? String
        city = aDecoder.decodeObject(forKey: "city") as? String
        country = aDecoder.decodeObject(forKey: "country") as? String
        id = aDecoder.decodeObject(forKey: "id") as? String
        
        isDeleted = aDecoder.decodeObject(forKey: "isDeleted") as? String
        placeLink = aDecoder.decodeObject(forKey: "placeLink") as? String
        customerAddress = aDecoder.decodeObject(forKey: "customerAddress") as? String
        areaId = aDecoder.decodeObject(forKey: "areaId") as? String
        addressString = aDecoder.decodeObject(forKey: "addressString") as? String
        
        latitude = aDecoder.decodeObject(forKey: "latitude") as? String
        longitude = aDecoder.decodeObject(forKey: "longitude") as? String
        userID = aDecoder.decodeObject(forKey: "userID") as? Int
    }
    
    class func validateAddress(name : UITextField?,houseNo : UITextField?,building : UITextField?,address : UILabel?,landmark : UITextField?,city : UITextField? , country : UITextField?) -> String{
        guard let name = name?.text, name.count != 0 else {
            return L10n.PleaseEnterYourName.string
        }
        guard let houseno = houseNo?.text, houseno.count != 0 else {
            return L10n.PleaseEnterYourHouseNo.string
        }
        guard let buildingName = building?.text, buildingName.count != 0 else {
            return L10n.PleaseEnterYourBuildingName.string
        }
        guard let address = address?.text, address.count != 0 else {
            return L10n.PleaseSelectYourLocation.string
        }
        guard let landmark = landmark?.text, landmark.count != 0 else {
            return L10n.PleaseEnterALandmarkName.string
        }
        guard let city = city?.text, city.count != 0 else {
            return L10n.PleaseEnterYourCity.string
        }
        guard let country = country?.text, country.count != 0 else {
            return L10n.PleaseEnterYourCounrty.string
        }
        return ""
    }
    
    override init() {
        super.init()
    }
}
