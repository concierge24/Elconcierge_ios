//
//  NTVerificationCodeViewController.swift
//  RoyoRide
//
//  Created by Ankush on 15/05/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import UIKit

class NTVerificationCodeViewController: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var stackViewDidntRecieveOtp: UIStackView!
    @IBOutlet var lblMobileNo: UILabel!
    
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var btnResend: UIButton!
    @IBOutlet var lblTimer: UILabel!
    
    @IBOutlet var textFieldCode: UITextField!
    
    @IBOutlet var stackView: UIStackView!
    
    //MARK:- PROPERTIES
    var sendOTP : SendOtp?
    var timer : Timer?
    var signup_as: LoginSignupType?
    var social_key: String?
    
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    
    var totalSecondLeft = 120
    
    //MARK:- VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            
            self?.setUpUI()
            
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        //  addKeyBoardObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        textFieldCode.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        // removeKeyBoardObserver()
    }
    
    func setUpUI() {
        
        lblMobileNo.text = "otp_text".localizedString + " " + /sendOTP?.countryCode + "-" + /sendOTP?.mobileNumber
        
        stackView.semanticContentAttribute = .forceLeftToRight
        
        btnResend.setButtonWithTitleColorBtnText()
        
        btnNext.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        btnNext.setButtonWithTintColorBtnText()
    }
    
    //MARK:- FUNCTIONS
    
    func startTimer() {
        
        totalSecondLeft = 120
        registerBackgroundTask()
        self.timer?.invalidate()
        self.timer = nil
        lblTimer.text = totalSecondLeft.formattedTimer()
        stackViewDidntRecieveOtp.isHidden = true
        lblTimer.isHidden = false
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self , selector: #selector(self.updateTimer), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        
        if totalSecondLeft > 0 {
            totalSecondLeft = totalSecondLeft - 1
            lblTimer.text = totalSecondLeft.formattedTimer()
        }else {
            endBackgroundTask()
            
            btnResend.isUserInteractionEnabled = true
            self.timer?.invalidate()
            stackViewDidntRecieveOtp.isHidden = false
            lblTimer.isHidden = true
            
            clearTxtFields()
        }
    }
    
    func clearTxtFields() {
        self.view.endEditing(true)
        textFieldCode.text = ""
    }
    
    func registerBackgroundTask() {
        
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        assert(backgroundTask != UIBackgroundTaskIdentifier.invalid)
    }
    
    func endBackgroundTask() {
        print("Background task ended.")
        UIApplication.shared.endBackgroundTask(backgroundTask)
        backgroundTask = UIBackgroundTaskIdentifier.invalid
    }
    
}


//MARK:- ButtonSelector
extension NTVerificationCodeViewController {
    
    @IBAction func buttonClicked(_ sender: UIButton) {
        
        // 1- Back, 2- Resend, 3- Next
        
        switch sender.tag {
        case 1:
            popVC()
            
        case 2:
            debugPrint("Resend")
            resendOtp(code: /sendOTP?.countryCode, number: /sendOTP?.mobileNumber, iso: /sendOTP?.iso)
            
        case 3:
            debugPrint("Next")
            (/textFieldCode.text?.trimmed()).isEmpty ? Alerts.shared.show(alert: "AppName".localizedString, message: "Validation.VerificationValidation".localizedString, type: .error )  : verifyOtp(otp: /textFieldCode.text)
            
        default:
            break
        }
    }
}

//MARK:- TextField Selector
extension NTVerificationCodeViewController {
    
    @IBAction func textFieldChanged(_ sender: Any) {
        
        if textFieldCode.text?.count == 4 {
            view.endEditing(true)
        }
        
    }
    
}



//MARK:- API
extension NTVerificationCodeViewController {
    
    func verifyOtp(otp:String) {
        
        self.view.endEditing(true)
        
        let objR = LoginEndpoint.verifyOTP(otpCode: otp)
        
        objR.request(header:  ["language_id" : LanguageFile.shared.getLanguage() , "access_token" : /sendOTP?.accessToken,"secretdbkey": APIBasePath.secretDBKey]) {[weak self] (response) in
            
            switch response {
                
            case .success(let data):
                
                guard let model = data as? LoginDetail else { return }
                self?.endBackgroundTask()
                
                UDSingleton.shared.userData = model
                let appDelegate = UIApplication.shared.delegate as? AppDelegate
                appDelegate?.setHomeAsRootVC()
                
               /* if model.userDetails?.user?.name != "" {
                    
                    UDSingleton.shared.userData = model
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    appDelegate?.setHomeAsRootVC()
                    
                } else {
                    
                    guard let vc = R.storyboard.main.userProfileVC() else{return}
                    vc.loginDetail = model
                    self?.pushVC(vc)
                } */
                break
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
                
            }
        }
    }
    
    func resendOtp(code:String, number:String, iso: String) {
        clearTxtFields()
        
        guard let accountType = signup_as else {return}
        
        let sendOTP = LoginEndpoint.sendOtp(countryCode: code, phoneNum: number, iso: iso, social_key: social_key, signup_as: accountType.rawValue)
        sendOTP.request( header: ["language_id" : LanguageCode.English.rawValue]) { [weak self] (response) in
            switch response {
                
            case .success(let data):
                guard let model = data as? SendOtp else { return }
                
                self?.sendOTP?.accessToken = model.accessToken
                
                // self?.sendOTP = model
                Alerts.shared.show(alert: "AppName".localizedString, message: "otp_resent_successfully".localizedString, type: .error )
                //                  self?.startTimer()
                break
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
}

