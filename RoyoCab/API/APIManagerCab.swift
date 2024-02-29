
import Foundation
import SwiftyJSON
import NVActivityIndicatorView
import Alamofire
 
typealias CompletionCab = (ResponseCab) -> ()

class APIManagerCab : UIViewController {
    
    static let shared = APIManagerCab()
    private lazy var httpClient : HTTPClientCab = HTTPClientCab()
    
    func request(with api : RouterCab , images: [UIImage?]? = [] , isLoaderNeeded: Bool? = true , completion : @escaping CompletionCab , header: [String: String] )  {
        
        if !isConnectedToNetwork() {
            Alerts.shared.show(alert: "AppName".localizedString, message: "Validation.InternetNotWorking".localizedString , type: .error)

            return completion(ResponseCab.failure("No Internet connection"))
        }

        if isLoaderNeeded ?? true {
            
            startAnimating(CGSize(width: 24, height: 24), message: nil, messageFont: nil, type: .ballScale, color: UIColor.white, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: nil, fadeInAnimation: nil)
            
        }
        
              var extendedHeader = header
               extendedHeader["secretdbkey"] = APIBasePath.secretDBKey
               extendedHeader["language_id"] = UserDefaultsManager.languageId
               
               debugPrint(extendedHeader)
        
        httpClient.postRequest(withApi: api, images:images ,success: {[weak self] (data , statusCode) in
            
            guard let response = data else {
                self?.stopAnimating()

                completion(ResponseCab.failure(.none))
                return
            }
            
            let json = JSON(response)
            debugPrint(json)
          var responseType = ValidateCab(rawValue: json[APIConstantsCab.success.rawValue].stringValue) ?? .failure
            if statusCode == 200 || statusCode == ValidateCab.lastRideCharges.rawValue.toInt() {
                responseType = ValidateCab.success
            }

            if json[APIConstantsCab.statusCode.rawValue].stringValue == ValidateCab.validation.rawValue {
                responseType = ValidateCab.validation

            }else if json[APIConstantsCab.statusCode.rawValue].stringValue == ValidateCab.apiError.rawValue {
                   responseType = ValidateCab.apiError
                
            }else if json[APIConstantsCab.statusCode.rawValue].stringValue == ValidateCab.invalidAccessToken.rawValue {
                responseType = ValidateCab.invalidAccessToken
            }
            
            if responseType == ValidateCab.success{
                let object : Any?
                object = api.handle( parameters: json )
                self?.stopAnimating()

                completion( ResponseCab.success(object as AnyObject))
                return
            }else if  responseType == ValidateCab.validation ||  responseType == ValidateCab.apiError {
                self?.stopAnimating()
                completion(ResponseCab.failure( json[APIConstantsCab.message.rawValue].stringValue ))
                
            }
            else if   responseType == ValidateCab.invalidAccessToken {
                UDSingleton.shared.tokenExpired()
            }
            
            }, failure: {[weak self] (message) in
                self?.stopAnimating()
                completion(ResponseCab.failure( message ))
                
        }, header: extendedHeader)
    }

    func tokenExpired(isTokenExpire: Bool) {
       // Alerts.shared.show(alert: .oops, message:  "Sorry, your account has been logged in other device! Please login again to continue." , type: .error)
      //  UserDefaultsManager.shared.tokenExpired()
    }
    
    func isLoaderNeeded(api : Router) -> Bool {
        switch api.route {
        default: return true
        }
    }

  func isConnectedToNetwork() -> Bool {
    guard let reachability = Alamofire.NetworkReachabilityManager()?.isReachable else { return false }
    return reachability ? true: false
    
   }
    
    func showLoader() {
    
      guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
      appDelegate.window?.rootViewController?.startAnimating(CGSize(width: 24, height: 24), message: nil, messageFont: nil, type: .ballScale, color: UIColor.white, padding: nil, displayTimeThreshold: nil, minimumDisplayTime: nil, backgroundColor: nil, textColor: nil, fadeInAnimation: nil)
     }
     
     func hideLoader(){
       guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else{return}
         appDelegate.window?.rootViewController?.stopAnimating()
     }
}

