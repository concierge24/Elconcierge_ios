//
//  SettingsVC.swift
//  Buraq24
//
//  Created by MANINDER on 14/09/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

class SettingsVC: BaseVCCab {
    
    //MARK:- Outlets
    
    @IBOutlet var btnSwitchPushNotification: UISwitch!
    @IBOutlet var btnSelectedLanguage: UIButton!
    @IBOutlet weak var btnDownArrow: UIButton!
    @IBOutlet var lblChangeLanguage: UILabel!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var heightLanguage: NSLayoutConstraint!
    @IBOutlet weak var lblLanguage: UILabel!

    @IBOutlet weak var lblPushNotification: UILabel!
    @IBOutlet weak var lblTerm: UILabel!
    @IBOutlet weak var lblChangeLnaguage: UILabel!
    @IBOutlet weak var lblPrivacy: UILabel!
    @IBOutlet weak var lblAboutUs: UILabel!
    
    
    //MARK:- Properties
    let template = AppTemplate(rawValue: (UDSingleton.shared.appSettings?.appSettings?.app_template?.toInt() ?? 0) )
    var languageArray = UDSingleton.shared.appSettings?.languages
    var languageNameArray = [String]()
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPreviousValues()
        
        if /languageArray?.count != 0 {
            lblLanguage.isHidden = false
            heightLanguage.constant = 70
            
        } else {
            lblLanguage.isHidden = true
            heightLanguage.constant = 0
        }
        lblTitle?.text =  "settings".localizedString
        
        btnSelectedLanguage.setButtonWithTitleColorTheme()
        btnDownArrow.setButtonWithTintColorSecondary()
        btnSwitchPushNotification.setSwitchTintColorSecondary()
        
        let template = AppTemplate(rawValue: (UDSingleton.shared.appSettings?.appSettings?.app_template?.toInt() ?? 0) )
        switch template {
        case .GoMove?:
            lblTitle?.text =  "Settings"
            break
            
        default:
            print("")
        }
        
        languageNameArray.removeAll()
        for language in languageArray ?? [] {
            languageNameArray.append(language.language_name ?? "")
        }
        
//                for language in languageArry{
//                    languageNameArray.append(language)
//                }
        
        lblPushNotification.text = "Setting.Push".localizedString
        lblTerm.text = "Setting.Term".localizedString
        lblChangeLanguage.text = "Setting.ChangeLanguage".localizedString
        lblPrivacy.text = "Setting.Privacy".localizedString
        lblAboutUs.text = "Setting.About".localizedString
        
    }
    
    /* override var preferredStatusBarStyle: UIStatusBarStyle {
     return .lightContent
     } */
 
    //MARK:- Functions
    func setUpPreviousValues() {
        
        if let status = UDSingleton.shared.userData?.userDetails?.notificationStatus  {
            let valBool = status == .Off ? false : true
            btnSwitchPushNotification.setOn(valBool, animated: true)
        }
        
        if  let languageCode = UserDefaultsManager.languageCode{
            //guard let intVal = Int(languageCode) else {return}
            //btnSelectedLanguage.setTitle(languageArry[intVal - 1], for: .normal)
            switch languageCode{
            case "en":
                btnSelectedLanguage.setTitle(languageArry[0], for: .normal)
                //            case "ur":
                //                btnSelectedLanguage.setTitle(languageArry[1], for: .normal)
                
            case "zh","zh-Hans" :
                btnSelectedLanguage.setTitle(languageArry[1], for: .normal)
                
            case "es":
                btnSelectedLanguage.setTitle(languageArry[2], for: .normal)
            case "fr":
                btnSelectedLanguage.setTitle(languageArry[3], for: .normal)
            case "nl":
                btnSelectedLanguage.setTitle(languageArry[4], for: .normal)
            case "ja":
                btnSelectedLanguage.setTitle(languageArry[6], for: .normal)
            case "de":
                btnSelectedLanguage.setTitle(languageArry[7], for: .normal)
            case "ar":
                btnSelectedLanguage.setTitle(languageArry[8], for: .normal)
            case "it":
                btnSelectedLanguage.setTitle(languageArry[5], for: .normal)
            default :
                btnSelectedLanguage.setTitle(languageArry[0], for: .normal)
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Actions
    
    @IBAction func actionBtnChangeLanguage(_ sender: UIButton) {
        
        if  let languageCode = UserDefaultsManager.languageCode{
           // guard let intVal = Int(languageCode) else {return}
            
            switch languageCode{
            
            case "ar","ur":
                showDropDown(view: sender)
                
            default :
                 showDropDown(view: sender)
            }
        }
    }
    
    
    @IBAction func actionSwitchStateChanged(_ sender: UISwitch) {
        changeNotification()
    }
    
    
    @IBAction func actionBtnTermsAndConditions(_ sender: Any) {
        
        
        switch template {
        case .GoMove?:
            
            guard let webView = R.storyboard.mainCab.termsAndConditionsVC() else{return}
            webView.strWebLink = APIBasePath.TermsConditionsGoMove
            webView.strNavTitle = "terms_and_conditions".localizedString
            pushVC(webView)
            
        default:
            
            guard let webView = R.storyboard.mainCab.termsAndConditionsVC() else{return}
            webView.strWebLink = APIBasePath.TermsConditions + LanguageFile.shared.getLanguage()
            webView.strNavTitle = "terms_and_conditions".localizedString
            pushVC(webView)
        }
    }
    
    
    @IBAction func actionBtnPrivacyPressed(_ sender: Any) {
        
        switch template {
        case .GoMove?:
            guard let webView = R.storyboard.mainCab.termsAndConditionsVC() else{return}
            webView.strWebLink = APIBasePath.PrivacyPolicyGoMove
            webView.strNavTitle = "privacy".localizedString
            pushVC(webView)
            
        default:
            
            guard let webView = R.storyboard.mainCab.termsAndConditionsVC() else{return}
            webView.strWebLink = APIBasePath.PrivacyPolicy + LanguageFile.shared.getLanguage()
            webView.strNavTitle = "privacy".localizedString
            pushVC(webView)
        }
    }
    
    @IBAction func actionBtnAboutUs(_ sender: Any) {
        
        
        switch template {
        case .GoMove?:
            guard let webView = R.storyboard.mainCab.termsAndConditionsVC() else{return}
            webView.strWebLink = APIBasePath.AboutUs
            webView.strNavTitle = "about".localizedString
            pushVC(webView)
            
        default:
            guard let aboutUs = R.storyboard.sideMenu.aboutUsVC() else {
                return
            }
            self.pushVC(aboutUs)
        }
        
        
    }
    
   
    //MARK:- Functions
    
    func showDropDown(view : UIView) {
        
        Utility.shared.showDropDown(anchorView: view, dataSource: languageNameArray , width: 85, handler: {[weak self] (index, strValu) in
//            if index == 0  {
//                LanguageFile.shared.setLanguage(languageID: 1,languageCode:"en")
//            }else  if index == 1 {
//                LanguageFile.shared.setLanguage(languageID: 1,languageCode:"zh")
//            }
//            else  if index == 2 {
//                LanguageFile.shared.setLanguage(languageID: 1,languageCode:"es")
//            }
//            else if index == 3  {
//                LanguageFile.shared.setLanguage(languageID: 1,languageCode:"fr")
//            }else  if index == 4 {
//                LanguageFile.shared.setLanguage(languageID: 1,languageCode:"nl")
//            }
//            else  if index == 5 {
//                LanguageFile.shared.setLanguage(languageID: 1,languageCode:"it")
//            }
//            else  if index == 6 {
//                LanguageFile.shared.setLanguage(languageID: 1,languageCode:"ja")
//            }
//            else  if index == 7{
//                LanguageFile.shared.setLanguage(languageID: 1,languageCode:"de")
//            }
            
                        LanguageFile.shared.setLanguage(languageID: /self?.languageArray?[index].language_id,languageCode: /self?.languageArray?[index].language_code?.lowercased())
            
            self?.updatedAppData()
            
        })
        
    }
    
    //MARK:- API
    
    func changeNotification() {
        
        
        
        guard let status = UDSingleton.shared.userData?.userDetails?.notificationStatus  else{return}
        let statusString = status == .Off ? "1" : "0"
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        let objNoti = LoginEndpoint.updateNotifications(value: statusString)
        
        objNoti.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) { [weak self] (response) in
            switch response {
            case .success(let data):
                
                if let userData = UDSingleton.shared.userData {
                    
                    userData.userDetails = data as? UserDetail
                    UDSingleton.shared.userData = userData
                    self?.setUpPreviousValues()
                    
                }
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
                
            }
        }
    }
    
    
    func updatedAppData() {
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        let updateDataVC = LoginEndpoint.updateData(fcmID: UserDefaultsManager.fcmId)
        print("AAAAbabbaba")
        updateDataVC.request(isLoaderNeeded: true, header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token]) {  (response) in
            switch response {
                
            case .success(let data):
                guard let model = data as? HomeCab else { return }
                
                if let userData = UDSingleton.shared.userData {
                    userData.userDetails = model.userDetail
                    userData.support = model.support
                    userData.services = model.services
                    UDSingleton.shared.userData = userData
                    print("shuuuuiii")
                }
                
                ez.runThisInMainThread {
                    AppDelegate.shared().setHomeAsRootVC()
                }
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
                print("shuuuuiii")
            }
        }
    }
}
