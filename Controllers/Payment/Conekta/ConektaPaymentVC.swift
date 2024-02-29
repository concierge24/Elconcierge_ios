//
//  ConektaPaymentVC.swift
//  Sneni
//
//  Created by Harminder on 25/03/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit
import Foundation

class ConektaPaymentVC: UIViewController {


    @IBOutlet weak var numberCardUI: UITextField!
    @IBOutlet weak var nameCardUI: UITextField!
    @IBOutlet weak var expMonthUI: UITextField!
    @IBOutlet weak var expYearUI: UITextField!
    @IBOutlet weak var cvcUI: UITextField!
    @IBOutlet weak var outTokenUI: UILabel!
    @IBOutlet weak var outUUID_UI: UILabel!
    
    //MARK::- PROPERTIES
    var paymentDone: ((_ token: String?) -> ())?
    var key = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func tokenizeBtn(_ sender: UIButton) {
         APIManager.sharedInstance.showLoader()
        let conekta = Conekta()
        conekta.delegate = self
        conekta.publicKey = key
        conekta.collectDevice()
        
        let card : Card = conekta.card()
        card.setNumber(numberCardUI.text, name: nameCardUI.text, cvc: cvcUI.text , expMonth: expMonthUI.text, expYear: expYearUI.text)
        
        let token = conekta.token()
        token?.card = card
        
        token?.create(success: { (data) -> Void in
             APIManager.sharedInstance.hideLoader()
            if let data = data as NSDictionary? as! [String:Any]? {
                self.outTokenUI.text = data["id"] as? String
                self.outUUID_UI.text = conekta.deviceFingerprint()
                if let id = (data["id"] as? String) {
                    self.paymentDone?(id)
                    self.dismissVC(completion: nil)
                }
            }
        }, andError: { (error) -> Void in
            APIManager.sharedInstance.hideLoader()
            SKToast.makeToast(error?.localizedDescription)

        })
    }
}
