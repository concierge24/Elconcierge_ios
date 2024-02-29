//
//  Chat.swift
//  Clikat
//
//  Created by cblmacmini on 6/9/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import SwiftyJSON
//{ userId: 22,
//      message: 'Disconnected',
//      name: 'harman',
//      type: 200,
//      adminId: 14,
//      status: 301 }

//DISCONNECT':301,
//    'TYPING':302,
//    'STOP_TYPING':303,
//    'NEW_MESSAGE':200,
//    'NOT_FOUND':304,
//    'NOT_FORMAT':401
//    
enum ChatKeys : String {
    case userId = "userId"
    case message = "message"
    case name = "name"
    case type = "type"
    case adminId = "adminId"
    case status = "status"
}

enum ChatStatus : String {
    case None = ""
    case Disconnect = "301"
    case Typing = "302"
    case StopTyping = "303"
    case NewMessage = "200"
    case NotFound = "304"
    case NotFormat = "401"
}

class ChatModel: NSObject {

    var messages : [Message]?
    init(attributes : [JSON]) {
        var tempMessages : [Message] = []
        for message in attributes {
            tempMessages.append(Message(attributes: message.dictionaryValue))
        }
        self.messages = tempMessages
    }
    
}

class Message  : NSObject{
    var userId : String?
    var message : String?
    var adminId : String?
    var type : String?
    var status : ChatStatus = .None
    var name : String?
    var myMessage : Bool?
    
    init(attributes : SwiftyJSONParameter){
        self.userId = attributes?[ChatKeys.userId.rawValue]?.stringValue
        self.adminId = attributes?[ChatKeys.adminId.rawValue]?.stringValue
        self.message = attributes?[ChatKeys.message.rawValue]?.stringValue
        self.status = ChatStatus(rawValue: attributes?[ChatKeys.userId.rawValue]?.stringValue ?? "") ?? .None
        self.type = attributes?[ChatKeys.type.rawValue]?.stringValue
        self.name = attributes?[ChatKeys.name.rawValue]?.stringValue
    }
    
    override init() {
        super.init()
    }
}
