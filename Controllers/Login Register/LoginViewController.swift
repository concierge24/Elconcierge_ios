//
//  LoginViewController.swift
//  Clikat
//
//  Created by Night Reaper on 20/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import TYAlertController
import Material
import EZSwiftExtensions
import Adjust
import AuthenticationServices

protocol LoginViewControllerDelegate : class {
    func userSuccessfullyLoggedIn(withUser user : User?)
    func userFailedLoggedIn()
    
}

class LoginViewController: LoginRegisterBaseViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var btnForgotPasswrd: ThemeButton! {
        didSet {
          //  btnForgotPasswrd.setAlignment()
        }
    }
    @IBOutlet weak var buttons_stackView: UIStackView!
    @IBOutlet weak var login_button: ThemeButton! {
        didSet {
            login_button.setBackgroundColor(SKAppType.type.color, forState: .normal)
        }
    }
    //MARK:- IBOutlet
    @IBOutlet weak var btnFb: UIButton? {
        didSet {
            //btnFb?.isHidden = true
            btnFb?.setBackgroundColor(UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1), forState:  .normal)
        }
    }
    
    @IBOutlet weak var tfEmail: TextField!{
        didSet{
            tfEmail.setThemeTextField()
        }
    }
    @IBOutlet weak var tfPassword: TextField!{
        didSet{
            tfPassword.setThemeTextField()
        }
    }
    @IBOutlet weak var btnSignUp: UIButton! {
        didSet {
            let objTxt = NSMutableAttributedString(string: "\("Dont't have an Account?".localized()) ", attributes: [
                NSAttributedString.Key.foregroundColor:UIColor.lightGray
            ])
            
            objTxt.append(NSAttributedString(string: "Sign up".localized(), attributes: [
                NSAttributedString.Key.foregroundColor:SKAppType.type.color,
                .underlineStyle: NSUnderlineStyle.single.rawValue
            ]))
            
            btnSignUp.setAttributedTitle(objTxt, for: .normal)
        }
    }
    
    //MARK:- Variables
    var isFromSideMenu : Bool = false
    weak var delegate : LoginViewControllerDelegate?
    var appleDataObj: AppleLoginData? {
        didSet {
            self.loginWithApple()
        }
    }
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addAppleLoginButton()
        btnBack.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if self.presentingViewController != nil {
            btnBack.isHidden = false
        }
    }
    
    func addAppleLoginButton() {
        
        if #available(iOS 13.0, *) {
            let authorizationButton = ASAuthorizationAppleIDButton()
            authorizationButton.frame = CGRect(x: 0, y: 0, width: buttons_stackView.frame.width, height: 40)
            authorizationButton.cornerRadius = 0
            authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
            self.buttons_stackView.insertArrangedSubview(authorizationButton, at: 2)
            
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    @objc func handleAppleIdRequest() {
        
        if #available(iOS 13.0, *) {
            
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.performRequests()
            
        } else {
            // Fallback on earlier versions
        }
        
    }
}

//MARK: - Button Actions
extension LoginViewController{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    @IBAction func submit_buttonAction(_ sender: Any) {
        
    }
    
    @IBAction func actionSignUp(sender: UIButton) {
        
        let vc = StoryboardScene.Register.instantiateRegisterFirstStepController()
        vc.delegate = delegate
        presentVC(vc)
        
    }
    
    @IBAction func actionForgotPass(sender: AnyObject) {
        
        let alert = TYAlertView(title: L10n.ForgotPassword.string , message: nil)
        let alertController = TYAlertController(alert: alert, preferredStyle: .alert, transitionAnimation: .scaleFade)
        
        let action = TYAlertAction(title: L10n.Send.string, style: .default) {[weak self] (action) in
            
            guard let emailId = (alert?.textFieldArray?.first as? UITextField)?.text, Register.isValidEmail(testStr: emailId) else {
                SKToast.makeToast(L10n.PleaseEnterAValidEmailAddress.string)
                APIManager.sharedInstance.hideLoader()
                return
            }
            
            alertController?.view.endEditing(true)
            alert?.hide()
            self?.handleForgotPassword(email: (alert?.textFieldArray?.first as? UITextField)?.text)
        }
        alert?.buttonDefaultBgColor = Colors.MainColor.color()
        alert?.textFieldFont = UIFont(name: Fonts.ProximaNova.Regular, size: Size.Small.rawValue)
        alert?.add(TYAlertAction(title: L10n.Cancel.string , style: .destructive, handler: { (action) in
            alert?.hide()
        }))
        alert?.add(action)
        alert?.addTextField { (textField) in
            textField?.placeholder = L10n.Email.string
            textField?.tag = 1
            textField?.returnKeyType = .done
            textField?.autocorrectionType = .no
            textField?.spellCheckingType = .no
        }
        presentVC(alertController ?? TYAlertController(alert: alert))
        
    }
    
    @IBAction func actionLogin(sender: AnyObject) {
        guard let email = tfEmail.text, let password = tfPassword.text else { return }
        self.view.endEditing(true)

        let message = Register.validateCredentials(email: email, password: password)
        
        if message.count == 0 {
            APIManager.sharedInstance.opertationWithRequest(withApi: API.Login(FormatAPIParameters.Login(email: email, phoneNumber: "", countryCode: "", password: password).formatParameters())) { (response) in

                weak var weakSelf : LoginViewController? = self
                switch response {
                case APIResponse.Success(let user):
                    guard let userData = user as? User else {return}
                    GDataSingleton.sharedInstance.customerPaymentId = /userData.customer_payment_id
                    if userData.firstName == "" {
                        let VC = StoryboardScene.Register.instantiateRegisterViewController()
                        VC.user = userData
                        VC.delegate = weakSelf?.delegate
                        weakSelf?.presentVC(VC)
                    } else {
                        AdjustEvent.Login.sendEvent()
                        weakSelf?.delegate?.userSuccessfullyLoggedIn(withUser: user as? User)
                        weakSelf?.dismissVC(completion: nil)
                    }
                case APIResponse.Failure(let validation):
                    SKToast.makeToast(validation.message)
                }
                
            }
        }else{
            SKToast.makeToast(message)
        }
    }
    
    @IBAction func actionLoginFb(sender: AnyObject) {
        
        FacebookManager.sharedManager.configureLoginManager(sender: self) { (facebook) in
            weak var weakSelf = self
            UtilityFunctions.startLoader()
            weakSelf?.handleFacebookLogin(facebookProfile: facebook)
        }
    }
}

extension LoginViewController {
    
    func handleFacebookLogin(facebookProfile : Facebook?){
        
        guard let profile = facebookProfile else { return }
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.LoginFacebook(FormatAPIParameters.FacebookLogin(fbProfile: profile).formatParameters())) { (response) in
            UtilityFunctions.stopLoader()
            weak var weakSelf = self
            switch response {
            case .Success(let object) :
                guard let user = object as? User else { return }
                GDataSingleton.sharedInstance.customerPaymentId = /user.customer_payment_id
                user.fbId = profile.fbId
                weakSelf?.facebookLoginWebServicehandler(object: user)
            default:
                break
            }
        }
    }
    
    func facebookLoginWebServicehandler(object : Any?){
        guard let user = object as? User else { return }
        
        if let otpVerified = user.otpVerified, otpVerified == "0"{
            let VC = StoryboardScene.Register.instantiatePhoneNoViewController()
            VC.user = user
            VC.delegate = delegate
            presentVC(VC)
        }else {
            delegate?.userSuccessfullyLoggedIn(withUser: user)
            dismissVC(completion: nil)
        }
    }
}

//MARK: - Forgot password
extension LoginViewController {
    
    func handleForgotPassword(email : String?){
        
        APIManager.sharedInstance.showLoader()
        APIManager.sharedInstance.opertationWithRequest(withApi: API.ForgotPassword(FormatAPIParameters.ForgotPassword(email: email).formatParameters())) { (response) in
            
            APIManager.sharedInstance.hideLoader()
            switch response {
            case .Success(_):
                SKToast.makeToast(L10n.PasswordRecoveryHasBeenSentToYourEmailId.string)
            default:
                APIManager.sharedInstance.hideLoader()
                break
            }
        }
    }
    
    func loginWithApple() {
        guard let appleObj = self.appleDataObj else {return}
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.appleSignin(FormatAPIParameters.appleSignin(email: appleObj.email ?? "", first_name: appleObj.givenName ?? "", last_name: appleObj.familyName ?? "", apple_id: appleObj.userId ?? "").formatParameters())) { (response) in
            
            weak var weakSelf = self
            switch response {
            case APIResponse.Success(let object):
                guard let data = object as? User else { return }
                if let otpVerified = data.otpVerified,otpVerified == "0" {
                    weakSelf?.handleLoginResponse(user: object as? User)
                } else {
                    if data.email == "" {
                        let VC = StoryboardScene.Register.instantiateRegisterViewController()
                        VC.user = data
                        VC.appleLogin = true
                        VC.delegate = self.delegate
                        weakSelf?.presentVC(VC)
                    }
                    else {
                        AdjustEvent.Login.sendEvent()
                        GDataSingleton.sharedInstance.loggedInUser = data
                        GDataSingleton.sharedInstance.customerPaymentId = /data.customer_payment_id
                        weakSelf?.delegate?.userSuccessfullyLoggedIn(withUser: data)
                        weakSelf?.dismissVC(completion: nil)
                    }
                }
            case APIResponse.Failure(let validation):
                SKToast.makeToast(validation.message)
            }
        }
    }
    //    func loginWithApple() {
    //        guard let appleObj = self.appleDataObj else {return}
    //
    //        APIManager.sharedInstance.opertationWithRequest(withApi: API.appleSignin(FormatAPIParameters.appleSignin(email: appleObj.email ?? "", first_name: appleObj.givenName ?? "", last_name: appleObj.familyName ?? "", apple_id: appleObj.userId ?? "").formatParameters())) { (response) in
    //
    //            weak var weakSelf = self
    //            switch response {
    //              case APIResponse.Success(let object):
    //                guard let data = object as? User else { return }
    //                GDataSingleton.sharedInstance.loggedInUser = data
    //                if let otpVerified = data.otpVerified,otpVerified == "0" {
    //                    weakSelf?.handleLoginResponse(user: object as? User)
    //                } else {
    //                    AdjustEvent.Login.sendEvent()
    //                    if self.presentingViewController == nil {
    //                        weakSelf?.delegate?.userSuccessfullyLoggedIn(withUser: object as? User)
    //                    }
    //                    ez.runThisInMainThread({
    //                        weakSelf?.dismissVC(completion: {
    //                             weakSelf?.delegate?.userSuccessfullyLoggedIn(withUser: object as? User)
    //                        })
    //                    })
    //                }
    //              case APIResponse.Failure(let validation):
    //                SKToast.makeToast(validation.message)
    //            }
    //
    //        }
    //
    //    }
    
    func handleLoginResponse(user : User?){
        let VC = StoryboardScene.Register.instantiatePhoneNoViewController()
        VC.user = user
        presentVC(VC)
    }
    
}

//MARK:- ASAuthorizationControllerDelegate`
extension LoginViewController : ASAuthorizationControllerDelegate {
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        if let appleIDCredential = authorization.credential as?  ASAuthorizationAppleIDCredential {
            let userIdentifier = appleIDCredential.user
            let fullName = appleIDCredential.fullName
            let email = appleIDCredential.email
            
            let obj:AppleLoginData = AppleLoginData(email: email, userId: userIdentifier, givenName: fullName?.givenName ?? "", familyName: fullName?.familyName ?? "")
            
            self.appleDataObj = obj
            
            print("User id is \(userIdentifier) \n Full Name is \(String(describing: fullName)) \n Email id is \(String(describing: email))")
        }
        else if let appleIDCredential = authorization.credential as?  ASPasswordCredential {
            let userIdentifier = appleIDCredential.user

            let obj:AppleLoginData = AppleLoginData(email: "", userId: userIdentifier, givenName: "", familyName: "")
            
            self.appleDataObj = obj
        }
        
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // Handle error.
    }
}
