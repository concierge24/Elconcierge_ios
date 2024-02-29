//
//  RazorpayVC.swift
//  Buraq24
//
//  Created by Apple on 28/07/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import UIKit
import Razorpay

class RazorpayVC: UIViewController, RazorpayPaymentCompletionProtocol {

    typealias Razorpay = RazorpayCheckout
    var razorpay: Razorpay?
    var razorpayTestKey = "rzp_test_NZM3rbof3YhW1p"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        razorpay = Razorpay.initWithKey(razorpayTestKey, andDelegate: self)
        showPaymentForm()
        // Do any additional setup after loading the view.
    }
    
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
      //  self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    internal func showPaymentForm(){
        let options: [String:Any] = [
            "amount": "100", //This is in currency subunits. 100 = 100 paise= INR 1.
            "currency": "INR",//We support more that 92 international currencies.
            "description": "Product Cost",
            "image": "https://url-to-image.png",
            "name": "business or product name",
            "prefill": [
                "contact": "9797979797",
                "email": "foo@bar.com"
            ],
            "theme": [
                "color": "#F37254"
            ]
        ]
        razorpay?.open(options)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
