//
//  TipScreen.swift
//  Trava
//
//  Created by CHANCHAL WARDE on 10/04/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import UIKit

class TipScreen: UIViewController {
    
    
    //MARK:- IBOutlet
    @IBOutlet var tfAmount: UITextField!
    
    
    //MARK:- Variable
    var orderId : Int?
    var amountAdded : (_ amount : Int) -> Void = { _ in }
    
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}

//MARK:- Textfield Delegate

extension TipScreen : UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        verifyAndDimiss()
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
    
    func verifyAndDimiss() {
        
        guard let text = tfAmount.text else { showError(); return }
        guard let amount = tfAmount.text?.toInt() else { showError();  return }
        guard  amount > 0 else {showError() ;  return }
        
        apiToTip(amount : amount)
        //        self.dismissVC(completion: nil)
    }
    
    func showError() {
        Alerts.shared.show(alert: "", message: "Please enter amount", type: .info)
    }
    
    
    @IBAction func dismiss(_ sender  : UIButton) {
        self.dismissVC(completion: nil)
    }
    
    func apiToTip(amount : Int?) {
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        if #available(iOS 16.0, *) {
            BookServiceEndPoint.addTip(tip: amount, orderId: orderId, gateway_unique_id: /UDSingleton.shared.appSettings?.appSettings?.gateway_unique_id).request(header:  ["language_id" : LanguageFile.shared.getLanguage(), "access_token" :  token], completion: {
                [weak self] (response) in
                
                switch response {
                    
                case .success(let data):
                    self?.amountAdded(amount ?? 0)
                    self?.dismissVC(completion: nil)
                    
                case .failure(let strError):
                    Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
                }
            })
        } else {
            // Fallback on earlier versions
        }
    }
    
}

