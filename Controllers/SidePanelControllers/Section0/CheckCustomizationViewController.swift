//
//  CheckCustomizationViewController.swift
//  Sneni
//
//  Created by Apple on 04/10/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class CheckCustomizationViewController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var tableView: UITableView!{
        didSet{
            self.tableView.register(UINib(nibName: CheckCustomizationTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: CheckCustomizationTableViewCell.identifier)
            self.tableView.estimatedRowHeight = 80
        }
    }
    @IBOutlet weak var buttonCustomization: UIButton!
    
    //MARK:- Variables
    var product: ProductF?
    var cartProdcuts : Cart?
    var completionBlock : AnyCompletionBlock?
    var tempArray : Array<Any>?
    var rowsArray : Array<Any>?
    var isChanged = false
    var savedModelArray = [SavedAddonModalClass]() {
        didSet {
            self.tableView.reloadData()
        }
    }
    var tempAddonData = [AddonsModalClass]()
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.getCartFromDB()
    }
    
    func getCartFromDB() {
        
        guard let productId = self.cartProdcuts?.id else {return}
        guard let addOnId = self.cartProdcuts?.addOnId else {return}
        
        DBManager().getProductAccToAddonId(productId: productId, addonId: addOnId) {  [weak self] (array) in
            guard let self = self else {return}
            if array.count > 0 {
                self.savedModelArray.removeAll()
                self.tempAddonData.removeAll()
                for i in 0...array.count-1 {
                    DBManager().getAddonsDataFromDb(productId: productId, addonId: addOnId) {[weak self] (addonData) in
                        guard let self = self else {return}
                        self.tempAddonData = addonData
                        for j in 0...addonData.count-1 {
                            let obj = SavedAddonModalClass(productId: productId, addonId: addOnId, cartData: array[i], addons: addonData, typeId: addonData[j].typeId ?? "", quantity: addonData[j].quantity ?? 0)
                            self.savedModelArray.append(obj)
                        }
                    }
                }
            }
        }
        
    }
    
    func addAnotherProductToCart(quantity : Double, productData:ProductF?, cell: CheckCustomizationTableViewCell?, shouldAdd : Bool?,typeId: String?,index : Int?) {
        
        guard let productObj = productData else {return}
        let data = productObj
        var arrayAddonValue = data.arrayAddonValue ?? []
        let addonId = data.addOnId
        let productId = data.product_id
        
        if shouldAdd ?? false {
        
            self.checkAddonExistAcctoTypeid(productId: productId ?? "", addonId: addonId ?? "", typeId: typeId ?? "") { (isContain, dataArray) in
//                let maxQuant = productObj.totalQuantity?.toDouble ?? 0.0
//                let purchased = productObj.purchased_quantity?.toDouble ?? 0.0
//
//                if quantity == (maxQuant - purchased) {
//                    UtilityFunctions.showAlert(message: "Maximum quantity Reached")
//                    return
//                }
                var array = [[AddonValueModal]]()
                let arrayObj = arrayAddonValue[index ?? 0]
                array.append(arrayObj)
                
                let obj = AddonsModalClass(productId: productId, addonId: addonId, addonData: array, quantity: Int(quantity), typeId: typeId ?? "")
                DBManager.sharedManager.manageAddon(addonData: obj)

                DBManager.sharedManager.getTotalQuantityPerProduct(productId: productId ?? "") { (quantity) in
                    guard let qaunt = Int(quantity) else {return}
                    DBManager.sharedManager.manageCart(product: data, quantity: qaunt+1)
                    guard let block = self.completionBlock else {return}
                    block((self.isChanged,data) as AnyObject)
                    self.getCartFromDB()
                }
            }
                        
        } else {
            
            if quantity == 0 {
                DBManager.sharedManager.removeAddonFromDbAcctoTypeId(productId: productId, addonId: addonId, typeId: typeId ?? "")
                
                DBManager.sharedManager.getTotalQuantityPerProduct(productId: productId ?? "") { (quantity) in
                    guard let totalQuant = Int(quantity) else {return}
                    let savedQuant = totalQuant-1
                    DBManager.sharedManager.manageCart(product: data, quantity: savedQuant)
                    if savedQuant == 0 {
                       // DBManager.sharedManager.removeAddonFromDb(productId: productId, addonId: addonId)
                        arrayAddonValue.removeAll()
                        self.dismiss(animated: true) {
                            self.sendDataBack(isChanged: false, data: data)
                        }
                    } else {
                        arrayAddonValue.remove(at: index ?? 0)
                        self.getCartFromDB()
                        self.sendDataBack(isChanged: self.isChanged, data: data)
                    }
                }
            } else {
                var array = [[AddonValueModal]]()
                let arrayObj = arrayAddonValue[index ?? 0]
                array.append(arrayObj)
                
                let obj = AddonsModalClass(productId: productObj.id ?? "", addonId: addonId, addonData: array, quantity: Int(quantity), typeId: typeId)
                DBManager.sharedManager.manageAddon(addonData: obj)
                
                DBManager.sharedManager.getTotalQuantityPerProduct(productId: productId ?? "") { (quanty) in
                    guard let qaunt = Int(quanty) else {return}
                    DBManager.sharedManager.manageCart(product: productData, quantity: qaunt-1)
                    self.sendDataBack(isChanged: self.isChanged, data: data)
                    self.getCartFromDB()
                }
            }
        }
                   
    }
    
    func sendDataBack(isChanged: Bool, data: ProductF) {
        guard let block = self.completionBlock else {return}
        block((isChanged,data) as AnyObject)
    }
    
    func checkAddonExistAcctoTypeid(productId: String, addonId: String,typeId:String, finished: (_ isContain: Bool, _ data: [AddonsModalClass]?)-> Void) {
        
        DBManager.sharedManager.getAddonsDataFromDbAcctoTypeId(productId: productId, addonId: addonId, typeId: typeId) { (data) in
            print(data)
            finished(data.count == 0 ? false : true, data.count == 0 ? nil : data)
        }
        
    }
    
    @IBAction func addCustomization_buttonAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            guard let block = self.completionBlock else {return}
            block((self.product,self.cartProdcuts,true) as AnyObject)
        }
        
    }
    
    @IBAction func back_buttonAction(_ sender: UIButton) {
        self.dismiss(animated: true) {
            guard let block = self.completionBlock else {return}
            if self.isChanged {
                block(self.isChanged as AnyObject)
            } else {
                block(2 as AnyObject)
            }
        }
    }

}

//MARK:- UITableViewDelegate , UITableViewDataSource
extension CheckCustomizationViewController : UITableViewDelegate , UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1 //self.savedModelArray.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tempAddonData.count//self.savedModelArray[section].addons?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CheckCustomizationTableViewCell.identifier) as? CheckCustomizationTableViewCell else {
            fatalError("Missing ServiceCell identifier")
        }
      //  guard let addon = self.savedModelArray[indexPath.section].addons?[indexPath.row] else {return UITableViewCell ()}
        cell.index = indexPath.row
        let modelObj = self.savedModelArray[indexPath.row]
        guard let arr = modelObj.cartData else {return UITableViewCell ()}
        arr.savedAddons = modelObj.addons ?? []
        arr.perAddonQuantity = modelObj.quantity ?? 0
    
        let prod = ProductF(cart: arr)
        prod.totalQuantity = self.product?.totalQuantity ?? 0
        prod.purchased_quantity = self.product?.purchased_quantity ?? 0
        
        cell.product = prod
    
        cell.completionBlock = { [weak self] data in
            guard let self = self else {return}
            
            if let obj = data as? (Double,Bool) {
                self.buttonCustomization.setTitleColor(SKAppType.type.color, for: .normal)
                self.buttonCustomization.isUserInteractionEnabled = true
                
                self.isChanged = true
                let typeId =  self.tempAddonData[indexPath.row].typeId ?? ""
                let product = ProductF(cart: arr)
                product.adds_on = self.product?.adds_on
                product.totalQuantity = self.product?.totalQuantity ?? 0
                product.purchased_quantity = self.product?.purchased_quantity ?? 0

                product.is_product_adds_on = self.product?.adds_on?.count == 0 ? 0 : 1
                self.addAnotherProductToCart(quantity: obj.0,productData: product, cell : cell, shouldAdd: obj.1, typeId: typeId, index: indexPath.row)

            } else if let _ = data as? (Bool,Bool) {
                self.buttonCustomization.setTitleColor(.lightGray, for: .normal)
                self.buttonCustomization.isUserInteractionEnabled = false
            }
            
        }
        cell.selectionStyle = .none

        return cell

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }

}
//MARK:- UIViewControllerTransitioningDelegate
extension CheckCustomizationViewController : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}

