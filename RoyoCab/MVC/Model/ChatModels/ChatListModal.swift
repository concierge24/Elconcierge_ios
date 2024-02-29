//
//  ChatListModal.swift
//  Buraq24
//
//  Created by Apple on 07/08/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import Foundation
import UIKit
import ObjectMapper


class UserList: Mappable {
    
    var cid : Int?
    var oppositionId : Int?
    var text : String?
    var sent_at : String?
    var message_id : Int?
    var name : String?
    var profile_pic : String?
    init(cid: Int?, oppositionId: Int?, text: String?, sent_at: String?, message_id : Int?,name : String?,profile_pic : String?) {
        self.cid = cid
        self.oppositionId = oppositionId
        
        self.text = text
        self.sent_at = sent_at
        self.message_id = message_id
        self.name = name
        self.profile_pic = profile_pic
    }
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        cid <- map["c_id"]
        oppositionId <- map["oppositionId"]
       
        text <- map["text"] // brands with products
        
        sent_at <- map["sent_at"]
        message_id <- map["message_id"]
        name <- map["name"]
        profile_pic <- map["profile_pic"]
    }
}


