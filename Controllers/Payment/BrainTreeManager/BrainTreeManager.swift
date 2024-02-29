//
//  BrainTreeManager.swift
//  Bart
//
//  Created by Paradox on 17/11/18.
//  Copyright © 2018 OSX. All rights reserved.
//

import Foundation
import PassKit
import Braintree
import BraintreeDropIn


typealias SuccessNonce = (String) -> ()
typealias PaymentError = ((Error?) -> ())


class BrainTreeManager: NSObject {
    
    static let sharedInstance = BrainTreeManager()
    
    private var braintreeClient: BTAPIClient!
    private var dataCollector: BTDataCollector?
    
    var applePaySupportedNetworks:[PKPaymentNetwork] {
        get {
            return [.visa, .masterCard, .amex, .discover]
        }
    }
    
    var successNonce:SuccessNonce?
    var errorCallback:PaymentError?
    
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
        APIManager.sharedInstance.showLoader()
        let objR = API.getBraintreeToken
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
             APIManager.sharedInstance.hideLoader()
            switch response {
            case APIResponse.Success(let object):
                guard let tok = object as? String else { return }
                self.token = tok
                success(/tok)
            default :
                print("Hello Nitin")
                break
            }
           
        }
    }
    
    //MARK: - Drop In UI
    func showDropIn(clientTokenOrTokenizationKey: String, amount:String, success: @escaping (BTDropInResult?)->(), errorCallback:((Error?)->())? = nil) {
        
        let request =  BTDropInRequest()
        request.vaultManager = true
     //   request.amount = amount //e.g: amount = 3.00
        //request.currencyCode = "USD"
        request.threeDSecureVerification = true
        
        BTUIKAppearance.sharedInstance().primaryTextColor = UIColor.blue
        BTUIKAppearance.sharedInstance()?.fontFamily = "Helvetica"
        
        
        let dropIn = BTDropInController(authorization: clientTokenOrTokenizationKey, request: request) { (controller, result, error) in
            if (error != nil) {
                debugPrint("ERROR")
                errorCallback?(error)
                
            } else if (result?.isCancelled == true) {
                debugPrint("CANCELLED")
                
            } else if let result = result {
                
                debugPrint(result.paymentDescription)
                success(result)
                // Use the BTDropInResult properties to update your UI
                // result.paymentOptionType
                // result.paymentMethod
                // result.paymentIcon
                // result.paymentDescription
                
            }
            controller.dismiss(animated: true, completion: nil)
        }
        
        DispatchQueue.main.async {
            guard let vc = dropIn else { return }
            UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
        }
        
    }
    
    //MARK: - Collect fraud data
    func collectDeviceData(barrier:Bool = true, completion: @escaping (String) -> () ) {
        
        if let safeValue = dataCollector {
            if barrier { APIManager.sharedInstance.showLoader() }
            safeValue.collectFraudData { (device) in
                if barrier { APIManager.sharedInstance.hideLoader() }
                debugPrint(device)
                completion(device)
            }
        } else {
            self.fetchClientToken(barrier: barrier, success: { [unowned self] (token) in
                if barrier { APIManager.sharedInstance.showLoader() }
                self.dataCollector?.collectFraudData { (device) in
                    if barrier { APIManager.sharedInstance.hideLoader() }
                    debugPrint(device)
                    completion(device)
                }
            }) { (error) in
                debugPrint(/error?.localizedDescription)
            }
        }
    }
    
    
}


//MARK: -  Card Payment
extension BrainTreeManager: BTCardFormViewControllerDelegate, BTDropInControllerDelegate {
    
    func payViaCreditOrDebitCard(amount:String = "1.00", success: @escaping SuccessNonce, callback: PaymentError? = nil) {
        
        /** Get client token */
        self.fetchClientToken(success: { [weak self] (token) in
            
            self?.braintreeClient = BTAPIClient(authorization: /token)
            self?.successNonce = success
            self?.errorCallback = callback
            self?.openCardFormController(requestAmount: amount)
            
        }) { (error) in
            callback?(error)
        }
        
    }
    
    //MARK: - Card form Conrtroller
    private func openCardFormController(requestAmount: String) {
        let request = BTDropInRequest()

        let cardFormVc = BTCardFormViewController(apiClient: self.braintreeClient, request: request)
        
        cardFormVc.delegate = self
        cardFormVc.supportedCardTypes = [1,3,6,4,5]
        
        let navController = UINavigationController(rootViewController: cardFormVc)
        navController.modalPresentationStyle = .overCurrentContext
        UIApplication.topViewController()?.present(navController, animated: true, completion: nil)
    
    }
    
    //MARK: - CardFormViewController delegate
    func cardTokenizationCompleted(_ tokenizedCard: BTPaymentMethodNonce?, error: Error?, sender: BTCardFormViewController) {
        if error != nil, let callBack = self.errorCallback {
            callBack(error)
            
        } else if let safeValue = tokenizedCard, let success = self.successNonce {
            sender.dismiss(animated: true) {
                success(safeValue.nonce)
            }
            
        } else {
            //cancelled
        }
    }
    
    //MARK: - DropInController delegate
    func reloadDropInData() {
        
    }
    
    func editPaymentMethods(_ sender: Any) {
        
    }
    
}

//MARK: - Paypal Payment
extension BrainTreeManager: BTViewControllerPresentingDelegate, BTAppSwitchDelegate {
    
    func payViaPayPal(amount:String = "1.00", success: @escaping SuccessNonce, cancelled: (()->())? = nil, callback: PaymentError? = nil) {
        
        self.fetchClientToken(barrier: true, success: { [unowned self] (token) in
            
            self.braintreeClient = BTAPIClient(authorization: /token)
            let payPalDriver = BTPayPalDriver(apiClient: self.braintreeClient)
            payPalDriver.viewControllerPresentingDelegate = self
            payPalDriver.appSwitchDelegate = self
            
            let request = BTPayPalRequest()
            request.billingAgreementDescription = "Your agremeent description"
            
            payPalDriver.requestBillingAgreement(request, completion: { (tokenizedPayPalAccount, error) in
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
        APIManager.sharedInstance.showLoader()
    }
    
    @objc private func hidePayPalLoadingUI() {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
        APIManager.sharedInstance.hideLoader()
    }
    
    
}


//MARK: - Venmo Payment
extension BrainTreeManager {
    
    func payViaVenmo( success: @escaping SuccessNonce, callback: PaymentError? = nil) {
        
        self.fetchClientToken(barrier: true, success: { [unowned self] (token) in
            
            self.braintreeClient = BTAPIClient(authorization: /token)
            let venmoDriver = BTVenmoDriver(apiClient: self.braintreeClient)
            venmoDriver.authorizeAccountAndVault(false) { (btVenmoAccountNonce, error) in
                if error != nil {
                    callback?(error)
                    return
                }
                
                guard let safeValue = btVenmoAccountNonce else { return }
                
                var message:String = ""
                message += "username: \(safeValue.username ?? "")"
                message += "nonce: \(safeValue.nonce)"
                message += "nonce: \(safeValue.nonce)\n"
                message += "type: \(safeValue.type)\n"
                message += "localizedDescription: \(safeValue.localizedDescription)\n"
                
                debugPrint(message)
                
                success(safeValue.nonce)
            }
            
        }) { (error) in
            callback?(error)
        }
        
    }
    
    
}

//MARK: - Apple Pay
extension BrainTreeManager: PKPaymentAuthorizationViewControllerDelegate {
    
    //MARK: - Setup
    func setupPaymentRequest(item_name:String? = "Parking", amount:String = "1.00", completion: @escaping (PKPaymentRequest?, Error?)->()) {
        
        self.fetchClientToken(barrier: true, success: { [unowned self] (token) in
            
            self.braintreeClient = BTAPIClient(authorization: /token)
            let applePayClient = BTApplePayClient(apiClient: self.braintreeClient)
            // You can use the following helper method to create a PKPaymentRequest which will set the `countryCode`,
            // `currencyCode`, `merchantIdentifier`, and `supportedNetworks` properties.
            // You can also create the PKPaymentRequest manually. Be aware that you'll need to keep these in
            // sync with the gateway settings if you go this route.
            applePayClient.paymentRequest { (paymentRequest, error) in
                guard let paymentRequest = paymentRequest else {
                    completion(nil, error)
                    return
                }
                
                // We recommend collecting billing address information, at minimum
                // billing postal code, and passing that billing postal code with all
                // Apple Pay transactions as a best practice.
                paymentRequest.requiredBillingContactFields = [.postalAddress]
                
                // Set other PKPaymentRequest properties here
                paymentRequest.merchantCapabilities = .capability3DS
                /*paymentRequest.paymentSummaryItems =
                    [
                        PKPaymentSummaryItem(label: /item_name, amount: NSDecimalNumber(string: /amount)),
                        // Add add'l payment summary items...
                        PKPaymentSummaryItem(label: "BART Official", amount: NSDecimalNumber(string: /amount)),
                ]*/
                completion(paymentRequest, nil)
            }
            
        }) { (error) in
            completion(nil, error)
        }
    }
    
    //MARK: - Pay
    func payViaApplePay(item_name:String? = "Parking", amount:String = "1.00", success: @escaping SuccessNonce, callback: PaymentError? = nil) {
        
        self.successNonce = success
        self.errorCallback = callback
        
        if PKPaymentAuthorizationViewController.canMakePayments(usingNetworks: self.applePaySupportedNetworks) {
            
            self.setupPaymentRequest { [unowned self] (paymentRequest, error) in
                guard error == nil else {
                    callback?(error)
                    return
                }
                
                if let requset = paymentRequest, let vc = PKPaymentAuthorizationViewController(paymentRequest: requset) {
                    vc.delegate = self
                    UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
                } else {
                    print("Error: Payment request is invalid.")
                }
            }
            
        } else {
            print("Error: Cannot make payments")
        }
        
    }
    
    //MARK: - Delegate
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        
        let applePayClient = BTApplePayClient(apiClient: braintreeClient!)
        applePayClient.tokenizeApplePay(payment) { [unowned self] (tokenizedApplePayPayment, error) in
            guard let tokenizedApplePayPayment = tokenizedApplePayPayment else {
                // Tokenization failed. Check `error` for the cause of the failure.
                
                // Indicate failure via completion callback.
                //completion(PKPaymentAuthorizationStatus.failure)
                if let callback = self.errorCallback {
                    callback(error)
                }
                completion(PKPaymentAuthorizationResult(status: PKPaymentAuthorizationStatus.failure, errors: []))
                return
            }
            
            // Received a tokenized Apple Pay payment from Braintree.
            
            // Send the nonce to your server for processing.
            print("nonce = \(tokenizedApplePayPayment.nonce)")
            if let success = self.successNonce {
                //UtilityFunctions.makeToast(text: , type: .success)
                success(tokenizedApplePayPayment.nonce)
            }
            
            // If requested, address information is accessible in `payment` and may
            // also be sent to your server.
            print("billingPostalCode = \(payment.billingContact?.postalAddress?.postalCode ?? "no addess available")")
            
            // Then indicate success or failure via the completion callback, e.g.
            completion(PKPaymentAuthorizationResult(status: PKPaymentAuthorizationStatus.success, errors: []))
        }
    }
    
    
    
}


