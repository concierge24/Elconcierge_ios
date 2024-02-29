//
//  chatModal.swift
//  Buraq24
//
//  Created by Apple on 06/08/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//
import UIKit
import ObjectMapper

struct driverDta {
    var name : String?
    var profilePic : String?
    var driverId : Int?
}


class Chat: Mappable {
    
    var cid : Int?
    var conversation_id : Int?
    var send_to: Int?
    var send_by: Int?
    var text : String?
    var sent_at : String?
    var original :String?
    var thumbnail :String?
    var chat_type :String?
    
    init(cid: Int?, conversationId: Int?, send_to: Int?, send_by: Int?, text: String?, sent_at: String?,original : String?,thumbnail : String?,chat_type : String?) {
        self.cid = cid
        self.conversation_id = conversationId
        self.send_to = send_to
        self.send_by = send_by
        self.text = text
        self.sent_at = sent_at
        self.original = original
        self.thumbnail = thumbnail
        self.chat_type = chat_type
    }
    
    required init?(map: Map){
        
    }
    
    func mapping(map: Map) {
        cid <- map["c_id"]
        conversation_id <- map["message_id"]
        send_to <- map["send_to"]
        send_by <- map["send_by"]
        text <- map["text"] // brands with products
        
        sent_at <- map["sent_at"]
        
        original <- map["original"]
        thumbnail <- map["thumbnail"]
        chat_type <- map["chat_type"]
    }
}


