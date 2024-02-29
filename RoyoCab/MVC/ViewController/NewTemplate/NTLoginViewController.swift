//
//  NTLoginViewController.swift
//  RoyoRide
//
//  Created by Ankush on 15/05/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import UIKit

class NTLoginViewController: UIViewController {
    
    //MARK:- Enum
    enum ScreenType: String {
        case phone
        case email
        case emailInstitution
    }
    
    //MARK:- Outlet
    
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonLoginWithEmailPhone: UIButton!
    
    @IBOutlet weak var constraintHeightContainerView: NSLayoutConstraint!
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet var viewPhone: UIView!
    @IBOutlet var viewEmail: UIView!
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet var lblCountryCode: UILabel!
    @IBOutlet var lblISOCode: UILabel!
    
    @IBOutlet var txtFieldMobileNo: UITextField!
    @IBOutlet weak var textFieldUsernameEmail: UITextField!
    @IBOutlet weak var textFieldPassword: UITextField!
    
    @IBOutlet weak var stackLoginWith: UIStackView!
    
    //MARK:- Property
    var screenType: ScreenType = .phone
    
    //MARK:- View LIfe Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetup()
    }
}


//MARK:- Function
extension NTLoginViewController {
    
    func initialSetup() {
        setupUI()
        setupData()
    }
    
    func setupUI() {
        
        switch screenType {
        case .email, .emailInstitution:
            viewPhone.isHidden = true
            constraintHeightContainerView.constant = 153.0
            view.layoutSubviews()
            
            viewEmail.frame = viewContainer.bounds
            viewContainer.addSubview(viewEmail)
            
            
        case .phone:
            viewEmail.removeFromSuperview()
            viewPhone.isHidden = false
            constraintHeightContainerView.constant = 53.0
            
            txtFieldMobileNo.delegate = self
        }
        
        let title = (screenType == .phone ? " " + "email".localizedString : "phone".localizedString)
        buttonLoginWithEmailPhone.setTitle(title, for: .normal)
        
        labelTitle.text = "loginTo".localizedString + " " + "AppName".localizedString + " " + (screenType == .emailInstitution ? ( "institution".localizedString) : "")

        stackLoginWith.isHidden = screenType == .emailInstitution
        
        buttonNext.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        buttonNext.setButtonWithTintColorBtnText()
    }
    
    func setupData() {
        
        switch screenType {
        case .phone:
            
            lblCountryCode.text =  UDSingleton.shared.appSettings?.appSettings?.default_country_code ?? DefaultCountry.countryCode.rawValue
            lblISOCode.text =  UDSingleton.shared.appSettings?.appSettings?.iso_code ?? DefaultCountry.ISO.rawValue
            
        default:
            break
        }
    }
    
    
}


//MARK:- Button Selectors
extension NTLoginViewController {
    
    // 1- Back, LoginWith -2, Next- 3, Country code - 4, 5- RememberMe, 6- Forgot password
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        
        switch sender.tag {
        case 1:
            popVC()
            
        case 2:
            screenType = screenType == .phone ? .email : .phone
            setupUI()
            
        case 3:
            debugPrint("Next")
            
            switch screenType {
            case .phone:
                
                let code = /lblCountryCode.text
                let number = /txtFieldMobileNo.text?.trimmed()
                
                if Validations.sharedInstance.validatePhoneNumber(phone: number) {
                    
                    self.sendOtp(code: code, number: number, login_as: .PhoneNo)
                    
                }
                
            case .email:
                if Validations.sharedInstance.validateLoginUsernameAndPassword(usernameOrEmail: /textFieldUsernameEmail.text?.trimmed(), password: /textFieldPassword.text?.trimmed()) {
                
                    debugPrint("Success")
                    
                    emailLogin(login_as: .Email)
                }
                
            case .emailInstitution:
                if Validations.sharedInstance.validateLoginUsernameAndPassword(usernameOrEmail: /textFieldUsernameEmail.text?.trimmed(), password: /textFieldPassword.text?.trimmed()) {
                
                    debugPrint("Success")
                    emailLogin(login_as: .PrivateCooperative)
                }
            }
            
        case 4:
            
            guard let countryPicker = R.storyboard.mainCab.countryCodeSearchViewController() else{return}
            countryPicker.delegate = self
            self.presentVC(countryPicker)
            
            
        case 5:
            debugPrint("Remember me")
            sender.isSelected = !sender.isSelected
            
        case 6:
            debugPrint("Forgot password")
            
            
        default:
            break
        }
    }
}


//MARK: - Country Picker Delegates

extension NTLoginViewController: CountryCodeSearchDelegate {
    
    func didTap(onCode detail: [AnyHashable : Any]!) {
        
        lblCountryCode.text = /(detail["dial_code"] as? String)
        lblISOCode.text = /(detail["code"] as? String)
    }
    
    func didSuccessOnOtpVerification() {
        
    }
    
    
}

//MARK:- API

extension NTLoginViewController {
    
    func sendOtp(code:String, number:String, login_as: LoginSignupType?) {
        
        guard let accountType = login_as else {return}
        
        let sendOTP = LoginEndpoint.sendOtp(countryCode: code, phoneNum: number, iso: lblISOCode.text, social_key: nil, signup_as: accountType.rawValue)
        sendOTP.request( header: ["language_id" : LanguageFile.shared.getLanguage()]) {[weak self] (response) in
            switch response {
                
            case .success(let data):
                
                guard let model = data as? SendOtp else { return }
                model.countryCode = code
                model.mobileNumber = number
                model.iso = self?.lblISOCode.text
                
                guard let vc = R.storyboard.newTemplateLoginSignUp.ntVerificationCodeViewController() else{return}
                vc.sendOTP = model
                vc.signup_as = login_as
                self?.pushVC(vc)
                
                break
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
                //Toast.show(text: strError, type: .error)
            }
        }
    }
    
    func emailLogin(login_as: LoginSignupType?) {
        
        guard let accountType = login_as else {return}
        
        let emailLogin = LoginEndpoint.emailLogin(login_as: accountType.rawValue, email: textFieldUsernameEmail.text, password: textFieldPassword.text)
        
        emailLogin.request( header: ["language_id" : LanguageFile.shared.getLanguage()]) { (response) in
            switch response {
                
            case .success(let data):
                
               guard let model = data as? LoginDetail else { return }
               
               UDSingleton.shared.userData = model
               let appDelegate = UIApplication.shared.delegate as? AppDelegate
               appDelegate?.setHomeAsRootVC()
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
                //Toast.show(text: strError, type: .error)
            }
        }
    }
    
}

//MARK:- UItextfield delegates

extension NTLoginViewController : UITextFieldDelegate {
    
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

