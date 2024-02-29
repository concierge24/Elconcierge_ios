//
//  CartItemsView.swift
//  Sneni
//
//  Created by Sandeep Kumar on 28/06/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit
import EZSwiftExtensions

class CartItemsView: UIView {

    //MARK:- ======== Outlets ========
    @IBOutlet weak var lblPrice: UILabel?
    @IBOutlet weak var lblNameSupplier: UILabel? {
        didSet {
            lblNameSupplier?.isHidden = AppSettings.shared.isSingleVendor ? true : false
        }
    }
    @IBOutlet weak var btnCartBtn: UIButton? {
        didSet {
            if AppSettings.shared.appThemeData?.is_health_theme == "1" {
                btnCartBtn?.setTitle("PROCEED".localized(), for: .normal)
                btnCartBtn?.setImage(UIImage(named: "ico_cart"), for: .normal)
                btnCartBtn?.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.05)
                btnCartBtn?.adjustImageAndTitleOffsetsForButton(space: -14)
                btnCartBtn?.semanticContentAttribute = .forceRightToLeft

            }else {
                btnCartBtn?.setTitle("VIEW CART".localized(), for: .normal)
            }
        }
    }
    @IBOutlet weak var heightCartBottom: NSLayoutConstraint! {
        didSet {
            heightCartBottom.constant = 0
        }
    }

    var arraySupplierNames: [String] = []
    var count: Int = 0
    var totalPrice: Double = 0.0
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    //MARK:- ======== LifeCycle ========
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = SKAppType.type.color
        handleCartQuantity(sender: NSNotification(name: NSNotification.Name(rawValue: ""), object: nil))
        NotificationCenter.default.addObserver(self, selector: #selector(CartButton.handleCartQuantity(sender:)), name: NSNotification.Name(rawValue: CartNotification), object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func update(qty: Int = 0, total: Double = 0.0, names: [String] = []) {
        
        arraySupplierNames = names
        count = qty
        //Doctor - for home
        if GDataSingleton.sharedInstance.cartAppType == SKAppType.home.rawValue, qty > 0 {
            count = 1
        }
        totalPrice = total
        
        var txt = "No Items".localized()
        if count == 1 {
            txt = "\(count) \("Item".localized()) | \("Total".localized()) \(totalPrice.addCurrencyLocale)"
        } else if count > 1 {
            txt = "\(count) \("Items".localized()) | \("Total".localized()) \(totalPrice.addCurrencyLocale)"
        }
        lblPrice?.text = txt
        lblNameSupplier?.isHidden = names.count != 1 || AppSettings.shared.isSingleVendor
        lblNameSupplier?.text = names.first
        if AppSettings.shared.appThemeData?.is_health_theme == "1" {

            btnCartBtn?.semanticContentAttribute = .forceRightToLeft

        }
        //Nitin
       // let noCartBar = (!(SKAppType.type == .home || SKAppType.type == .gym) && SKAppType.type != .food)
        
        //Now cart icon is hidden from top, so show cat view always if it has items
        let noCartBar = false//(!(SKAppType.type == .home) && SKAppType.type != .food && !(SKAppType.type == .eCom))

        var height:CGFloat = 0.0
        if let _ = ez.topMostVC as? CartViewController {
            height = 0
            self.isHidden = true
//            if let _ = vc.parent as? MainTabBarViewController {
//                height = 0
//            } else {
//                height = 48
//            }
        }else {
            height = 48
            self.isHidden = false
        }
        self.heightCartBottom.constant = (noCartBar || self.count == 0) ? 0.0 : height
        self.clipsToBounds = (noCartBar || self.count == 0)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if ez.topMostVC is HomeViewController || ez.topMostVC is DoctorHomeVC {
            guard let parentVc = ez.topMostVC?.parent as? MainTabBarViewController else { return }
            parentVc.selectedIndex = SKAppType.type == .eCom ? 2 : 1
            guard let topVc = parentVc.viewControllers?[1] as? CartViewController else {return}
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: CartNotification), object: self, userInfo: nil)
            topVc.hideBackButton = true
            topVc.cartProdcuts = nil
            if let vc = ez.topMostVC as? HomeViewController {
                topVc.deliveryType = vc.deliveryType
                parentVc.deliveryType = vc.deliveryType
            }
            else {
                topVc.deliveryType = parentVc.deliveryType
            }
        } else if let _ = ez.topMostVC as? CartViewController {
            print("Do Nothing")
        } else {
            let vc = StoryboardScene.Options.instantiateCartViewController()
            vc.hideBackButton = false
            ez.topMostVC?.pushVC(vc)
        }

    }
    
    //MARK:- ======== Functions ========
    @objc func handleCartQuantity(sender : NSNotification) {
        
        DBManager.sharedManager.getCart {
            [weak self] (products) in
            
            guard let arrCart = products as? [Cart] else {
                self?.update()
                return
            }
            
            CartBillCell.getNewTotalPrice(promo: nil, cart: arrCart, minDelCharges: nil, region_delivery_charge: nil) {
                [weak self] (totalPrice, deliveryCharges, discountOnTotal, _, qtyTotal) in
                guard let self = self else {
                    return
                }
                
                let array = arrCart.reduce([], {
                    (array, obj) -> [String] in
                    return array.contains(/obj.supplierName) ? array : array + [/obj.supplierName]
                })
                
                self.update(qty: qtyTotal, total: totalPrice, names: array)
            }
        }
    }

}
