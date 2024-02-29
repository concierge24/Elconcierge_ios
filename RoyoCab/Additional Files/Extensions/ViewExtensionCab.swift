//
//  ViewExtension.swift
//  BusinessDirectory
//
//  Created by Aseem 13 on 28/12/16.
//  Copyright © 2016 Taran. All rights reserved.
//

import UIKit
import Foundation

//protocol StringType { var get: String { get } }
//
//extension String: StringType { var get: String { return self } }
//
//extension Optional where Wrapped: StringType {
//    func unwrap() -> String {
//        return self?.get ?? ""
//    }
//}

extension Int {
    
    func showCallOption() {
        let str: String = String(self)
        if let url = URL(string: "tel://\(str)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:]) { (result) in
                }
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
}


extension UIView
{
    @IBInspectable var bWidth:CGFloat {
        get{
            return layer.borderWidth
        }
        set{
            layer.borderWidth = newValue
            layer.masksToBounds = newValue > 0
            
        }
    }
    
    @IBInspectable var cRadius:CGFloat{
        get{
            return layer.cornerRadius
        }
        set{
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable var bColor:UIColor{
        get{
            return UIColor.clear
        }
        set{
            layer.borderColor = newValue.cgColor
        }
    }
    
    //Shadow
    @IBInspectable var sRadius:CGFloat{
        get{
            return layer.shadowRadius
        }
        set{
            layer.shadowRadius = newValue
        }
    }
    @IBInspectable var sOffSet:CGSize{
        get{
            return layer.shadowOffset
        }
        set{
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable var sOpacity:Float{
        get{
            return layer.shadowOpacity
        }
        set{
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable var sColor:UIColor{
        get{
            return UIColor(cgColor:layer.shadowColor ?? UIColor.clear.cgColor)
        }
        set{
            layer.shadowColor = newValue.cgColor
        }
    }
    
    @IBInspectable var enableWithCornerRadius:Bool{
        get{
            return false
        }
        set{
            
            self.addShadowWithCornerRadius(cornerRadius: 8.0, shadowOffset: sOffSet, shadowColor: sColor.cgColor, shadowRadius: sRadius,shadowOpacity: sOpacity)
            
            layer.shadowColor = UIColor.clear.cgColor
            layer.shadowOpacity = 0
            layer.shadowRadius = 0
        }
    }
    
}

