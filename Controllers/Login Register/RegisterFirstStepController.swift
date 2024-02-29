//
//  RegisterFirstStepController.swift
//  Clikat
//
//  Created by cblmacmini on 4/27/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import Material
import AuthenticationServices

class AppleLoginData: NSObject {
    
    var email : String?
    var userId : String?
    var givenName : String?
    var familyName : String?

    init(email: String?,userId: String?,givenName:String?,familyName: String? ) {
        
      self.email = email
      self.userId = userId
      self.givenName = givenName
      self.familyName = familyName
        
    }
      
    override init() {
        super.init()
    }
    
}

class RegisterFirstStepController: LoginRegisterBaseViewController {
    
    weak var delegate : LoginViewControllerDelegate?

    //MARK:- IBOutlet
    @IBOutlet weak var buttons_stackView: UIStackView!
    @IBOutlet weak var tfReferal: TextField!
    @IBOutlet weak var labelPrivacyPolicy: UILabel!
    @IBOutlet weak var signup_button: ThemeButton!{
        didSet {
            signup_button.setBackgroundColor(SKAppType.type.color, forState: .normal)
        }
    }
    @IBOutlet weak var btnFb: UIButton? {
        didSet {
            //btnFb?.isHidden = true
            btnFb?.setBackgroundColor(UIColor(red: 59/255, green: 89/255, blue: 152/255, alpha: 1), forState:  .normal)
        }
    }
    @IBOutlet weak var tfEmail: TextField!{
        didSet {
            tfEmail.setThemeTextField()
        }
    }
    @IBOutlet weak var tfPassword: TextField!{
        didSet {
              tfPassword.setThemeTextField()
        }
    }
    @IBOutlet weak var btnSignUp: UIButton! {
        didSet {
            let objTxt = NSMutableAttributedString(string: "\("Already have an Account?".localized()) ", attributes: [
                NSAttributedString.Key.foregroundColor:UIColor.lightGray
                ])
            
            objTxt.append(NSAttributedString(string: "Login".localized(), attributes: [
                NSAttributedString.Key.foregroundColor:SKAppType.type.color,
                .underlineStyle: NSUnderlineStyle.single.rawValue
                ]))
            
            btnSignUp.setAttributedTitle(objTxt, for: .normal)
        }
    }
    
    //MARK:- Variables
    var appleDataObj: AppleLoginData? {
        didSet {
            self.loginWithApple()
        }
    }
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addAppleLoginButton()
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
extension RegisterFirstStepController {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
        
    
    @IBAction func actionContinue(sender: UIButton) {
        
        let message = Register.validateCredentials(email: tfEmail.text ?? "", password: tfPassword.text ?? "")
        guard let email = tfEmail.text,let password = tfPassword.text else { return }
        
        if message.count == 0 {
            
            APIManager.sharedInstance.opertationWithRequest(withApi: API.Register(FormatAPIParameters.Register(email: email, password: password).formatParameters()), completion: { (response) in
                weak var weakSelf = self
            
                switch response {
                case APIResponse.Success(let object):
                    weakSelf?.handleLoginResponse(user: object as? User)
                    break
                case APIResponse.Failure(_):
                    break
                }
            })
        }else{
             SKToast.makeToast(message)
        }
        
    }
    
    @IBAction func actionRegisterFacebook(sender: UIButton) {
        
        FacebookManager.sharedManager.configureLoginManager(sender: self) { (facebook) in
            weak var weakSelf = self
            weakSelf?.handleFacebookLogin(facebookProfile: facebook)
        }
    }
    
    func handleLoginResponse(user : User?){
       let VC = StoryboardScene.Register.instantiatePhoneNoViewController()
        VC.user = user
        VC.delegate = delegate
        presentVC(VC)
    }
    
    func handleFacebookLogin(facebookProfile : Facebook?){
        
        guard let profile = facebookProfile else { return }
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.LoginFacebook(FormatAPIParameters.FacebookLogin(fbProfile: profile).formatParameters())) { (response) in
            UtilityFunctions.stopLoader()
            weak var weakSelf = self
            switch response {
            case .Success(let object) :
                let userNew = object as? User
                userNew?.fbId = facebookProfile?.fbId
                weakSelf?.facebookLoginWebServicehandler(object: userNew)
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
            self.delegate?.userSuccessfullyLoggedIn(withUser: nil)
         self.presentingViewController?.presentingViewController?.dismissVC(completion: nil)
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
                  break
              case APIResponse.Failure(_):
                  break
            }
            
        }

    }
}

//MARK:- ASAuthorizationControllerDelegate
extension RegisterFirstStepController : ASAuthorizationControllerDelegate {
    
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
