////
////  SocketIOManager.swift
////  SocketChat
////
////  Created by Gabriel Theodoropoulos on 1/31/16.
////  Copyright © 2016 AppCoda. All rights reserved.
////
//
//import UIKit
//import SocketIO
//import SwiftyJSON
//
//enum SocketEvent : String {
//    case Connection = "conenction"
//    case MesasgeToServer = "messageToServer"
//    case MessageFromServer = "messageFromServer"
//    case Connect = "connect"
//    case DisconnectFromApp = "disconnectFromApp"
//    case Typing = "typing"
//    case StopTyping = "stopTyping"
//}
//
////Socket Blocks
//typealias MessageFromServer = (Chat?) -> ()
//typealias DisconnectFromApp = () -> ()
//typealias StartTyping = () -> ()
//typealias StopTyping = () -> ()
//
//class SocketIOManager: NSObject {
//    
//    class var sharedInstance: SocketIOManager {
//        struct Static {
//            static var instance: SocketIOManager?
//            static var token: dispatch_once_t = 0
//        }
//        
//        dispatch_once(&Static.token) {
//            Static.instance = SocketIOManager()
//        }
//        
//        return Static.instance!
//    }
//    var socket: SocketIOClient = SocketIOClient(socketURL: NSURL(string: APIConstants.BasePath)!)
//    
//    
//    override init() {
//        super.init()
//    }
//    
//    var startTypingBlock : StartTyping?
//    var stopTypingBlock : StopTyping?
//    
//    func establishConnection() {
//        
//        socket.connect()
//        socket.emit(SocketEvent.Connection.rawValue, [APIConstants.DataKey : GDataSingleton.sharedInstance.loggedInUser?.id ?? ""])
//        socket.emit(SocketEvent.MesasgeToServer.rawValue, "")
//        listenForOtherMessages()
//    }
//    
//    
//    func closeConnection() {
//        socket.disconnect()
//    }
//    
//    func getMessagesFromServer(messages: MessageFromServer) {
//       
//        socket.on(SocketEvent.MessageFromServer.rawValue) { ( dataArray, ack) -> Void in
//            messages(Chat(attributes: JSON(dataArray).arrayValue))
//        }
//        socket.on(SocketEvent.Connect.rawValue) { ( dataArray, ack) -> Void in
//            
//        }
//    }
//    
//    
//    func exitChat(exit: DisconnectFromApp) {
//        socket.emit(SocketEvent.DisconnectFromApp.rawValue, "")
//        exit()
//    }
//    
//    
//    func sendMessage(message : OptionalDictionary) {
//        guard let currentMessage = message else { return }
//        socket.emit(SocketEvent.MesasgeToServer.rawValue, currentMessage)
//    }
//    
//    
//    private func listenForOtherMessages() {
//        socket.on(SocketEvent.Typing.rawValue) { (dataArray, socketAck) -> Void in
//            weak var weakSelf = self
//            guard let block = weakSelf?.startTypingBlock else { return }
//            block()
//        }
//        
//        socket.on(SocketEvent.StopTyping.rawValue) { (dataArray, socketAck) -> Void in
//            weak var weakSelf = self
//            guard let block = weakSelf?.stopTypingBlock else { return }
//            block()
//        }
//    }
//    
//    
//    func sendStartTypingMessage() {
//        socket.emit(SocketEvent.Typing.rawValue, "")
//    }
//    
//    
//    func sendStopTypingMessage() {
//        socket.emit(SocketEvent.StopTyping.rawValue, "")
//    }
//    
//    func formatParameters(message : String?,adminId : String?) -> OptionalDictionary{
//        return [ChatKeys.userId.rawValue : GDataSingleton.sharedInstance.loggedInUser?.id ?? "",ChatKeys.name.rawValue : GDataSingleton.sharedInstance.loggedInUser?.firstName ?? "",ChatKeys.message.rawValue : message ?? "",ChatKeys.adminId.rawValue : adminId ?? ""]
//    }
//    
//    func convertDictToMessage(dict : OptionalDictionary) -> Message?{
//        guard let messageDict = dict else { return nil }
//        let message = Message()
//        message.adminId = messageDict[ChatKeys.adminId.rawValue] as? String
//        message.userId = messageDict[ChatKeys.userId.rawValue] as? String
//        message.message = messageDict[ChatKeys.message.rawValue] as? String
//        message.name = messageDict[ChatKeys.name.rawValue] as? String
//        return message
//    }
//}
