//
//  ChatHttpClient.swift
//  Sneni
//
//  Created by Harminder on 23/03/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON


extension APIConstants {
    static let conversations = "getChat"
    static let socketBase = "https://api-saas.royoapps.com/"
}

enum Response {
    case success(Any?)
    case failure(Any?)
}

typealias Completion = (Response) -> ()

func isConnectedToNetwork() -> Bool {
    guard let reachability = Alamofire.NetworkReachabilityManager()?.isReachable else { return false }
    return reachability ? true: false
}

enum ChatEndPoint{
    case getConversation(limit:String, skip:String? , order_id:String? , receiver_created_id:String? )
}

extension ChatEndPoint: RouterChat {
    //MARK::-  HANDLE RESPONSE
    func handle(parameters: JSON) -> Any? {
        switch self {
            
        case .getConversation(_):
            return MessageChat.getMessageListing(array: parameters["data"].arrayValue)
        }
    }
    
    func request(isImage: Bool = false , images: [UIImage?]? = [] , isLoaderNeeded: Bool? = true , header: [String: String] , completion: @escaping Completion ) {
        
        APIManagerChat.shared.request(with: self, isLoaderNeeded: isLoaderNeeded, completion: completion, header: header)
        
    }
    
    
    var route : String  {
        
        switch self {
        case .getConversation(_): return APIConstants.conversations
        }
    }
    
    var parameters: OptionalDictionary {
        var format1 = format()
        return format1
    }
    
    
    func format() -> OptionalDictionary {
        
        switch self {
            
        case .getConversation(let limit, let skip , let order_id , let receiver_created_id ):
            return ["userType":"2","limit":limit,"skip":skip,"order_id":order_id,"receiver_created_id":receiver_created_id,"accessToken":/GDataSingleton.sharedInstance.loggedInUser?.token]
            
        }
    }
    
    
    var method : Alamofire.HTTPMethod {
        switch self {
        case .getConversation(_):
            return .get
        default:
            return .post
        }
    }
    
    var baseURL: String {
        return APIConstants.BasePath
    }
    
    
}


enum Validate : Int {
    
    case none
    case success = 201
    case notFound = 404
    case failure = 400
    case sessionExpire = 401
    case invalidAccessToken = 2
    case fbLogin = 3
    
    
    func map(response message : String?) -> String? {
        
        switch self {
        case .success:
            return message
        case .failure :
            return message
            
        default:
            return nil
        }
        
    }
}


class APIManagerChat : UIViewController{
    
    
    static let shared = APIManagerChat()
    private lazy var httpClient : HTTPClientChat = HTTPClientChat()
    
    func request(with api : RouterChat , isLoaderNeeded: Bool? = true , completion : @escaping Completion , header: [String: String] )  {
        
        if !isConnectedToNetwork(){
            SKToast.makeToast("You need to enable interet connection".localized())
            
            return
        }
        
        if isLoaderNeeded ?? true {
            APIManager.sharedInstance.showLoader()
            
        }
        
        
        
        httpClient.postRequest(withApi: api, success: { [weak self] (data , statusCode) in
            
            if /statusCode == 500 {
                self?.tokenExpired(isTokenExpire: false)
            }
            
            APIManager.sharedInstance.hideLoader()
            
            guard let response = data else {
                completion(Response.failure(.none))
                return
            }
            let json = JSON(response)
            print(json)
            
            var responseType = Validate(rawValue: json["statusCode"].intValue) ?? .failure
            if /json["message"].stringValue == "Unauthenticated." {
                //logout
                SKToast.makeToast("Session Expired".localized())
                
            }
            if statusCode == 200{
                responseType = Validate.success
            }else{
                if statusCode == Validate.notFound.rawValue{
                    completion( Response.success("") )
                }
                
                if statusCode == Validate.failure.rawValue{
                    completion(Response.failure( json[APIConstants.message].stringValue ))
                }
                if statusCode == Validate.sessionExpire.rawValue || json["success"].intValue == 500  {
                    self?.tokenExpired(isTokenExpire: false)
                    return
                }
            }
            
            if responseType == Validate.success{
                
                let object : Any?
                object = api.handle( parameters: json )
                completion( Response.success(object) )
                
                return
            }else{
                completion(Response.failure( json[APIConstants.message].stringValue )) }
            
            }, failure: {[weak self] (message) in
                
                completion(Response.failure( message ))
                
            }, header: header)
        
    }
    
    
    
    
    func tokenExpired(isTokenExpire: Bool){
        
        SKToast.makeToast("Sorry your account has been logged in other device, Please login to continue".localized())
        
        if #available(iOS 10.0, *) {
            let delegate = UIApplication.shared.delegate as? AppDelegate
            //            delegate?.sessionExpired()
        } else {
            // Fallback on earlier versions
        }
        //        delegate?.logout()
    }
    
    func isLoaderNeeded(api : RouterChat) -> Bool{
        
        switch api.route {
        default: return true
        }
    }
    
    
    
    
}

class UserData {
    
    static var share: UserData = {
        return UserData()
    }()
    
    var currentConversationId: String? {
        get{
            guard let userData = UserDefaults.standard.data(forKey: "currentConversationId") else { return "" }
            return (NSKeyedUnarchiver.unarchiveObject(with: userData) as? String)
        }
        set{
            if let value = newValue{
                let val = NSKeyedArchiver.archivedData(withRootObject: value)
                UserDefaults.standard.set(val, forKey: "currentConversationId" )
            }else{
                UserDefaults.standard.set(nil, forKey: "currentConversationId" )
            }
        }
    }
    
    var currentAgentId: String? {
        get{
            guard let userData = UserDefaults.standard.data(forKey: "currentAgentId") else { return "" }
            return (NSKeyedUnarchiver.unarchiveObject(with: userData) as? String)
        }
        set{
            if let value = newValue{
                let val = NSKeyedArchiver.archivedData(withRootObject: value)
                UserDefaults.standard.set(val, forKey: "currentAgentId" )
            }else{
                UserDefaults.standard.set(nil, forKey: "currentAgentId" )
            }
        }
    }
    
    
}

typealias HttpClientSuccessChat = (Any? , Int) -> ()
typealias HttpClientFailureChat = (String) -> ()


protocol RouterChat {
    var route : String { get }
    var baseURL : String { get }
    var parameters : OptionalDictionary { get }
    var method : Alamofire.HTTPMethod { get }
    func handle(parameters : JSON) -> Any?
    func request( isImage: Bool  , images: [ UIImage? ]? , isLoaderNeeded : Bool? , header: [String: String] , completion : @escaping Completion  )
}

class HTTPClientChat {
    
    
    
    
    func JSONObjectWithData(data: NSData) -> Any? {
        do { return try JSONSerialization.jsonObject(with: data as Data, options: []) }
        catch { return .none }
    }
    
    func postRequest(withApi api : RouterChat  , success : @escaping HttpClientSuccessChat , failure : @escaping HttpClientFailureChat , header: [String: String] ){
        
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
        }
        var fullPath = ""
        let params = api.parameters
        
        fullPath = APIConstants.BasePath + api.route
        
        
        let method = api.method
        
        var parameters = params
        
        var newHeader = header
        let bearerToken = header["authorization"]
        if /bearerToken == "bearer "{
            newHeader["authorization"] = "bearer"
        }
        if /GDataSingleton.sharedInstance.loggedInUser?.token == ""{
            newHeader = [:]
        }
        print(fullPath)
        print(parameters )
        print(newHeader)
        Alamofire.request(fullPath, method: method, parameters: parameters, encoding: URLEncoding.default, headers: newHeader).responseJSON { (response) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            switch response.result {
            case .success(let data):
                success(data , response.response?.statusCode ?? 0)
                
            case .failure(let error):
                print(response.response?.statusCode)
                print(error.localizedDescription)
                failure(error.localizedDescription)
            }
        }
    }
    
    
    
}
