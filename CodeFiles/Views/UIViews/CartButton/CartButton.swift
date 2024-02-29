//
//  CartButton.swift
//  Clikat
//
//  Created by cblmacmini on 5/15/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class CartButton: SKThemeButton {
    
    let badgeView = M13BadgeView(frame: CGRect(x: 0, y: MidPadding, w: 20, h: 20))
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//       self.setImage(UIImage(asset: .Ic_cart), for: .normal)
//        self.imageView?.image?.withRenderingMode(UIImage.RenderingMode.alwaysTemplate)
//        
//        self.imageView?.tintColor = UIColor.red
      //  let colorTheme = ColorTheme()
        
       // self.setImage(UIImage(asset: .Ic_fb), for: .normal)
        
//        self.imageView?.sd_setImage(with: URL(string: "http://45.232.252.46:8081//clikat-buckettest//Banananutbread6DELMy.jpg"), completed: { (image, errir, type, url) in
//            self.setImage(image, for: .normal)
//        })
        
        badgeView.animateChanges = false
        badgeView.badgeBackgroundColor = ButtonThemeColor.shared.btnThemeColor
       
      //  self.tintColor = ButtonThemeColor.shared.btnTintColor
        self.badgeView.textColor = ButtonThemeColor.shared.btnTitleThemeColor
       // self.titleLabel?.font =   UIFont(openSans: .semiboldItalic, size: 11.0)
//        self.buttonType = UIButton.ButtonType.system
      //  badgeView.badgeBackgroundColor = Colors.MainColor.color()
        badgeView.hidesWhenZero = true
        badgeView.horizontalAlignment = M13BadgeViewHorizontalAlignmentRight
        badgeView.font =  UIFont(openSans: .semibold, size: 11.0)
        //UIFont(name: Fonts.ProximaNova.Light, size: Size.Small.rawValue)
        badgeView.shadowBadge = true
        addSubview(badgeView)
        handleCartQuantity(sender: NSNotification(name: NSNotification.Name(rawValue: ""), object: nil))
        NotificationCenter.default.addObserver(self, selector: #selector(CartButton.handleCartQuantity(sender:)), name: NSNotification.Name(rawValue: CartNotification), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func handleCartQuantity(sender : NSNotification){
        //Nitin
        //isHidden = ((SKAppType.type == .home || SKAppType.type == .gym) || SKAppType.type == .food)
        
        //hide cart button at top and show cart details at bottom only
        isHidden = true//(SKAppType.type == .home || SKAppType.type == .food)
        
//        alpha = SKAppType.type == .home ? 0.0 : 1.0
        DBManager.sharedManager.getCart { (products) in
            weak var weakSelf = self
            var badgeCount = 0
            
            defer {
                UIApplication.shared.cancelAllLocalNotifications()
                if products.count == 0 {
                    GDataSingleton.sharedInstance.currentSupplierId = nil
                    GDataSingleton.sharedInstance.currentCategoryId = nil
                }else {
                    self.createLocalNotification()
                }
            }
            
            for product in products {
                guard let currentProduct = product as? Cart,let quantity = currentProduct.quantity else { continue }
                let quant = quantity == "-1" ? "1" : quantity
                badgeCount += Int(quant) ?? 0
            }
            weakSelf?.badgeView.text = "0"
            weakSelf?.badgeView.text = String(badgeCount < 0 ? 0 : badgeCount)
            
        }
        //        guard let badgeValue = sender.userInfo?["badge"] as? Int else { return }
        //        badgeView.text = String(badgeValue)
    }
    
    func createLocalNotification(){
        
        let localNotification = UILocalNotification()
        //7200
        localNotification.fireDate = Date(timeIntervalSinceNow: 7200)
        localNotification.timeZone = NSTimeZone.local
        localNotification.alertBody = L10n.HaveYouForgotCompletingYourLastShoppingCart.string
        localNotification.alertAction = "View"
        localNotification.soundName = UILocalNotificationDefaultSoundName
        localNotification.userInfo = ["UUID" : ""]
        UIApplication.shared.scheduleLocalNotification(localNotification)
    }
}
