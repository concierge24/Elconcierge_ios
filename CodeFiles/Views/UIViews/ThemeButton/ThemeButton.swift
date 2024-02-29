//
//  ThemeButton.swift
//  Sneni
//
//  Created by MAc_mini on 22/01/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

enum SKThemeButtonColorId: String {
    
    case appColor = "AppColor"
    case gray32 = "Gray32"
    case gray90 = "Gray90"
    case white = "White"

    var color: UIColor {
        switch self {
        case .appColor:
            return SKAppType.type.color
        case .gray32:
            return #colorLiteral(red: 0.3176470588, green: 0.3176470588, blue: 0.3176470588, alpha: 1)
        case .gray90:
            return #colorLiteral(red: 0.5647058824, green: 0.5647058824, blue: 0.5647058824, alpha: 1)
        case .white:
            return UIColor.white
        }
    }
}

class SKActivityIndicatorView: UIActivityIndicatorView {
    
    @IBInspectable public var colorId: String = "" {
        didSet {
            guard let id = SKThemeButtonColorId(rawValue: colorId) else { return }
            color = id.color
        }
    }
}

class SKThemeButton: UIButton {
    
    @IBInspectable public var bgColor: String = "" {
        didSet {
            guard let id = SKThemeButtonColorId(rawValue: bgColor) else { return }
            backgroundColor = id.color
        }
    }
    
    @IBInspectable public var imgColorId: String = "" {
        didSet {
            setImage(image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
            setImage(image(for: .selected)?.withRenderingMode(.alwaysTemplate), for: .selected)
            
            guard let id = SKThemeButtonColorId(rawValue: isSelected ? imgSelectedColorId : imgColorId) else { return }
            self.imageView?.tintColor = id.color
        }
    }
    
    @IBInspectable public var imgSelectedColorId: String = "" {
        didSet {
            
            setImage(image(for: .normal)?.withRenderingMode(.alwaysTemplate), for: .normal)
            setImage(image(for: .selected)?.withRenderingMode(.alwaysTemplate), for: .selected)
            guard let id = SKThemeButtonColorId(rawValue: isSelected ? imgSelectedColorId : imgColorId) else { return }
            self.imageView?.tintColor = id.color
            
        }
    }
    
    @IBInspectable public var titleColorId: String = "" {
        didSet {
            guard let id = SKThemeButtonColorId(rawValue: titleColorId) else { return }
            setTitleColor(id.color, for: .normal)
        }
    }
    
    @IBInspectable public var titleSelectedColorId: String = "" {
        didSet {
            guard let id = SKThemeButtonColorId(rawValue: titleSelectedColorId) else { return }
            setTitleColor(id.color, for: .normal)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            guard let id = SKThemeButtonColorId(rawValue: isSelected ? imgSelectedColorId : imgColorId) else { return }
            self.imageView?.tintColor = id.color
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.001) {
            [weak self] in
            guard let self = self else { return }
            
            guard let id = SKThemeButtonColorId(rawValue: self.isSelected ? self.imgSelectedColorId : self.imgColorId) else { return }
            self.imageView?.tintColor = id.color
        }
    }
    
}

class SKThemeView: UIView {
    
    @IBInspectable public var bgColor: String = "" {
        didSet {
            guard let id = SKThemeButtonColorId(rawValue: bgColor) else { return }
            backgroundColor = id.color
        }
    }
}

class ThemeButton: SKThemeButton {
    
    @IBInspectable public var btnTextColor: Bool = true {
        didSet{
            if btnTextColor == true{
                self.setTitleColor(ButtonThemeColor.shared.btnTextThemeColor, for: .normal)
                self.setTitleColor(ButtonThemeColor.shared.btnTextThemeColor, for: .selected)
            }
        }
    }
    
    @IBInspectable public var btnElementTextColor: Bool = true {
        didSet{
            if btnTextColor == true{
                self.setTitleColor(SKAppType.type.elementColor, for: .normal)
                self.setTitleColor(SKAppType.type.elementColor, for: .selected)
                layer.borderColor = SKAppType.type.elementColor.cgColor
            }
        }
    }
    
    @IBInspectable public var btnTintFlag: Bool = true{
        didSet{
            if btnTintFlag == true {
                self.imageView?.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
                self.imageView?.tintColor = ButtonThemeColor.shared.btnTintColor
                self.tintColor = ButtonThemeColor.shared.btnTintColor
            }
        }
    }
    
    @IBInspectable public var btnbgFlag: Bool = true{
        didSet{
            if btnbgFlag == true{
                self.backgroundColor = ButtonThemeColor.shared.btnThemeColor
            }
        }
    }
    
    @IBInspectable public var isVisibleTitleColor: Bool = true{
        didSet{
            if isVisibleTitleColor == true{
               // self.titleLabel?.font =  UIFont(openSans: .boldItalic, size: 15.0)
                self.setTitleColor(ButtonThemeColor.shared.btnTitleThemeColor, for: .normal)
                self.setTitleColor(ButtonThemeColor.shared.btnTitleThemeColor, for: .selected)
            }
        }
    }
    
    @IBInspectable public var isBorderColor: Bool = true{
        didSet{
            if isBorderColor ==  true{
                layer.borderWidth = 1
                 layer.borderColor = ButtonThemeColor.shared.btnBorderThemeColor.cgColor
            }
            else {
                layer.borderWidth = 0
            }
        }
    }
    
    @IBInspectable public var isSelectedColor: Bool = true{
        didSet{
            if isSelectedColor ==  true{
                layer.borderColor = ButtonThemeColor.shared.btnSelectedColor.cgColor
            }
        }
    }
    
    @IBInspectable public var isUnSelectedColor: Bool = true{
        didSet{
            if isSelectedColor ==  true{
                layer.borderColor = ButtonThemeColor.shared.btnUnSelectedColor.cgColor
            }
        }
    }
    
    @IBInspectable public var isbackImage: Bool = true{
        didSet{
            if isbackImage == false{
                 layer.borderColor = ButtonThemeColor.shared.btnBorderThemeColor.cgColor
            }
        }
    }
    
    @IBInspectable public var isMenuBtn: Bool = true{
        didSet{
            if isMenuBtn ==  false{
                 self.setImage(ImageIcon.shared.btnMenu_Icon, for: .normal)
            }
        }
    }
    
    @IBInspectable public var isbtnLanguage: Bool = true{
        didSet{
            if isbtnLanguage ==  false{
                self.setImage(ImageIcon.shared.btnLanguage_Icon, for: .normal)
            }
        }
    }
    
    @IBInspectable public var isbtnFilter: Bool = true{
        didSet{
            if isbtnFilter == false{
                self.setImage(ImageIcon.shared.btnFilter_Icon, for: .normal)
            }
        }
    }
    
    @IBInspectable public var isbtnBack: Bool = true{
        didSet{
            if isbtnBack ==  false{
                self.setImage(ImageIcon.shared.btnBack_Icon, for: .normal)
            }
            else {
                imageView?.mirrorTransform()
                self.tintColor = SKAppType.type.headerTextColor
            }
        }
    }
    
    @IBInspectable public var isbtnFav: Bool = true{
        didSet{
            if isbtnFav == false{
                self.setImage(ImageIcon.shared.btnLanguage_Icon, for: .normal)
            }
        }
    }
    
    @IBInspectable public var isbtnBarCode: Bool = true{
        didSet{
            if isbtnBarCode ==  false{
                self.setImage(ImageIcon.shared.btnBarCode_Icon, for: .normal)
            }
        }
    }
    
    @IBInspectable public var isbtnSearch: Bool = true{
        didSet{
            if isbtnSearch ==  false{
                 self.setImage(ImageIcon.shared.btnSearch_Icon, for: .normal)
            }
        }
    }
    
    @IBInspectable public var isbtnLoc: Bool = true{
        didSet{
            if isbtnLoc == false{
                 self.setImage(ImageIcon.shared.btnLoc_Icon, for: .normal)
            }
        }
    }
    
    @IBInspectable public var isbtnShare: Bool = true{
        didSet{
            if isbtnShare ==  false{
                 self.setImage(ImageIcon.shared.btnShare_Icon, for: .normal)
            }
        }
    }
    
}
