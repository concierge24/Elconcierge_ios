//
//  ViewExtension.swift
//  Sneni
//
//  Created by MAc_mini on 09/02/19.
//  Copyright © 2019 Taran. All rights reserved.
//
import UIKit
import AVFoundation

extension UIView {
    
    @IBInspectable
      var cornerRadiusR: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidthW: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
    
    func hideContentController(content: UIViewController) {
        
        content.willMove(toParent: nil)
        content.view.removeFromSuperview()
        content.removeFromParent()
    }
    
    func openAnimate(parentVC:UIViewController, childVC:UIViewController, leftMargin:CGFloat, width:CGFloat) {
        
        parentVC.view.addSubview(childVC.view)
        parentVC.addChild(childVC)
        childVC.view.layoutIfNeeded()
        
        childVC.view.frame=CGRect(x:  UIScreen.main.bounds.size.width-leftMargin, y: 0, width: UIScreen.main.bounds.size.width-width, height: UIScreen.main.bounds.size.height)
        UIView.animate(withDuration: 0.5, animations: { () -> Void in
            childVC.view.frame=CGRect(x: leftMargin, y: 0, width: UIScreen.main.bounds.size.width-width, height: UIScreen.main.bounds.size.height);
        }, completion:nil)
        
    }
    
    
    func closeAnimate(childVC:UIViewController,leftMargin:CGFloat,width:CGFloat) {
        
          UIView.animate(withDuration: 1.0, animations: { () -> Void in
            
              childVC.view.frame=CGRect(x:  UIScreen.main.bounds.size.width-leftMargin, y: 0, width: UIScreen.main.bounds.size.width-width, height: UIScreen.main.bounds.size.height)
            
            }, completion:nil)
        
    }
    
    
   
}
