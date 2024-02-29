//
//  ContactUsVC.swift
//  Buraq24
//
//  Created by MANINDER on 07/09/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import MessageUI

class ContactUsVC: BaseVCCab,MFMailComposeViewControllerDelegate,UINavigationControllerDelegate {

    //MARK:- Outlets
    @IBOutlet var txtViewContactUS: PlaceholderTextView!
    @IBOutlet weak var buttonSubmit: UIButton!
    @IBOutlet weak var niewPhone: UIView!
    @IBOutlet weak var viewEmail: UIView!
    @IBOutlet weak var btnContact: UIButton!
        @IBOutlet weak var btnEmail: UIButton!
    //MARK:- Properties
    
    var mailComposer : MFMailComposeViewController?
      let template = AppTemplate(rawValue: (UDSingleton.shared.appSettings?.appSettings?.app_template?.toInt() ?? 0) )
    
    //MARK:- View life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // Dispose of any resources that can be recreated.
    }
    
   /* override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    } */
    
     //MARK:- Action
   
    @IBAction func actionBtnContactUsByphone(_ sender: Any) {
        switch template{
        case .GoMove:  self.callToNumber(number: customerCareGoMove)
        default:  self.callToNumber(number: customerCare2)
        }
        
    }
    
    @IBAction func actionBtnEmail(_ sender: Any) {
        
        if MFMailComposeViewController .canSendMail() {
            
            mailComposer = MFMailComposeViewController()
            switch template{
            case .GoMove:  mailComposer?.setToRecipients([customerSupportEmailGoMove])
            default:  mailComposer?.setToRecipients([customerSupportEmail])
            }
            
            mailComposer?.mailComposeDelegate = self
            guard let composer = mailComposer else { return }
            self.presentVC(composer)
        }else{
            Alerts.shared.show(alert: "AppName".localizedString, message:"email_not_configured".localizedString , type: .error )
        }
    }
    
    @IBAction func actionBtnSharePressed(_ sender: UIButton) {
        if (Validations.sharedInstance.validateContactUS(strReason: txtViewContactUS.text)) {
            let strTrimmed = txtViewContactUS.text.trimmed()
            self.view.endEditing(true)
            sendMessage(message: strTrimmed)
        }
    }
    
    //MARK:- Functions
    
    
    func setupUI() {
       
        view.layoutIfNeeded()
        txtViewContactUS.placeholder = "contact_us_msg_hint".localizedString as NSString
        txtViewContactUS.setAlignment()
        
        buttonSubmit.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        niewPhone.setViewBorderColorSecondary()
        viewEmail.setViewBorderColorSecondary()
        
        btnContact.setButtonWithTintColorSecondary()
        btnEmail.setButtonWithTintColorSecondary()
        
        
        let template = AppTemplate(rawValue: (UDSingleton.shared.appSettings?.appSettings?.app_template?.toInt() ?? 0) )
              switch template {
              case .GoMove?:
                  lblTitle?.text =  "Help"
                  break
                  
              default:
                  print("")
              }
        
    }
    
    
    //MARK:- Mail Composer Delegates
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismissVC(completion: nil)
    }
    
    
}

extension ContactUsVC {
    
    func sendMessage(message : String) {
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        let objContact = LoginEndpoint.contactUs(message: message)
        objContact.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) {  [weak self] (response) in
            switch response {
            case .success(_):
                self?.popVC()
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
}


