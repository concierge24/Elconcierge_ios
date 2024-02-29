//
//  PaystackPaymentVC.swift
//  Sneni
//
//  Created by Daman on 19/05/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit
import Paystack

class PaystackPaymentVC: UIViewController, PSTCKPaymentCardTextFieldDelegate {

    //MARK::- OUTLETS
    @IBOutlet var tfCardDetails: PSTCKPaymentCardTextField! {
        didSet {
            tfCardDetails.delegate = self
        }
    }
    @IBOutlet var btnAddCard: UIButton?{
        didSet{
            btnAddCard?.setBackgroundColor(SKAppType.type.color, forState: .normal)
        }
    }
    
    //MARK::- PROPERTIES
    var email: String?
    var netAmount: Double?
    let card : PSTCKCard = PSTCKCard()
    var paymentDone: ((String) -> ())?
    
    //MARK::- VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.modalPresentationStyle = .currentContext
        // Do any additional setup after loading the view.
    }
    
    //MARK::- ACTIONS


    
    @IBAction func actionAddCard(_ sender: UIButton) {
        self.view.endEditing(true)
        if tfCardDetails.isValid {
            fetchAccessCodeAndChargeCard()
        }
        else {
            self.showOkayableMessage("An error occured", message: "Please enter valid card number")
        }
    }
    
    func fetchAccessCodeAndChargeCard() {
        guard let email = email, let netAmount = netAmount else { return }
        let objR = API.getPaystackAccessCode(email: email, netAmount: netAmount)
        
        APIManager.sharedInstance.opertationWithRequest(isLoader: true, withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            
            switch response {
            case APIResponse.Success(let object):
                if let obj = object as? PayStackData, let accessCode = obj.access_code {
                    self.chargeWithSDK(newCode: accessCode)
                }
                break
            default :
                break
            }
        }
    }
     func chargeWithSDK(newCode: String){
            let transactionParams = PSTCKTransactionParams.init();
            transactionParams.access_code = newCode
            //transactionParams.additionalAPIParameters = ["enforce_otp": "true"];
    //        transactionParams.email = "ibrahim@paystack.co";
    //        transactionParams.amount = 2000;
    //        let dictParams: NSMutableDictionary = [
    //            "recurring": true
    //        ];
    //        let arrParams: NSMutableArray = [
    //            "0","go"
    //        ];
    //        do {
    //            try transactionParams.setMetadataValueDict(dictParams, forKey: "custom_filters");
    //            try transactionParams.setMetadataValueArray(arrParams, forKey: "custom_array");
    //        } catch {
    //            print(error)
    //        }
            // use library to create charge and get its reference
            PSTCKAPIClient.shared().chargeCard(self.tfCardDetails.cardParams, forTransaction: transactionParams, on: self, didEndWithError: { (error, reference) in
                print(error)
                if let errorDict = (error._userInfo as! NSDictionary?){
                    if let errorString = errorDict.value(forKeyPath: "com.paystack.lib:ErrorMessageKey") as! String? {
                        if let reference=reference {
                            self.showOkayableMessage("An error occured while completing "+reference, message: errorString)
                            //self.verifyTransaction(reference: reference)
                        } else {
                            self.showOkayableMessage("An error occured", message: errorString)
                        }
                    }
                }
            }, didRequestValidation: { (reference) in
            }, willPresentDialog: {
                // make sure dialog can show
                // if using a "processing" dialog, please hide it
            }, dismissedDialog: {
                // if using a processing dialog, please make it visible again
            }) { (reference) in
                self.paymentDone?(reference)
                self.dismissVC(completion: nil)
            }
            return
        }
    
    @IBAction func btnActionBack(_ sender: UIButton) {
        self.dismissVC(completion: nil)
    }
    
    // MARK: Helpers
    func showOkayableMessage(_ title: String, message: String){
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: UIAlertController.Style.alert
        )
        let action = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

}
