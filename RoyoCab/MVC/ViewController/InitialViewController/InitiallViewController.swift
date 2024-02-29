//
//  InitiallViewController.swift
//  RoyoRide
//
//  Created by Ankush on 08/05/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import UIKit

class InitiallViewController: UIViewController {

    @IBOutlet weak var bottomTitleStack: UIStackView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if "AppName".localizedString == "Delivery20" {
            bottomTitleStack.isHidden = false
        } else {
            bottomTitleStack.isHidden = true
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        getAppSettings()
        //guard let vc = R.storyboard.main.landingAndPhoneInputVC() else{ return }
        //self.pushVC(vc)
    }
    

}

//MARK:- API

extension InitiallViewController {
    
    func getAppSettings() {
        
        let getSettings = LoginEndpoint.appSetting
        getSettings.request( header: ["language_id" : LanguageFile.shared.getLanguage()]) {[weak self] (response) in
            switch response {
                
            case .success(let data):
                
                debugPrint(data as Any)
                
                guard let model = data as? AppSettingModel, let _ = model.appSettings else { return }
                
                UDSingleton.shared.appSettings = model
                let userInfo = UDSingleton.shared
                
                let template = AppTemplate(rawValue: (UDSingleton.shared.appSettings?.appSettings?.app_template?.toInt() ?? 0) )
                switch template {
                case .Moby?:
                    
                    if (userInfo.userData != nil) {
                         ez.runThisInMainThread {
                            AppDelegate.shared().setHomeAsRootVC()
                         }
                      }else  {
                       
                        ez.runThisInMainThread {
                            guard let vc = R.storyboard.newTemplateLoginSignUp.ntLoginSignupTypeViewController() else {return}
                            self?.pushVC(vc)
                        }
                    }
                    
                case .DeliverSome:
                    
                    if (userInfo.userData != nil) {
                        ez.runThisInMainThread {
                           AppDelegate.shared().setHomeAsRootVC()
                        }
                    }else  {
                        
                        ez.runThisInMainThread {
                           guard let loginTemplate1 = R.storyboard.template1_Design.landingAndPhoneInputVCTemplate1() else { return }
                           self?.pushVC(loginTemplate1)
                       }
                    }
                
                    
                default:
                    if (userInfo.userData != nil) {
                         ez.runThisInMainThread {
                            AppDelegate.shared().setHomeAsRootVC()
                         }
                      }else  {
                       
                        ez.runThisInMainThread {
                            guard let vc = R.storyboard.mainCab.landingAndPhoneInputVC() else {return}
                            self?.pushVC(vc)
                        }
                    }
                }
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
                //Toast.show(text: strError, type: .error)
            }
        }
    }
}
