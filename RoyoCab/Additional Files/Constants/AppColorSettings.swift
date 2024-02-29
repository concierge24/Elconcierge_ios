//
//  AppColorSettings.swift
//  RoyoRide
//
//  Created by Ankush on 16/05/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import Foundation


/* let PrimaryColour = "#FFCC01"
let BtnTextColour = "#000000"
let SecondaryBtnColour = "#000000"
let SecondaryBtnTextcolour = "#FFFFFF"
let HeaderColour = "#000000"
let HeaderTextColour = "#FFFFFF" */


  extension UIColor {
    func colorFromHexString (_ hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

//MARK:- UIView Extension
extension UIView {
    func setViewBackgroundColorHeader() {
        self.backgroundColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.header_colour ?? DefaultColor.color.rawValue)
    }
    
    func setViewBackgroundColorTheme() {
        self.backgroundColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.Primary_colour ?? DefaultColor.color.rawValue)
    }
    
    func setViewBackgroundColorBtnText() {
        self.backgroundColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.Btn_Text_Colour ?? DefaultColor.color.rawValue)
    }
    
    func setViewBackgroundColorSecondary() {
        self.backgroundColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue)
    }
    
    func setViewBorderColorSecondary() {
        
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 4.0
        self.layer.borderColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue).cgColor
    }
    
    func addShadowToViewColorSecondary() {
        self.backgroundColor = UIColor.white
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue).withAlphaComponent(0.2).cgColor
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 4.0
    }
}

extension UIButton {
    
    func setButtonWithTitleAndBorderColorSecondary() {
        
    self.setTitleColor(UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue), for: .normal)
        
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 4.0
        self.layer.borderColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue).cgColor
    }
    
    func setButtonWithBorderColorSecondary() {
                
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 4.0
        self.layer.borderColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue).cgColor
    }
    
    func setButtonBorderTitleAndTintColor() {
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 4.0
        self.layer.borderColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue).cgColor
        
        self.tintColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue)
        
    self.setTitleColor(UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue), for: .normal)
    }
    
    
    func setButtonWithBackgroundColorThemeAndTitleColorBtnText() {
    self.setTitleColor(UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.Btn_Text_Colour ?? DefaultColor.color.rawValue), for: .normal)
        self.backgroundColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.Primary_colour ?? DefaultColor.color.rawValue)
    }
    
    
    func setButtonWithBackgroundColorSecondaryAndTitleColorBtnText() {
       self.setTitleColor(UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.Btn_Text_Colour ?? DefaultColor.color.rawValue), for: .normal)
           self.backgroundColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue)
       }
    
    
    func setButtonWithTintColorBtnText() {
        self.tintColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.Btn_Text_Colour ?? DefaultColor.color.rawValue)
    }
    
    func setButtonWithTintColorSecondary() {
        self.tintColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue)
    }
    
    func setButtonWithTintColorHeaderText() {
        self.tintColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.heder_txt_colour ?? DefaultColor.color.rawValue)
    }
    
    
    func setButtonWithTitleColorBtnText() {
        self.setTitleColor(UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.Btn_Text_Colour ?? DefaultColor.color.rawValue), for: .normal)
    }
    
    func setButtonWithTitleColorSecondary() {
        self.setTitleColor(UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue), for: .normal)
    }
    
    func setButtonWithTitleColorTheme() {
        self.setTitleColor(UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.Primary_colour ?? DefaultColor.color.rawValue), for: .normal)
    }
    
    func setButtonWithTitleColorHeaderText() {
        self.setTitleColor(UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.heder_txt_colour ?? DefaultColor.color.rawValue), for: .normal)
    }
    
    
    
}

extension UILabel {
    
    func setTextColorSecondary() {
        self.textColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue)
    }
    
    func setTextColorHeaderText() {
        self.textColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.heder_txt_colour ?? DefaultColor.color.rawValue)
    }
    
    func setTextColorTheme() {
        self.textColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.Primary_colour ?? DefaultColor.color.rawValue)
    }
    
}


extension UISegmentedControl{
    
    func setTextColorBtnText() {
        
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.Btn_Text_Colour ?? DefaultColor.color.rawValue)], for: .selected)
        self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.Btn_Text_Colour ?? DefaultColor.color.rawValue)], for: .normal)
    }
}


extension UITextField {
    
    func setBorderColorSecondary() {
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 4.0
        self.layer.borderColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue).cgColor
    
    }
    
    func setPadding(_ amount:CGFloat){
        
        if Localize.currentLanguage()  == Languages.Arabic || Localize.currentLanguage()  == Languages.Urdu{
            setRightPaddingPoints(amount)
        }else {
            setLeftPaddingPoints(amount)
        }
    }
    
    func setLeftPaddingPoints(_ amount:CGFloat){
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.leftView = paddingView
        self.leftViewMode = .always
    }
    
    func setRightPaddingPoints(_ amount:CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: self.frame.size.height))
        self.rightView = paddingView
        self.rightViewMode = .always
    }
    
    
    func addShadowToTextFieldColorSecondary() {

      self.backgroundColor = UIColor.white
      self.layer.masksToBounds = false
      self.layer.shadowColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue).withAlphaComponent(0.2).cgColor
      self.layer.shadowOffset = CGSize.zero
      self.layer.shadowOpacity = 1.0
      self.layer.shadowRadius = 4.0
    
     }
    
}



extension UITextView {
    
    func setBorderColorSecondary() {
        self.layer.borderWidth = 1.0
        self.layer.cornerRadius = 4.0
        self.layer.borderColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue).cgColor
    }
    
        
    func addShadowToTextViewColorSecondary() {

      self.backgroundColor = UIColor.white
      self.layer.masksToBounds = false
      self.layer.shadowColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue).withAlphaComponent(0.2).cgColor
      self.layer.shadowOffset = CGSize.zero
      self.layer.shadowOpacity = 1.0
      self.layer.shadowRadius = 4.0
    
     }
    
}


extension UIImageView {
    func setImageTintColorSecondary() {
            self.tintColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue)
        }
}


extension UISwitch {
    
    func setSwitchTintColorSecondary() {
        self.onTintColor = UIColor().colorFromHexString(UDSingleton.shared.appSettings?.appSettings?.secondary_colour ?? DefaultColor.color.rawValue)
    }
    
}
