//
//  NetworkAdapter.swift
//  Nequore
//
//  Created by MAC_MINI_6 on 12/07/18.
//  Copyright © 2018 Code-Brew Labs. All rights reserved.
//

import Foundation
import Moya
import ObjectMapper
import SwiftyJSON

private func JSONResponseDataFormatter(_ data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data)
        let prettyData =  try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData
    } catch {
        return data // fallback to original data if it can't be serialized.
    }
}

extension TargetType {
    func provider<T:TargetType>() -> MoyaProvider<T> {
        return MoyaProvider<T>(plugins: [(NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter))])
    }
    
    func request(isLoaderNed: Bool = true , success successCallback: @escaping (AnyObject) -> Void, error errorCallback: @escaping (Swift.Error) -> Void, failure failureCallback: @escaping (MoyaError) -> Void) {
       
        provider().request(self) { (result) in
            switch result {
            case .success(let response):
                do {
                    
                    let json = try JSONSerialization.jsonObject(with: response.data, options: []) as? [String : Any]
                    
                    if (json?["status"] as? String) == "OK" {
                        let mappedData = self.parse(response: json)
                        successCallback(mappedData as AnyObject)
                    } else {
                        successCallback(json as AnyObject)
                    }
                }  catch let error as NSError {
                     print(error.localizedDescription)
                }
            case .failure(let error):
                print(error)
                do {
                    //          let json = try JSONSerialization.jsonObject(with: error.response?.data ?? Data(), options: []) as? [String : Any]
                    //          let data = User(map: Map(mappingType: .fromJSON, JSON: json!))
                    //          if /data?.message == "Please login" {
                    //            CommonFuncs.shared.logout(/data?.message)
                    //          } else {
                    //            ToastManager.shared.showToastAPI(/data?.message)
                    //          }
                } catch let error as NSError {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
}





