//
//  DeliveryTypeView.swift
//  Sneni
//
//  Created by Sandeep Kumar on 02/07/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

enum DeliveryType: Int {
    case delivery = 0
    case pickup
    case both
    
    static var shared: DeliveryType {
        get {
            var defaultT = DeliveryType.delivery
            if SKAppType.type.isJNJ {
                defaultT = .pickup
            }
            return SKAppType.type == .food ? (DeliveryType(rawValue: /(UserDefaults.standard.value(forKey: SingletonKeys.deliveryType.rawValue) as? Int)) ?? defaultT) : defaultT
        }
        set {
            let defaults = UserDefaults.standard
            defaults.set(newValue.rawValue, forKey: SingletonKeys.deliveryType.rawValue)
            defaults.synchronize()
            blockChangeState?(newValue)
        }
    }
    
    static var blockChangeState: ((DeliveryType) -> ())?
}

class DeliveryTypeView: UIView {

    //MARK:- ======== Outlets ========
    @IBOutlet weak var lblBarLine: UILabel? {
        didSet {
            lblBarLine?.backgroundColor = SKAppType.type.color
        }
    }
    @IBOutlet weak var btnDelivery: UIButton!{
        didSet{
            if APIConstants.defaultAgentCode == "yummy_0122"{
                    let image = #imageLiteral(resourceName: "ic_delivery@3x")
                    btnDelivery.setImage(image, for: .normal)
            }
            btnDelivery.setTitle("Delivery".localized(), for: .normal)
                           btnDelivery.adjustImageAndTitleOffsetsForButton(space: 8)
        }
    }
    @IBOutlet weak var btnPickup: UIButton! {
        didSet {
            btnPickup.alpha = 0.5
            if APIConstants.defaultAgentCode == "yummy_0122"{
                let image = #imageLiteral(resourceName: "ic_picked@3x")
                            btnPickup.setImage(image, for: .normal)
                    }
            btnPickup.setTitle("Self pickup".localized(), for: .normal)
            btnPickup.adjustImageAndTitleOffsetsForButton(space: 8)
        }
    }
    
    @IBOutlet weak var leadingLine: NSLayoutConstraint!
    @IBOutlet weak var heightView: NSLayoutConstraint! {
        didSet {
            if SKAppType.type == .eCom {
                heightView.constant = 0
            }
            else {
                heightView.constant = SKAppType.type == .food ? AppSettings.shared.isPickupOrder == 1 || AppSettings.shared.isPickupOrder == 0 ? 0.0 : AppSettings.shared.isSingleVendor ? 0.0 : 50.0 : 0.0
            }
        }
    }

    //MARK:- ======== Variables ========
    var state = DeliveryType.delivery {
        didSet {
            var deliveryType = 0
            if let type = UserDefaults.standard.value(forKey: SingletonKeys.deliveryType.rawValue) as? Int {
                deliveryType = type
            } else {
                UserDefaults.standard.set(deliveryType, forKey: SingletonKeys.deliveryType.rawValue)
            }
            
            leadingLine.constant = deliveryType == 0 ? 0.0 :UIScreen.main.bounds.width/2.0
            btnDelivery.alpha = deliveryType == 0 ? 1 : 0.5
            btnPickup.alpha = deliveryType == 0 ? 0.5 : 1
        }
    }
    var isFirstTime: Bool?
    
    //MARK:- ======== LifeCycle ========
    override func awakeFromNib() {
        super.awakeFromNib()
        initalSetup()
    }
    
    //MARK:- ======== Actions ========
    @IBAction func didTapChnageState(_ sender: UIButton) {
        let type = DeliveryType(rawValue: sender.tag) ?? .delivery

        if DeliveryType.shared == type {
            return
        }
        DBManager.sharedManager.cleanCart()
        DeliveryType.shared = type
        state = type
        UIView.animate(withDuration: 0.5) {
            self.layoutIfNeeded()
        }
    }
    
    //MARK:- ======== Functions ========
    func initalSetup() {
        state = DeliveryType.shared
        if let headerColor = AppSettings.shared.appThemeData?.header_color {
            let header = UIColor(hexString: headerColor)
            self.backgroundColor = .white//header ?? UIColor.white
        }
        self.layoutIfNeeded()
    }
}
