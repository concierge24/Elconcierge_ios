//
//  RegisterSingleScreenVC.swift
//  Sneni
//
//  Created by Ankit Chhabra on 17/04/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit
import Material
import SwiftyJSON
import MRCountryPicker
import ADCountryPicker
import FlagPhoneNumber
import EZSwiftExtensions

class RegisterSingleScreenVC: LoginRegisterBaseViewController, ADCountryPickerDelegate {
    
    weak var delegate : LoginViewControllerDelegate?
    var appleLogin = false
    
    //MARK:- IBOutlet
    @IBOutlet weak var buttons_stackView: UIStackView!
    @IBOutlet weak var labelPrivacyPolicy: UILabel!
    @IBOutlet weak var signup_button: ThemeButton!{
        didSet {
            signup_button.setBackgroundColor(SKAppType.type.color, forState: .normal)
        }
    }
    
    @IBOutlet weak var tfFName: TextField!{
        didSet {
            tfFName.setNewThemeTextField()
        }
    }
    @IBOutlet weak var tfLName: TextField!{
        didSet {
            tfLName.setNewThemeTextField()
        }
    }
    @IBOutlet weak var tfEmail: TextField!{
        didSet {
            tfEmail.setNewThemeTextField()
        }
    }
    @IBOutlet weak var tfPassword: TextField!{
        didSet {
              tfPassword.setNewThemeTextField()
        }
    }
    
    @IBOutlet weak var tfConfirmPassword: TextField!{
        didSet {
              tfConfirmPassword.setNewThemeTextField()
        }
    }
    
    @IBOutlet weak var phoneNumberTextField: FPNTextField! {
           didSet {
               phoneNumberTextField.setAlignment()
           }
       }
    
    @IBOutlet weak var viewReferral: UIView!
    @IBOutlet weak var textFieldReferal: TextField! {
        didSet {
              textFieldReferal.setNewThemeTextField()
        }
    }
    
    @IBOutlet weak var tfCountryCode: TextField!
//    {
//        didSet {
//
//            tfCountryCode.text = "+91"//"+1"
//
//        }
//    }
    @IBOutlet weak var tfPhoneNumber: TextField! {
        didSet {
            tfPhoneNumber.setNewThemeTextField()
        }
    }
    @IBOutlet var viewPhone: UIView!
    
    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)

    var user : User?
    let picker = ADCountryPicker()
    var lastStatusOfInvalidPhone = false
    
    
    @IBOutlet weak var btnLogin: UIButton! {
        didSet {
            let objTxt = NSMutableAttributedString(string: "\("Already have an Account?".localized()) ", attributes: [
                NSAttributedString.Key.foregroundColor:UIColor.lightGray
                ])
            
            objTxt.append(NSAttributedString(string: "Login".localized(), attributes: [
                NSAttributedString.Key.foregroundColor:SKAppType.type.color,
                .underlineStyle: NSUnderlineStyle.single.rawValue
                ]))
            
            btnLogin.setAttributedTitle(objTxt, for: .normal)
        }
    }
    
    //MARK:- Variables
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    //MARK:- viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let normalTextS = L10n.BySigningUpYouAgreeToThe.string
        let boldPrivacy  = L10n.PrivacyPolicy.string
        let boldTerms = L10n.TermsAndConditionsSignUp.string
        
        let attributedString1 = NSMutableAttributedString(string:normalTextS)
        let attributedString2 = NSMutableAttributedString(string: L10n.And.string)
        let attrs = [NSAttributedString.Key.font : UIFont(name: Fonts.ProximaNova.Bold,size: 12)!]
        let boldStringP = NSMutableAttributedString(string:boldPrivacy, attributes:attrs)
        let boldStringT = NSMutableAttributedString(string:boldTerms, attributes:attrs)
        
        attributedString1.append(boldStringP)
        attributedString1.append(attributedString2)
        attributedString1.append(boldStringT)
        
        labelPrivacyPolicy?.attributedText = attributedString1
        
        phoneNumberTextField.delegate = self
        phoneNumberTextField.setFlag(key: .SA)
      //  phoneNumberTextField.setCountries(including: [.SA])
        phoneNumberTextField.flagButton.isUserInteractionEnabled = false
        viewReferral.isHidden = !AppSettings.shared.showReferral
    }
    
    func setupView() {
        if appleLogin {
            tfPassword.superview?.isHidden = true
            tfConfirmPassword.superview?.isHidden = true
            viewPhone.isHidden = true
        }
    }
    
      func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String) {
          print(code)
      }
      
      func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
          print(dialCode)
          self.tfCountryCode.text = dialCode
          self.picker.dismiss(animated: true, completion: nil)
      }
    @IBAction func actionShowPassword(_ sender: UIButton) {
        tfPassword.isSecureTextEntry = sender.isSelected
        sender.isSelected = !sender.isSelected
    }
}

//MARK: - Button Actions
extension RegisterSingleScreenVC {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
        
    
    @IBAction func actionContinue(sender: UIButton) {
        view.endEditing(true)

        
        if appleLogin {
            guard let email = tfEmail.text, let fName = tfFName.text, let lName = tfLName.text else { return }
            registerAppleUser()
            return
        }
        
        
        guard let email = tfEmail.text, let password = tfPassword.text, let confirmPassword = tfConfirmPassword.text, let fName = tfFName.text, let lName = tfLName.text, let phoneNumber = phoneNumberTextField?.getRawPhoneNumber() else { return }
        
        
        let message = Register.validateSignupDetails(email: email, password: password, confirmPassword: confirmPassword, first_name: fName, last_name: lName, mobileNo: phoneNumber, isMobileValid: lastStatusOfInvalidPhone)
        
        
        if message.count == 0 {
            
            APIManager.sharedInstance.opertationWithRequest(withApi: API.RegisterSingleStep(FormatAPIParameters.RegisterSingleStep(email: email, password: password, first_name: fName, last_name: lName, referralCode: /self.textFieldReferal.text, countryCode: /self.phoneNumberTextField?.selectedCountry?.phoneCode, mobileNumber: phoneNumber).formatParameters()), completion: { (response) in
                weak var weakSelf = self
            
                switch response {
                case APIResponse.Success(let object):
                    guard let userObj = object as? User else {return}
                    userObj.email = email
                    userObj.firstName = fName + " " + lName
                    userObj.countryCode = /self.phoneNumberTextField?.selectedCountry?.phoneCode
                    userObj.mobileNo = self.phoneNumberTextField.text
                    
                    weakSelf?.handleSignupResponse(user: userObj)
                    break
                case APIResponse.Failure(_):
                    break
                }
            })
        }else{
             SKToast.makeToast(message)
        }
        
    }
    
    func registerAppleUser() {
        let message = validateCredentials()
              if message.isEmpty {

                  APIManager.sharedInstance.showLoader()
                var name = tfFName.text ?? ""
                if let lName = tfLName.text, !lName.isEmpty {
                    name = "\(name) \(lName)"
                }
                  let objR = API.RegisterLastStep(FormatAPIParameters.RegisterLastStep(accessToken : user?.token, name: tfFName.text ?? "", email: appleLogin ? (tfEmail.text ?? "") : nil).formatParameters())
                  APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
                      [weak self] (response) in
                      APIManager.sharedInstance.hideLoader()
                      guard let `self` = self else { return }
                      switch response {
                      case .Success(let object):
                          
                          let userNew = object as? User
                          userNew?.fbId = self.user?.fbId
                          userNew?.otpVerified = self.user?.otpVerified
                          self.handleSignupResponse(user: userNew)
                      default:
                          break
                      }
                  }
              }else {
                  SKToast.makeToast(message)
              }
    }
    
    func validateCredentials() -> String{
        guard let name = tfFName.text, name.trim().count != 0 else {
            
            return L10n.PleaseEnterYourName.string
        }
        if appleLogin {
            guard let email = tfEmail.text, name.trim().count != 0 else {
                
                return L10n.PleaseEnterYourEmailAddress.string
            }
            if !Register.isValidEmail(testStr: email){
                return L10n.PleaseEnterAValidEmailAddress.string
            }
        }
        
        return ""
    }
    
    func handleSignupResponse(user : User?){
        if user?.otpVerified == "1" || appleLogin {
            GDataSingleton.sharedInstance.loggedInUser = user
            
            AdjustEvent.SignUp.sendEvent()
            ez.runThisInMainThread({
                var VC = self.presentingViewController
                while ((VC?.presentingViewController) != nil) {
                    VC = VC?.presentingViewController
                }
                if VC is LoginNewVC && VC?.presentingViewController == nil {
                    (UIApplication.shared.delegate as? AppDelegate)?.userSuccessfullyLoggedIn(withUser: self.user)
                    GDataSingleton.isProfilePicDone = true
                    VC?.dismissVC{}
                }
                else {
                    self.delegate?.userSuccessfullyLoggedIn(withUser: self.user)
                    GDataSingleton.isProfilePicDone = true
                    VC?.dismissVC{}
                }
            })
        }
        else {
            let VC = StoryboardScene.Register.instantiateOTPViewController()
            VC.user = user
            VC.delegate = delegate
            presentVC(VC)
        }

    }
    
    
    @IBAction func actionSelectCountryCode(sender: UIButton) {
        
        picker.delegate = self
        picker.showCallingCodes = true
        picker.showFlags = true
        picker.defaultCountryCode = "IN"
        picker.forceDefaultCountryCode = false
        let pickerNavigationController = UINavigationController(rootViewController: picker)
        self.present(pickerNavigationController, animated: true, completion: nil)
        
        //        let countryController = CountryListViewController(nibName: "CountryListViewController", delegate: self)
        //      presentVC(countryController!)
        
    }
}


//MARK: - Country Controller Delegate
extension RegisterSingleScreenVC : CountryListViewDelegate {
    
    func didSelectCountry(_ countryName: String!, dialCode DialCode: String!, countryCode: String!) {
        tfCountryCode.text = DialCode
        
    }
}

//MARK: - UITextFieldDelegate
extension RegisterSingleScreenVC : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfCountryCode {
            actionSelectCountryCode(sender: UIButton())
            return false
        }
        return true
    }
}

extension RegisterSingleScreenVC: FPNTextFieldDelegate {
    
    func fpnDisplayCountryList() {
        let navigationViewController = UINavigationController(rootViewController: listController)

        listController.title = "Countries"
        listController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissCountries))

        self.present(navigationViewController, animated: true, completion: nil)
    }
    
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        textField.rightViewMode = .always
        textField.rightView = UIImageView(image: isValid ? UIImage(named:"success")  : UIImage(named:"error") )
        lastStatusOfInvalidPhone = isValid
        print(
            isValid,
            textField.getFormattedPhoneNumber(format: .E164) ?? "E164: nil",
            textField.getFormattedPhoneNumber(format: .International) ?? "International: nil",
            textField.getFormattedPhoneNumber(format: .National) ?? "National: nil",
            textField.getFormattedPhoneNumber(format: .RFC3966) ?? "RFC3966: nil",
            textField.getRawPhoneNumber() ?? "Raw: nil"
        )
    }
    
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
         self.tfCountryCode.text = dialCode
        print(name, dialCode, code)
    }
    
    @objc func dismissCountries() {
        listController.dismiss(animated: true, completion: nil)
    }
    
    
}

