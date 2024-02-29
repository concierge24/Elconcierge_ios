//
//  OTPVC.swift
//  Buraq24
//
//  Created by Maninder on 30/07/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//



/// RepeatingTimer mimics the API of DispatchSourceTimer but in a way that prevents
/// crashes that occur from calling resume multipOole times on a timer that is
/// already resumed (noted by https://github.com/SiftScience/sift-ios/issues/52



import UIKit

class OTPVC: UIViewController, UITextFieldDelegate, MyTextFieldDelegate{
    
    //MARK:- OUTLETS
    @IBOutlet var arrayOtpViews: [UIView]!
    @IBOutlet weak var stackViewDidntRecieveOtp: UIStackView!
    @IBOutlet var lblMobileNo: UILabel!
    @IBOutlet var txtFieldFirstDigit: MyTextField!
    @IBOutlet var txtFieldSecondDigit: MyTextField!
    @IBOutlet var txtFieldThirdDigit: MyTextField!
    @IBOutlet var txtFieldFourthDigit: MyTextField!
    @IBOutlet weak var txtFieldFifthDigit: MyTextField!
    @IBOutlet weak var txtFieldSixthDigit: MyTextField!
    @IBOutlet weak var lblVerificationCodeTitle: UILabel!
    
    
    
    
    @IBOutlet var viewBottom: UIView!
    @IBOutlet var constraintBottomView: NSLayoutConstraint!
    @IBOutlet var btnBack: UIButton!
    @IBOutlet var btnNext: UIButton!
    @IBOutlet var btnResend: UIButton!
    @IBOutlet var lblTimer: UILabel!
    @IBOutlet var stackView: UIStackView!
    @IBOutlet weak var otpInputWithViews: UIStackView!
    @IBOutlet weak var otpInputWithTextfield: UIStackView!
    @IBOutlet weak var template1Next: UIStackView!
    @IBOutlet weak var otpTextfield: UITextField!
    @IBOutlet weak var btnNextTemplate1: UIButton!
    @IBOutlet weak var lblNotReceiveCode: UILabel!
    
    //MARK:- PROPERTIES
    var sendOTP : SendOtp?
    var timer : Timer?
   
    var backgroundTask: UIBackgroundTaskIdentifier = UIBackgroundTaskIdentifier.invalid
    
    var totalSecondLeft = 120
    
    //MARK:- VIEW CYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnNext.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        btnResend.setButtonWithTitleColorSecondary()
        btnNextTemplate1.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        
        let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
              switch template {
              case .DeliverSome:
                  otpInputWithViews.isHidden = true
                  otpInputWithTextfield.isHidden = false
                  template1Next.isHidden = false
                  btnNext.isHidden = true
                  otpTextfield.becomeFirstResponder()
                  break
               
              case .GoMove:
                btnResend.setTitle("Resend the verification code", for: .normal)
                lblNotReceiveCode.isHidden = true
                otpInputWithViews.isHidden = false
                otpInputWithTextfield.isHidden = true
                template1Next.isHidden = true
                btnNext.isHidden = false
                txtFieldFirstDigit.becomeFirstResponder()
                
              default:
                otpInputWithViews.isHidden = false
                otpInputWithTextfield.isHidden = true
                template1Next.isHidden = true
                btnNext.isHidden = false
                txtFieldFirstDigit.becomeFirstResponder()
                
               
                
              }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
                                  self?.setUpUI()
                              }
              
 
        otpTextfield.delegate = self
       
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        lblVerificationCodeTitle.text = "OTPVC.VerificationCode".localizedString
        lblNotReceiveCode.text = "OTPVC.DontReceiveCode".localizedString
        addKeyBoardObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
       
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        removeKeyBoardObserver()
    }
    
    func setUpUI(){
        
        
        setMobileNumber()
        stackView.semanticContentAttribute = .forceLeftToRight
        
        btnNext.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        btnResend.setButtonWithTitleColorSecondary()

        self.arrayOtpViews.forEach { (view) in
            view.setViewBorderColorSecondary()
        }
        
//        //adding gradient to otp text views
//        self.arrayOtpViews.forEach { (view) in
//            
//            view.addBorderGradient(firstColor: (UIColor.AppPurple?.withAlphaComponent(0.5))!, secondColor: UIColor.AppPurple!)
//            
//        }
    }
    
    //MARK:- FUNCTIONS
    func setMobileNumber() {
        
        txtFieldFirstDigit.myDelegate = self
        txtFieldSecondDigit.myDelegate = self
        txtFieldThirdDigit.myDelegate = self
        txtFieldFourthDigit.myDelegate = self
        txtFieldFifthDigit.myDelegate = self
        txtFieldSixthDigit.myDelegate = self
        
        txtFieldFirstDigit.delegate = self
        txtFieldSecondDigit.delegate = self
        txtFieldThirdDigit.delegate = self
        txtFieldFourthDigit.delegate = self
        txtFieldFifthDigit.delegate = self
        txtFieldSixthDigit.delegate = self
        
        
        lblMobileNo.text = "enter_otp_on".localizedString + " " + /sendOTP?.countryCode + "-" + /sendOTP?.mobileNumber
      //  lblMobileNo.setAlignment()

//        startTimer()
    }
    
    
    
    func startTimer() {
       
        totalSecondLeft = 120
        registerBackgroundTask()
        self.timer?.invalidate()
        self.timer = nil
        lblTimer.text = totalSecondLeft.formattedTimer()
        stackViewDidntRecieveOtp.isHidden = true
        lblTimer.isHidden = false
        self.timer = Timer.scheduledTimer(timeInterval: 1.0, target: self , selector: #selector(OTPVC.updateTimer), userInfo: nil, repeats: true)
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
    
    func addKeyBoardObserver() {
        
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillShow),name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self,selector: #selector(keyboardWillhide),name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyBoardObserver() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    func clearTxtFields() {
        self.view.endEditing(true)
        txtFieldFirstDigit.text = ""
        txtFieldThirdDigit.text = ""
        txtFieldSecondDigit.text = ""
        txtFieldFourthDigit.text = ""
        txtFieldFifthDigit.text = ""
        txtFieldSixthDigit.text = ""
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            animateBottomView(true, height: keyboardHeight)
        }
    }
    @objc func keyboardWillhide(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            animateBottomView(false, height: keyboardHeight)
        }
    }
    
    func animateBottomView(_ isToShown : Bool , height : CGFloat) {
        UIView.animate(withDuration: 0.2) { [weak self] in
                self?.constraintBottomView?.constant =  isToShown ?  -(height) :  -CGFloat(40)
            self?.view.layoutIfNeeded()
        }
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
    
 
    //MARK:- ACTIONS
    
    @IBAction func actionBtnBackPressed(_ sender: UIButton) {
        self.popVC()
    }
    
    
    @IBAction func actionBtnNextPressed(_ sender: Any) {
        
      let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
        switch template {
        case .DeliverSome:
            
            let otp = /otpTextfield.text
            otp.count != 6 ? Alerts.shared.show(alert: "AppName".localizedString, message: "otp_validation_message".localizedString, type: .error )  : verifyOtp(otp: otp)
            
            break
            
        default:
            
            let tempOtp = /txtFieldFifthDigit.text + /txtFieldSixthDigit.text
            
            let otp = /txtFieldFirstDigit.text + /txtFieldSecondDigit.text + /txtFieldThirdDigit.text + /txtFieldFourthDigit.text
            
             let totalOTP = otp + tempOtp
            
            
            totalOTP.count != 6 ? Alerts.shared.show(alert: "AppName".localizedString, message: "otp_validation_message".localizedString, type: .error )  : verifyOtp(otp: totalOTP)
        }
        
        
      
    }
    
    @IBAction func actionBtnResentPressed(_ sender: UIButton) {
        
        resendOtp(code: /sendOTP?.countryCode, number: /sendOTP?.mobileNumber, iso: /sendOTP?.iso)
        
        
    }
    
    @IBAction func actionBtnEditThisNumber(_ sender: UIButton) {
         self.popVC()
    }
}


extension OTPVC{
    //MARK: - TextField Delegate
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if textField == otpTextfield {
             let maxLength = 6
               let currentString: NSString = textField.text! as NSString
               let newString: NSString =
                   currentString.replacingCharacters(in: range, with: string) as NSString
               return newString.length <= maxLength
        }
        
        
        var shouldProcess = false //default to reject
        var shouldMoveToNextField = false //default to remaining on the current field
        let  insertStrLength = string.count
        
        if insertStrLength == 0 {
            
            shouldProcess = true //Process if the backspace character was pressed
            
        } else {
            if /textField.text?.count <= 1 {
                shouldProcess = true //Process if there is only 1 character right now
            }
        }
        
        if shouldProcess {
            
            var mString = ""
            if mString.count == 0 {
                
                mString = string
                shouldMoveToNextField = true
                
            } else {
                //adding a char or deleting?
                if(insertStrLength > 0){
                    mString = string
                    
                } else {
                    //delete case - the length of replacement string is zero for a delete
                    mString = ""
                }
            }
            
            //set the text now
            textField.text = mString
            
            if (shouldMoveToNextField&&textField.text?.count == 1) {
                
                if (textField == txtFieldFirstDigit) {
                    txtFieldSecondDigit.becomeFirstResponder()
                    
                } else if (textField == txtFieldSecondDigit){
                    txtFieldThirdDigit.becomeFirstResponder()
                    
                } else if (textField == txtFieldThirdDigit){
                    txtFieldFourthDigit.becomeFirstResponder()
                    
                } else if (textField == txtFieldFourthDigit){
                    txtFieldFifthDigit.becomeFirstResponder()
                    
                } else if (textField == txtFieldFifthDigit){
                    txtFieldSixthDigit.becomeFirstResponder()
                    
                } else {
                    txtFieldSixthDigit.resignFirstResponder()
                }
            }
        }
        return false
    }
    
    
    //MARK: - MyTextField Delegate
    func textFieldDidDelete() {
        
//        if (txtFieldFirstDigit.hasText ||  txtFieldSecondDigit.hasText || txtFieldThirdDigit.hasText || txtFieldFourthDigit.hasText || txtFieldFifthDigit.hasText || txtFieldSixthDigit.hasText) {
//
//
//            if ( txtFieldSecondDigit.hasText || txtFieldThirdDigit.hasText || txtFieldFourthDigit.hasText) {
//
//                if (txtFieldThirdDigit.hasText || txtFieldFourthDigit.hasText) {
//
//                    if (txtFieldFourthDigit.hasText) {
//
//                    }else{
//                        txtFieldThirdDigit.becomeFirstResponder()
//                    }
//                }else{
//                    txtFieldSecondDigit.becomeFirstResponder()
//                }
//            }else{
//                txtFieldFirstDigit.becomeFirstResponder()
//            }
//        }
        
        
        if (txtFieldFirstDigit.hasText ||  txtFieldSecondDigit.hasText || txtFieldThirdDigit.hasText || txtFieldFourthDigit.hasText || txtFieldFifthDigit.hasText ||  txtFieldSixthDigit.hasText) {
            
            if ( txtFieldSecondDigit.hasText || txtFieldThirdDigit.hasText || txtFieldFourthDigit.hasText || txtFieldFifthDigit.hasText ||  txtFieldSixthDigit.hasText) {
                
                if (txtFieldFifthDigit.hasText ||  txtFieldSixthDigit.hasText) {
                    if (txtFieldSixthDigit.hasText) {
                        
                    } else {
                        txtFieldFifthDigit.becomeFirstResponder()
                    }
                } else if (txtFieldThirdDigit.hasText || txtFieldFourthDigit.hasText) {
                    
                    if (txtFieldFourthDigit.hasText) {
                        txtFieldFourthDigit.becomeFirstResponder()
                    }else{
                        txtFieldThirdDigit.becomeFirstResponder()
                    }
                }else{
                    txtFieldSecondDigit.becomeFirstResponder()
                }
            }else{
                txtFieldFirstDigit.becomeFirstResponder()
            }
        }

    }
}

//MARK:- API
extension OTPVC{
    
    func verifyOtp(otp:String) {
        
        self.view.endEditing(true)
        
        let objR = LoginEndpoint.verifyOTP(otpCode: otp)
        
        objR.request(header:  ["language_id" : LanguageFile.shared.getLanguage() , "access_token" : /sendOTP?.accessToken, "secretdbkey": APIBasePath.secretDBKey]) {[weak self] (response) in
            
            switch response {
                
            case .success(let data):
                
                guard let model = data as? LoginDetail else { return }
                self?.endBackgroundTask()
              
                if model.userDetails?.user?.name != "" {
                    
                    UDSingleton.shared.userData = model
                    let appDelegate = UIApplication.shared.delegate as? AppDelegate
                    appDelegate?.setHomeAsRootVC()
                    
                } else {
                    
                    guard let vc = R.storyboard.mainCab.userProfileVC() else{return}
                    vc.loginDetail = model
                    self?.pushVC(vc)
                }
                break
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )

            }
        }
    }
    
    func resendOtp(code:String, number:String, iso: String) {
            clearTxtFields()
            let sendOTP = LoginEndpoint.sendOtp(countryCode: code, phoneNum: number, iso: iso)
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
