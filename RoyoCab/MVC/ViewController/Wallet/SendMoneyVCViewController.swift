//
//  SendMoneyVCViewController.swift
//  RoyoRide
//
//  Created by Rohit Prajapati on 08/06/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import UIKit

class SendMoneyVCViewController: UIViewController {
    
    //MARK:- Outlets
    @IBOutlet weak var txfAmount: UITextField!
    @IBOutlet weak var txfPhoneNumber: UITextField!
    @IBOutlet weak var btnFlagImage: UIImageView!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var btnSendMoneyOulets: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        btnSendMoneyOulets.setButtonWithBackgroundColorSecondaryAndTitleColorBtnText()
      
        
    }

    @IBAction func btnCountryCode(_ sender: Any) {
        guard let countryPicker = R.storyboard.mainCab.countryCodeSearchViewController() else{return}
               countryPicker.delegate = self
               self.presentVC(countryPicker)
    }
    
    @IBAction func dismissrTapped(_ sender: Any) {
        self.dismissVC(completion: nil)
    }
    
    @IBAction func btnSendMoney(_ sender: Any) {
        
        sendMoney(amount: /txfAmount.text, phone_code: lblCountryCode.text, phone_number: /txfPhoneNumber.text)
        
    }
    
    
    func sendMoney(amount: String?, phone_code: String?, phone_number: String?) {
        
        if phone_code?.trimmed() == "" ||  phone_number?.trimmed() == "" {
            Alerts.shared.show(alert: "AppName".localizedString, message: "Please enter amount and phome number", type: .error )
        } else {
            let token = /UDSingleton.shared.userData?.userDetails?.accessToken
            let walletTransferService = BookServiceEndPoint.walletTransfer(amount: amount, phone_code: phone_code, phone_number: phone_number)
            if #available(iOS 16.0, *) {
                walletTransferService.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) { (response) in
                    switch response {
                        
                    case .success(let data):
                        print("success")
                        self.dismissVC {
                            NotificationCenter.default.post(name: NSNotification.Name(rawValue: LocalNotifications.updateWallet.rawValue), object: nil, userInfo: nil)
                        }
                        //self.dismissVC(completion: nil)
                        
                    case .failure(let strError):
                        
                        Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
                    }
                }
            } else {
                // Fallback on earlier versions
            }

        }
        
    }
    
}

//MARK: - Country Picker Delegates

extension SendMoneyVCViewController: CountryCodeSearchDelegate {
    
    func didTap(onCode detail: [AnyHashable : Any]!) {
        
        btnFlagImage.image = UIImage(named:/(detail["code"] as? String)?.lowercased())
        //lblCountryAbbr.text = /(detail["code"] as? String)
        lblCountryCode.text = /(detail["dial_code"] as? String)
        
        //iso = /(detail["code"] as? String)
    }
    
    func didSuccessOnOtpVerification() {
        
    }
    
    
}
