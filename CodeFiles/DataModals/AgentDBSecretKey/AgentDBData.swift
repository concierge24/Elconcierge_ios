//
//  AgentDBData.swift
//  Sneni
//
//  Created by Mac_Mini17 on 12/04/19.
//  Copyright © 2019 Taran. All rights reserved.
//


enum AgentSecretKeys : String {
    
    case value = "value"
    case key = "key"
}

import SwiftyJSON
import RMMapper

class AgentDBData : NSObject , RMMapping, NSCoding {
    
    var key : String?
    var value : String?
        
    init (attributes : Dictionary<String, JSON>?){
        
        
        self.key = attributes?[AgentSecretKeys.key.rawValue]?.stringValue
        self.value = attributes?[AgentSecretKeys.value.rawValue]?.stringValue
        
        
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.key, forKey: AgentSecretKeys.key.rawValue)
            aCoder.encode(self.value , forKey: AgentSecretKeys.value.rawValue)
        
        
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
                self.key  = aDecoder.decodeObject(forKey: AgentSecretKeys.key.rawValue) as? String
             self.value  = aDecoder.decodeObject(forKey: AgentSecretKeys.value.rawValue) as? String
        
        
        //        arrayServiceTypesEN = aDecoder.decodeObject(forKey:
    }
    
    
    override init(){
        super.init()
    }
    

}
