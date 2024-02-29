//
//  AgentDBSecretKey.swift
//  Sneni
//
//  Created by Mac_Mini17 on 12/04/19.
//  Copyright © 2019 Taran. All rights reserved.
//


import SwiftyJSON
import RMMapper

class AgentDBSecretKey : NSObject , RMMapping, NSCoding {
  
     var agentDBData : [AgentDBData]?
    
     init(sender : SwiftyJSONParameter){
    
            guard let rawData = sender else { return }
            let json = JSON(rawData)
        
            let array = json[APIConstants.DataKey].arrayValue
        
            agentDBData = [AgentDBData]()
            
            for (_ , element) in array.enumerated(){
                
                let agentData = AgentDBData(attributes: element.dictionaryValue)
                agentDBData?.append(agentData)
              
            }
   
     }
    
    
    override init(){
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(agentDBData, forKey: APIConstants.DataKey)
  
    }
    
    required init(coder aDecoder: NSCoder) {
        
        agentDBData = aDecoder.decodeObject(forKey: APIConstants.DataKey) as? [AgentDBData]

    }
    
}

