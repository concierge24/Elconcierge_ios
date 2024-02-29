//
//  SocketIOManagerCab.swift
//  GasItUp
//
//  Created by cbl24_Mac_mini on 11/04/18.
//  Copyright © 2018 cbl24_Mac_mini. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON
import Alamofire
import SocketIO
import ObjectMapper

typealias  OrderEventResponseBlock = (_ response : Any? , _ type : OrderEventType) -> ()
typealias  TrackResponseBlock = (_ response : Any?) -> ()
typealias  chatResponse = (_ response : Chat?) -> ()


class SocketIOManagerCab: NSObject {
    
    static let shared = SocketIOManagerCab()
    
    private var manager: SocketManager?
    var socket: SocketIOClient?
    
    override init() {
        super.init()
//        let token = UDSingleton.shared.userData?.userDetails?.accessToken
//
//        guard let URL = URL(string: APIBasePath.basePath) else {
//            return
//        }
//
//        manager = SocketManager(socketURL: URL , config: [.log(false), .connectParams(["access_token" : /token])])
//        socket = manager?.defaultSocket
//        setupListeners()
        
    }
    
    func initialiseSocketManager(){
        let token = UDSingleton.shared.userData?.userDetails?.accessToken
        
        guard let URL = URL(string: APIBasePath.basePath) else {
            return
        }
        
        manager = SocketManager(socketURL: URL , config: [.log(false), .connectParams(["access_token" : /token, "secretdbkey": APIBasePath.secretDBKey])])
        socket = manager?.defaultSocket
        setupListeners()
        self.establishConnection()
    }
    
    //Server Methods
    
    func establishConnection() {
        
        let token = UDSingleton.shared.userData?.userDetails?.accessToken
        if (self.socket?.status == .disconnected || self.socket?.status == .notConnected ) {
            if (token != nil || token != "") {
                socket?.connect()
            }
        }
        else {
            debugPrint("======= Socket already connected =======")
        }
    }
    
    func closeConnection() {
        debugPrint("=======***** SocketClientEvent.disconnect called ****=======")
        socket?.disconnect()
    }
    
    func setupListeners() {
        socket?.on(SocketClientEvent.disconnect.rawValue) { [weak self] (array, emitter) in
            debugPrint("======= SocketClientEvent.disconnect listener=======")
          self?.establishConnection()
        }
        
        socket?.on(SocketClientEvent.error.rawValue) {[weak self] (array, emitter) in
            debugPrint("======= SocketClientEvent.error =======")
          self?.establishConnection()
        }
        
        socket?.on(SocketClientEvent.connect.rawValue) {  (array, emitter) in
            if self.socket?.status == .connected {
                debugPrint("======= userauth after connected =======")
            }
        }
    }
    
    
    func getStatus() -> SocketIOStatus? {
        
        guard let status = self.socket?.status else{ return nil }
        return status
    }
    
    //MARK:- Emitter Events
    //MARK:-
    
    func listenOrderEventConnected(_ completionHandler: @escaping OrderEventResponseBlock) {
        socket?.on(SocketEvents.OrderEvent.rawValue) {(arrData, socketAck) in
            
            guard let item = JSON(arrData[0]).dictionaryObject else {return}
            
            print("socket data")
            print("Rohit Kumar ")
            print("Socket Item",item)
        
            guard  let type = item["type"] as? String else{return}
            debugPrint("® ============ ================== \(type)")
            
            guard let typeSocket :  OrderEventType = OrderEventType(rawValue: type) else {return}
            
            switch typeSocket {
                
            case .serReached, .ServiceAccepted , .ServiceOngoing :
             
                guard  let orderModel = item["order"] as? [Any] else{return}
                let order =  Mapper<OrderCab>().map(JSONObject: orderModel[0])
                completionHandler(order, typeSocket)
                
            case .DriverRatedCustomer:
                print("DriverRatedCustomer")
                
            case .ServiceCompletedByDriver, .ServiceBreakdown, .SerHalfWayStopRejected , .ServiceBreakDownAccepted, .ServiceBreakDownRejected:
                print(item)
                guard  let orderModel = item["order"] as? [Any] else{return}
                let order =  Mapper<OrderCab>().map(JSONObject: orderModel[0])
                completionHandler(order, typeSocket)
                
            case .ServiceRejectedByAllDriver  ,.ServiceTimeOut, .SerLongDistance :
              completionHandler(nil, typeSocket)
          
            case .ServiceCurrentOrder:
                
                let trackObj =  Mapper<TrackingModel>().map(JSONObject: item)
                completionHandler(trackObj, typeSocket)
                
            case .DriverCancelrequest:
                
                guard  let orderModel = item["order"] as? [Any] else{return}
                let order =  Mapper<OrderCab>().map(JSONObject: orderModel[0])
                completionHandler(order, typeSocket)
                
            case .EtokenConfirmed:
                
                Alerts.shared.show(alert: "etoken.eToken".localizedString, message: R.string.localizable.eTokenOrderConfirmed(), type: .success)
                completionHandler(nil,typeSocket)
                
            case .EtokenStart:
                
                guard  let orderModel = item["order"] as? [Any] else{return}
                let order =  Mapper<OrderCab>().map(JSONObject: orderModel[0])
                
                NotificationCenter.default.post(name: Notification.Name("\(LocalNotifications.ETokenRefresh.rawValue)\(/order?.orderId)"), object: nil, userInfo: nil)
                
                Alerts.shared.show(alert: "etoken.eToken".localizedString, message: R.string.localizable.etokenOrderOutForDelivery(), type: .success)
                completionHandler(nil,typeSocket )
                
            case .EtokenSerCustPending :
                guard  let orderModel = item["order"] as? [Any] else{return}

                let order =  Mapper<OrderCab>().map(JSONObject: orderModel[0])
                NotificationCenter.default.post(name: Notification.Name("\(LocalNotifications.ETokenRefresh.rawValue)\(/order?.orderId)"), object: nil, userInfo: nil)
                Alerts.shared.show(alert: "etoken.eToken".localizedString, message: R.string.localizable.eTokenOrderWaitingConfirmation(), type: .success)
                completionHandler(nil,typeSocket )

            case .EtokenCTimeout :
                guard  let orderModel = item["order"] as? [Any] else{return}
                
                let order =  Mapper<OrderCab>().map(JSONObject: orderModel[0])
                NotificationCenter.default.post(name: Notification.Name("\(LocalNotifications.ETokenRefresh.rawValue)\(/order?.orderId)"), object: nil, userInfo: nil)
                Alerts.shared.show(alert: "etoken.eToken".localizedString, message: R.string.localizable.etokenOrderTimeOut(), type: .success)
                completionHandler(nil,typeSocket )

                
            case .CardAdded:
                completionHandler(nil,typeSocket)
                
            case .SerCheckList:
                
                 Alerts.shared.show(alert: "AppName".localizedString, message: "Please Review checklist price, update by driver.", type: .success)
                
                print("=======> Check List Socket Data <=======")
                completionHandler(item, typeSocket)
                 
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifications.SerCheckList.rawValue), object: nil, userInfo: item)
                
            case .Pending:
                 completionHandler(nil,typeSocket)
                
            case .DApproved:
                completionHandler(nil,typeSocket)
            }
           }
        }
    
    //MARK:- Listener Events
    /// It will get driver listing near you when user change service type at home screen view
    func emitMapLocation(_ userData : [String: Any] , _ completionHandler: @escaping TrackResponseBlock) {
        
        print("UserData CommonEvent : ")
        print(userData)

        socket?.emitWithAck(SocketEvents.CommonEvent.rawValue , userData).timingOut(after: 4.0, callback: { (response) in
            
            print("CommonEvent : ")
            print(response)
            
            guard  let item = JSON(response[0]).dictionaryObject else{return}
            let json = JSON(item)
             if json[APIConstantsCab.statusCode.rawValue].stringValue == ValidateCab.successCode.rawValue {
                 let objDriver = Mapper<ApiSucessDataCab<DriverList>>().map(JSONObject: item)
                
              completionHandler( objDriver?.object)
                
             }
        })
    }
    
    func getParticularOrder(_ userData : [String: Any]  , _ completionHandler: @escaping TrackResponseBlock) {
        
        socket?.emitWithAck(SocketEvents.CommonEvent.rawValue, userData).timingOut(after: 2.0, callback: {
            (response) in
            let item = JSON(response[0]).dictionaryObject
           
            let json = JSON(item)
   
            if json[APIConstantsCab.statusCode.rawValue].stringValue == ValidateCab.successCode.rawValue {
                let objOrder = Mapper<ApiSucessDataCab<OrderCab>>().map(JSONObject: item)
                completionHandler( objOrder?.object)
            }
        })
    }
    
    func sendChatsMessage(userDetailId: String, text: String,to : String,sendAt : String,originalIMage : String?,thumbnailImage : String?,chat_type : String) {
        let dte = Date()
        let format = DateFormatter()
        format.timeZone = TimeZone.current
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dteGet = format.string(from: dte) as AnyObject
        let dict: [String:AnyObject] = ["detail":["user_detail_id": userDetailId ,"text" : text,"to": to,"sent_at" : dteGet,"original" : /originalIMage,"thumbnail": /thumbnailImage,"chat_type" : chat_type] as AnyObject]
        
        print(dict)
        socket?.emit("sendMessage", dict)
       
        
    }
    
    func getChatsMessage(completionHandler: @escaping  chatResponse) {
        
        socket?.on("receiveMessage") { (dataArray, socketAck) -> Void in
            print(dataArray)
            //var messageDictionary = [String: AnyObject]()
            //  let obj = Mapper<ApiSucessDataCab<Chat>>().map(JSONObject: dataArray)
            let obj = Chat(cid: (dataArray[0] as! Dictionary<String,AnyObject>)["c_id"]! as? Int, conversationId: 0, send_to: (dataArray[0] as! Dictionary<String,AnyObject>)["send_to"]! as? Int, send_by: (dataArray[0] as! Dictionary<String,AnyObject>)["send_by"]! as? Int, text: (dataArray[0] as! Dictionary<String,AnyObject>)["text"]! as? String, sent_at: (dataArray[0] as! Dictionary<String,AnyObject>)["sent_at"]! as? String,original: (dataArray[0] as! Dictionary<String,AnyObject>)["original"]! as? String,thumbnail: (dataArray[0] as! Dictionary<String,AnyObject>)["thumbnail"]! as? String,chat_type: (dataArray[0] as! Dictionary<String,AnyObject>)["chat_type"]! as? String)
      
            
            completionHandler(obj)
        }
    }
    
}
