//
//  ThemeImgView.swift
//  Sneni
//
//  Created by MAc_mini on 22/01/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class SKThemeImage: UIImageView {
    
    @IBInspectable public var imgColorId: String = "" {
        didSet {
            
            guard let id = SKThemeButtonColorId(rawValue: imgColorId) else { return }
            self.setImageColor(color: id.color)
            
        }
    }
    
}

class ThemeImgView: UIImageView {
    
    enum ColorId: String {
        case none = ""
        case changeTint = "ChangeTint"
        case changeFoodAppSupplierTint = "ChangeFoodAppSupplierTint"
        
        var color: UIColor? {
            switch self {
            case .changeTint:
                return ThemeimageColor.shared.imgTintColor
            case .changeFoodAppSupplierTint:
                return ThemeimageColor.shared.tintColorFoodAppSupplierDetail
            default:
                return nil
            }
        }
    }
    
    public var idTintColor: ThemeImgView.ColorId = .none {
        didSet {
            if idTintColor == .none {
                return
            }
            self.setImageColor(color: idTintColor.color)
        }
    }
    
    @IBInspectable public var idTint: String? {
        didSet {
            idTintColor = ThemeImgView.ColorId(rawValue: /idTint) ?? .none
        }
    }
    
    @IBInspectable public var isImgIconTintClr: Bool = true {
        didSet{
            
            if isImgIconTintClr == true {
                self.setImageColor(color: ThemeimageColor.shared.imgTintColor)
            }
        }
    }
    
    @IBInspectable public var isThemeTint: Bool = true {
           didSet{
               
               if isImgIconTintClr == true {
                self.setImageColor(color: SKAppType.type.color)
               }
           }
       }
    
}

extension UIImageView {
    func setImageColor(color: UIColor? = nil) {
        let color = color ?? ThemeimageColor.shared.imgTintColor
        let templateImage = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = templateImage
        self.tintColor = color//ThemeimageColor.shared.imgTintColor
    }
}
