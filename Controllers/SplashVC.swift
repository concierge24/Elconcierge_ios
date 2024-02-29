//
//  SplashVC.swift
//  Sneni
//
//  Created by Sandeep Kumar on 30/05/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit
import Alamofire
import ObjectMapper
import GooglePlaces
import GoogleMaps

class SplashVC: UIViewController {
    
    //MARK:- ======== Outlets ========
    @IBOutlet weak var btnTryAgain: UIButton?
    @IBOutlet weak var activityIndicatir: UIActivityIndicatorView!
    @IBOutlet weak var agent_view: UIView! {
        didSet{
           self.agent_view.isHidden = true

            if GDataSingleton.isOnBoardingDone {
                self.agent_view.isHidden = true
                
               // self.getAgentSecretKey()
            }
        }
    }
    @IBOutlet weak var agentCode_textField: UITextField!
    @IBOutlet weak var submit_button: UIButton!
    @IBOutlet weak var splashBg: UIImageView! {
        didSet {
            //splashBg.isHidden = false
          //  splashBg.image = UIImage(named: "LittleSeassorSplash")
//            let locationGif = UIImage.gifImageWithName("keeda")
//            splashBg.image = locationGif
        }
    }
    @IBOutlet weak var logoBg: UIImageView! {
        didSet{
            //logoBg.isHidden = true
        }
    }
    var agentDataFetched = false
    
    //MARK:- ======== Variables ========
    
    //MARK:- ======== LifeCycle ========
    override func viewDidLoad() {
        super.viewDidLoad()
       getAgentData()
       self.getAppSettings()
    }
    
    func getAgentData() {
        var agentCode = ""
        if let code = UserDefaults.standard.value(forKey: "uniqueId") as? String {
           agentCode = code
        } else {
           agentCode = APIConstants.defaultAgentCode
        }
        getAgentSecretKey(code: agentCode)
    }
    
    //MARK:- ======== Actions ========
    @IBAction func didTapTryAgain(_ sender: Any) {
        if !agentDataFetched {
            getAgentData()
            getAppSettings()
        }
        webserviceGetSettings()
    }
    
    //MARK:- ======== Functions ========
    func initalSetup(uniqueId: String) {
        //check previously saved data with current value and clear data if app type changed
        if GDataSingleton.agentUniqueId != uniqueId {
            GDataSingleton.sharedInstance.clearAllSavedData()
        }
        GDataSingleton.agentUniqueId = uniqueId
        GMSPlacesClient.provideAPIKey(GoogleApiKey)
        GMSServices.provideAPIKey(GoogleApiKey)//AIzaSyCNAdSEpIbtSy2rkdGpKqwZMaOv4_WUpJ4
        webserviceGetSettings()
    }

    //MARK:- ======== Actions ========
    @IBAction func submit_buttonAction(_ sender: Any) {
        if self.agentCode_textField.text?.count == 0 {
            SKToast.makeToast("Please enter an agent code!".localized())
        }else {
            let code = agentCode_textField.text  ?? ""
            let trimmed = code.trimmingCharacters(in: .whitespacesAndNewlines)
            print(trimmed)
            UserDefaults.standard.set(code, forKey: "uniqueId")
            //self.getAgentSecretKey()
        }
        
    }
    
    func getAppSettings() {
         
         let getSettings = LoginEndpoint.appSetting
         getSettings.request( header: ["language_id" : LanguageFile.shared.getLanguage()]) {[weak self] (response) in
             switch response {
                 
             case .success(let data):
                 
                 debugPrint(data as Any)
                 
                 guard let model = data as? AppSettingModel, let _ = model.appSettings else { return }
                 
                 UDSingleton.shared.appSettings = model
                 let userInfo = UDSingleton.shared
                 
                // self?.getAgentData()
                 
             case .failure(let strError):
                 Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
                 //Toast.show(text: strError, type: .error)
             }
         }
     }
    
    func getAgentSecretKey(code: String) {
        if !Alamofire.NetworkReachabilityManager()!.isReachable {
            btnTryAgain?.isHidden = false
            SKToast.makeToast(L10n.PleaseCheckYourInternetConnection.string)
                   //refreshControl?.endRefreshing()
            return
        }
        APIManager.sharedInstance.showLoader()
         APIManager.sharedInstance.opertationWithRequest(withApi: API.getSecretKey(uniqueId: code)) { [weak self] (response) in // "parul_0267" //gurmeets_0283 // ialphafoods_0285 // elhormiguero_0301 // ziptaste_0005 // littleceasors_0009 //  adeee1234_0040 // yummy_0122 // pickmyweed_0012
            //ashish_0286//neena_0291 // elhormiguero_0033 // homemprod_0138 //homedev_0530
            APIManager.sharedInstance.hideLoader()
            switch response {
            case .Success(let data):
                if let obj = data as? [String:Any] {
                    if let agentData = obj["agentData"] as? AgentCodeData {
                        
                        if agentData.cbl_customer_domains?.count ?? 0 > 0 {
                            self?.agent_view.isHidden = true
                            self?.initalSetup(uniqueId: agentData.uniqueId ?? code)
                        }else {
                            SKToast.makeToast("Please enter a valid code!".localized())
                        }
                    } else {
                        SKToast.makeToast("Please enter a valid code!".localized())
                    }
                } else {
                    SKToast.makeToast("Please enter a valid code!".localized())
                }
                
                
                
            case .Failure( let message) :
                print(message)
                self?.btnTryAgain?.isHidden = false
                if message.rawValue == "None" {
                    SKToast.makeToast("Please enter a valid code!".localized())
                }
            }
        }
    }
    
    //MARK:- ======== Api's ========
    func webserviceGetSettings()  {
        
        btnTryAgain?.isHidden = true
        activityIndicatir.startAnimating()
        let objR = API.GetSettings(FormatAPIParameters.GetSetting.formatParameters())
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            
            self.activityIndicatir.stopAnimating()
            
            switch response {
            case APIResponse.Success(let object):
                
                guard let object = object as? AppSettings else { return }
                GDataSingleton.sharedInstance.appSettingsData = object
                
//                if let themeColor = GDataSingleton.sharedInstance.appSettingsData?.returnValueForKey(keyValue: "theme_color") {
//                    GDataSingleton.sharedInstance.themeColor = themeColor
//                }
//                if let elementColor = GDataSingleton.sharedInstance.appSettingsData?.returnValueForKey(keyValue: "element_color") {
//                    GDataSingleton.sharedInstance.elementColor = elementColor
//                }
//                if let headerColor = GDataSingleton.sharedInstance.appSettingsData?.returnValueForKey(keyValue: "header_color") {
//                    GDataSingleton.sharedInstance.headerColor = headerColor
//                }
//                if let headerTextColor = GDataSingleton.sharedInstance.appSettingsData?.returnValueForKey(keyValue: "header_text_color") {
//                    GDataSingleton.sharedInstance.headerTextColor = headerTextColor
//                }
//                if let logoBackground = GDataSingleton.sharedInstance.appSettingsData?.returnValueForKey(keyValue: "logo_background") {
//                    GDataSingleton.sharedInstance.logoBackground = logoBackground
//                }
//                if let terminology = GDataSingleton.sharedInstance.appSettingsData?.returnValueForKey(keyValue: "terminology") {
//                    if let dict = self.convertToDictionary(text: terminology){
//                        if let obj = Mapper<TerminologyModalClass>().map(JSONObject: dict) {
//                            GDataSingleton.sharedInstance.terminology = obj
////                            if let status = obj.english?.status {
////                                GDataSingleton.sharedInstance.terminologyEnglishStatus = status
////                            }
////                            if let status = obj.other?.status {
////                                GDataSingleton.sharedInstance.terminologyOtherStatus = status
////                            }
//                        }
//                    }
//                }
                
                ButtonThemeColor.shared.reset()
                
//                GDataSingleton.isOnBoardingDone = false
                
                if !GDataSingleton.isOnBoardingDone {
                    if APIConstants.defaultAgentCode == "lconcierge_0676"{
//                        let vc = OnboardingViewController.getVC(.splash)
//                        self.pushVC(vc)
                        (UIApplication.shared.delegate as? AppDelegate)?.onload()

                    }else{
                        let vc = SelectLocationVC.getVC(.moreScreen)
                        self.pushVC(vc)
                    }
                  
                   
                } else {
                    (UIApplication.shared.delegate as? AppDelegate)?.onload()
                }
            default :
                self.btnTryAgain?.isHidden = false
                break
            }
        }
    }
}
