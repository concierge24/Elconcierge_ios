//
//  SocketIOManagerTracking
//
//
//

import Foundation
import ObjectMapper
import SocketIO
import SwiftyJSON

//You need to update socketEvent names at line number: 17,100 and 105
//Also create locationObject at line number 106

enum SocketEvent : String {
    case sendMessage = "sendMessage"
    case receiveMessage = "receiveMessage"
    case currentLocation = "currentLocation"
    case orderLocation = "order_location"

}

class SocketIOManagerTracking: NSObject {
    
    static let shared = SocketIOManagerTracking()
    
    var socketManager: SocketManager?
    var socketClient: SocketIOClient?
    var isAuthenticated = false
    
    private override init() {
        super.init()
        let socketUrl  = TrackingConstants.socketUrl
        socketManager = SocketManager.init(socketURL: URL.init(string: socketUrl)!, config: [.connectParams([TrackingConstants.id : TrackingConstants.userId,TrackingConstants.secretdbkey: AgentCodeClass.shared.loggedAgent?.cbl_customer_domains?.first?.db_secret_key ?? "f9dad48c891fc13b2e9009f86839d51e"]), .forceNew(true)])
        socketClient = socketManager?.defaultSocket
    }

    func addHandlers() {
        
        if socketClient?.status == .connected {
            return
        }
        socketClient?.off(SocketClientEvent.connect.rawValue)
        socketClient?.off(SocketClientEvent.error.rawValue)
        socketClient?.off(SocketClientEvent.disconnect.rawValue)
        
        socketClient?.onAny({
            (objEvent) in
            print("Socket2019 \(objEvent.event) : \(String(describing: objEvent.items))")
            
        })
        
        socketClient?.on(clientEvent: .connect, callback: { (data, ack) in
            print("Socket Connected : " + /self.socketClient?.sid)
        })
        
        socketClient?.on(clientEvent: .error, callback: { (data, ack) in
            print("Error connecting")
            SocketIOManagerTracking.shared.connect()
        })
        
        socketClient?.on(clientEvent: .disconnect, callback: { (data, ack) in
            print("Socket Disconnected")
            self.isAuthenticated = false
            
        })
        socketClient?.connect()
        
    }
    
    func checkSocketConnection(){
        socketClient?.off("socketConnected")
        socketClient?.on("socketConnected", callback: { (dataArray, socketAck) in
            print(dataArray)
        })
    }
    
    
    func disConnectMsgEvent(){
        //add all those events here which you want to make off
        socketClient?.off(SocketEvent.currentLocation.rawValue)
    }
    
    func connect() {
        print("trying to connect")
        guard let socket = socketClient else { return }
        
        if socket.status == .connected {
            self.isAuthenticated = true
            return
        }
        
        if (socket.status == .disconnected || socket.status == .notConnected ) {
            print("=====Socket connected again=======")
            socket.connect()
            
            
        }
    }
    
    func disconnect() {
        guard let socket = socketClient else { return }
        if socket.status == .disconnected {
            return
        } else {
            print("disconnected")
            socket.disconnect()
        }
    }
    
    //MARK::- EMIT AND LISTENERS
    func sendCurrentLocation(data: [String : Any],ack : @escaping  (Bool) -> ()) {
        socketClient?.emitWithAck(SocketEvent.currentLocation.rawValue, data ).timingOut(after: 1) { responseData in
        }
    }
    
    func listenLocation(_ completionHandler: @escaping (LocationObject) -> Void) {
        
        socketClient?.off(SocketEvent.orderLocation.rawValue)
        socketClient?.on(SocketEvent.orderLocation.rawValue) {(dataArray, socketAck) in
            //please create the object of LocationObject from dataArray by creating
            print("dataArray")
            print(dataArray)
            let location = Mapper<ReceivedLocation>().map(JSONObject: dataArray.first)
            
            let obj = LocationObject(latitude: Double(/location?.latitude)! , longitude: Double(/location?.longitude)!, bearing: Double(/location?.bearing)!, horizontalAccuracy: Double(/location?.accuracy)!, estimatedTimeInMinutes: /location?.estimatedTimeInMinutes)
            
            completionHandler(obj)
        }
    }
}

class LocationObject {
    
    var latitude: Double?
    var longitude: Double?
    var bearing: Double?
    var horizontalAccuracy: Double?
    var estimatedTimeInMinutes: String?
    
    init(latitude: Double , longitude: Double , bearing:Double , horizontalAccuracy: Double , estimatedTimeInMinutes: String) {
        self.latitude = latitude
        self.longitude = longitude
        self.bearing = bearing
        self.horizontalAccuracy = horizontalAccuracy
        self.estimatedTimeInMinutes = estimatedTimeInMinutes
    }
    
}
