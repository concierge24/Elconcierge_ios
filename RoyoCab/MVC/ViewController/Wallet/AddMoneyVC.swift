//
//  AddMoneyVC.swift
//  RoyoRide
//
//  Created by Prashant on 24/06/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import UIKit

class AddMoneyVC: UIViewController {
    
    typealias AmountEntered = (Int)->()
    
    @IBOutlet weak var btnContinue: UIButton!
    @IBOutlet weak var txtFldAmount:UITextField!
    
    var amountEntered:AmountEntered?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
          btnContinue.setButtonWithBackgroundColorSecondaryAndTitleColorBtnText()
    }
    
    @IBAction func dismissrTapped(_ sender: Any) {
           self.dismissVC(completion: nil)
       }
    

    @IBAction func btnContinueAction(_ sender:UIButton){
        
        guard let amount = txtFldAmount.text?.toInt() else{return}
        
        if amount <= 0{
            
              Alerts.shared.show(alert: "AppName".localizedString, message: "Wallet.AddAmountLess".localizedString , type: .error )
        }
        else{
            
            if let amountEntered = amountEntered{
                
                self.dismissVC {
                     amountEntered(amount)
                }
               
            }
            else{
                
                 self.dismissVC(completion: nil)
            }
        }
        
    }
    
    

}
