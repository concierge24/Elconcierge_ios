//
//  HTTPClient.swift
//  BusinessDirectory
//
//  Created by Aseem 13 on 04/01/17.
//  Copyright © 2017 Taran. All rights reserved.
//

import Foundation
import Alamofire

typealias HttpClientSuccessCab = (Any? , Int) -> ()
typealias HttpClientFailureCab = (String) -> ()

var googleRestaurantUrl = ""

class HTTPClientCab {
    
    func JSONObjectWithData(data: NSData) -> Any? {
        do { return try JSONSerialization.jsonObject(with: data as Data, options: []) }
        catch { return .none }
    }
    
    func postRequest(withApi api : RouterCab , images : [UIImage?]? = []   , success : @escaping HttpClientSuccessCab , failure : @escaping HttpClientFailureCab , header: [String: String] ){
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        var fullPath = ""
        let params = api.parameters
        
        if api.route.contains("developers.zomato.com") || api.route.contains("maps.googleapis.com") {
            fullPath = api.route
        }else{
            fullPath = api.baseURL + api.route
        }
        
        if api.route.contains("https://maps.googleapis.com/maps"){
            fullPath = googleRestaurantUrl
        }
        
        let method = api.method
        
        var newHeader = header
        let bearerToken = header["authorization"]
        if /bearerToken == "bearer "{
            newHeader["authorization"] = "bearer"
        }
        
        print("======== fullPath ========")
        print(fullPath)
        print(params)
        
        guard let arrIamges = images else{return}
        if arrIamges.count > 0 {
            
            Alamofire.upload(
                multipartFormData: { multipartFormData in
                    
                    if let paramters = params  {
                        
                        for (key,value) in paramters{
                            multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                        }
                    }
                    
                    
                    for (i, image) in arrIamges.enumerated()  {
                        
                        if let imageWrapped = image {
                            let imageData = imageWrapped.jpegData(compressionQuality: 0.5)
                            
                            if api.route == APITypes.editProfile {
                                multipartFormData.append(imageData!, withName: Keys.profile_pic.rawValue, fileName: "image.jpg", mimeType: "image/jpg")
                            }else if api.route == APITypes.requestAPI {
                                
                                let imgeParmName = Keys.order_images.rawValue + "[\(i)]"
                                
                                let name = imgeParmName + ".jpg"
                                multipartFormData.append(imageData!, withName: Keys.order_images.rawValue , fileName: name, mimeType: "image/jpg")
                                
                            }
                        }
                    }
            },
                to: fullPath ,
                method: method ,
                headers: newHeader,
                encodingCompletion: { encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.uploadProgress(closure: { (progress) in
                            debugPrint(progress)
                        })
                        upload.responseJSON { (response) in
                            
                            print(">>>>>>=========== Request ===========")
                            print(fullPath)
                            print(method)
//                            print(headers)
                            print(params ?? "No params")
                            
                            print(">>>>>>=========== response ===========")
                            print(response)
                            
                            
                            switch response.result {
                            case .success(let data):
                                success(data , response.response?.statusCode ?? 0)
                                
                            case .failure(let error):
                                failure(error.localizedDescription)
                            }
                        }
                    case .failure(let encodingError):
                        failure(encodingError.localizedDescription)
                    }
            })
        } else {
            
            debugPrint(params)
            Alamofire.request(fullPath, method: method, parameters: params, encoding: URLEncoding.default, headers: newHeader).responseJSON { (response) in
                
                print(">>>>>>=========== Request ===========")
                print(fullPath)
                print(method)
//                print(headers)
                print(params ?? "No params")
                
                print(">>>>>>=========== response ===========")
                print(response)
                
                
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
                switch response.result {
                case .success(let data):
                    success(data , response.response?.statusCode ?? 0)
                    
                case .failure(let error):
                    debugPrint(response.response?.statusCode)
                    failure(error.localizedDescription)
                }
            }
        }
    }
    
}



