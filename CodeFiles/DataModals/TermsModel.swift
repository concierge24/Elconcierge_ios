//
//  TermsModel.swift
//  Sneni
//
//  Created by cbl41 on 3/13/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit
import SwiftyJSON

enum TermsResponseKeys : String {
    
    case data = "data"
   
}

class TermsResponse: NSObject, NSCoding {
    
    var array: [TermsModel]?
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(array, forKey: TermsResponseKeys.data.rawValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        array = aDecoder.decodeObject(forKey: TermsResponseKeys.data.rawValue) as? [TermsModel]
    }
    
    
    
    init(sender : SwiftyJSONParameter){
        
        guard let rawData = sender else { return }
        
        let json = JSON(rawData)
        let arr = json[APIConstants.DataKey].arrayValue
        
        self.array = []
        for (_ , element) in arr.enumerated(){
            
            let obj = TermsModel(attributes: element.dictionaryValue)
            self.array?.append(obj)
        }
    }
    
}


enum TermsModelKeys : String {
    
    case aboutUs = "about_us"
    case languageId = "language_id"
    case terms = "terms_and_conditions"
    case privacyPolicy = "faq"
}

class TermsModel: NSObject, NSCoding {
   
    var aboutUs : String?
    var languageId : String?
    var terms :String?
    var privacyPolicy :String?

    init (attributes : SwiftyJSONParameter){
       
        self.aboutUs = attributes?[TermsModelKeys.aboutUs.rawValue]?.stringValue
        self.languageId = attributes?[TermsModelKeys.languageId.rawValue]?.stringValue
        self.terms = attributes?[TermsModelKeys.terms.rawValue]?.stringValue
        self.privacyPolicy = attributes?[TermsModelKeys.privacyPolicy.rawValue]?.stringValue

    }
   
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(aboutUs, forKey: TermsModelKeys.aboutUs.rawValue)
        aCoder.encode(languageId, forKey: TermsModelKeys.languageId.rawValue)
        aCoder.encode(terms, forKey: TermsModelKeys.terms.rawValue)
        aCoder.encode(privacyPolicy, forKey: TermsModelKeys.privacyPolicy.rawValue)

      
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        aboutUs = aDecoder.decodeObject(forKey: TermsModelKeys.aboutUs.rawValue) as? String
        languageId = aDecoder.decodeObject(forKey: TermsModelKeys.languageId.rawValue) as? String
        terms = aDecoder.decodeObject(forKey: TermsModelKeys.terms.rawValue) as? String
        privacyPolicy = aDecoder.decodeObject(forKey: TermsModelKeys.privacyPolicy.rawValue) as? String

    }
    
    
}
