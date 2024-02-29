//
//  LanguageFile.swift
//  Buraq24
//
//  Created by MANINDER on 12/09/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit




class LanguageFile: NSObject {
    
    static let shared = LanguageFile()
   
    func setLanguage(languageID : Int,languageCode:String="en") {
        
        switch languageCode {
            
        case "en":
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            //L102Language.setAppleLAnguageTo(lang: Languages.English)
            UserDefaultsManager.localeIdentifierCustom = "en_US"
        case "hi":
            //L102Language.setAppleLAnguageTo(lang: Languages.Hindi)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            UserDefaultsManager.localeIdentifierCustom = "hi_IN"
            
        case "ur":
           // L102Language.setAppleLAnguageTo(lang: Languages.Urdu)
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            UserDefaultsManager.localeIdentifierCustom = "ur"
            
        case "zh":
           // L102Language.setAppleLAnguageTo(lang: Languages.Chinese)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            UserDefaultsManager.localeIdentifierCustom = "zh-Hans"
            
            
        case "ar":
          //  L102Language.setAppleLAnguageTo(lang: Languages.Arabic)
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            UserDefaultsManager.localeIdentifierCustom = "ar_OM"
            
        case "es":
          // L102Language.setAppleLAnguageTo(lang: Languages.Spanish)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            UserDefaultsManager.localeIdentifierCustom = "es"
        case "fr":
           // L102Language.setAppleLAnguageTo(lang: Languages.French)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            UserDefaultsManager.localeIdentifierCustom = "fr"
            
        case "nl":
           // L102Language.setAppleLAnguageTo(lang: Languages.Dutch)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            UserDefaultsManager.localeIdentifierCustom = "nl"
            
        case "ja":
           // L102Language.setAppleLAnguageTo(lang: Languages.Japnesse)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            UserDefaultsManager.localeIdentifierCustom = "ja"
            
            
        case "de":
          //  L102Language.setAppleLAnguageTo(lang: Languages.German)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            UserDefaultsManager.localeIdentifierCustom = "de"
            
        case "it":
           // L102Language.setAppleLAnguageTo(lang: Languages.Italian)
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            UserDefaultsManager.localeIdentifierCustom = "it"
            
        case "SQ":
            //    L102Language.setAppleLAnguageTo(lang: Languages.Albanian)
                UIView.appearance().semanticContentAttribute = .forceLeftToRight
                UserDefaultsManager.localeIdentifierCustom = "sq"

            
        default:
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
          //  L102Language.setAppleLAnguageTo(lang: Languages.English)
            UserDefaultsManager.localeIdentifierCustom = "en_US"
            
        }
        if languageCode == "zh" || languageCode == "zh-Hans"{
            UserDefaultsManager.languageId = "\(languageID)"
            UserDefaultsManager.languageCode = "\("zh-Hans")"
            UserDefaults.standard.set("zh-Hans", forKey: "language")
            BundleLocalizationCab.sharedInstance().language = "zh-Hans"
            
        } else if languageCode == "SQ"{
            UserDefaultsManager.languageId = "\(languageID)"
            UserDefaultsManager.languageCode = "\("SQ")"
            UserDefaults.standard.set("sq", forKey: "language")
            BundleLocalizationCab.sharedInstance().language = "sq"
            
        } else {
        UserDefaultsManager.languageId = "\(languageID)"
        UserDefaultsManager.languageCode = "\(languageCode)"
        UserDefaults.standard.set(languageCode, forKey: "language")
        BundleLocalizationCab.sharedInstance().language = languageCode
        }
    }
    
    
    func getLanguage() -> String {
        
        if  let languageCode = UserDefaultsManager.languageId{
            return languageCode
        }
           return LanguageCode.English.rawValue
    }
    
    func isLanguageRightSemantic() -> Bool {
        
        if let languageCode = UserDefaultsManager.languageCode {
            if languageCode == "ar" ||  languageCode == "ur" {
               return true
            }
        }
        return false
    }
    
}



extension UIButton{
//    func setAlignment() {
//        if BundleLocalization.sharedInstance().language == Languages.Arabic || BundleLocalization.sharedInstance().language == Languages.Urdu{
//            self.contentHorizontalAlignment = .right
//        }else {
//            self.contentHorizontalAlignment = .left
//        }
//    }
    
    func setLeftAlign(){
        self.contentHorizontalAlignment = .left
    }
}

extension UILabel{
//    func setAlignment() {
//        if Localize.currentLanguage()  == Languages.Arabic || Localize.currentLanguage()  == Languages.Urdu{
//            self.textAlignment = .right
//        }else {
//            self.textAlignment = .left
//        }
//    }
    
    func setLeftAlign(){
        self.textAlignment = .left
    }
}
