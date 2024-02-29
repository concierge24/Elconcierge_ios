//
//  AgentData.swift
//  Sneni
//
//  Created by Mac_Mini17 on 12/04/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation


enum AgentListingKeys : String {
    
    case cbluser = "cbl_user"
    case serviceid = "service_id"
}

import SwiftyJSON
import RMMapper

class AgentListingData : NSObject , RMMapping, NSCoding {
    
    var cblUser : CblUser?
    var serviceId : String?
    
    override init(){
        super.init()
    }
    
    init (attributes : Dictionary<String, JSON>?){
        
        let dict =  attributes?[AgentListingKeys.cbluser.rawValue]?.dictionaryValue
        cblUser = CblUser(attributes: dict)
        self.serviceId = attributes?[AgentListingKeys.serviceid.rawValue]?.stringValue
        
    }
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(self.cblUser, forKey: AgentListingKeys.cbluser.rawValue)
        aCoder.encode(self.serviceId , forKey: AgentListingKeys.serviceid.rawValue)
        
    }
    
    required init(coder aDecoder: NSCoder) {
        
        self.cblUser  = aDecoder.decodeObject(forKey: AgentListingKeys.cbluser.rawValue) as? CblUser
        self.serviceId  = aDecoder.decodeObject(forKey: AgentListingKeys.serviceid.rawValue) as? String
    }
    
    
    
    
    
}

