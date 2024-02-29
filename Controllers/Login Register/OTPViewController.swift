//
//  OTPViewController.swift
//  Clikat
//
//  Created by cbl73 on 4/21/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import Material
import EZSwiftExtensions

class OTPViewController: LoginRegisterBaseViewController {
    
    var user : User?
    weak var delegate : LoginViewControllerDelegate?

    @IBOutlet weak var btnSubmit : UIButton!{
        didSet{
            self.btnSubmit.setBackgroundColor(SKAppType.type.color, forState: .normal)
            btnSubmit.kern(kerningValue: ButtonKernValue)
        }
    }
    @IBOutlet weak var tfOTP: TextField!{
        didSet{
            tfOTP.setThemeTextField()
        }
    }
    
    @IBOutlet weak var lblNumber: UILabel!
    @IBOutlet weak var btnResend: UIButton! {
        didSet {
            btnResend.isHidden = true
            
            let objTxt = NSMutableAttributedString(string: "Dont't receive your code? ", attributes: [
                NSAttributedString.Key.foregroundColor:UIColor.lightGray
                ])
            
            objTxt.append(NSAttributedString(string: "Resend Code", attributes: [
                NSAttributedString.Key.foregroundColor:SKAppType.type.color,
                .underlineStyle: NSUnderlineStyle.single.rawValue
                ]))
            
            btnResend.setAttributedTitle(objTxt, for: .normal)
        }
    }
    
    var timer : Timer?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        self.getAllCoutryCode()
        
        lblNumber.text = "Enter the OTP sent to".localized() + "\(/user?.countryCode) \(/user?.mobileNo)"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       // timer = Timer.scheduledTimer(timeInterval: 180, target: self, selector: #selector(OTPViewController.startTimer), userInfo: nil, repeats: false)
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        timer?.invalidate()
    }
    
    @objc func startTimer(){
        timer?.invalidate()
        btnResend?.isHidden = false
    }
}


//MARK: - Button Actions

extension OTPViewController{
    
    @IBAction func actionSubmitOTP(sender: AnyObject) {
        
        let message = validateOTP()
        if message.isEmpty {
            
            let objR = API.CheckOTP(FormatAPIParameters.CheckOTP(accessToken :user?.token,OTP: tfOTP?.text).formatParameters())
            APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
                [weak self] (response) in
                guard let self = self else { return }
                
                switch response {
                case APIResponse.Success(_):
                    self.handleCheckOTPResponse()
                    
                case APIResponse.Failure(_):
                    self.btnResend?.isHidden = false
                    break
                }
                
            }
        } else {
            SKToast.makeToast(message)
        }
    }
    
    @IBAction func actionResendOTP(sender: UIButton) {
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.ResendOTP(FormatAPIParameters.ResendOTP(token: user?.token).formatParameters())) {
            (response) in
            switch response {
            case .Success(_):
                SKToast.makeToast(L10n.OTPSent.string)
                self.btnResend?.isHidden = false
            case .Failure(_):
            self.btnResend?.isHidden = false
                //                SKToast.makeToast("Please try again.")
            }
        }
    }
}

extension OTPViewController {
    
    func getAllCoutryCode() {
        
        let countryCodes: [AnyObject] = NSLocale.isoCountryCodes as [AnyObject]
        
        let countries: NSMutableArray = NSMutableArray(capacity: countryCodes.count)
        
        for countryCode in countryCodes {
            
            print(countryCode)
            
            let identifier: String = NSLocale.localeIdentifier(fromComponents: NSDictionary(object: countryCode, forKey: NSLocale.Key.countryCode as NSCopying) as! [String : String])
            let country: String = NSLocale(localeIdentifier: "en_US").displayName(forKey: NSLocale.Key.identifier, value: identifier)!
            countries.add(country)
        }
        let codeForCountryDictionary: [NSObject : AnyObject] = NSDictionary(objects: countryCodes, forKeys: countries as! [NSCopying]) as [NSObject : AnyObject]
        print(codeForCountryDictionary)
                
    }
    
    func handleCheckOTPResponse(){
        if /AppSettings.shared.appThemeData?.user_register_flow == "1" {
            user?.otpVerified = "1"
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
        }else {
            let VC = StoryboardScene.Register.instantiateRegisterViewController()
            VC.user = user
            VC.delegate = delegate
            presentVC(VC)
        }
        
    }
    
    func validateOTP() -> String{
        guard let otp = tfOTP.text else {
            return "Please enter OTP.".localized()
        }
        guard let _ = Int(otp), otp.count == 5 else {
            return "OTP is not Valid.".localized()
        }
        return ""
    }
}
