//
//  NTAddPhoneNumberViewController.swift
//  RoyoRide
//
//  Created by Ankush on 18/05/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import UIKit

import UIKit

class NTAddPhoneNumberViewController: UIViewController {
    
    @IBOutlet var viewPhone: UIView!
    @IBOutlet weak var viewContainer: UIView!
    
    @IBOutlet var txtFieldMobileNo: UITextField!
    
    @IBOutlet weak var buttonNext: UIButton!
    
    @IBOutlet var lblCountryCode: UILabel!
    @IBOutlet var lblISOCode: UILabel!
    
    var signup_as: LoginSignupType?
    var socialId: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
}

extension NTAddPhoneNumberViewController {
    
    func initialSetup() {
        setupUI()
        setupData()
    }
    
    func setupUI() {
        
        buttonNext.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        buttonNext.setButtonWithTintColorBtnText()
        
        txtFieldMobileNo.delegate = self
    }
    
    
    func setupData() {
        
        lblCountryCode.text =  UDSingleton.shared.appSettings?.appSettings?.default_country_code ?? DefaultCountry.countryCode.rawValue
        lblISOCode.text =  UDSingleton.shared.appSettings?.appSettings?.iso_code ?? DefaultCountry.ISO.rawValue
        
    }
}

//MARK:- Button Selector
extension NTAddPhoneNumberViewController {
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        
        // 1- Back, 2- Next, 3- Country code
        
        switch sender.tag {
        case 1:
            popVC()
            
        case 2:
            debugPrint("Next")
            let code = /lblCountryCode.text
            let number = /txtFieldMobileNo.text?.trimmed()
            
            if Validations.sharedInstance.validatePhoneNumber(phone: number) {
                
                self.sendOtp(code: code, number: number)
                
            }
            
        case 3:
            debugPrint("Country code")
            guard let countryPicker = R.storyboard.mainCab.countryCodeSearchViewController() else{return}
            countryPicker.delegate = self
            self.presentVC(countryPicker)
            
            
        default:
            break
        }
    }
}

//MARK: - Country Picker Delegates

extension NTAddPhoneNumberViewController: CountryCodeSearchDelegate {
    
    func didTap(onCode detail: [AnyHashable : Any]!) {
        
        lblCountryCode.text = /(detail["dial_code"] as? String)
        lblISOCode.text = /(detail["code"] as? String)
    }
    
    func didSuccessOnOtpVerification() {
        
    }
    
    
}

//MARK:- API

extension NTAddPhoneNumberViewController {
    
    func sendOtp(code:String, number:String) {
        
        guard let accountType = signup_as else {return}
        
        let sendOTP = LoginEndpoint.sendOtp(countryCode: code, phoneNum: number, iso: lblISOCode.text, social_key: socialId, signup_as: accountType.rawValue)
        sendOTP.request( header: ["language_id" : LanguageFile.shared.getLanguage()]) {[weak self] (response) in
            switch response {
                
            case .success(let data):
                
                guard let model = data as? SendOtp else { return }
                model.countryCode = code
                model.mobileNumber = number
                model.iso = self?.lblISOCode.text
                
                guard let vc = R.storyboard.newTemplateLoginSignUp.ntVerificationCodeViewController() else{return}
                vc.sendOTP = model
                vc.social_key = self?.socialId
                vc.signup_as = self?.signup_as
                self?.pushVC(vc)
                
                break
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
                //Toast.show(text: strError, type: .error)
            }
        }
    }
}

//MARK:- UItextfield delegates

extension NTAddPhoneNumberViewController : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        guard let text = textField.text else { return true }
        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        
        if  string == numberFiltered {
            if text == "" && string == "0" {
                return false
            }
            let newLength = text.length + string.length - range.length
            return newLength <= 15
        } else {
            return false
        }
    }
}

