//
//  L102Language.swift
//  Localization102
//
//  Created by Moath_Othman on 2/24/16.
//  Copyright © 2016 Moath_Othman. All rights reserved.
//

import UIKit


//import Foundation
//// constants
//let APPLE_LANGUAGE_KEY = "AppleLanguages"
///// L102Language
//class L102Language {
//    /// get current Apple language
//    class func currentAppleLanguage() -> String{
//        let userdef = UserDefaults.standard
//        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
//        let current = langArray.firstObject as! String
//        return current
//    }
//    /// set @lang to be the first in Applelanguages list
//    class func setAppleLAnguageTo(lang: String) {
//        let userdef = UserDefaults.standard
//        userdef.set([lang,currentAppleLanguage()], forKey: APPLE_LANGUAGE_KEY)
//        userdef.synchronize()
//    }
//}



//MARK:- ======== Api's ========
extension L102Language {
    
    class func changeLang(showLogin: Bool = false, showWalkthrough: Bool = false)
    {
        
        let currentLanguage = L102Language.isRTL ? "en" : "ar"
        
        // change semantics
        //kapil
        L102Language.setAppleLAnguageTo(lang: currentLanguage)
        UIView.appearance().semanticContentAttribute = currentLanguage == "en" ? .forceLeftToRight : .forceRightToLeft
        UINavigationBar.appearance().semanticContentAttribute = currentLanguage == "en" ? .forceLeftToRight : .forceRightToLeft
        
    }

}

//
//  L102Language.swift
//  Localization102
//
//  Created by Moath_Othman on 2/24/16.
//  Copyright © 2016 Moath_Othman. All rights reserved.
//

import UIKit

// constants
let APPLE_LANGUAGE_KEY = "AppleLanguages"
let kapilLanguage = "abcd"
/// L102Language

class L102Language {
    
    
    /// get current Apple language
//    class func currentAppleLanguage() -> String {
//
//        let userdef = UserDefaults.standard
//        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
//
//        let current  = langArray.firstObject as! String
//        let endIndex = current.startIndex
//
//        let currentWithoutLocale = current.substring(to: current.index(endIndex, offsetBy: 2))
//
//        return currentWithoutLocale
//    }
    class func currentAppleLanguage() -> String {
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        let endIndex = current.startIndex
        let currentWithoutLocale = String(current[..<current.index(endIndex, offsetBy: 2)])
        return currentWithoutLocale
    }
    class func currentAppleLanguageFull() -> String {
        
        let userdef = UserDefaults.standard
        let langArray = userdef.object(forKey: APPLE_LANGUAGE_KEY) as! NSArray
        let current = langArray.firstObject as! String
        
        return current
    }
    
    /// set @lang to be the first in Applelanguages list
    class func setAppleLAnguageTo(lang: String) {
        let userdef = UserDefaults.standard
        userdef.set([lang,currentAppleLanguage()], forKey: APPLE_LANGUAGE_KEY)
        userdef.set(lang, forKey: kapilLanguage)
        userdef.synchronize()
    }
    class func kapilAppleLanguage() -> String {
        let userdef = UserDefaults.standard
        let langStr = userdef.value(forKey: kapilLanguage) as? String
        
        
        return langStr ?? "en"
    }
    
    class var isRTL : Bool {
        
        return L102Language.currentAppleLanguage() == "ar"
    }
    
    class var isAppArabic : Bool {
        
        return L102Language.currentAppleLanguage() == "ar"
    }
    
    
}

func MethodSwizzleGivenClassName1(cls: AnyClass, originalSelector: Selector, overrideSelector: Selector) {
    
    guard let origMethod: Method = class_getInstanceMethod(cls, originalSelector) , let overrideMethod: Method = class_getInstanceMethod(cls, overrideSelector) else {return}
    
    if (class_addMethod(cls, originalSelector, method_getImplementation(overrideMethod), method_getTypeEncoding(overrideMethod))) {
        
        class_replaceMethod(cls, overrideSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod))
        
    } else {
        method_exchangeImplementations(origMethod, overrideMethod);
    }
}

extension Bundle {
    
    @objc func specialLocalizedStringForKey(_ key: String, value: String?, table tableName: String?) -> String {
        
        if self == Bundle.main {
            
            let currentLanguage = L102Language.currentAppleLanguage()
            var bundle = Bundle();
            
            if let _path = Bundle.main.path(forResource: L102Language.currentAppleLanguageFull(), ofType: "lproj") {
                
                bundle = Bundle(path: _path)!
                
            }else if let _path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj") {
                
                bundle = Bundle(path: _path)!
                
            } else {
                
                let _path = Bundle.main.path(forResource: "Base", ofType: "lproj")!
                bundle = Bundle(path: _path)!
            }
            
            return (bundle.specialLocalizedStringForKey(key, value: value, table: tableName))
            
        } else {
            
            return (self.specialLocalizedStringForKey(key, value: value, table: tableName))
        }
    }
}

class L102Localizer: NSObject {
    
    class func DoTheMagic() {
        
        MethodSwizzleGivenClassName1(cls: Bundle.self, originalSelector: #selector(Bundle.localizedString(forKey:value:table:)), overrideSelector: #selector(Bundle.specialLocalizedStringForKey(_:value:table:)))
    }
    
    class func DoMagic() {
        
    }
}


extension UIApplication {
    
    class func isRTL() -> Bool {
        return UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft
    }
}
