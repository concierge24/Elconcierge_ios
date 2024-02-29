//
//  DBManager.swift
//  Clikat
//
//  Created by cblmacmini on 5/10/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import CoreData
import SwiftyJSON
import EZSwiftExtensions

enum AddonKeys : String {
    
    case addonData
    case addonId
    case productId
    case quantity
    case typeId

}
enum CartKeys : String{
    
    case id = "id"
    case name = "name"
    case dateModified = "dateModified"
    case quantity = "quantity"
    case price = "price"
    case productType = "productType"
    case image = "image"
    case deliveryCharges = "deliveryCharges"
    case handlingAdmin = "handlingAdmin"
    case handlingSupplier = "handlingSupplier"
    case supplierBranchId = "supplierBranchId"
    case displayPrice = "displayPrice"
    case sku = "sku"
    case measuringUnit = "measuringUnit"
    
    case priceType = "priceType"
    case fixedPrice = "fixedPrice"
    case hourlyPrice = "hourlyPrice"
    case canUrgent = "canUrgent"
    case urgentValue = "urgentValue"
    case urgentType = "urgentType"
    case category = "category"
    case categoryId = "categoryId"
    case supplier_id = "supplier_id"
    case suppliername = "supplier_name"
    case agentlist = "agentlist"
    case isAgent = "isAgent"
    case duration
    case isProduct
    case addOns
    case isAddon
    case arrayAddOnValue
    case addOnId
    case selfPickup
    
    case typeId
    case latitude
    case longitude
    case radius_price
    case averageRating
    case supplierAddrerss
    case deliveryMaxTime
    case totalQuantity
    case purchased_quantity
    case variants
    case questionsSelected
    case payment_after_confirmation
    case distanceValue
}

extension String {
    var toDict: [String: Any]? {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                let dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                return dictonary
            } catch let error as NSError {
                print(error)
            }
        }
        return nil
    }
    
    static func toString(dict : [String: Any]) -> String {
        do {
            let data = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            let dataString = String(data: data, encoding: String.Encoding.utf8)
            return /dataString
        } catch let error as NSError {
            print(error)
        }
        return ""
    }
}

class DBManager: NSObject {
    
    var coreDataStack : CoreDataStack{
        get{
            let delegate = UIApplication.shared.delegate as! AppDelegate
            return delegate.coreDataStack
        }
    }
    
    static var sharedManager = DBManager()
    
    func getCart(result : @escaping CartCompletionBlock) {
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntity.Cart.rawValue)
        
        DispatchQueue.main.async {
            self.coreDataStack.managedObjectContext.perform {
                 do {
                     guard let results = try self.coreDataStack.managedObjectContext.fetch(fetchRequest) as? [NSManagedObject] else { return }
                     let cartArray = self.convertManagedObjectArrayToCartArray(arrManagedObject: results)
                     result(cartArray)
                 } catch let error {
                     print(error)
                 }
             }
        }
 
    }
    
    func convertManagedObjectArrayToCartArray(arrManagedObject : [NSManagedObject]) -> [Cart] {
        
        var arrCart : [Cart] = []
        for mc in arrManagedObject {
            let cart = Cart()
            cart.id = mc.value(forKey: CartKeys.id.rawValue) as? String
            cart.quantity = mc.value(forKey: CartKeys.quantity.rawValue) as? String
            cart.name = mc.value(forKey: CartKeys.name.rawValue) as? String
            cart.dateModified = mc.value(forKey: CartKeys.dateModified.rawValue) as? Date
            cart.handlingSupplier = mc.value(forKey: CartKeys.handlingSupplier.rawValue) as? String
            cart.productType = mc.value(forKey: CartKeys.productType.rawValue) as? String
            cart.image = mc.value(forKey: CartKeys.image.rawValue) as? String
            cart.deliveryCharges = mc.value(forKey: CartKeys.deliveryCharges.rawValue) as? String
            cart.handlingAdmin = mc.value(forKey: CartKeys.handlingAdmin.rawValue) as? String
            cart.supplierBranchId = mc.value(forKey: CartKeys.supplierBranchId.rawValue) as? String
            cart.displayPrice = mc.value(forKey: CartKeys.displayPrice.rawValue) as? String
            cart.sku = mc.value(forKey: CartKeys.sku.rawValue) as? String
//            cart.measuringUnit = mc.value(forKey: CartKeys.measuringUnit.rawValue) as? String
            
            let txtM = mc.value(forKey: CartKeys.measuringUnit.rawValue) as? String
            let dictM = JSON(txtM?.toDict ?? [:])
            cart.measuringUnit = dictM.dictionary?[CartKeys.measuringUnit.rawValue]?.string
            cart.isQuantity = dictM.dictionary?[ProductKeys.isQuantity.rawValue]?.int
            
            cart.canUrgent = mc.value(forKey: CartKeys.canUrgent.rawValue) as? String
            cart.fixedPrice = mc.value(forKey: CartKeys.fixedPrice.rawValue) as? String

            cart.price = mc.value(forKey: CartKeys.price.rawValue) as? String
            cart.priceType = PriceType(rawValue: (mc.value(forKey: CartKeys.priceType.rawValue) as? String)?.toInt() ?? 2) ?? .None

            cart.isProduct = ProductType(rawValue: /(mc.value(forKey: CartKeys.isProduct.rawValue) as? Int)) ?? .product
            cart.agentList = mc.value(forKey: CartKeys.agentlist.rawValue) as? String
            cart.isAgent = mc.value(forKey: CartKeys.isAgent.rawValue) as? String
            cart.deliveryMaxTime = mc.value(forKey: CartKeys.deliveryMaxTime.rawValue) as? Int
            cart.strHourlyPrice = mc.value(forKey: CartKeys.hourlyPrice.rawValue) as? String
            cart.hourlyPrice = Cart.initializePriceArray(rawStr: cart.strHourlyPrice) ?? []
            cart.duration = mc.value(forKey: CartKeys.duration.rawValue) as? Int
            
            cart.urgentValue = mc.value(forKey: CartKeys.urgentValue.rawValue) as? String
            cart.urgentType = mc.value(forKey: CartKeys.urgentType.rawValue) as? String
            cart.category = mc.value(forKey: CartKeys.category.rawValue) as? String
            cart.categoryId = mc.value(forKey:CartKeys.categoryId.rawValue) as? String
            cart.supplierId = mc.value(forKey:CartKeys.supplier_id.rawValue) as? String
            cart.supplierName = mc.value(forKey: CartKeys.suppliername.rawValue) as? String
            
            //Nitin
            cart.addOns = mc.value(forKey: CartKeys.addOns.rawValue) as? [AddonValueModal]
            cart.isAddonAdded = mc.value(forKey: CartKeys.isAddon.rawValue) as? Bool
            cart.arrayAddonValue = mc.value(forKey: CartKeys.arrayAddOnValue.rawValue) as? [[AddonValueModal]]
            cart.addOnId = mc.value(forKey: CartKeys.addOnId.rawValue) as? String
            cart.typeId = mc.value(forKey: CartKeys.typeId.rawValue) as? String

            cart.latitude = mc.value(forKey: CartKeys.latitude.rawValue) as? Double
            cart.longitude = mc.value(forKey: CartKeys.longitude.rawValue) as? Double
            cart.radius_price = mc.value(forKey: CartKeys.radius_price.rawValue) as? Double
            cart.averageRating = mc.value(forKey: CartKeys.averageRating.rawValue) as? Int
            cart.supplierAddressCart = mc.value(forKey: CartKeys.supplierAddrerss.rawValue) as? String
            cart.purchased_quantity = mc.value(forKey: CartKeys.purchased_quantity.rawValue) as? Int
            cart.totalQuantity = mc.value(forKey: CartKeys.totalQuantity.rawValue) as? Int
            cart.selectedVariants = mc.value(forKey: CartKeys.variants.rawValue) as? [ProductVariantValue]
            cart.questionsSelected = mc.value(forKey: CartKeys.questionsSelected.rawValue) as? [Question]
            cart.payment_after_confirmation = mc.value(forKey: CartKeys.payment_after_confirmation.rawValue) as? Bool ?? false
            cart.distanceValue = mc.value(forKey: CartKeys.distanceValue.rawValue) as? Double ?? 0
            cart.updateHourly()
            
            arrCart.append(cart)
        }
        
        return arrCart
    }
    
    
    func saveProductsToCart(entityName : String, product : ProductF?, quantity : Int){
        
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: (coreDataStack.managedObjectContext)),let currentProduct = product else {
            fatalError("Could not find entity descriptions!")
        }
        
        coreDataStack.managedObjectContext.mergePolicy = NSErrorMergePolicy
        print("\nSaved product id = \(currentProduct.id ?? "")")
        let cartProduct = NSManagedObject(entity: entity, insertInto: coreDataStack.managedObjectContext)
        cartProduct.setValue(currentProduct.id, forKey: CartKeys.id.rawValue)
        cartProduct.setValue(currentProduct.dateModified, forKey: CartKeys.dateModified.rawValue)
        cartProduct.setValue(currentProduct.handlingSupplier, forKey: CartKeys.handlingSupplier.rawValue)
        cartProduct.setValue(currentProduct.name, forKey: CartKeys.name.rawValue)
        cartProduct.setValue(quantity.toString, forKey: CartKeys.quantity.rawValue)
        cartProduct.setValue(currentProduct.productType, forKey: CartKeys.productType.rawValue)
        cartProduct.setValue(currentProduct.image, forKey: CartKeys.image.rawValue)
        cartProduct.setValue(currentProduct.deliveryCharges, forKey: CartKeys.deliveryCharges.rawValue)
        cartProduct.setValue(currentProduct.handlingAdmin, forKey: CartKeys.handlingAdmin.rawValue)
        cartProduct.setValue(currentProduct.supplierBranchId, forKey: CartKeys.supplierBranchId.rawValue)
        cartProduct.setValue(currentProduct.displayPrice, forKey: CartKeys.displayPrice.rawValue)
        
        let dict = [
            CartKeys.measuringUnit.rawValue:/currentProduct.measuringUnit,
            ProductKeys.isQuantity.rawValue:/currentProduct.isQuantity
            ] as [String : Any]
        cartProduct.setValue(String.toString(dict: dict), forKey: CartKeys.measuringUnit.rawValue)
        cartProduct.setValue(currentProduct.sku, forKey: CartKeys.sku.rawValue)
        cartProduct.setValue(currentProduct.canUrgent, forKey: CartKeys.canUrgent.rawValue)
        cartProduct.setValue(currentProduct.fixedPrice, forKey: CartKeys.fixedPrice.rawValue)
        cartProduct.setValue(currentProduct.urgentValue, forKey: CartKeys.urgentValue.rawValue)
        cartProduct.setValue(currentProduct.urgentType, forKey: CartKeys.urgentType.rawValue)
        cartProduct.setValue(currentProduct.category, forKey: CartKeys.category.rawValue)
        cartProduct.setValue(currentProduct.categoryId, forKey: CartKeys.categoryId.rawValue)
//         cartProduct.setValue(FilterCategory.shared.catIDString, forKey: CartKeys.categoryId.rawValue)
        cartProduct.setValue(currentProduct.supplierName, forKey: CartKeys.suppliername.rawValue)
        cartProduct.setValue(currentProduct.supplierId, forKey: CartKeys.supplier_id.rawValue)
        cartProduct.setValue(currentProduct.agentList, forKey: CartKeys.agentlist.rawValue)
        cartProduct.setValue(currentProduct.isAgent, forKey: CartKeys.isAgent.rawValue)
         //cart.agent_list = mc.value(forKey: CartKeys.agentlist.rawValue) as? String

        cartProduct.setValue(currentProduct.price, forKey: CartKeys.price.rawValue)
        cartProduct.setValue(currentProduct.duration, forKey: CartKeys.duration.rawValue)
        cartProduct.setValue(currentProduct.isProduct.rawValue, forKey: CartKeys.isProduct.rawValue)
        cartProduct.setValue(currentProduct.strHourlyPrice, forKey: CartKeys.hourlyPrice.rawValue)
        cartProduct.setValue(currentProduct.priceType.rawValue.toString, forKey: CartKeys.priceType.rawValue)

        //Nitin
        cartProduct.setValue(currentProduct.addOnValue, forKey: CartKeys.addOns.rawValue)
        if let addons = currentProduct.addOnValue,addons.count>0{
            cartProduct.setValue(true, forKey: CartKeys.isAddon.rawValue)
        } else {
            cartProduct.setValue(false, forKey: CartKeys.isAddon.rawValue)
        }
        cartProduct.setValue(currentProduct.arrayAddonValue, forKey: CartKeys.arrayAddOnValue.rawValue)
        cartProduct.setValue(currentProduct.addOnId, forKey: CartKeys.addOnId.rawValue)
        cartProduct.setValue(currentProduct.typeId, forKey: CartKeys.typeId.rawValue)
        
        cartProduct.setValue(currentProduct.latitude, forKey: CartKeys.latitude.rawValue)
        cartProduct.setValue(currentProduct.longitude, forKey: CartKeys.longitude.rawValue)
        cartProduct.setValue(currentProduct.radius_price, forKey: CartKeys.radius_price.rawValue)
        cartProduct.setValue(currentProduct.averageRating, forKey: CartKeys.averageRating.rawValue)
        cartProduct.setValue(currentProduct.supplierAddrerss, forKey: CartKeys.supplierAddrerss.rawValue)
        cartProduct.setValue(currentProduct.deliveryMaxTime, forKey: CartKeys.deliveryMaxTime.rawValue)
        cartProduct.setValue(currentProduct.purchased_quantity, forKey: CartKeys.purchased_quantity.rawValue)
        cartProduct.setValue(currentProduct.totalQuantity, forKey: CartKeys.totalQuantity.rawValue)
        cartProduct.setValue(currentProduct.distanceValue, forKey: CartKeys.distanceValue.rawValue)
        
        if let variants = currentProduct.selectedVariants, variants.count > 0 {
            cartProduct.setValue(variants, forKey: CartKeys.variants.rawValue)
        }
        if let questions = currentProduct.questionsSelected, questions.count > 0 {
            cartProduct.setValue(questions, forKey: CartKeys.questionsSelected.rawValue)
        }
        cartProduct.setValue(currentProduct.payment_after_confirmation, forKey: CartKeys.payment_after_confirmation.rawValue)
        coreDataStack.saveMainContext()

    }
    
    func manageCart(product: ProductF?, quantity : Int?){
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: CartNotification), object: self, userInfo: ["badge" : quantity ?? 0])
        
        if let qty = quantity {
            if qty == 0 {
                removeProductFromCart(productId: product?.id)
            }else{
                updateProductsToCart(product: product, quantity: quantity)
            }
        } else {
            updateProductsToCart(product: product, quantity: quantity)
        }
        
    }
    
    func updateProductsToCart(product : ProductF?, quantity : Int?){

        let managedContext = coreDataStack.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntity.Cart.rawValue)
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "id = %@", product?.id ?? "")
        fetchRequest.predicate = predicate
        guard let currentProduct = product else {
            return
        }
        
        do { 
            var cartProduct: [NSManagedObject] = []
            if let array = try? managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                cartProduct = array ?? []
            }

            for cart in cartProduct {
                
                cart.setValue(currentProduct.id, forKey: CartKeys.id.rawValue)
                cart.setValue(currentProduct.dateModified, forKey: CartKeys.dateModified.rawValue)
                cart.setValue(currentProduct.handlingSupplier, forKey: CartKeys.handlingSupplier.rawValue)
                cart.setValue(currentProduct.name, forKey: CartKeys.name.rawValue)
                if quantity != nil {
                    cart.setValue(quantity?.toString, forKey: CartKeys.quantity.rawValue)
                }
                cart.setValue(currentProduct.price, forKey: CartKeys.price.rawValue)
                cart.setValue(currentProduct.productType, forKey: CartKeys.productType.rawValue)
                cart.setValue(currentProduct.image, forKey: CartKeys.image.rawValue)
                cart.setValue(currentProduct.deliveryCharges, forKey: CartKeys.deliveryCharges.rawValue)
                cart.setValue(currentProduct.handlingAdmin, forKey: CartKeys.handlingAdmin.rawValue)
                cart.setValue(currentProduct.supplierBranchId, forKey: CartKeys.supplierBranchId.rawValue)
                cart.setValue(currentProduct.displayPrice, forKey: CartKeys.displayPrice.rawValue)
                
                let dict = [
                    CartKeys.measuringUnit.rawValue:/currentProduct.measuringUnit,
                    ProductKeys.isQuantity.rawValue:/currentProduct.isQuantity
                    ] as [String : Any]
                cart.setValue(String.toString(dict: dict), forKey: CartKeys.measuringUnit.rawValue)
//                cart.setValue(currentProduct.measuringUnit, forKey: CartKeys.measuringUnit.rawValue)
                cart.setValue(currentProduct.sku, forKey: CartKeys.sku.rawValue)
                cart.setValue(currentProduct.canUrgent, forKey: CartKeys.canUrgent.rawValue)
                cart.setValue(currentProduct.priceType.rawValue.toString, forKey: CartKeys.priceType.rawValue)
                cart.setValue(currentProduct.fixedPrice, forKey: CartKeys.fixedPrice.rawValue)
                cart.setValue(currentProduct.strHourlyPrice, forKey: CartKeys.hourlyPrice.rawValue)
                cart.setValue(currentProduct.urgentValue, forKey: CartKeys.urgentValue.rawValue)
                cart.setValue(currentProduct.urgentType, forKey: CartKeys.urgentType.rawValue)
                cart.setValue(currentProduct.category, forKey: CartKeys.category.rawValue)
                cart.setValue(currentProduct.categoryId, forKey: CartKeys.categoryId.rawValue)
                cart.setValue(currentProduct.supplierId, forKey: CartKeys.supplier_id.rawValue)
                cart.setValue(currentProduct.supplierName, forKey: CartKeys.suppliername.rawValue)
                cart.setValue(currentProduct.agentList, forKey: CartKeys.agentlist.rawValue)
                cart.setValue(currentProduct.isAgent, forKey: CartKeys.isAgent.rawValue)
                cart.setValue(currentProduct.duration, forKey: CartKeys.duration.rawValue)
                cart.setValue(currentProduct.isProduct.rawValue, forKey: CartKeys.isProduct.rawValue)
                
                //Nitin
                cart.setValue(currentProduct.addOnValue, forKey: CartKeys.addOns.rawValue)
                if let addons = currentProduct.addOnValue,addons.count>0{
                    cart.setValue(true, forKey: CartKeys.isAddon.rawValue)
                } else {
                    cart.setValue(false, forKey: CartKeys.isAddon.rawValue)
                }
                cart.setValue(currentProduct.arrayAddonValue, forKey: CartKeys.arrayAddOnValue.rawValue)
                cart.setValue(currentProduct.addOnId, forKey: CartKeys.addOnId.rawValue)
                cart.setValue(currentProduct.selfPickup, forKey: CartKeys.selfPickup.rawValue)
                cart.setValue(currentProduct.latitude, forKey: CartKeys.latitude.rawValue)
                cart.setValue(currentProduct.longitude, forKey: CartKeys.longitude.rawValue)
                cart.setValue(currentProduct.radius_price, forKey: CartKeys.radius_price.rawValue)
                cart.setValue(currentProduct.typeId, forKey: CartKeys.typeId.rawValue)
                cart.setValue(currentProduct.averageRating, forKey: CartKeys.averageRating.rawValue)
                cart.setValue(currentProduct.supplierAddrerss, forKey: CartKeys.supplierAddrerss.rawValue)
                cart.setValue(currentProduct.deliveryMaxTime, forKey: CartKeys.deliveryMaxTime.rawValue)
                cart.setValue(currentProduct.purchased_quantity, forKey: CartKeys.purchased_quantity.rawValue)
                cart.setValue(currentProduct.totalQuantity, forKey: CartKeys.totalQuantity.rawValue)
                cart.setValue(currentProduct.addOnValue, forKey: CartKeys.addOns.rawValue)
                cart.setValue(currentProduct.distanceValue, forKey: CartKeys.distanceValue.rawValue)

                if let variants = currentProduct.selectedVariants, variants.count > 0 {
                    cart.setValue(variants, forKey: CartKeys.variants.rawValue)
                }
                if let questions = currentProduct.questionsSelected, questions.count > 0 {
                    cart.setValue(questions, forKey: CartKeys.questionsSelected.rawValue)
                }
                cart.setValue(currentProduct.payment_after_confirmation, forKey: CartKeys.payment_after_confirmation.rawValue)
            }
            
            if cartProduct.count == 0 {
//                if AppSettings.shared.isSingleProduct {
//                    removePreviousProduct()
//                }
                saveProductsToCart(entityName: CoreDataEntity.Cart.rawValue, product: product, quantity: quantity ?? 0)
            }
            coreDataStack.saveMainContext()
            
//            //It is difficult to refresh all product, so go to cart screen
//            if SKAppType.type == .home && !(ez.topMostVC is CartViewController) {
//                ez.runThisAfterDelay(seconds: 1.0, after: {
//                    let vc = StoryboardScene.Options.instantiateCartViewController()
//                    ez.topMostVC?.pushVC(vc)
//                })
//
//            }
            
        }catch let error {
            print(error)
        }
    }
    
    func refreshPriceToCart(product : ProductF?){

            let managedContext = coreDataStack.managedObjectContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntity.Cart.rawValue)
            fetchRequest.returnsObjectsAsFaults = false
            let predicate = NSPredicate(format: "id = %@", product?.id ?? "")
            fetchRequest.predicate = predicate
            guard let currentProduct = product else {
                return
            }
            
            do {
                var cartProduct: [NSManagedObject] = []
                if let array = try? managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                    cartProduct = array ?? []
                }

                //cart.purchasedQuant = productDta.first().purchased_quantity
                //cart.prodQuant = productDta.first().quantity

                for cart in cartProduct {
                    let quantityAvailable = Double(/product?.totalQuantity) - /product?.purchasedQuantity
                    if (Double(/product?.totalQuantity)) == 0 || quantityAvailable <= 0 {
                        coreDataStack.managedObjectContext.delete(cart)
                        continue
                    }
                    if let quantityStr = cart.value(forKey: CartKeys.quantity.rawValue) as? String, let quantity = Double(quantityStr) {
                        if quantity > quantityAvailable {
                            cart.setValue(quantityAvailable.toString, forKey: CartKeys.quantity.rawValue)
                        }
                    }
                    cart.setValue(currentProduct.purchased_quantity, forKey: CartKeys.purchased_quantity.rawValue)
                    cart.setValue(currentProduct.totalQuantity, forKey: CartKeys.totalQuantity.rawValue)
                    cart.setValue(currentProduct.averageRating, forKey: CartKeys.averageRating.rawValue)
                    cart.setValue(currentProduct.latitude, forKey: CartKeys.latitude.rawValue)
                    cart.setValue(currentProduct.longitude, forKey: CartKeys.longitude.rawValue)
                    cart.setValue(currentProduct.radius_price, forKey: CartKeys.radius_price.rawValue)
                    
                    let addOnValues =  cart.value(forKey: CartKeys.addOns.rawValue) as? [AddonValueModal]
                    for addOn in addOnValues ?? [] {
                        if let newAddOn = currentProduct.adds_on?.first?.value?.first(where: {$0.id == addOn.id}) {
                            addOn.price = newAddOn.price
                        }
                    }
                    let arrayAddonValue = cart.value(forKey: CartKeys.arrayAddOnValue.rawValue) as? [[AddonValueModal]]
                    for obj in arrayAddonValue ?? [] {
                        for addOn in obj {
                            if let newAddOn = currentProduct.adds_on?.first?.value?.first(where: {$0.id == addOn.id}) {
                                addOn.price = newAddOn.price
                            }
                        }
                    }
                    cart.setValue(addOnValues, forKey: CartKeys.addOns.rawValue)
                    cart.setValue(arrayAddonValue, forKey: CartKeys.arrayAddOnValue.rawValue)
                    
                    cart.setValue(currentProduct.fixedPrice, forKey: CartKeys.fixedPrice.rawValue)
                    cart.setValue(currentProduct.strHourlyPrice, forKey: CartKeys.hourlyPrice.rawValue)
                    cart.setValue(currentProduct.price, forKey: CartKeys.price.rawValue)
                    cart.setValue(currentProduct.deliveryMaxTime, forKey: CartKeys.deliveryMaxTime.rawValue)
                    cart.setValue(currentProduct.handlingAdmin, forKey: CartKeys.handlingAdmin.rawValue)
                    cart.setValue(currentProduct.deliveryCharges, forKey: CartKeys.deliveryCharges.rawValue)
                    cart.setValue(currentProduct.distanceValue, forKey: CartKeys.distanceValue.rawValue)

                }
                coreDataStack.saveMainContext()
                
            }catch let error {
                print(error)
            }
        }
    
    func updateProductsToCartAccToAddonId(product : ProductF?, quantity : Int?,addonId:String?){
        
        let managedContext = coreDataStack.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntity.Cart.rawValue)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "id = %@ AND addOnId = %@", argumentArray: [product?.id ?? "" , product?.addOnId ?? ""])
//        let predicate = NSPredicate(format: "id = %@", product?.id ?? "")
//        fetchRequest.predicate = predicate
        guard let currentProduct = product else {
            return
        }
        
        do {
            var cartProduct: [NSManagedObject] = []
            if let array = try? managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                cartProduct = array ?? []
            }
            
            for cart in cartProduct {
                
                cart.setValue(currentProduct.id, forKey: CartKeys.id.rawValue)
                cart.setValue(currentProduct.dateModified, forKey: CartKeys.dateModified.rawValue)
                cart.setValue(currentProduct.handlingSupplier, forKey: CartKeys.handlingSupplier.rawValue)
                cart.setValue(currentProduct.name, forKey: CartKeys.name.rawValue)
                cart.setValue(quantity?.toString, forKey: CartKeys.quantity.rawValue)
                cart.setValue(currentProduct.price, forKey: CartKeys.price.rawValue)
                cart.setValue(currentProduct.productType, forKey: CartKeys.productType.rawValue)
                cart.setValue(currentProduct.image, forKey: CartKeys.image.rawValue)
                cart.setValue(currentProduct.deliveryCharges, forKey: CartKeys.deliveryCharges.rawValue)
                cart.setValue(currentProduct.handlingAdmin, forKey: CartKeys.handlingAdmin.rawValue)
                cart.setValue(currentProduct.supplierBranchId, forKey: CartKeys.supplierBranchId.rawValue)
                cart.setValue(currentProduct.displayPrice, forKey: CartKeys.displayPrice.rawValue)
                
                let dict = [
                    CartKeys.measuringUnit.rawValue:/currentProduct.measuringUnit,
                    ProductKeys.isQuantity.rawValue:/currentProduct.isQuantity
                    ] as [String : Any]
                cart.setValue(String.toString(dict: dict), forKey: CartKeys.measuringUnit.rawValue)
                //                cart.setValue(currentProduct.measuringUnit, forKey: CartKeys.measuringUnit.rawValue)
                cart.setValue(currentProduct.sku, forKey: CartKeys.sku.rawValue)
                cart.setValue(currentProduct.canUrgent, forKey: CartKeys.canUrgent.rawValue)
                cart.setValue(currentProduct.priceType.rawValue.toString, forKey: CartKeys.priceType.rawValue)
                cart.setValue(currentProduct.fixedPrice, forKey: CartKeys.fixedPrice.rawValue)
                cart.setValue(currentProduct.strHourlyPrice, forKey: CartKeys.hourlyPrice.rawValue)
                cart.setValue(currentProduct.urgentValue, forKey: CartKeys.urgentValue.rawValue)
                cart.setValue(currentProduct.urgentType, forKey: CartKeys.urgentType.rawValue)
                cart.setValue(currentProduct.category, forKey: CartKeys.category.rawValue)
                cart.setValue(currentProduct.categoryId, forKey: CartKeys.categoryId.rawValue)
                cart.setValue(currentProduct.supplierId, forKey: CartKeys.supplier_id.rawValue)
                cart.setValue(currentProduct.supplierName, forKey: CartKeys.suppliername.rawValue)
                cart.setValue(currentProduct.agentList, forKey: CartKeys.agentlist.rawValue)
                cart.setValue(currentProduct.isAgent, forKey: CartKeys.isAgent.rawValue)
                cart.setValue(currentProduct.duration, forKey: CartKeys.duration.rawValue)
                cart.setValue(currentProduct.isProduct.rawValue, forKey: CartKeys.isProduct.rawValue)
                
                //Nitin
                cart.setValue(currentProduct.addOnValue, forKey: CartKeys.addOns.rawValue)
                if let addons = currentProduct.addOnValue,addons.count>0{
                    cart.setValue(true, forKey: CartKeys.isAddon.rawValue)
                } else {
                    cart.setValue(false, forKey: CartKeys.isAddon.rawValue)
                }
                cart.setValue(currentProduct.arrayAddonValue, forKey: CartKeys.arrayAddOnValue.rawValue)
                cart.setValue(currentProduct.addOnId, forKey: CartKeys.addOnId.rawValue)
                cart.setValue(currentProduct.selfPickup, forKey: CartKeys.selfPickup.rawValue)

                cart.setValue(currentProduct.latitude, forKey: CartKeys.latitude.rawValue)
                cart.setValue(currentProduct.longitude, forKey: CartKeys.longitude.rawValue)
                cart.setValue(currentProduct.radius_price, forKey: CartKeys.radius_price.rawValue)
                cart.setValue(currentProduct.typeId, forKey: CartKeys.typeId.rawValue)
                cart.setValue(currentProduct.averageRating, forKey: CartKeys.averageRating.rawValue)
                cart.setValue(currentProduct.supplierAddrerss, forKey: CartKeys.supplierAddrerss.rawValue)
                cart.setValue(currentProduct.deliveryMaxTime, forKey: CartKeys.deliveryMaxTime.rawValue)
                cart.setValue(currentProduct.purchased_quantity, forKey: CartKeys.purchased_quantity.rawValue)
                cart.setValue(currentProduct.totalQuantity, forKey: CartKeys.totalQuantity.rawValue)
            }
            
            if cartProduct.count == 0{
                saveProductsToCart(entityName: CoreDataEntity.Cart.rawValue, product: product, quantity: quantity ?? 0)
            }
            coreDataStack.saveMainContext()
            
        }catch let error {
            print(error)
        }
    }
    
    func getProductToCart(productId: String?, finished: (_ arrayCartProduct:[Cart]) -> Void) {
        
        let managedContext = coreDataStack.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntity.Cart.rawValue)
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "id == %@", productId ?? "")
        fetchRequest.predicate = predicate
        
        do {
            weak var weakSelf = self
            //guard let cartProduct = try managedContext.fetch(fetchRequest) as? [NSManagedObject] else { return }
            guard let cartProduct = try managedContext.fetch(fetchRequest) as? [NSManagedObject], let cartArray = weakSelf?.convertManagedObjectArrayToCartArray(arrManagedObject: cartProduct) else { return }
            
            finished(cartArray)
            
        }
            
        catch let error {
            print(error)
        }
    }
    
    func getTotalQuantityPerProduct(productId: String?, finished: (_ count: String) -> Void) {
        
        let managedContext = coreDataStack.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntity.Cart.rawValue)
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "id == %@", productId ?? "")
        fetchRequest.predicate = predicate
        
        do {
           weak var weakSelf = self
           //guard let cartProduct = try managedContext.fetch(fetchRequest) as? [NSManagedObject] else { return }
           guard let cartProduct = try managedContext.fetch(fetchRequest) as? [NSManagedObject], let cartArray = weakSelf?.convertManagedObjectArrayToCartArray(arrManagedObject: cartProduct) else { return }
           
            finished(cartArray.first?.quantity ?? "0")
           
       }
           
       catch let error {
           print(error)
       }
    }
    
    func getProductAccToAddonId(productId: String?,addonId:String? ,finished: (_ arrayCartProduct:[Cart]) -> Void) {
        
        let managedContext = coreDataStack.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntity.Cart.rawValue)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "id = %@ AND addOnId = %@", argumentArray: [productId ?? "" , addonId ?? ""])

       // let predicate = NSPredicate(format: "id == %@", productId ?? "")
       // fetchRequest.predicate = predicate
        
        do {
            weak var weakSelf = self
            //guard let cartProduct = try managedContext.fetch(fetchRequest) as? [NSManagedObject] else { return }
            guard let cartProduct = try managedContext.fetch(fetchRequest) as? [NSManagedObject], let cartArray = weakSelf?.convertManagedObjectArrayToCartArray(arrManagedObject: cartProduct) else { return }
            
            finished(cartArray)
            
        }
            
        catch let error {
            print(error)
        }
    }
    

}

//MARK: - Delete
extension DBManager {
 
    func cleanCart() {
        print("Cart cleaned")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: CartNotification), object: self,userInfo: ["badge" : 0])
        //deleteAllData(entity: CoreDataEntity.Cart.rawValue)
        let dbNames = [CoreDataEntity.Cart.rawValue,CoreDataEntity.Message.rawValue,CoreDataEntity.Addons.rawValue]
        dbNames.forEach { (dBName) in
            self.removeDataFromTable(tableName: dBName)
        }
    }
    
    func deleteAllData(entity: String){
        print("Cleared all data fro cart: \(entity)")
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: CartNotification), object: self,userInfo: ["badge" : 0])
        let managedContext = coreDataStack.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        managedContext.performAndWait {
            do {
                let results = try managedContext.fetch(fetchRequest)
                for managedObject in results
                {
                    let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                    managedContext.delete(managedObjectData)
                }
                self.coreDataStack.saveMainContext()
            } catch let error as NSError {
                print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
            }
        }
        
    }
    
    func removeProductFromCart(productId : String?){
        print("Remove product from cart: \(/productId)")
        let managedContext = coreDataStack.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntity.Cart.rawValue)
        fetchRequest.returnsObjectsAsFaults = false
        let predicate = NSPredicate(format: "id = %@", productId ?? "")
        fetchRequest.predicate = predicate
        
        do {
            guard let cartProduct = try managedContext.fetch(fetchRequest) as? [NSManagedObject] else { return }
            for cart in cartProduct {
                
                coreDataStack.managedObjectContext.delete(cart)
            }
            coreDataStack.saveMainContext()
        }catch let error {
            print(error)
        }
    }
    
    func isCartEmpty() -> Bool {
        let managedContext = coreDataStack.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntity.Cart.rawValue)
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let count = try managedContext.count(for: fetchRequest)
             return count > 0 ? false : true
        }catch{
            return true
        }
       
    }
    
    func removeDataFromTable(tableName : String) {
        
        let managedContext = coreDataStack.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
        fetchRequest.returnsObjectsAsFaults = false

        do {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
            self.coreDataStack.saveMainContext()

            } catch let error as NSError {
            print("delete fail--",error)
          }
    }
    
}

extension DBManager {
    
    func removePreviousProduct() {
        deleteAllData(entity: CoreDataEntity.Cart.rawValue)
    }
    
    func checkIfQuestionsAdded(productId: String, finished: (_ added: Bool) -> Void) {
        
        let managedContext = coreDataStack.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntity.Cart.rawValue)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "id = %@", productId)

        do {
           let cartProduct = try managedContext.fetch(fetchRequest) as? [NSManagedObject]
            let questions = cartProduct?.first?.value(forKey: CartKeys.questionsSelected.rawValue) as? [Question] ?? []
            finished((questions.count ) > 0)
            
        }
            
        catch let error {
            print(error)
        }
    }
}

//Nitin
//MARK: Addons DB Management
extension DBManager {
    
    func manageAddon(addonData: AddonsModalClass?) {
        if let data = addonData {
            if let qty = data.quantity,qty == 0 {
                removeAddonFromDb(productId: data.productId ?? "", addonId: data.addonId ?? "")
            } else {
                updateAddons(addonData: data, productId: data.productId ?? "", addonId: data.addonId ?? "", typeId: data.typeId ?? "")
            }
        }
    }
    
    func updateAddons(addonData: AddonsModalClass?, productId: String?,addonId: String?, typeId: String?) {
        
        let managedContext = coreDataStack.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntity.Addons.rawValue)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "productId = %@ AND addonId = %@ AND typeId = %@", argumentArray: [productId ?? "" , addonId ?? "", typeId ?? ""])
        guard let currentProduct = addonData else {
            return
        }
        
        do {
            var cartProduct: [NSManagedObject] = []
            if let array = try? managedContext.fetch(fetchRequest) as? [NSManagedObject] {
                cartProduct = array
            }
            
            for cart in cartProduct {
                
                cart.setValue(currentProduct.productId, forKey: AddonKeys.productId.rawValue)
                cart.setValue(currentProduct.addonId, forKey: AddonKeys.addonId.rawValue)
                cart.setValue(currentProduct.addonData, forKey: AddonKeys.addonData.rawValue)
                cart.setValue(currentProduct.quantity, forKey: AddonKeys.quantity.rawValue)
                cart.setValue(currentProduct.typeId, forKey: AddonKeys.typeId.rawValue)
            }
            
            if cartProduct.count == 0{
                saveAddonToDb(entityName: CoreDataEntity.Addons.rawValue, addons: addonData)
            }
            coreDataStack.saveMainContext()
            
        } catch let error {
            print(error)
        }
        
    }
    
    func saveAddonToDb(entityName:String,addons: AddonsModalClass?) {
        
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: (coreDataStack.managedObjectContext)),let currentProduct = addons else {
            fatalError("Could not find entity descriptions!")
        }
        coreDataStack.managedObjectContext.mergePolicy = NSErrorMergePolicy
        let addonData = NSManagedObject(entity: entity, insertInto: coreDataStack.managedObjectContext)
        
        addonData.setValue(currentProduct.productId, forKey: AddonKeys.productId.rawValue)
        addonData.setValue(currentProduct.addonId, forKey: AddonKeys.addonId.rawValue)
        addonData.setValue(currentProduct.addonData, forKey: AddonKeys.addonData.rawValue)
        addonData.setValue(currentProduct.quantity, forKey: AddonKeys.quantity.rawValue)
        addonData.setValue(currentProduct.typeId, forKey: AddonKeys.typeId.rawValue)

        coreDataStack.saveMainContext()
        
    }
    
    func removeAddonFromDb(productId : String?,addonId:String?){
        
        let managedContext = coreDataStack.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntity.Addons.rawValue)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "productId = %@ AND addonId = %@", argumentArray: [productId ?? "" , addonId ?? ""])
        
        do {
            guard let cartProduct = try managedContext.fetch(fetchRequest) as? [NSManagedObject] else { return }
            for cart in cartProduct {
                coreDataStack.managedObjectContext.delete(cart)
            }
            coreDataStack.saveMainContext()
        }catch let error {
            print(error)
        }
    }
    
    func removeAddonFromDbAcctoTypeId(productId : String?,addonId:String?, typeId:String?){
        
        let managedContext = coreDataStack.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntity.Addons.rawValue)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "productId = %@ AND addonId = %@ AND typeId = %@", argumentArray: [productId ?? "" , addonId ?? "", typeId ?? ""])
      
        do {
            guard let cartProduct = try managedContext.fetch(fetchRequest) as? [NSManagedObject] else { return }
            for cart in cartProduct {
                coreDataStack.managedObjectContext.delete(cart)
            }
            coreDataStack.saveMainContext()
        } catch let error {
          print(error)
        }
        
    }

    func getAddonsDataFromDb(productId: String?,addonId:String? ,finished: (_ arrayCartProduct:[AddonsModalClass]) -> Void) {
        
        let managedContext = coreDataStack.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntity.Addons.rawValue)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "productId = %@ AND addonId = %@", argumentArray: [productId ?? "" , addonId ?? ""])

        do {
            weak var weakSelf = self
            guard let cartProduct = try managedContext.fetch(fetchRequest) as? [NSManagedObject], let cartArray = weakSelf?.convertManagedObjectArrayToAddonArray(arrManagedObject: cartProduct) else { return }
            
            finished(cartArray)
            
        }
            
        catch let error {
            print(error)
        }
    }
    
    func getAddonsDataFromDbAcctoTypeId(productId: String?,addonId:String? ,typeId: String?,finished: (_ arrayCartProduct:[AddonsModalClass]) -> Void) {
        
        let managedContext = coreDataStack.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntity.Addons.rawValue)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "productId = %@ AND addonId = %@ AND typeId = %@", argumentArray: [productId ?? "" , addonId ?? "",typeId ?? ""])

        do {
            weak var weakSelf = self
            guard let cartProduct = try managedContext.fetch(fetchRequest) as? [NSManagedObject], let cartArray = weakSelf?.convertManagedObjectArrayToAddonArray(arrManagedObject: cartProduct) else { return }
            
            finished(cartArray)
            
        }
            
        catch let error {
            print(error)
        }
    }

    func getPerAddonQuantityAccToTypeId(productId: String?,addonId:String? ,typeId: String?,finished: (_ quantity: Int?) -> Void) {
        
        let managedContext = coreDataStack.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntity.Addons.rawValue)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "productId = %@ AND addonId = %@ AND typeId = %@", argumentArray: [productId ?? "" , addonId ?? "",typeId ?? ""])

        do {
            weak var weakSelf = self
            guard let cartProduct = try managedContext.fetch(fetchRequest) as? [NSManagedObject], let cartArray = weakSelf?.convertManagedObjectArrayToAddonArray(arrManagedObject: cartProduct) else { return }
              
            if let data = cartArray.first {
                finished(data.quantity ?? 0)
            } else {
                finished(nil)
            }
        }
              
        catch let error {
            print(error)
        }
        
    }
    
    func getTypeIdsOfAddonId(productId: String?,addonId:String?,finished: (_ typeIds:[String]) -> Void) {
        
        let managedContext = coreDataStack.managedObjectContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: CoreDataEntity.Addons.rawValue)
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "productId = %@ AND addonId = %@", argumentArray: [productId ?? "" , addonId ?? ""])
        
        do {
           weak var weakSelf = self
           guard let cartProduct = try managedContext.fetch(fetchRequest) as? [NSManagedObject], let cartArray = weakSelf?.convertManagedObjectArrayToAddonArray(arrManagedObject: cartProduct) else { return }
            
            var idArray = [String]()
            for data in cartArray {
                idArray.append(data.typeId ?? "")
            }
           
           finished(idArray)
        }
           
       catch let error {
           print(error)
        }
        
    }
    
    func convertManagedObjectArrayToAddonArray(arrManagedObject : [NSManagedObject]) -> [AddonsModalClass] {
        
        var addonsData : [AddonsModalClass] = []
        for mc in arrManagedObject {
            let addons = AddonsModalClass()
            
            addons.productId = mc.value(forKey: AddonKeys.productId.rawValue) as? String
            addons.addonId = mc.value(forKey: AddonKeys.addonId.rawValue) as? String
            addons.addonData = mc.value(forKey: AddonKeys.addonData.rawValue) as? [[AddonValueModal]]
            addons.quantity = mc.value(forKey: AddonKeys.quantity.rawValue) as? Int
            addons.typeId = mc.value(forKey: AddonKeys.typeId.rawValue) as? String
            addonsData.append(addons)
        }
        
        return addonsData
    }
    
}
