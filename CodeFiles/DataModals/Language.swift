//
//  Language.swift
//  Clikat
//
//  Created by cbl73 on 4/23/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import Foundation
import SwiftyJSON
import RMMapper


enum Language : String {
    case id = "id"
    case language_code = "language_code"
    case language_name = "language_name"
    
    static let allValues = [ "en" , "ar" ]
    
}



class ApplicationLanguage : NSObject , RMMapping, NSCoding {
    
    var id : String?
    var language_code : String?
    var language_name : String?
    
    
    init (attributes : SwiftyJSONParameter){
        self.id = attributes?[Language.id.rawValue]?.stringValue
        self.language_code = attributes?[Language.language_code.rawValue]?.stringValue
        self.language_name = attributes?[Language.language_name.rawValue]?.stringValue
        
    }
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(id, forKey: "id")
        aCoder.encode(language_code, forKey: "language_code")
        aCoder.encode(language_name, forKey: "language_name")
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        id = aDecoder.decodeObject(forKey: "id") as? String
        language_code = aDecoder.decodeObject(forKey: "language_code") as? String
        language_name = aDecoder.decodeObject(forKey: "language_name") as? String
    }
    
}

class LanguageListing : NSObject , RMMapping {
    
    var languages : [ApplicationLanguage]?
    
    
    init (attributes : SwiftyJSONParameter){
        guard let rawData = attributes else { return }
        let json = JSON(rawData)
        let languages = json[HomeKeys.languageList.rawValue].arrayValue
        
        var tempLanguages : [ApplicationLanguage] = []
        for language in languages {
            let lang = ApplicationLanguage(attributes: language.dictionaryValue)
            tempLanguages.append(lang)
        }
        self.languages = tempLanguages
        
    }
    
    override init() {
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(languages, forKey: "languages")
    }
    
    required init(coder aDecoder: NSCoder) {
        languages = aDecoder.decodeObject(forKey: "languages") as? [ApplicationLanguage]
   
    }
    
}

