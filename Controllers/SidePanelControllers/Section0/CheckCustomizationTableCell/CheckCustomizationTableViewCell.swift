//
//  CheckCustomizationTableViewCell.swift
//  Sneni
//
//  Created by Apple on 23/10/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class CheckCustomizationTableViewCell: UITableViewCell {

    //MARK:- IBOutlet
    @IBOutlet weak var totalPrice_label: UILabel!
    @IBOutlet weak var customization_label: UILabel!
    @IBOutlet weak var productPrice_label: UILabel!
    @IBOutlet weak var productName_label: UILabel!
    @IBOutlet var stepper: GMStepper? {
        didSet {
            stepper?.willHideRemoveCart = true
            stepper?.forCheckCustomizationVC = true
        }
    }
    
    //MARK:- Variables
    var index: Int?
    var completionBlock : AnyCompletionBlock?
    var product : ProductF? {
        didSet {
            
            if let arrayAddon = product?.savedAddons[self.index ?? 0] {
                
                self.productName_label?.text = product?.name
                let productPrice = product?.price
                
                for arrayAdd in arrayAddon.addonData ?? []{
                    
                    var totalPrice = ""
                    var totalPriceDouble:Double = 0.0
                    var addons = ""
                    
                    totalPriceDouble = (productPrice?.toDouble() ?? 0.0)
                    
                    for addon in arrayAdd {
                        if let price = addon.price {
                            if let priceDouble = Double(price) {
                                totalPriceDouble = totalPriceDouble + priceDouble
                                let value = UtilityFunctions.appendOptionalStrings(withArray: [priceDouble.addCurrencyLocale])
                                totalPrice =  value + "," + totalPrice
                            }
                        }
                        if let addon = addon.type_name {
                            addons = addon + "," + addons
                        }
                    }
                    
                    if addons.last == "," {
                        addons.removeLast()
                    }
                    if totalPrice.last == "," {
                        totalPrice.removeLast()
                    }
                    
                    totalPriceDouble = (Double(arrayAddon.quantity ?? 0) * totalPriceDouble)
                    productPrice_label?.text = totalPrice
                    customization_label.text = "\("Extras:".localized()) " + addons
                    self.totalPrice_label.text = UtilityFunctions.appendOptionalStrings(withArray: [totalPriceDouble.addCurrencyLocale])

                }
                
              //  self.updateValue()
                stepper?.associatedProduct = product
                stepper?.isCartView = false
                
                stepper?.addonStepperListner = {  [weak self] (value) in
                    guard let self = self else { return }
                    guard let block = self.completionBlock else {return}
                    if let data = value as? (Double,Bool) {
                        self.stepper?.value = data.0
                        block(data as AnyObject)
                    } else if let data = value as? (Bool,Bool) {
                        block(data as AnyObject)
                    }
                }
                self.stepper?.value = Double(arrayAddon.quantity ?? 0)
            }
            
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func updateValue() {
        
        DBManager.sharedManager.getCart {
            [weak self] (products) in
            
            guard let arrCart = products as? [Cart] else {
                return
            }
            
            CartBillCell.getNewTotalPrice(promo: nil, cart: arrCart, minDelCharges: nil, region_delivery_charge: nil) {
                [weak self] (totalPrice, deliveryCharges, discountOnTotal, _, qtyTotal) in
                guard let self = self else {
                    return
                }
                let value = UtilityFunctions.appendOptionalStrings(withArray: [totalPrice.addCurrencyLocale])
                self.totalPrice_label.text = value
            }
        }
    }
    
}
