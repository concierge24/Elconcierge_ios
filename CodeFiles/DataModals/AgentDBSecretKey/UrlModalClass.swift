//
//  UrlModalClass.swift
//  Sneni
//
//  Created by admin on 05/04/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper

enum UrlKeys: String {

    case app
    case web
    
}

class UrlModalClass: NSObject,Mappable,NSCoding {
    
    var app : String?
    var web : String?
    
    required init?(map: Map){}
    private override init(){}
    
    func mapping(map: Map) {
        app <- map ["app"]
        web <- map["web"]
    }

    @objc required init(coder aDecoder: NSCoder){
        app = aDecoder.decodeObject(forKey: "app") as? String
        web = aDecoder.decodeObject(forKey: "web") as? String

    }
    
    @objc func encode(with aCoder: NSCoder){
        if app != nil{
            aCoder.encode(web, forKey: "app")
        }
        if web != nil{
            aCoder.encode(web, forKey: "english")
        }
        
    }
    
    func returnValueForKey(key : String) -> Any? {
        if key == UrlKeys.app.rawValue {
                   return self.app
               }else if key == UrlKeys.web.rawValue {
                   return self.web
               }else {
                   return nil
               }
    }
    
}
