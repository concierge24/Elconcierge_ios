//
//  RoyoExtensions.swift
//  Sneni
//
//  Created by Daman on 28/05/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit


extension AppDelegate {
    func showFoodApp(language: String = L102Language.currentAppleLanguage()) {
              
              if AppSettings.shared.appThemeData?.login_template == true && !GDataSingleton.sharedInstance.isLoggedIn {
                  let vc = StoryboardScene.Register.instantiateLoginViewController()
                   (vc as? LoginViewController)?.delegate = self
                             (vc as? SignupSelectionVC)?.delegate = self
                  window?.rootViewController = vc
                  return
              }
              if language == "ar" {
                  UIView.appearance().semanticContentAttribute = .forceRightToLeft
                  UITextField.appearance()
              }
              else {
                  UIView.appearance().semanticContentAttribute = .forceLeftToRight
              }
              //Localize.setCurrentLanguage(language: language)
              let navigationVc = StoryboardScene.Main.instantiateLeftNavigationViewController()
              window?.rootViewController = navigationVc
          }
       
       func showCabApp() {
           if !GDataSingleton.sharedInstance.isLoggedIn {
                 let vc = StoryboardScene.Register.instantiateLoginViewController()
                  (vc as? LoginViewController)?.delegate = self
                            (vc as? SignupSelectionVC)?.delegate = self
               ez.topMostVC?.navigationController?.presentVC(vc)
                 return
             }
           if UDSingleton.shared.userData?.services == nil {
               updatedAppData()
           }
           else {
               setHomeAsRootVC()
           }
       }
       
       func updatedAppData() {
           
           let token = /UDSingleton.shared.userData?.userDetails?.accessToken
           let updateDataVC = LoginEndpoint.updateData(fcmID: UserDefaultsManager.fcmId)
           
           updateDataVC.request(isLoaderNeeded: true, header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token]) {  (response) in
               switch response {
                   
               case .success(let data):
                   guard let model = data as? HomeCab else { return }
                   
                   if let userData = UDSingleton.shared.userData {
                       userData.userDetails = model.userDetail
                       userData.support = model.support
                       userData.services = model.services
                       UDSingleton.shared.userData = userData
                    print("successsssssss")
                   }
                   
                   ez.runThisInMainThread {
                       AppDelegate.shared().setHomeAsRootVC()
                   }
               
               case .failure(let strError):
                   Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
               }
           }
       }
}
