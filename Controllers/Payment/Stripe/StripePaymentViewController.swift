//
//  StripePaymentViewController.swift
//  Sneni
//
//  Created by Gagandeep Singh on 18/03/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit
import Stripe

class StripePaymentViewController: UIViewController {
    
    //MARK::- OUTLETS
    @IBOutlet var tfCardDetails: STPPaymentCardTextField!
    @IBOutlet var tfname: UITextField?
    @IBOutlet var btnAddCard: UIButton?{
        didSet{
            btnAddCard?.setBackgroundColor(SKAppType.type.color, forState: .normal)
        }
    }
    
    //MARK::- PROPERTIES
    var paymentDone: (() -> ())?
    
    //MARK::- VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.modalPresentationStyle = .currentContext
        // Do any additional setup after loading the view.
    }
    
    //MARK::- ACTIONS


    
    @IBAction func actionAddCard(_ sender: UIButton) {
        
        
        if /self.tfCardDetails.cardNumber?.isBlank || /self.tfCardDetails.cvc?.isBlank || /self.tfname?.text?.isBlank {
            SKToast.makeToast("Please fill out all card details.")
            return
        }
        hitAddCardApi()
    }
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        self.dismissVC(completion: nil)
    }
    
    
    
    func hitAddCardApi(){

        let params = (FormatAPIParameters.addCard(user_id: GDataSingleton.sharedInstance.userId, card_type: "", card_number: "\(/tfCardDetails.cardNumber)", exp_month: "\(/tfCardDetails?.expirationMonth.toInt)", exp_year: "\(/tfCardDetails?.expirationYear.toInt)", card_token: "", gateway_unique_id: "stripe", cvc: /tfCardDetails.cvc, card_holder_name : /tfname?.text).formatParameters())

            let objR = API.addCard(params)
        APIManager.sharedInstance.opertationWithRequest(isLoader: true, withApi: objR) {
                [weak self] (response) in
                
                switch response {
                case .Success(let object):
                    let value = object as? AddCard
                    print (value?.customer_payment_id)
                    GDataSingleton.sharedInstance.customerPaymentId = /value?.customer_payment_id
                    self?.paymentDone!()
                     self?.dismissVC(completion: nil)
                default:
                    break
                }
            
        }
    }
    
}
