//
//  APIClient.swift
//  Clikat
//
//  Created by cbl73 on 4/22/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import Foundation
import Alamofire
import AFNetworking
import SwiftyJSON

typealias HttpClientSuccess = (Any?) -> ()
typealias HttpClientFailure = (String) -> ()

class HTTPClient {
    
    func JSONObjectWithData(data: Data) -> Any? {
        do { return try JSONSerialization.jsonObject(with: data, options: []) }
        catch { return .none }
    }
    
    func postRequest(refreshControl : UIRefreshControl? = nil, withApi api : API  , success : @escaping HttpClientSuccess , failure : @escaping HttpClientFailure )  {
        
        let params = api.parameters
        let fullPath = /apiApiPath(api: api) + api.route
        let method = api.method
        let headers: HTTPHeaders? = apiHeader(api: api)
        
        print(">>>>>>=========== Pre Request ===========")
        print(fullPath)
        
        if let params = params, let dataBody = try? JSONSerialization.data(withJSONObject: params) {
            guard let url = URL(string: fullPath) else {
                failure("Please enter valid agent code!")
                return}
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.allHTTPHeaderFields = headers
            
            if !params.isEmpty {
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                request.httpBody = dataBody
            }
            
            Alamofire.request(request)
                .responseJSON {
                    (response) in
                    
                    refreshControl?.endRefreshing()
                    
                    print(">>>>>>=========== Post Request ===========")
                    print(fullPath)
                    print(method)
                    print(headers ?? "NA")
                    print(params )
                    
                    //            DispatchQueue.main.async {
                    
                    switch response.result {
                    case .success(let data):
                        success(data)
                    case .failure(let error):
                        print(error )
                        if let dataStr = response.data {
                            print(String(data: dataStr, encoding: .utf8))
                        }
                        failure(error.localizedDescription)
                    }
                    
            }
            return
        }
        
        Alamofire.request(fullPath, method: method, parameters: params, encoding: JSONEncoding.default, headers: headers).responseJSON {
            (response) in
            
            print(">>>>>>=========== Request ===========")
            print(fullPath)
            print(method)
            print(headers ?? "NA")
            print(params ?? "NA")
            
            
            switch response.result {
            case .success(let data):
                success(data)
            case .failure(let error):
                print(error )
                failure(error.localizedDescription)
            }
            
        }
    }
    
    func postRequest(withApi api : API,image : UIImage?, success : @escaping HttpClientSuccess , failure : @escaping HttpClientFailure){
        
        let params = api.parameters
        let fullPath = APIConstants.BasePath + api.route
        // let method = api.method
        let headers: HTTPHeaders? = apiHeader(api: api)
        print(fullPath)
        print(params)
        Alamofire.upload(multipartFormData: { (formData) in
            if let ppic = image, let data = ppic.jpegData(compressionQuality: 0.0) {
                switch api {
                case .UploadReceipt(_), .uploadPrescription(_):
                    formData.append(data, withName: "file", fileName: "temp" + "\(Int(arc4random_uniform(100000)))" + ".jpeg", mimeType: "image/jpeg")
                default:
                    formData.append(data, withName: "profilePic", fileName: "temp" + "\(Int(arc4random_uniform(100000)))" + ".jpeg", mimeType: "image/jpeg")
                }
            }
            for (key, value) in params ?? [:] {
                formData.append(("\(value)" as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                
            }
        }, to: fullPath,headers:headers) { (result) in
            switch result {
            case .success(request:let req, streamingFromDisk: _, streamFileURL: _):
                req.responseJSON(completionHandler: { (response) in
                    switch response.result {
                    case .success(let data):
                        success(data)
                    case .failure(let error):
                        failure(error.localizedDescription)
                    }
                })
                req.responseString(completionHandler: { (response) in
                    print(response)
                })
            case .failure(let error):
                failure(error.localizedDescription)
            }
        }
        
    }
    
    func isLoaderNeeded(api : API) -> Bool{
        switch api {
            
        case .RateProduct(_) , .OrderDetail(_): return true
        case .GetAgentDBKeys: return true
        case .ServiceAgentlist(_): return true
        case .GenerateOrder(_): return true
        case .getAgentAvailabilties(_), .getAgentAvailabilty, .verifySlot(_): return true
            
        default:
            return false
        }
    }
    
    func apiApiPath(api : API) -> String?{
        
        switch api {
            
        case .ServiceAgentlist(_), .getAgentAvailabilties, .getSlotAvailabilties, .getAgentAvailabilty, .verifySlot(_) : return  APIConstants.agentBasePath
            
        case .getBotResponce :
            return  SKAppType.type.apiBot
            
        case .getSecretKey(_): return APIConstants.agentTokenBasePath
            
        default: return  APIConstants.BasePath
            
        }
    }
    
    func apiHeader(api : API) -> HTTPHeaders?{
        
        switch api {
        case .getBotResponce :
            return  [
                "Content-Type":"application/json",
                "Authorization":"Bearer \(SKAppType.type.apiBotKey)"
            ]
            
        case .ServiceAgentlist(_), .getAgentAvailabilties(_), .getAgentAvailabilty, .getSlotAvailabilties, .verifySlot(_):
            var headers: HTTPHeaders? = nil
            
            var apikey:String?
            var db_SecretKey:String?
            
            let agentDBSecretKey  =  GDataSingleton.sharedInstance.agentDBSecretKey
            agentDBSecretKey?.agentDBData?.forEach({ (obj) in
                
                if obj.key == "api_key"{
                    apikey = obj.value
                }
                else if obj.key == "secret_key"{
                    db_SecretKey = obj.value
                }        
            })
            
            headers = ["api_key": /apikey,
                       "secret_key": AgentCodeClass.shared.agentSecretKey]
            return headers
            
        case .getSecretKey(_) : return [:]
        default:
            let token = /(GDataSingleton.sharedInstance.loggedInUser?.token)
            if token.isEmpty {
                return ["secretdbkey":AgentCodeClass.shared.clientSecretKey]
                
            }
            return [
                "secretdbkey":AgentCodeClass.shared.clientSecretKey,
                "Authorization": /(GDataSingleton.sharedInstance.loggedInUser?.token),
            ]
        }
    }
    
}
