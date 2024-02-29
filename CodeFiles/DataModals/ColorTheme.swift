//
//  MyTheme.swift
//  Sneni
//
//  Created by MAc_mini on 21/01/19.
//  Copyright © 2019 Taran. All rights reserved.
//

extension UIColor {
    static var appColor: UIColor {
//        #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        return UIColor(red: 0.8745098039, green: 0.1568627451, blue: 0.3019607843, alpha: 1)
    }
    
    static var appBlue: UIColor {
        if let themeColor = AppSettings.shared.appThemeData?.theme_color {
            let theme = UIColor(hexString: themeColor)
                return theme ?? #colorLiteral(red: 0.1294117647, green: 0.4117647059, blue: 0.8078431373, alpha: 1)
        }
        return #colorLiteral(red: 0.1294117647, green: 0.4117647059, blue: 0.8078431373, alpha: 1)
//        return #colorLiteral(red: 0.2196078431, green: 0.8392156863, blue: 1, alpha: 1)
    }
    
    static var appOringe: UIColor {
        return #colorLiteral(red: 0.1725490196, green: 0.6509803922, blue: 0.6941176471, alpha: 1)
    }
    
    static var appRed: UIColor {
        if let themeColor = AppSettings.shared.appThemeData?.theme_color {
            let theme = UIColor(hexString: themeColor)
                return theme ?? #colorLiteral(red: 0.9568627451, green: 0.1725490196, blue: 0.1882352941, alpha: 1)
        }
        return #colorLiteral(red: 0.9568627451, green: 0.1725490196, blue: 0.1882352941, alpha: 1)
    }
    
    static var appBeauty: UIColor {
        return #colorLiteral(red: 0.9411764706, green: 0.2274509804, blue: 0.462745098, alpha: 1)
    }
    
    static var appHome: UIColor {
        if let themeColor = AppSettings.shared.appThemeData?.theme_color {
            let theme = UIColor(hexString: themeColor)
                return theme ?? #colorLiteral(red: 0.02352941176, green: 0.2274509804, blue: 0.3137254902, alpha: 1)
        }
        return #colorLiteral(red: 0.02352941176, green: 0.2274509804, blue: 0.3137254902, alpha: 1)
    }
    
    static var appConstrution: UIColor {
        return #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
    }
    
    static var appParty: UIColor {
        return #colorLiteral(red: 0, green: 0.7445153594, blue: 1, alpha: 1)
    }
    
    static var appCBCafe: UIColor {
        return #colorLiteral(red: 0.2901960784, green: 0.2901960784, blue: 0.2901960784, alpha: 1)
    }
    
    static var alphaFood: UIColor {
        if let themeColor = AppSettings.shared.appThemeData?.theme_color {
            let theme = UIColor(hexString: themeColor, alpha: 0.7)
            return theme ?? #colorLiteral(red: 0.9568627451, green: 0.1725490196, blue: 0.1882352941, alpha: 1)
        }
        return #colorLiteral(red: 0.9568627451, green: 0.1725490196, blue: 0.1882352941, alpha: 1)
    }
}

struct ViewThemeColor {
    
    static let shared = ViewThemeColor()
    
    var viewThemeColor:UIColor
    var viewBoaderThemeColor:UIColor
    var viewNavThemeColor:UIColor
    var viewSearchThemeColor:UIColor
    var viewHighlightColor:UIColor
    var viewLeftDrawerColor:UIColor
    
    private init() {
        
        self.viewThemeColor = SKAppType.type.color
        self.viewNavThemeColor = UIColor.lightGray
//        if !SKAppType.type.isJNJ {
//            self.viewSearchThemeColor = UIColor(red: 244.0/255.0, green: 244.0/255.0, blue: 244.0/255.0, alpha: 1.0)
//        } else {
//            self.viewSearchThemeColor = #colorLiteral(red: 1, green: 0.8274509804, blue: 0.8196078431, alpha: 1)
//        }
        self.viewSearchThemeColor = UIColor(red: 223.0/255.0, green: 223.0/255.0, blue: 223.0/255.0, alpha: 1.0)//SKAppType.type.alphaColor

        self.viewHighlightColor = UIColor(red: 55.0/255.0, green: 213.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        self.viewLeftDrawerColor = UIColor(red: 39.0/255.0, green: 39.0/255.0, blue: 39.0/255.0, alpha: 1.0)
        self.viewBoaderThemeColor = UIColor(red:0.8, green:0.84, blue:0.85, alpha:1)
        
    
    }
    
}

struct ButtonThemeColor {
    
    static var shared = ButtonThemeColor()
    
    var btnThemeColor = SKAppType.type.color
    var btnBorderThemeColor = SKAppType.type.color
    var btnTitleThemeColor = UIColor.white
    var btnTextThemeColor = SKAppType.type.color
    var btnTintColor = SKAppType.type.color
    var btnSelectedColor = SKAppType.type.color
    var btnUnSelectedColor = SKAppType.type.color
    
    private init(){

    }
    
    mutating func reset() {
        self.btnThemeColor = SKAppType.type.color
        self.btnBorderThemeColor = SKAppType.type.color
        self.btnTitleThemeColor = UIColor.white
        self.btnSelectedColor = SKAppType.type.color//UIColor(red: 55.0/255.0, green: 213.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        self.btnUnSelectedColor = SKAppType.type.color//UIColor(red: 9.0/255.0, green: 9.0/255.0, blue: 9.0/255.0, alpha: 1.0)
        self.btnTextThemeColor = SKAppType.type.color
        self.btnTintColor = SKAppType.type.color
    }
}


struct LabelThemeColor {
    
    static let shared = LabelThemeColor()
    
    var lblThemeColor:UIColor
    var lblNavTitleThemeColor:UIColor
    var lblTitleClr:UIColor
    var lblSubTitleClr:UIColor
    var lblLightTitleClr:UIColor
    var lblSelectedTitleClr:UIColor
    var lblUnSelectedTitleClr:UIColor
    var lblMenuTitleClr:UIColor
    var lblStepperClr:UIColor
    var themeLblColor:UIColor
    
    
    private init(){
        
        self.lblNavTitleThemeColor = UIColor(red:0.32/255.0, green:0.32/255.0, blue:0.32/255.0, alpha:1.0)
        self.lblTitleClr = UIColor(red:0.32, green:0.32, blue:0.32, alpha:1.0)
        self.lblSubTitleClr = UIColor.darkGray
        self.lblLightTitleClr = UIColor.lightGray
        self.lblThemeColor = SKAppType.type.color
        self.lblSelectedTitleClr = UIColor(red: 55.0/255.0, green: 213.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        self.lblUnSelectedTitleClr = UIColor(red: 55.0/255.0, green: 213.0/255.0, blue: 255.0/255.0, alpha: 1.0)
        self.lblStepperClr = SKAppType.type.color
        self.lblMenuTitleClr = UIColor.white
        self.themeLblColor = SKAppType.type.color
    }
}

struct StatusThemeColor {
    
    static let shared = StatusThemeColor()
    var closeStatusColor : UIColor
    var busyStatusColor : UIColor
    var onlineStatusColor : UIColor
    
    private init(){
        self.closeStatusColor = UIColor(hexString: "0xDF3737") ?? UIColor.red
        self.busyStatusColor = UIColor(hexString: "0xF2C307") ?? UIColor.yellow
        self.onlineStatusColor = UIColor(hexString: "0x89D232") ?? UIColor.green
    }
    
}


struct CollectionThemeColor {
    
    static let shared = CollectionThemeColor()
    var collectionbgClr:UIColor
    var collectionTitleClr:UIColor
    var collectionSubTitleClr:UIColor
    var collectionDescClr:UIColor
    var cellThemeColor:UIColor
    var lblSectionHeaderClr:UIColor
    
    var cellSelectedBorderClr:UIColor
    var cellUnSelectedBorderClr:UIColor
    
    private init(){
        
        self.collectionbgClr = UIColor.clear
        self.collectionTitleClr = UIColor(red:0.32, green:0.32, blue:0.32, alpha:1.0)
        self.cellSelectedBorderClr = SKAppType.type.color
        self.cellUnSelectedBorderClr = UIColor.lightGray
        self.collectionSubTitleClr = UIColor.darkGray
        self.collectionDescClr =  UIColor.lightGray
        self.cellThemeColor = UIColor.clear
        self.lblSectionHeaderClr =  UIColor.black
        
    }
}

struct TableThemeColor {
    
    static let shared = TableThemeColor()
    
    var tblBgClr:UIColor
    var cellTblTitleClr:UIColor
    var cellTblSubTitleClr:UIColor
    var cellTblDescClr:UIColor
    var cellThemeColor:UIColor
    var lblSectionHeaderClr:UIColor
    
    private init(){
//        #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        self.tblBgClr = UIColor.clear
        self.cellTblTitleClr = SKAppType.type.color//SKAppType.type.color(red:0.32, green:0.32, blue:0.32, alpha:1.0)
        self.cellTblSubTitleClr = UIColor.darkGray
        self.cellTblDescClr = UIColor.lightGray
        self.cellThemeColor = UIColor.white
        self.lblSectionHeaderClr =  UIColor.white
    }
    
    
}


struct TextFieldTheme {
    
    static let shared = TextFieldTheme()
    
    var txtFld_PlaceholderActiveColor:UIColor
    var txtFld_TextColor:UIColor
    var txtFld_DividerActiveColor:UIColor
    var txtFld_DividerColor:UIColor
    
    var txtFldThemeColor:UIColor
    var txtDividerColor:UIColor
    var txtCursorColor:UIColor
    
    private init() {
        
        //  let color = UIColor.white
        self.txtFld_DividerActiveColor =  SKAppType.type.color
        
            ///UIColor.gray
        self.txtFld_PlaceholderActiveColor =  SKAppType.type.color
        
           // UIColor.lightGray
        
        self.txtFld_TextColor = .darkGray // UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
        
        self.txtFld_DividerColor =  UIColor(red: 51.0/255.0, green: 51.0/255.0
            , blue: 51.0/255.0, alpha: 1.0)
        
        self.txtFldThemeColor = UIColor.black
        self.txtDividerColor = UIColor.black
        self.txtCursorColor = SKAppType.type.color
        
       // self.txtFld_TextColor = .white
//        if let elementColor = GDataSingleton.sharedInstance.appSettingsData?.returnValueForKey(keyValue: "element_color") {
//            let element = UIColor(hexString: elementColor)
//            self.txtFld_TextColor = element ?? UIColor.lightGray
//        } else {
//            self.txtFld_TextColor =   UIColor(red: 51.0/255.0, green: 51.0/255.0, blue: 51.0/255.0, alpha: 1.0)
//        }
        
    }
    
}

struct ThemeimageColor {
    
    static let shared = ThemeimageColor()
    var imgTintColor = SKThemeButtonColorId.gray32.color
    var tintColorFoodAppSupplierDetail = UIColor.gray
    
    private init() {
//        self.imgTintColor = SKAppType.type.color
    }
}

