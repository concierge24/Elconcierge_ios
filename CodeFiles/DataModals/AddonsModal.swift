//
//  AddonsModal.swift
//  Sneni
//
//  Created by Apple on 31/10/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import Foundation
import UIKit

class AddonsModalClass: NSObject{
    
    var productId : String?
    var addonId : String?
    var addonData : [[AddonValueModal]]?
    var quantity :Int?
    var typeId : String?
    
    init(productId: String?,addonId: String?,addonData:[[AddonValueModal]]?,quantity: Int?,typeId:String? ) {
        self.productId = productId
        self.addonId = addonId
        self.addonData = addonData
        self.quantity = quantity
        self.typeId = typeId
    }
    
    override init() {
        super.init()
    }
    
    func getAddonPrice(productId: String?,addonId: String?, block: @escaping (Double) -> Void) {
        DBManager.sharedManager.getAddonsDataFromDb(productId: productId ?? "", addonId: addonId ?? "") { (addonsArray) in

            var price : Double = 0.0
            addonsArray.forEach({ (addonObj) in
                addonObj.addonData?.forEach({ (addonModal) in
                    if addonModal.count>0{
                        addonModal.forEach({ (addon) in
                            if let addonPrice = addon.price?.toDouble() {
                                price += addonPrice
                            }
                        })
                        block(price)
                    }
                })
            })
        }

    }
}

class SavedAddonModalClass : NSObject {
    
    var productId : String?
    var addonId : String?
    var cartData : Cart?
    var addons : [AddonsModalClass]?
    var typeId: String?
    var quantity : Int?
    
    init(productId: String?,addonId: String?,cartData:Cart? ,addons : [AddonsModalClass]?,typeId: String? ,quantity : Int? ) {
        self.productId = productId
        self.addonId = addonId
        self.cartData = cartData
        self.addons = addons
        self.typeId = typeId
        self.quantity = quantity
    }
    
    override init() {
        super.init()
    }
}


