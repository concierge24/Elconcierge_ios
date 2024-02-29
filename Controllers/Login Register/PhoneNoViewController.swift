//
//  PhoneNoViewController.swift
//  Clikat
//
//  Created by cbl73 on 4/21/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import Material
import SwiftyJSON
import MRCountryPicker
import ADCountryPicker
import FlagPhoneNumber

enum CountryKeys : String {
    case name = "name"
    case dial_code = "dial_code"
    case code = "code"
}

class PhoneNoViewController: LoginRegisterBaseViewController,ADCountryPickerDelegate {
    
    weak var delegate : LoginViewControllerDelegate?
    
    @IBOutlet weak var phoneNumberTextField: FPNTextField! {
        didSet {
            phoneNumberTextField.setAlignment()
        }
    }
    
    @IBOutlet weak var stackReferral: UIStackView!
    @IBOutlet weak var textFieldReferal: TextField! {
        didSet{
            textFieldReferal.setThemeTextField()
        }
    }

    @IBOutlet weak var btnOTP : UIButton!{
        didSet{
            if AppSettings.shared.appThemeData?.bypass_otp == "1" {
                btnOTP.setTitle("CONTINUE".localized(), for: .normal)
            }
            self.btnOTP.setBackgroundColor(SKAppType.type.color, forState: .normal)
            btnOTP.kern(kerningValue: ButtonKernValue)
            
        }
    }
    
    //    @IBOutlet weak var tfCountryCode: FPNTextField! {
    //        didSet{
    //            tfCountryCode.displayMode = .list
    //            tfCountryCode.delegate = self
    //            tfCountryCode.hasPhoneNumberExample = false
    //        }
    //    }
    @IBOutlet weak var tfCountryCode: TextField! {
        didSet {

        }
    }
    @IBOutlet weak var tfPhoneNumber: TextField! {
        didSet {
            tfPhoneNumber.setThemeTextField()
        }
    }
    
    var listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)

    var user : User?
    let picker = ADCountryPicker()
    var lastStatusOfInvalidPhone = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //tfPhoneNumber.dividerColor = TextFieldTheme.shared.txtFld_DividerColor
        
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        phoneNumberTextField.delegate = self
        //        NotificationCenter.default.addObserver(self, selector: #selector(PhoneNoViewController.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        //   NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        // self.countryPickerSetUp()
        
        if AppSettings.shared.appThemeData?.custom_vertical_theme == "1" {
            phoneNumberTextField.setFlag(key: .AL)
        }

        stackReferral.isHidden = !AppSettings.shared.showReferral
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String) {
        print(code)
    }
    
    func countryPicker(_ picker: ADCountryPicker, didSelectCountryWithName name: String, code: String, dialCode: String) {
        print(dialCode)
        self.tfCountryCode.text = dialCode
        self.picker.dismiss(animated: true, completion: nil)
    }
}


//MARK: - Button Actions
extension PhoneNoViewController{
    
    @IBAction func actionSelectCountryCode(sender: UIButton) {
        
        picker.delegate = self
        picker.showCallingCodes = true
        picker.showFlags = true
        picker.defaultCountryCode = "VE"
        
        picker.forceDefaultCountryCode = false
        let pickerNavigationController = UINavigationController(rootViewController: picker)
        self.present(pickerNavigationController, animated: true, completion: nil)
        
        //        let countryController = CountryListViewController(nibName: "CountryListViewController", delegate: self)
        //      presentVC(countryController!)
        
    }
    
    @IBAction func actionSendOTP(sender: AnyObject) {
        view.endEditing(true)
        if !lastStatusOfInvalidPhone{
            SKToast.makeToast("Please enter valid phone number".localized())
            return
        }
        guard let phoneNumber = phoneNumberTextField?.text else { return }
        if Register.isValidPhoneNumber(testStr: phoneNumber) {
            let mobileNumber = phoneNumber
            APIManager.sharedInstance.opertationWithRequest(withApi: API.SendOTP(FormatAPIParameters.SendOTP(accessToken: user?.token,mobileNumber: mobileNumber,countryCode: self.phoneNumberTextField?.selectedCountry?.phoneCode, referalCode: /self.textFieldReferal.text ).formatParameters()), completion: {
                [weak self] (response) in
                guard let self = self else { return }
                
                switch response {
                case APIResponse.Success(let object):
                    if AppSettings.shared.appThemeData?.bypass_otp == "1" {
                        self.actionSubmitOTP(user: object as? User)
                        return
                    }
                    var user : User?
                    user = object as? User
                    user?.mobileNo = phoneNumber
                    user?.fbId = self.user?.fbId
                    user?.countryCode = self.phoneNumberTextField?.selectedCountry?.phoneCode
                    self.handleOTPSentResponse(tempUser: user)
                    break
                default:
                    break
                }
            })
        }else{
            SKToast.makeToast("Please enter phone number".localized())
        }
    }
    
    
    func handleOTPSentResponse(tempUser : Any?){
        
        let VC = StoryboardScene.Register.instantiateOTPViewController()
        VC.user = tempUser as? User
        VC.delegate = delegate
        presentVC(VC)
    }
    
    func actionSubmitOTP(user: User?) {
        
        let objR = API.CheckOTP(FormatAPIParameters.CheckOTP(accessToken :user?.token ,OTP: "12345").formatParameters())
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            
            switch response {
            case APIResponse.Success(_):
                self.handleCheckOTPResponse()
                
            case APIResponse.Failure(_):
                break
            }
            
        }
    }
    
    func handleCheckOTPResponse(){
        let VC = StoryboardScene.Register.instantiateRegisterViewController()
        user?.countryCode = tfCountryCode.text
        VC.user = user
        VC.delegate = delegate
        presentVC(VC)
    }
    
    func countryPickerSetUp()  {
        //        let countryPicker = MRCountryPicker()
        //        countryPicker.countryPickerDelegate = self
        //        tfCountryCode.inputView = countryPicker
    }
    
}
//MARK: - Country Controller Delegate
extension PhoneNoViewController : CountryListViewDelegate {
    
    func didSelectCountry(_ countryName: String!, dialCode DialCode: String!, countryCode: String!) {
        tfCountryCode.text = DialCode
        
    }
}

//MARK: - UITextFieldDelegate
extension PhoneNoViewController : UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == tfCountryCode {
            actionSelectCountryCode(sender: UIButton())
            return false
        }
        return true
    }
}


extension PhoneNoViewController: FPNTextFieldDelegate {
    
    func fpnDisplayCountryList() {
        let navigationViewController = UINavigationController(rootViewController: listController)

        listController.title = "Countries"
        listController.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .stop, target: self, action: #selector(dismissCountries))

        self.present(navigationViewController, animated: true, completion: nil)
    }
    
    
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        textField.rightViewMode = .always
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, w: 32, h: 32))
        imgView.image = isValid ? UIImage(named:"success")  : UIImage(named:"error")
        textField.rightView = imgView
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



//extension PhoneNoViewController{
//    
//    
//    @objc func keyboardWillHide(notification: NSNotification) {
//        
//         tfPhoneNumber.dividerNormalColor = UIColor.black
//        print("Hiiiiiii")
//       
//        }
//    
//  
//}



////MARK: - CountryPicker Delegate
//extension PhoneNoViewController:MRCountryPickerDelegate{
//
//    func countryPhoneCodePicker(_ picker: MRCountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
//         tfCountryCode.text = phoneCode
//
//    }
////        self.countryName.text = name
////        self.countryCode.text = countryCode
////        self.phoneCode.text = phoneCode
////        self.countryFlag.image = flag
////    }
//
//}
