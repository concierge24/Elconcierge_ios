import Foundation
import UIKit

extension UIColor {
    
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    
    class func colorDefaultBrown() -> UIColor {
        return UIColor.init(hexString: "342920")
    }
    
    class func colorDefaultPink() -> UIColor {
        return UIColor.init(hexString: "9B3372")
    }
    
    class func colorDefaultDarkPink() -> UIColor {
        return UIColor.init(hexString: "DB0D7C")
    }
    
    class func colorDefaultGray() -> UIColor {
        return UIColor.init(hexString: "555555")
    }
    
    
    class func colorGray() -> UIColor {
        return UIColor.init(hexString: "424242")
    }
    
    class func colorLightGray() -> UIColor {
        return UIColor.init(hexString: "CCCCCC")
    }
    
    
    class func colorGroupTableView() -> UIColor {
        return UIColor.init(hexString: "EBEBF1")
    }
    
    
    static func colorWhite66() -> UIColor {
        return UIColor(red: 255.0 / 255.0, green: 255.0 / 255.0, blue: 255.0 / 255.0, alpha: 0.66)
    }
    
}

//Tab Bar Colors
extension UIColor
{
    static var colorDefaultBlue:UIColor {
        return UIColor(red:0.22, green:0.15, blue:0.84, alpha:1)
    }
    
    static var colorDefaultBlack:UIColor {
        return UIColor(red:0.06, green:0.06, blue:0.06, alpha:1)
    }
    
    //Tabbar buttons
    static var colorDefaultGreen:UIColor {
        return UIColor(red:0.04, green:0.98, blue:0.58, alpha:1)
    }
    
    static var colorDefaultRed:UIColor {
        return UIColor(red:0.70, green:0.15, blue:0.21, alpha:1)
    }
    
    static var colorDefaultLighPurple:UIColor {
        return UIColor(red:0.84, green:0, blue:0.98, alpha:1)
    }
    
    static var colorDefaultPurple:UIColor {
        return UIColor(red:0.62, green:0.25, blue:1, alpha:1)
    }

    
    static var colorDefaultSkyBlue:UIColor {
        return UIColor(red:66.0/255.0, green:145.0/255.0, blue:206.0/255.0, alpha:1)
    }
    
    
    static var colorDefaultYellow:UIColor {
        return UIColor(red:0.25, green:0.82, blue:0.8, alpha:1)
    }
   static  var colorSkyBlueDarkGradient:UIColor {
        return UIColor(red:0.14, green:0.60, blue:0.82, alpha:1)
    }
    static  var colorSkyBlueLightGradient:UIColor {
        return UIColor(red:0.40, green:0.77, blue:0.90, alpha:1)
    }
    static  var colorDarkGrayPopUp:UIColor {
        return UIColor(red:0.0, green:0.0, blue:0.0, alpha:0.75)
    }
    
    static  var colorGrayGredient:UIColor {
        return UIColor(red:0.92, green:0.93, blue:0.93, alpha:1)
    }
    
    static var placeHolderGray: UIColor {
         return UIColor(red: 0.0, green: 0, blue: 0.0980392, alpha: 0.22)
    }
    
}

@available(iOS 11.0, *)
extension UIColor{
    
    static let AppPurple:UIColor = UIColor.init(named: "AppPurple") ?? UIColor.clear
    static let AppRed:UIColor =  UIColor.init(named: "AppRed") ?? UIColor.clear
    static let AppDarkGrayHigh:UIColor =  UIColor.init(named: "AppDarkGrayHigh") ?? UIColor.clear
    static let AppDefaultLight:UIColor =  UIColor.init(named: "AppDefaultLight") ?? UIColor.clear
    static let AppGreen:UIColor =  UIColor.init(named: "AppGreen") ?? UIColor.clear
    static let AppOrange:UIColor =  UIColor.init(named: "AppOrange") ?? UIColor.clear
    static let AppShadowLightGray:UIColor =  UIColor.init(named: "AppShadowLightGray") ?? UIColor.clear
    static let AppTextBlack:UIColor =  UIColor.init(named: "AppTextBlack") ?? UIColor.clear
    
}
