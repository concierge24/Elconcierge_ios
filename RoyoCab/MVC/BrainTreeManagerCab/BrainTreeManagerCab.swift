//
//  BrainTreeManager.swift
//  RoyoRide
//
//  Created by Prashant on 08/08/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import UIKit
import Braintree
import BraintreeDropIn

typealias SuccessNonceCab = (String) -> ()
typealias PaymentErrorCab = ((Error?) -> ())

class BrainTreeManagerCab: NSObject {
    
    static let sharedInstance = BrainTreeManagerCab()
    
     private var braintreeClient: BTAPIClient!
     private var dataCollector: BTDataCollector?
    
    var successNonce:SuccessNonceCab?
    var errorCallback:PaymentErrorCab?
    
    override init() {
        super.init()
        
    }
    
    //MARK: - Client token
       private var token:String? = nil {
           didSet {
               if let safeValue = token, let apiClient = BTAPIClient(authorization: safeValue) {
                   self.dataCollector = BTDataCollector(apiClient: apiClient)
               }
           }
       }
    
    
    
       //MARK: - Clear clinet token
       func clearClientToken() {
           self.token = nil
       }
       
       //MARK: Get Client token
       func fetchClientToken(barrier: Bool = true , success: @escaping (String?)->(), callback: ((Error?)->())? = nil) {
        
          let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        let brainTreeToken = BookServiceEndPoint.getBraintreeToken
        
        
//        brainTreeToken.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) { (response) in
//            
//            switch response {
//                
//            case .success(let data):
//            guard let tokObj = data as? BraintreeModel,let tok = tokObj.token else { return }
//                                  self.token = tok
//                                  success(/tok)
//               
//                
//            case .failure(let strError):
//                
//                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
//            }
//        }
        
        
  
          // APIManager.shared.showLoader()
//           let objR = API.getBraintreeToken
//           APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
//               [weak self] (response) in
//               guard let self = self else { return }
//                APIManager.sharedInstance.hideLoader()
//               switch response {
//               case APIResponse.Success(let object):
//                   guard let tok = object as? String else { return }
//                   self.token = tok
//                   success(/tok)
//               default :
//                   print("Hello Nitin")
//                   break
//               }
//
//           }
       }
    
    
    
      //MARK: - Collect fraud data
      func collectDeviceData(barrier:Bool = true, completion: @escaping (String) -> () ) {
          
          if let safeValue = dataCollector {
              if barrier { APIManagerCab.shared.showLoader() }
              safeValue.collectFraudData { (device) in
                  if barrier { APIManagerCab.shared.hideLoader() }
                  debugPrint(device)
                  completion(device)
              }
          } else {
              self.fetchClientToken(barrier: barrier, success: { [unowned self] (token) in
                  if barrier { APIManagerCab.shared.showLoader() }
                  self.dataCollector?.collectFraudData { (device) in
                      if barrier { APIManagerCab.shared.hideLoader() }
                      debugPrint(device)
                      completion(device)
                  }
              }) { (error) in
                  debugPrint(/error?.localizedDescription)
              }
          }
      }
    
}



//MARK: - Paypal Payment
extension BrainTreeManagerCab: BTViewControllerPresentingDelegate, BTAppSwitchDelegate {
    
    func payViaPayPal(amount:String = "1.00", success: @escaping SuccessNonce, cancelled: (()->())? = nil, callback: PaymentError? = nil) {
        
        self.fetchClientToken(barrier: true, success: { [unowned self] (token) in
            
            self.braintreeClient = BTAPIClient(authorization: /token)
            let payPalDriver = BTPayPalDriver(apiClient: self.braintreeClient)
            payPalDriver.viewControllerPresentingDelegate = self
            payPalDriver.appSwitchDelegate = self
            
            let request = BTPayPalRequest()
            request.billingAgreementDescription = "Your agremeent description"
            APIManagerCab.shared.showLoader()
            payPalDriver.requestBillingAgreement(request, completion: { (tokenizedPayPalAccount, error) in
                  APIManagerCab.shared.hideLoader()
                guard let tokenizedPayPalAccount = tokenizedPayPalAccount else {
                    if let error = error {
                        // Handle error
                        callback?(error)
                    } else {
                        // User canceled
                        cancelled?()
                    }
                    return
                }
                
                var message:String = ""
                message += "email: \(/tokenizedPayPalAccount.email)\n"
                message += "firstName: \(/tokenizedPayPalAccount.firstName)\n"
                message += "lastName: \(/tokenizedPayPalAccount.lastName)\n"
                message += "phone: \(/tokenizedPayPalAccount.phone)\n"
                message += "billingAddress: \(tokenizedPayPalAccount.billingAddress)\n"
                message += "shippingAddress: \(tokenizedPayPalAccount.shippingAddress)\n"
                message += "clientMetadataId: \(/tokenizedPayPalAccount.clientMetadataId)\n"
                message += "payerId: \(/tokenizedPayPalAccount.payerId)\n"
                message += "nonce: \(tokenizedPayPalAccount.nonce)\n"
                message += "type: \(tokenizedPayPalAccount.type)\n"
                message += "localizedDescription: \(tokenizedPayPalAccount.localizedDescription)\n"
                
                debugPrint(message)
                
                print("Got a nonce! \(tokenizedPayPalAccount.nonce)")
                success(tokenizedPayPalAccount.nonce)
            })
                        
        }) { (error) in
            callback?(error)
        }
        
        
        
    }
    
    //MARK: - ViewController Delegates
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
        
        UIApplication.topViewController()?.present(viewController, animated: true, completion: nil)
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    //MARK: - App Switch Delegates
    func appSwitcherWillPerformAppSwitch(_ appSwitcher: Any) {
        showPayPalLoadingUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.hidePayPalLoadingUI), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    func appSwitcher(_ appSwitcher: Any, didPerformSwitchTo target: BTAppSwitchTarget) {
        
    }
    
    func appSwitcherWillProcessPaymentInfo(_ appSwitcher: Any) {
        hidePayPalLoadingUI()
    }
    
    //MARK: - PayPal Loader methods
    private func showPayPalLoadingUI() {
        APIManagerCab.shared.showLoader()
    }
    
    @objc private func hidePayPalLoadingUI() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        APIManagerCab.shared.hideLoader()
    }
    
    
}
