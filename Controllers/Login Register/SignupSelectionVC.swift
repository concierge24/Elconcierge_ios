//
//  SignupSelectionVC.swift
//  Sneni
//
//  Created by Ankit Chhabra on 29/04/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit
import TYAlertController
import EZSwiftExtensions
import Adjust
import AuthenticationServices

class SignupSelectionVC: LoginRegisterBaseViewController {
    
    @IBOutlet weak var labelPrivacyPolicy: UILabel!
    
    @IBOutlet weak var backBtn: BackButtonImage!
    @IBOutlet weak var buttons_stackView: UIStackView!
    @IBOutlet weak var btnLogin: UIButton!{
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
    @IBOutlet weak var btnTermsCheck: UIButton!
    @IBOutlet weak var btnFBLogin: ThemeButton! {
        didSet {
            if FacebookKey == "1"{
                btnFBLogin?.isHidden = false
                btnFBLogin?.setBackgroundColor(UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1), forState:  .normal)
            }else{
                btnFBLogin?.isHidden = true
            }
        }
    }
    @IBOutlet weak var btnCreateNew: ThemeButton! {
        didSet {
            btnCreateNew.setBackgroundColor(SKAppType.type.color, forState: .normal)
        }
    }
    
    //MARK:- Variables
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
        backBtn.isHidden = true
        btnCreateNew.isHidden = false
        
        /* let normalTextS = L10n.BySigningUpYouAgreeToThe.string
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
         
         labelPrivacyPolicy?.attributedText = attributedString1   */
    }
    
    func addAppleLoginButton() {
        
        if #available(iOS 13.0, *) {
            let authorizationButton = ASAuthorizationAppleIDButton()
            authorizationButton.frame = CGRect(x: 0, y: 0, width: buttons_stackView.frame.width, height: 40)
            authorizationButton.cornerRadius = 0
            authorizationButton.addTarget(self, action: #selector(handleAppleIdRequest), for: .touchUpInside)
            if FacebookKey == "1"{
                self.buttons_stackView.insertArrangedSubview(authorizationButton, at: 2)
            }else{
                self.buttons_stackView.insertArrangedSubview(authorizationButton, at: 1)
            }
            
        } else {
            // Fallback on earlier versions
        }
        
    }
    
    @objc func handleAppleIdRequest() {
        if !(btnTermsCheck.isSelected) {
            SKToast.makeToast("Please check terms and conditions".localized())
            return
        }
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
    @IBAction func actionLogin(_ sender: Any) {
        let vc = LoginNewVC.getVC(.register)
        vc.delegate = delegate
        presentVC(vc)
    }
    
    @IBAction func actionTermsCheck(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func actionCreateNew(_ sender: Any) {
        if !(btnTermsCheck.isSelected) {
            SKToast.makeToast("Please check terms and conditions".localized())
            return
        }
        let vc = RegisterSingleScreenVC.getVC(.register)
        vc.delegate = delegate
        presentVC(vc)
    }
    
    @IBAction func actionFBLogin(_ sender: Any) {
        if !(btnTermsCheck.isSelected) {
            SKToast.makeToast("Please check terms and conditions".localized())
            return
        }
        FacebookManager.sharedManager.configureLoginManager(sender: self) { (facebook) in
            weak var weakSelf = self
            UtilityFunctions.startLoader()
            weakSelf?.handleFacebookLogin(facebookProfile: facebook)
        }
    }
    
    
}

extension SignupSelectionVC {
    
    func handleFacebookLogin(facebookProfile : Facebook?){
        
        guard let profile = facebookProfile else { return }
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.LoginFacebook(FormatAPIParameters.FacebookLogin(fbProfile: profile).formatParameters())) { (response) in
            UtilityFunctions.stopLoader()
            weak var weakSelf = self
            switch response {
            case .Success(let object) :
                guard let user = object as? User else { return }
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
                        let vc = StoryboardScene.Register.instantiateRegisterSingleScreenVC()
                        vc.delegate = self.delegate
                        vc.user = data
                        vc.appleLogin = true
                        weakSelf?.presentVC(vc)
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
    
    func handleLoginResponse(user : User?){
        let VC = StoryboardScene.Register.instantiatePhoneNoViewController()
        VC.user = user
        presentVC(VC)
    }
    
}

//MARK:- ASAuthorizationControllerDelegate`
extension SignupSelectionVC : ASAuthorizationControllerDelegate {
    
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


