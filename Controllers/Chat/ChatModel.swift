//
//  ChatModel.swift
//  NequoreUser
//
//  Created by MAC_MINI_6 on 04/08/18.
//

import UIKit
import SwiftyJSON
import Contacts
import AddressBook
import SocketIO
import Photos


//typealias OptionalJSON = [String : JSON]?

enum MessageType: String {
    case Text = "text"
    case Image = "Image"
    case Video = "Video"
    case Attachement = "Attachement"
    case Property = "Property"
    
    func cellID(isOwn: Bool) -> String {
        switch self {
        case .Text:
            return isOwn ? "SenderTxtCell" : "ReceiverTxtCell"
        case .Image, .Video , .Property:
            return isOwn ? "SenderImgCell" : "ReceiverImgCell"
        case .Attachement:
            return isOwn ? "SenderAtchCell" : "ReceiverAtchCell"
        }
    }
    
    var chatType: String{
        switch self {
        case .Text:
            return "text"
        case .Image, .Video , .Property , .Attachement:
            return "set the name"
        }
    }
    
    var height: CGFloat {
        switch self {
        case .Text, .Attachement:
            return UITableView.automaticDimension
        case .Image, .Video , .Property:
            return ScreenSize.SCREEN_WIDTH * 0.5
        }
    }
}

class MessageChat : NSObject{
    
    var userID: String?
    var message: String?
    var image: MessageImage?
    var video: MessageVideo?
    var attachement: MessageDoc?
    var type: MessageType?
    var isOwnMessage: Bool?
    var messageID: String?
    var time: String?
    var convoId: String?
    var uploaded = true
    var isFail = false
    var propertyId: String?
    var order_id: String?
    
    init(attributes: OptionalJSON) {
        super.init()
        order_id =  /attributes?["order_id"]?.stringValue
        uploaded = true
        message = /attributes?["text"]?.stringValue
        
        //        image = MessageImage(image: /attributes?["image"]?.stringValue, url: /attributes?["image"]?.stringValue)
        //        video = MessageVideo(url: /attributes?["video"]?.stringValue, data: nil, thumb: /attributes?["image"]?.stringValue)
        //        attachement = MessageDoc(url: /attributes?["attachment"]?.stringValue, data: nil, fileName: /attributes?["attachment_name"]?.stringValue )
        //        type = MessageType(rawValue:  /attributes?["message_type"]?.stringValue.toInt())
        type = MessageType(rawValue: /attributes?["chat_type"]?.stringValue)
        let send_by = /attributes?["send_by"]?.stringValue
        isOwnMessage = /GDataSingleton.sharedInstance.loggedInUser?.user_created_id == /send_by
        messageID = /attributes?["message_id"]?.stringValue
        time = calculateTimeBK(time: /attributes?["sent_at"]?.stringValue)
        convoId = /attributes?["conversation_id"]?.stringValue
        isFail = false
    }
    
    override init() {
        super.init()
    }
    
    
    init(userID: String?, message: String?, image: MessageImage?, video: MessageVideo?, atch: MessageDoc?, type: MessageType? , messageID: String? , popertyId: String? = "" , convoId:String? = "") {
        self.isOwnMessage = true
        self.userID = userID
        self.message = message
        self.attachement = atch
        self.type = type
        self.image = image
        self.video = video
        self.attachement = atch
        self.time = Date().changeFormat(newFormat: "MMM d yyyy. h:mm a")
        self.messageID = messageID
        self.uploaded =  false
        self.isFail = false
        self.convoId = convoId
    }
    
    class func getMessageListing(array : [JSON]) -> [MessageChat]? {
        var tempArr : [MessageChat] = []
        for dict in array {
            tempArr.append(MessageChat(attributes: dict.dictionaryValue))
        }
        return tempArr
    }
    
    var getCellID: String? {
        return self.type?.cellID(isOwn: /isOwnMessage)
    }
    
}

class MessageImage {
    
    var image: Any?
    var url: String?
    
    init(image: Any? , url: String?) {
        self.image = image
        self.url = url
    }
}

class MessageVideo {
    
    var url: String?
    var data: Data?
    var thumbnail: Any?
    var savedUrl : URL?
    
    
    init(url: String?, data: Data?, thumb: Any?) {
        self.url = url
        self.data = data
        self.thumbnail = thumb
    }
    
    
    
}

class MessageDoc {
    
    var url: String?
    var data: Data?
    var fileName: String?
    
    init(url: String?, data: Data?, fileName: String?) {
        self.url = url
        self.data = data
        self.fileName = fileName
    }
}

class MessagesData {
    //    class func getTempMessages() -> [Message] {
    //        let messages = [Message.init(userID: "", message: "Hey! I am interested in the  property you’ve listed. I was thinking of having a look at it. Can we schedule a tour? and Is the price listed fixed? Thanks.", image: nil, video: nil, atch: nil, type: .Text),
    //                        Message.init(userID: "", message: "Hey! I am interested in the  property you’ve listed. I was thinking of having a look at it. Can we schedule a tour? and Is the price listed fixed? Thanks.", image: nil, video: nil, atch: nil, type: .Text),
    //                        Message.init(userID: "", message: "Hey! I am interested in the  property you’ve listed. I was thinking of having a look at it. Can we schedule a tour? and Is the price listed fixed? Thanks.", image: nil, video: nil, atch: nil, type: .Text),
    //                        Message.init(userID: "", message: "Hey! I am interested in the  property you’ve listed. I was thinking of having a look at it. Can we schedule a tour? and Is the price listed fixed? Thanks.", image: nil, video: nil, atch: nil, type: .Text)]
    //
    //        messages.first?.isOwnMessage = false
    //        messages[2].isOwnMessage = false
    //        return messages
    //    }
}

typealias GetMessage = (_ message: MessageChat?) -> ()

class SocketIOManager: NSObject {
    
    static let shared = SocketIOManager()
    
    var socketManager: SocketManager?
    var socketClient: SocketIOClient?
    let currentUser = GDataSingleton.sharedInstance.loggedInUser
    var isAuthenticated = false
    
    var msg: GetMessage?
    
    override init() {
        super.init()
        socketManager = SocketManager.init(socketURL: URL.init(string: APIConstants.BasePath )!, config: [.connectParams(["userType":"2", TrackingConstants.id : TrackingConstants.userId, TrackingConstants.secretdbkey: AgentCodeClass.shared.loggedAgent?.cbl_customer_domains?.first?.db_secret_key ?? "b6405ad1d46ff3c6022810838a5742d1"]), .forceNew(true)])
        socketClient = socketManager?.defaultSocket
        //addHandlers()
    }
    
    func addHandlers() {
        
        print("======= Initial Connection Status ========" , socketClient?.status)
        
        if socketClient?.status == .connected {
            self.isAuthenticated = true
            return
        }
        
        socketClient?.on(clientEvent: .connect, callback: { (data, ack) in
            //
            //self.setUpListeners()
            //            self.addUser(/self.socketClient?.sid)
            print("Socket Connected with success")
            print("Socket Connected" + /self.socketClient?.sid)
        })
        
        socketClient?.on(clientEvent: .error, callback: { (data, ack) in
            print("Error connecting")
            //            self.isAuthenticated = false
            //            SocketIOManager.shared.connect()
        })
        
        socketClient?.on(clientEvent: .disconnect, callback: { (data, ack) in
            print("Socket Disconnected")
            self.isAuthenticated = false
            //SocketIOManager.shared.connect()
            //             self.setUpListeners()
            //             self.addUser(/self.socketClient?.sid)
            
        })
        socketClient?.connect()
        
    }
    
    func setUpListeners() {
        
//
        socketClient?.on("parameterError", callback: {  [ weak self ] (data, ack) in
            print(/JSON.init(data).rawString())
        })
        
        
        socketClient?.on(SocketEvent.receiveMessage.rawValue, callback: {  [ weak self ] (data, ack) in
            print(/JSON.init(data).rawString())
            if let json = JSON(data).arrayValue.first {
                let message = MessageChat(attributes: json["detail"].dictionaryValue)
                if let block = self?.msg {
                    block(message)
                }
            }
        })
    }
    
    func disConnectMsgEvent(){
        socketClient?.off(SocketEvent.receiveMessage.rawValue)
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
            //            self.addUser(/self.socketClient?.sid)
            //            self.isAuthenticated = true
            
        }
    }
    
    func addMessage(_ data: [String : Any]) {
        let dict = ["detail":data]
        print(dict)

        //        socketClient?.emit(SocketEvent.sendMessage.rawValue, data)
        socketClient?.emitWithAck(SocketEvent.sendMessage.rawValue, dict ).timingOut(after: 1) { responseData in
            print(responseData)
        }
        
        //        //MARK::- EMIT AND LISTENERS
        //        func sendCurrentLocation(data: [String : Any],ack : @escaping  (Bool) -> ()) {
        //            socketClient?.emitWithAck(SocketEvent.currentLocation.rawValue, data ).timingOut(after: 1) { responseData in
        //            }
        //        }
        
        //        var dictionaryKeysToSend: [String: Any] = [String : Any]()
        //        dictionaryKeysToSend["api_token"] = /UserData.share.loggedInUser?.token
        //        dictionaryKeysToSend["user_id"] = /UserData.share.loggedInUser?.id
        //        dictionaryKeysToSend["socket_id"] = /socketID
        //        dictionaryKeysToSend["device_id"] = /UIDevice.current.identifierForVendor?.uuidString
        //        print("making socket stream")
        //        print(dictionaryKeysToSend)
        //
        ////        if let status = socketClient?.status {
        ////            ( status == .connected && !isAuthenticated)  ?
        ////
        //        if !isAuthenticated {
        //            self.isAuthenticated = true
        //            print("User Added")
        //            socketClient?.emit(SocketEvent.addUser.rawValue, dictionaryKeysToSend)
        //
        //        }
        //        //: print("Socket not connected")
        ////        }
    }
    
    func disconnect() {
        
        guard let socket = socketClient else { return }
        if socket.status == .disconnected {
            return
        } else {
            print("disconnected")
            
            self.isAuthenticated = false
            socket.disconnect()
        }
    }
}

class ChatListing: NSObject {
    
    var lastMessage: String?
    var time: String?
    var lastVideo: String?
    //    var lastImage: String?
    var otherUser: User?
    var convoId: String?
    
    init(lastMessage: String? , time: String? , otherUser: User? ) {
        
    }
    
    init(attributes: OptionalJSON) {
        super.init()
        let lastMessageObj = attributes?["last_message"]?.dictionaryValue
        lastMessage = lastMessageObj?["message"]?.stringValue
        lastVideo = lastMessageObj?["video"]?.stringValue
        let lastImage1 = /lastMessageObj?["image"]?.stringValue
        let thumb = lastImage1.replacingOccurrences(of: "/uploads/", with: "/thumbs/400x400/")
        
        let updatedAt = lastMessageObj?["updated_at"]?.stringValue
        let otherUserDetails = attributes?["other"]?.dictionaryValue
        otherUser = User(attributes: otherUserDetails)
        convoId = attributes?["id"]?.stringValue
        //        time = calculateTimeSince(time: /updatedAt)
    }
    
    override init() {
        super.init()
    }
    
    class func getMessageListing(array : [JSON]) -> [ChatListing]? {
        var tempArr : [ChatListing] = []
        for dict in array {
            tempArr.append(ChatListing(attributes: dict.dictionaryValue))
        }
        return tempArr
    }
    
}

enum PermissionType {
    
    case camera
    case photos
    case locationInUse
    case contacts
    case microphone
    
    var message:String {
        switch self {
        case .camera: return "for camera access".localized()
        case .photos: return ""
        case .locationInUse: return ""
        case .contacts: return ""
        case .microphone: return ""
        }
    }
    
}

class CheckPermission {
    
    static let shared = CheckPermission()
    
    
    //MARK: - Check Permission
    func permission(_ For : PermissionType, openSettingsAlert: Bool? = true, requestAccess: Bool? = true, completion: @escaping (Bool) -> () ) {
        
        switch status(For: For) {
        case 1,2:
            
            self.alert(show: openSettingsAlert ?? true, permissionType: For)
            completion(false)
        default:
            
            switch For {
            case .camera:
                AVCaptureDevice.requestAccess(for: AVMediaType.video,
                                              completionHandler: { granted in
                                                completion(granted)
                })
                
            default: completion(true)
            }
        }
        
    }
    
    fileprivate func alert(show: Bool, permissionType: PermissionType) {
        if show {
            let actionSheetController = UIAlertController(title: "Permission Required".localized(), message: permissionType.message, preferredStyle: .alert)
            
            let cancelActionButton = UIAlertAction(title: "Cancel".localized(), style: .cancel) { action -> Void in
                print("Cancel")
            }
            actionSheetController.addAction(cancelActionButton)
            
            let openSettingActionButton = UIAlertAction(title: "Open Settings".localized() , style: .default, handler: { (action) in
                self.openAppSettings()
            })
            actionSheetController.addAction(openSettingActionButton)
            UIApplication.topViewController()?.presentVC(actionSheetController)
        }
    }
    
    //MARK: - Open App Settings
    func openAppSettings() {
        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
        
        if UIApplication.shared.canOpenURL(settingsUrl) {
            
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: { (success) in
                    print("Settings opened: \(success)")
                })
            } else {
                // Fallback on earlier versions
            }
        }
    }
    
    
    //MARK: - Check Status
    func status(For: PermissionType) -> Int {
        
        switch For {
        case .camera:
            return AVCaptureDevice.authorizationStatus(for: AVMediaType.video).rawValue
            
        case .contacts:
            return CNContactStore.authorizationStatus(for: .contacts).rawValue
            
        case .locationInUse:
            guard CLLocationManager.locationServicesEnabled() else { return 2 }
            return Int(CLLocationManager.authorizationStatus().rawValue)
            
        case .photos:
            return PHPhotoLibrary.authorizationStatus().rawValue
            
        case .microphone:
            let recordPermission = AVAudioSession.sharedInstance().recordPermission
            return Int(recordPermission.rawValue)
            
        }
        
    }
    
    
    
    
    
}

//S3 upload
//class Upload {
//
//
//
//
//
//    static func postRequestWithImages( isDocType : Bool = false , type: MessageType , withApi api : String, parameters: [String: String] ,  images : [UIImage? ]?, success : @escaping HttpClientSuccess , failure : @escaping HttpClientFailure , header: [String: String]){
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
//        let fullPath = APIConstants.basePath + api
//        print(fullPath)
//        print(header)
//        print(parameters)
//        if isDocType{
//            Utility.functions.loader()
//        }
//        Alamofire.upload(multipartFormData: { (multipartFormData) in
//
//            if let arrayImages = images{
//                for (i, image) in arrayImages.enumerated() {
//
//                    guard let image = image?.resize(with: 1200) , let imageData = UIImageJPEGRepresentation(image, 0.5) else {
//                        return }
//                    if arrayImages.count == 1{
//                        if isDocType{
//
//                            multipartFormData.append(imageData, withName: "attachment", fileName: "image.png", mimeType:"image/png" )
//                        }else{
//                            multipartFormData.append(imageData, withName: "image", fileName: "image.png", mimeType:"image/png" )
//                        }
//
//
//                    }else{
//                        multipartFormData.append(imageData, withName: "image\(i+1)", fileName: "photo\(i+1).png", mimeType: "image/jpg")
//                    }
//
//                }
//            }
//
//            for (key, value) in parameters {
//                let val  = value as? String ?? ""
//                multipartFormData.append(val.data(using: String.Encoding.utf8)!, withName: key)
//            }
//
//        }, to: fullPath , headers : ["Authorization":"Bearer " + /UserData.share.loggedInUser?.token ] ) { (encodingResult) in
//            UIApplication.shared.isNetworkActivityIndicatorVisible = false
//            switch encodingResult {
//            case .success(let upload,_,_):
//
//                upload.responseJSON { response in
//                    Utility.functions.removeLoader()
//                    switch response.result {
//                    case .success(let data):
//                        let jsondata = JSON(data)
//
//                        switch type{
//                        case .Image:
//                            let successdata = jsondata["data"].dictionaryValue
//                            let imageString = successdata["image"]?.stringValue
//                            success(imageString , response.response?.statusCode ?? 0)
//
//                        default: break
//                        }
//
//                    case .failure(let error):
//                        print(error)
//                        failure(error.localizedDescription)
//                    }
//                }
//
//            case .failure(let encodingError):
//                Utility.functions.removeLoader()
//                print(encodingError)
//                print(encodingError.localizedDescription)
//                failure(encodingError.localizedDescription)
//            }
//        }
//    }
//
//    static func sendVideo(video: Data? , header: [String: String] , image: UIImage? , parameters: [String:Any] , success: @escaping (String,String)->() , failure: @escaping (NSError)->() , url: String){
//        print(parameters)
//        Alamofire.upload(
//            multipartFormData: {
//                multipartFormData in
//
//
//                guard let videoData = video, let image = image ,let imgData = UIImageJPEGRepresentation(image, 0.5) else { return  }
//
//                multipartFormData.append(imgData, withName: "thumb", fileName: "image.jpg", mimeType: "image/jpeg")
//                multipartFormData.append(videoData, withName: "video", fileName: "video.mp4", mimeType: "video/mp4")
//
//                for (key, value) in parameters {
//                    let val  = value as? String ?? ""
//                    multipartFormData.append(val.data(using: String.Encoding.utf8)!, withName: key)
//                }
//
//                print(multipartFormData)
//
//        },
//            to: url , headers : ["Authorization":"Bearer " + /UserData.share.loggedInUser?.token ] ) { encodingResult in
//                switch encodingResult {
//                case .success(let upload, _, _):
//
//                    upload.responseJSON { response in
//                        print(response)
//                        switch response.result {
//                        case .success(let data):
//                            let resp = JSON(data)
//                            let successdata = resp["data"].dictionaryValue
//                            let video = /successdata["video"]?.stringValue
//                            let thumb = /successdata["thumb"]?.stringValue
//                            success(video , thumb)
//                        case .failure(let error):
//                            print(error)
//                            failure(error as NSError)
//                        }
//
//                    }
//                case .failure(let encodingError):
//                    print(encodingError)
//                    failure(encodingError as NSError)
//                }
//
//        }
//
//    }
//
//
//
//    static func uploadDocument(doc: MessageDoc , parameters: [String:Any] , success: @escaping (String)->() , failure: @escaping (NSError)->() , url: String){
//        print(parameters)
//        print(["Authorization":"Bearer " + /UserData.share.loggedInUser?.token ])
//        Utility.functions.loader()
//        Alamofire.upload(
//            multipartFormData: {
//                multipartFormData in
//
//                guard let videoData = doc.data  else { return  }
//
//                let mimeaType = /(/doc.fileName?.components(separatedBy: ".").last).mimeTypeFromFileExtension()
//                multipartFormData.append(videoData, withName: "attachment", fileName: /doc.fileName , mimeType: mimeaType)
//
//                for (key, value) in parameters{
//                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
//                }
//
//
//        },
//            to: url, headers : ["Authorization":"Bearer " + /UserData.share.loggedInUser?.token ] ) { encodingResult in
//                Utility.functions.removeLoader()
//                switch encodingResult {
//                case .success(let upload, _, _):
//
//                    upload.responseJSON { response in
//                        print(response)
//                        let resp = JSON(response.result.value)
//                        let successdata = resp["data"].dictionaryValue
//                        let attachment = /successdata["name"]?.stringValue
//                        print(attachment)
//                        success(attachment)
//                    }
//                case .failure(let encodingError):
//                    print(encodingError)
//                    failure(encodingError as NSError)
//                }
//
//        }
//
//    }
//}

public func calculateTimeBK(time : String , format: String? = "") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = NSTimeZone.local
    let date = dateFormatter.date(from: time) ?? Date()
    let dateFormatter1 = DateFormatter()
    dateFormatter1.dateFormat = format == "" ? "MMM d yyyy. h:mm a" : format
    dateFormatter1.timeZone = TimeZone.current
    return dateFormatter1.string(from: date)
}

public func calculateTime(time : String , format: String? = "") -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    dateFormatter.timeZone = NSTimeZone.local
    let date = dateFormatter.date(from: time) ?? Date()
    let dateFormatter1 = DateFormatter()
    dateFormatter1.dateFormat = format == "" ? "MMM d yyyy, h:mm a" : format
    dateFormatter1.timeZone = TimeZone(abbreviation: "UTC")
    return dateFormatter1.string(from: date)
}

extension Date{
    
    func getDateFromStr(str: String , newFormat: String) -> Date{
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeZone = NSTimeZone.local
        formatter.dateFormat = newFormat
        let date = formatter.date(from: str)
        return date ?? Date()
    }
    
    func changeFormat(newFormat: String?) -> String{
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeZone = NSTimeZone.local
        formatter.dateFormat = newFormat
        let dateString = formatter.string(from: self)
        return dateString
    }
    
}

extension UtilityFunctions {
    
    class func show(nativeActionSheet title : String? , subTitle : String? , vc : UIViewController? , senders : [Any] , success : @escaping (Any,Int) -> ()){
        
        let alertController =  UIAlertController(title: nil, message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        for (index,element) in senders.enumerated() {
            alertController.addAction(UIAlertAction(title: element as? String ?? "", style: UIAlertAction.Style.default , handler: { (action) in
                success(element, index)
            }))
            
            
        }
        alertController.addAction(UIAlertAction(title: "Cancel".localized() , style: UIAlertAction.Style.destructive, handler: nil))
        vc?.present(alertController, animated: true, completion: nil)
        
    }
    
    static func show(alert title:String , message:String  , buttonOk: @escaping () -> (), buttonCancel: @escaping () -> () , viewController: UIViewController , buttonText: String , cancelButtonText: String  ){
        
        let alertController = UIAlertController(title: title, message: message , preferredStyle: UIAlertController.Style.alert)
        alertController.addAction(UIAlertAction(title: buttonText , style: UIAlertAction.Style.destructive, handler: {  (action) in
            buttonOk()
        }))
        alertController.addAction(UIAlertAction(title: cancelButtonText , style: UIAlertAction.Style.cancel, handler: {  (action) in
            buttonCancel()
        }))
        viewController.present(alertController, animated: true, completion: nil)
    }
    
}
