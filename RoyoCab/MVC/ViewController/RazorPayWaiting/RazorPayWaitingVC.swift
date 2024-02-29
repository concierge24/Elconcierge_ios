//
//  RazorPayWaitingVC.swift
//  RoyoRide
//
//  Created by Rohit Prajapati on 13/07/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import UIKit
import Razorpay

class RazorPayWaitingVC: UIViewController {
    
    typealias Razorpay = RazorpayCheckout
    var razorpay: Razorpay?
    var razorpayTestKey = /UDSingleton.shared.appSettings?.appSettings?.razorpaytestkey
    var order_id = String()
    var order: OrderCab?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        showPaymentForm()
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
    }
    
    
    
    func intailiseRazorpay(){
        razorpay = Razorpay.initWithKey(razorpayTestKey, andDelegate: self)
    }
    
    internal func showPaymentForm() {
        intailiseRazorpay()
        
        let finalCharge = Int(Double(/order?.payment?.finalCharge)!)
        let totalCharge = finalCharge * 100
        
        let options: [String:Any] = [
            "amount": String(totalCharge), //This is in currency subunits. 100 = 100 paise= INR 1.
            "currency": "INR",//We support more that 92 international currencies.
            "description": "Product Cost",
            "image": "https://url-to-image.png",
            "name": "Royo",
            "prefill": [
                "contact": /UDSingleton.shared.userData?.userDetails?.user?.phoneNumber,
                "email": /UDSingleton.shared.userData?.userDetails?.user?.email
            ],
            "theme": [
                "color": /UDSingleton.shared.appSettings?.appSettings?.app_color_code
            ]
        ]
        razorpay?.open(options)
    }

}

extension RazorPayWaitingVC: RazorpayPaymentCompletionProtocol {
    
    
    func onPaymentError(_ code: Int32, description str: String) {
        let alertController = UIAlertController(title: "FAILURE", message: str, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
      //  self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        let alertController = UIAlertController(title: "SUCCESS", message: "Payment Id \(payment_id)", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
      // self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        
        razorPayment(order_id: String(/order?.orderId), payment_id: payment_id)
        
    }
    
    
    func razorPayment(order_id: String, payment_id: String) {
         let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        let walletBalance = BookServiceEndPoint.razorPayReturnUrl(order_id: order_id, payment_id: payment_id)
        if #available(iOS 16.0, *) {
            walletBalance.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) { (response) in
                
                switch response {
                    
                case .success(let data):
                    
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: HomeVC.self) {
                            
                            self.navigationController!.popToViewController(controller, animated: true)
                            NotificationCenter.default.post(name: Notification.Name("RazorPaySucccess"), object: nil)
                            break
                        }
                    }
                    
                    break
                    
                case .failure(let strError):
                    Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
                    
                    for controller in self.navigationController!.viewControllers as Array {
                        if controller.isKind(of: HomeVC.self) {
                            
                            self.navigationController!.popToViewController(controller, animated: true)
                            NotificationCenter.default.post(name: Notification.Name("RazorPaySucccess"), object: nil)
                            break
                        }
                    }
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
}
