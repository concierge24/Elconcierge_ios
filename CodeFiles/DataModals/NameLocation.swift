//
//  NameLocation.swift
//  Sneni
//
//  Created by Mac_Mini17 on 28/03/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation

enum NameLocationKeys : String {
    
    case name = "name"
    case languageiId = "language_id"
    case id = "id"
   
}

class NameLocation: NSObject, NSCoding {
   
    var name : String?
    var languageid : String?
    var id :String?
    
    init (attributes : SwiftyJSONParameter){
       
        self.name = attributes?[NameLocationKeys.name.rawValue]?.stringValue
        self.languageid = attributes?[NameLocationKeys.languageiId.rawValue]?.stringValue
        self.id = attributes?[NameLocationKeys.id.rawValue]?.stringValue
        
    }
   
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(languageid, forKey: NameLocationKeys.languageiId.rawValue)
        aCoder.encode(name, forKey: NameLocationKeys.name.rawValue)
        aCoder.encode(id, forKey: NameLocationKeys.id.rawValue)
      
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        name = aDecoder.decodeObject(forKey: NameLocationKeys.name.rawValue) as? String
        languageid = aDecoder.decodeObject(forKey: NameLocationKeys.languageiId.rawValue) as? String
        id  =  aDecoder.decodeObject(forKey: NameLocationKeys.id.rawValue) as? String
    }
    
    
}
