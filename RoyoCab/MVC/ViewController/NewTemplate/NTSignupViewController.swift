//
//  NTSignupViewController.swift
//  RoyoRide
//
//  Created by Ankush on 15/05/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import UIKit

class NTSignupViewController: UIViewController {
    
    @IBOutlet var viewPhone: UIView!
    
    @IBOutlet weak var stackViewUserEmail: UIStackView!
    @IBOutlet weak var stackViewPassword: UIStackView!
    @IBOutlet weak var stackViewConfirmPassword: UIStackView!
    
    @IBOutlet weak var stackViewContainer: UIStackView!
    
    @IBOutlet var txtFieldMobileNo: UITextField!
    @IBOutlet weak var textFieldUsernameEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    @IBOutlet weak var textFieldConfirmPassword: UITextField!
    
    @IBOutlet weak var segmentPhoneEmail: UISegmentedControl!
    
    
    @IBOutlet weak var buttonNext: UIButton!
    
    @IBOutlet var lblCountryCode: UILabel!
    @IBOutlet var lblISOCode: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
}

extension NTSignupViewController {
    
    func initialSetup() {
        
        segmentPhoneEmail.selectedSegmentIndex = 0
        
        setupUI()
        setupData()
    }
    
    func setupUI() {
        
        stackViewUserEmail.isHidden = segmentPhoneEmail.selectedSegmentIndex == 0
        stackViewPassword.isHidden = segmentPhoneEmail.selectedSegmentIndex == 0
        stackViewConfirmPassword.isHidden = segmentPhoneEmail.selectedSegmentIndex == 0
        
        segmentPhoneEmail.setTextColorBtnText()
        
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
extension NTSignupViewController {
    
    @IBAction func segmentClicked(_ sender: UISegmentedControl) {
        
        setupUI()
        
      /*  switch sender.selectedSegmentIndex {
            
        case 0:
            viewEmail.removeFromSuperview()
            viewPhone.isHidden = false
            constraintHeightContainerView.constant = 53.0
            
        case 1:
            viewPhone.isHidden = true
            constraintHeightContainerView.constant = 248.0
            view.layoutSubviews()
            
            viewEmail.frame = viewContainer.bounds
            viewContainer.addSubview(viewEmail)
            
            
        default:
            break
        } */
        
        
    }
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        
        // 0- Phone, 1- Email
        // 1- Back, 2- Terms, 3- Privacy, 4- Next, 5- Country code
        
        switch sender.tag {
        case 1:
            popVC()
            
        case 2:
            debugPrint("Terms")
            
        case 3:
            debugPrint("Policy")
            
        case 4:
            
            let code = /lblCountryCode.text
            let number = /txtFieldMobileNo.text?.trimmed()
            
            switch segmentPhoneEmail.selectedSegmentIndex {
            case 0:
                
                if Validations.sharedInstance.validatePhoneNumber(phone: number) {
                    
                    self.sendOtp(code: code, number: number, signup_as: .PhoneNo)
                    
                }
                
            case 1:
                if Validations.sharedInstance.validateSignupUsernameAndPassword(usernameOrEmail: /textFieldUsernameEmail.text?.trimmed(), password: /textFieldPassword.text?.trimmed(), confirmPassword: /textFieldConfirmPassword.text?.trimmed(), phone: /txtFieldMobileNo.text?.trimmed() ) {
                
                    debugPrint("Success")
                    
                    sendOtp(code: code, number: number, signup_as: .Email, email: /textFieldUsernameEmail.text?.trimmed(), password: /textFieldPassword.text?.trimmed())
                }

            default:
                break
            }
            
        case 5:
            
            guard let countryPicker = R.storyboard.mainCab.countryCodeSearchViewController() else{return}
            countryPicker.delegate = self
            self.presentVC(countryPicker)
            
        default:
            break
        }
    }
    
}

//MARK: - Country Picker Delegates

extension NTSignupViewController: CountryCodeSearchDelegate {
    
    func didTap(onCode detail: [AnyHashable : Any]!) {
        
        lblCountryCode.text = /(detail["dial_code"] as? String)
        lblISOCode.text = /(detail["code"] as? String)
    }
    
    func didSuccessOnOtpVerification() {
        
    }
    
    
}

//MARK:- API

extension NTSignupViewController {
    
    func sendOtp(code:String, number:String, signup_as: LoginSignupType?, email: String? = nil, password: String? = nil) {
        
        guard let accountType = signup_as else {return}
        
        let sendOTP = LoginEndpoint.sendOtp(countryCode: code, phoneNum: number, iso: lblISOCode.text, social_key: nil, signup_as: accountType.rawValue, email: email, password: password)
        sendOTP.request( header: ["language_id" : LanguageFile.shared.getLanguage()]) {[weak self] (response) in
            switch response {
                
            case .success(let data):
                
                guard let model = data as? SendOtp else { return }
                model.countryCode = code
                model.mobileNumber = number
                model.iso = self?.lblISOCode.text
                
                guard let vc = R.storyboard.newTemplateLoginSignUp.ntVerificationCodeViewController() else{return}
                vc.sendOTP = model
                vc.signup_as = signup_as
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

extension NTSignupViewController : UITextFieldDelegate {
    
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
