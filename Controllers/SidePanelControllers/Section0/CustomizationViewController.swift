//
//  CustomizationViewController.swift
//  Sneni
//
//  Created by Apple on 26/09/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

class CustomizationViewController: UIViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var foodName_label: UILabel!
    
    
    @IBOutlet weak var customiseyourfood_label: ThemeLabel!
    {
        didSet
        {
            customiseyourfood_label.text = "Customise your food".localized()
        }
    }
    @IBOutlet weak var foodDescription_label: UILabel!
    @IBOutlet weak var proceed_button: ThemeButton! {
        didSet{
            proceed_button.setBackgroundColor(SKAppType.type.color, forState: .normal)
            proceed_button.setTitle("Add".localized(), for: .normal)
        }
    }
    @IBOutlet weak var back_button: ThemeButton!
    @IBOutlet weak var tableView: UITableView!{
        didSet {
            tableView.register(UINib(nibName: "CustomizationTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomizationTableViewCell")
            tableView.tableFooterView = UIView(frame: CGRect.zero)
        }
    }
    // AddOn Quantity
    @IBOutlet weak var viewAddonQuantity: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    

    //MARK:- Variables
    var completionBlock : AnyCompletionBlock?
    var headerView : CutomizationTableHeaderView? = nil
    var tempModel : [[AddonValueModal]]?
    var hideAddCustom :Bool?
    var isUpdated = false
    var index: Int?
    var addonsModalArray = [AddonsModalClass]()
    var cartData : Cart?
    var product: ProductF? {
        didSet {
            if let addon = product?.adds_on {
                for i in 0...addon.count-1 {
                    if let value = addon[i].value?[0].is_multiple {
                        self.product?.adds_on?[i].is_multiple = value
                    }
                }
            }
        }
    }
    var boolArray = [[Bool]]()
    
    var aryQuantity = [Int]()
    var quantity = 0
    var btnIndex = IndexPath()
    var isQuantity = false
  

    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let product = self.product {
            self.foodName_label.text = product.name ?? ""
            self.foodDescription_label.attributedText = (product.desc ?? "").htmlToAttributedString(label: self.foodDescription_label)
        }
        if let ishide = self.hideAddCustom,ishide{
            self.proceed_button.isHidden = true
        }
        
        for i in 1..<11{
            aryQuantity.append(i)
        }
        self.pickerView.reloadAllComponents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        guard let product = self.product else {return}
        
        DBManager.sharedManager.getAddonsDataFromDb(productId: product.id ?? "", addonId: String(index ?? 0)) { [weak self] (data) in
            guard let self = self else { return }
            print(data)
            self.addonsModalArray = data
        }
        
    }
    
    //MARK:- ButtonActions
    @IBAction func back_buttonAction(_ sender: Any) {
        self.dismiss(animated: true) {
            guard let block = self.completionBlock else {return}
            guard let data = self.product else {return}
            data.addOnValue?.removeAll()
            block((data,self.hideAddCustom ?? false) as AnyObject)
        }
    }
    
    @IBAction func proceed_buttonAction(_ sender: Any) {
        
        var ids = [String]()
        var minAddOn = 0
        var selectedMinAddOns = 0
        
//        for object in self.product?.addOnValue ?? [AddonValueModal]() {
//            ids.append(object.id ?? "0")
//        }
        
        for i in 0...(self.product?.adds_on?.count ?? 1)-1 {
            for object in self.product?.adds_on?[i].value ?? [AddonValueModal]() {
                ids.append(object.id ?? "0")
            }
        }
        ids.removeDuplicates()
        ids.removeObject("0")
        
        
        var aryMinAdons: [[String:Any]] = [[String:Any]]()
        var minAdons: [String:Any] = [String:Any]()
        for id in ids {
            var isFound = false
            for i in 0...(self.product?.adds_on?.count ?? 1)-1 {
                for object in self.product?.adds_on?[i].value ?? [AddonValueModal]() {
                    if object.id == id {
                        isFound = true
                        if object.is_multiple == "1" {
                            minAdons["title"] = object.name
                            minAdons["id"] = object.id
                            minAdons["count"] = Int(object.min_adds_on ?? "0") ?? 0
                            minAddOn += Int(object.min_adds_on ?? "0") ?? 0
                        }else {
                            minAddOn += 1
                            minAdons["title"] = object.name
                            minAdons["id"] = object.id
                            minAdons["count"] = 1 // Int(object.min_adds_on ?? "0") ?? 0
                        }
                        aryMinAdons.append(minAdons)
                        
                        break
                    }
                }
                if isFound {
                    break
                }
            }
        }
        
        print(aryMinAdons)
        
//        for id in ids {
//            for object in self.product?.addOnValue ?? [AddonValueModal]() {
//                if object.id == id {
//                    if object.is_multiple == "1" {
//                        minAddOn += Int(object.min_adds_on ?? "0") ?? 0
//                    }else {
//                        minAddOn += 1
//                    }
//                    break
//                }
//            }
//        }
        
        var arySelAdons: [[String:Any]] = [[String:Any]]()
        var selAdons: [String:Any] = [String:Any]()
         for id in ids {
            
            for object in self.product?.addOnValue ?? [AddonValueModal]() {
                var isExist = false
                var index = -1
                if object.id == id {
                    for i in 0..<arySelAdons.count {
                        if (arySelAdons[i]["id"] as? String ?? "0") == object.id {
                            isExist = true
                            index = i
                            break
                        }
                    }
                    selAdons["title"] = object.name
                    selAdons["id"] = object.id
                    selAdons["count"] = 1 // (selAdons["count"] as? Int ?? 0) + 1
                    
                    selectedMinAddOns += 1
                    if isExist {
                        arySelAdons[index]["count"] = (selAdons["count"] as? Int ?? 0) + 1
                    }else {
                        arySelAdons.append(selAdons)
                    }
                }
                
            }
            
        }
        
        print(arySelAdons)
        
        var isExist = false
        for i in aryMinAdons {
            var isExist = false
            for j in arySelAdons {
                if (i["id"] as? String) == (j["id"] as? String){
                    if (i["count"] as? Int ?? 0) > (j["count"] as? Int ?? 0) {
                        SKToast.makeToast("Please select atleast \(i["count"] as? Int ?? 0) items in \(j["title"] as? String ?? "")")
                        return
                    }
                    isExist = true
//                    break
                }
            }
            if !isExist {
                            if (i["count"] as? Int ?? 0) != 0 {
                                SKToast.makeToast("Please select atleast \(i["count"] as? Int ?? 0) items in \(i["title"] as? String ?? "")")
                                return
                            }
                        }
                    }
                    
            //        if minAddOn > selectedMinAddOns {
            //            SKToast.makeToast("Please select minimum addOns.")
            //            return
            //        }
                    self.dismiss(animated: true) {
                        self.addDataToSpecificObject()
                    }
    }
    @IBAction func actionDoneAddonQuantity(_ sender: Any) {
        guard let value =  self.product?.adds_on?[self.btnIndex.section].value?[self.btnIndex.row] else {return }
               guard let index = self.index else {return}
               value.add_on_id_ios = String(index)
               var dict = Dictionary<Int,Any>()
        value.selectedQuantity = "\(self.quantity)"
               dict[self.btnIndex.section] = value
               self.saveSelected(data: dict)
               
               self.viewAddonQuantity.isHidden = true
    }
    @IBAction func actionCancelAddonQuantity(_ sender: Any) {
       
        self.viewAddonQuantity.isHidden = true
    }
    func addonQuantityMethod() -> Bool{
        var ids = [String]()
                      var max = 0
                      var selectedMaxAddOns = 0
                      
                      for object in self.product?.addOnValue ?? [AddonValueModal]() {
                          ids.append(object.id ?? "0")
                      }
                      ids.removeDuplicates()
                      ids.removeObject("0")
                      
                      
        var isIn = false
                      for id in ids {
                          for object in self.product?.addOnValue ?? [AddonValueModal]() {
                              if object.id == id {
//                                  max += Int(object.max_adds_on ?? "0") ?? 0
                                max = Int(object.max_adds_on ?? "0") ?? 0
                                isIn = true
                                  break
                              }
                          }
                        if isIn {
                            print("Exit loop")
                            break
                        }
                      }
                      
                       for id in ids {
                          for object in self.product?.addOnValue ?? [AddonValueModal]() {
                              if object.id == id {
                                selectedMaxAddOns += 1 // (Int(object.selectedQuantity) ?? 1)
                              }
                          }
                      }
                      
                      if max > selectedMaxAddOns {
                          guard let value =  self.product?.adds_on?[self.btnIndex.section].value?[self.btnIndex.row] else {return false}
                                 guard let index = self.index else {return false}
                                 value.add_on_id_ios = String(index)
                                 var dict = Dictionary<Int,Any>()
                          value.selectedQuantity = "\(self.quantity)"
                                 dict[self.btnIndex.section] = value
                                 self.saveSelected(data: dict)
                       return true
                      }

        return false
    }
    func removeAddOn() -> Bool{
            
             var ids = [String]()
                   var min = 0
                   var selectedMinAddOns = 0
                   
                   for object in self.product?.addOnValue ?? [AddonValueModal]() {
                       ids.append(object.id ?? "0")
                   }
                   ids.removeDuplicates()
                   ids.removeObject("0")
                   
                   
                   for id in ids {
                       for object in self.product?.addOnValue ?? [AddonValueModal]() {
                           if object.id == id {
                               min = Int(object.min_adds_on ?? "0") ?? 0
                               break
                           }
                       }
                   }
                   
                    for id in ids {
                       for object in self.product?.addOnValue ?? [AddonValueModal]() {
                           if object.id == id {
                            selectedMinAddOns += (Int(object.selectedQuantity) ?? 1)
                           }
                       }
                   }
                   
                   if min < selectedMinAddOns {
                       guard let value =  self.product?.adds_on?[self.btnIndex.section].value?[self.btnIndex.row] else {return false}
                              guard let index = self.index else {return false}
                              value.add_on_id_ios = String(index)
                              var dict = Dictionary<Int,Any>()
                       value.selectedQuantity = "\(self.quantity)"
                              dict[self.btnIndex.section] = value
                              self.saveSelected(data: dict)
                    return true
                   }
            
            return false
        }
    
    func addDataToSpecificObject() {
        
        guard let productObj = self.product else {return}
        guard var addonValue = productObj.addOnValue else {return}
        guard let block = self.completionBlock else {return}

        addonValue = addonValue.sorted { (obj1, obj2) -> Bool in
            obj1.type_id ?? "" < obj2.type_id ?? ""
        }
        var typeIdStr = ""
        for value in addonValue {
            print(value.type_id ?? "")
            typeIdStr = typeIdStr + (value.type_id ?? "")
        }
        if typeIdStr == "" { // for no addons added
            block(false as AnyObject)
        } else {
            productObj.addOnId = String(index ?? 0)
            if let _ = self.cartData {
                self.getAddonsAcctoTypeid(typeId: typeIdStr, addonValue: addonValue)
            } else {
                self.typeCastData(product: productObj, addonValue: addonValue, typeIdStr: typeIdStr,quantity : 1, shouldClear: true)
            }
            
            block((self.isUpdated,productObj) as AnyObject)
        }
        
    }
    
    func typeCastData(product : ProductF?, addonValue : [AddonValueModal]?, typeIdStr : String?,quantity :Int, shouldClear : Bool?) {
        
        guard let productObj = product , let addonValueObj = addonValue , let typeId = typeIdStr  else {return}

        var array = [[AddonValueModal]]()
        array.append(addonValueObj)

        self.saveAddons(productId:  productObj.id ?? "", addonId: String(index ?? 0), arrayAddonValue: array, typeIdStr: typeId, quantity: quantity, product: productObj, addonObj: addonValueObj, shouldClear: shouldClear)
    }
    
    func saveAddons(productId : String?, addonId: String?, arrayAddonValue : [[AddonValueModal]]?, typeIdStr : String?, quantity: Int, product: ProductF?, addonObj: [AddonValueModal]? , shouldClear : Bool?) {
          
        DBManager.sharedManager.getTotalQuantityPerProduct(productId: productId ?? "") { (quanti) in
            guard let qaunt = Int(quanti) else {return}
            
            let obj = AddonsModalClass(productId: productId ?? "", addonId: String(index ?? 0), addonData: arrayAddonValue, quantity: quantity, typeId: typeIdStr ?? "")
            DBManager.sharedManager.manageAddon(addonData: obj)
              
            guard let productData = product else {return}
            productData.typeId = typeIdStr

            guard let adds = productData.arrayAddonValue else {return}
            var array = [[AddonValueModal]]()

            for data in adds {
                array.append(data)
            }
            if shouldClear ?? false {
                array.append(addonObj ?? [])
            }
            productData.arrayAddonValue = array
            
            DBManager.sharedManager.manageCart(product: productData, quantity: qaunt+1)
        }
         
    }
    
    func getAddonsAcctoTypeid(typeId:String?,addonValue : [AddonValueModal]?) {
        
        guard let productObj = self.product else {return}
        guard let addonValueObj = addonValue else {return}
        let productId = productObj.id ?? ""
        
        DBManager.sharedManager.getAddonsDataFromDbAcctoTypeId(productId: productId, addonId: String(index ?? 0), typeId: typeId) { (data) in
            print(data)
            
            self.typeCastData(product: productObj, addonValue: addonValueObj, typeIdStr: typeId,quantity: data.count + 1, shouldClear: data.count == 0 ? true : false)
        }
        
    }
        
    func saveSelected(data : Dictionary<Int,Any>){
        for (key,value) in data {
            if let obj = value as? AddonValueModal {
               if let isMultiple = self.product?.adds_on?[key].is_multiple,isMultiple == "0" {
                    guard let addons = self.product?.adds_on?[key].value else { return }
                    let output = self.product?.addOnValue?.filter({ (addonValue) -> Bool in
                         return addons.contains(where: {$0.type_id == addonValue.type_id})
                    })
                
                var contains = false
                if let contain = self.product?.addOnValue?.contains(where: {$0.type_id == obj.type_id}),contain {
                if let index = self.product?.addOnValue?.firstIndex(where: {$0.type_id == obj.type_id}) {
                        contains = true
                    }
                }
                
//                    if output?.count ?? 0 > 0 {
//                        if let index = self.product?.addOnValue?.firstIndex(where: {$0.type_id == output?[0].type_id}) {
//                            self.product?.addOnValue?.remove(at: index)
//                        }
//                     }
                if contains{
                    if output?.count ?? 0 > 0 {
                       if let index = self.product?.addOnValue?.firstIndex(where: {$0.type_id == output?[0].type_id}) {
                           self.product?.addOnValue?.remove(at: index)
                       }
                    }
                } else {
                    if output?.count ?? 0 > 0 {
                       if let index = self.product?.addOnValue?.firstIndex(where: {$0.type_id == output?[0].type_id}) {
                           self.product?.addOnValue?.remove(at: index)
                       }
                    }
                    self.product?.addOnValue?.append(obj)
                }
               } else {
                    if let contain = self.product?.addOnValue?.contains(where: {$0.type_id == obj.type_id}),contain {
                        if let index = self.product?.addOnValue?.firstIndex(where: {$0.type_id == obj.type_id}) {
                            if self.isQuantity {
                                var prodCount = 0
                                for object in self.product?.addOnValue ?? [AddonValueModal]() {
                                    if object.type_id == obj.type_id {
                                        prodCount += 1
                                    }
                                }
                                if prodCount > Int(obj.selectedQuantity) ?? 0 {
                                    let cc = prodCount - (Int(obj.selectedQuantity) ?? 0)
                                    for _ in stride(from: 0, to: cc, by: 1) {
                                        self.product?.addOnValue?.remove(at: index)
//                                        self.product?.addOnValue?.append(obj)
                                    }
                                    
                                }else if prodCount < Int(obj.selectedQuantity) ?? 0 {
                                    let cc = (Int(obj.selectedQuantity) ?? 0) - prodCount
                                    for _ in stride(from: 0, to: cc, by: 1) {
                                        self.product?.addOnValue?.append(obj)
                                    }
                                }else {
//
                                }
                                
                            }else{
                                if obj.is_default != "1" {
                                    for _ in self.product?.addOnValue ?? [AddonValueModal]() {
                                           if let contain = self.product?.addOnValue?.contains(where: {$0.type_id == obj.type_id}),contain {
                                                   if let index = self.product?.addOnValue?.firstIndex(where: {$0.type_id == obj.type_id}) {
                                                        self.product?.addOnValue?.remove(at: index)
                                                    
                                            }
                                        }
                                    }
                                }
                            }
                            
                        }
                    } else {
                        // Not exists
                        var id = "0"
                        var addOn = 0
                        
                        for object in self.product?.addOnValue ?? [AddonValueModal]() {
                            if object.id == obj.id {
                                id = object.id ?? "0"
                                addOn += 1
                            }
                        }
                        let maxAddOn = /Int(obj.max_adds_on ?? "0")
                        if id == obj.id ?? "0" && (maxAddOn > 0 && addOn >= maxAddOn) {
                            return
                        }
                        self.product?.addOnValue?.append(obj)
                    }
                }
                self.tableView.reloadSections(IndexSet(integer: key), with: .none)
            }
        }
    }
    
    func saveDefalut(indexPath: IndexPath) {
        
        guard let value =  self.product?.adds_on?[indexPath.section].value?[indexPath.row] else {return }
//        if value.max_adds_on == "0" && value.is_multiple == "1" {
//            return
//        }
        guard let index = self.index else {return}
        value.add_on_id_ios = String(index)
        var dict = Dictionary<Int,Any>()
        value.selectedQuantity = "1"
        dict[indexPath.section] = value
        self.saveSelected(data: dict)
    }
    
    @IBAction func selectAddOnQuantity(_ sender: UIButton, indexPath: IndexPath){
        
        self.viewAddonQuantity.isHidden = false
        self.btnIndex = indexPath
    
        
//        guard let value =  self.product?.adds_on?[indexPath.section].value?[indexPath.row] else {return }
//        guard let index = self.index else {return}
//        value.add_on_id_ios = String(index)
//        var dict = Dictionary<Int,Any>()
//        dict[indexPath.section] = value
//        self.saveSelected(data: dict)
    }
}

//MARK:- UITableViewDelegate,UITableViewDataSource
extension CustomizationViewController : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.product?.adds_on?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.product?.adds_on?[section].value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomizationTableViewCell", for: indexPath) as! CustomizationTableViewCell
        
        guard let data =  self.product?.adds_on?[indexPath.section].value?[indexPath.row] else {return UITableViewCell()}
        
        cell.name_label.text = data.type_name ?? ""
        
        cell.price_label.text = ""
        var price = /data.price
        price = price.replacingOccurrences(of: "0", with: "")
        price = price.replacingOccurrences(of: ".", with: "")
        if price != "" {
            cell.price_label.text = /data.price?.toDouble()?.addCurrencyLocale
        }
        
        cell.selection_view.isHidden = true
        
        cell.quantity_label.text = data.selectedQuantity
        
        cell.actionPlusBlock = {
            let maxQuantity = data.max_adds_on ?? "1"
                        self.quantity = Int(cell.quantity_label.text ?? "1") ?? 1
                        if cell.quantity_label.text != maxQuantity {
                            print("Button tapped")
                                        self.btnIndex = indexPath
                                        self.isQuantity = true
                                        self.quantity += 1
                                        let res = self.addonQuantityMethod()
                            if res {
                                let qt = Int(data.selectedQuantity) ?? 1
//                                qt += 1
                                data.selectedQuantity = qt.toString
                                self.tableView.reloadData()
                            }
                        }
                    }
        
        cell.actionMinusBlock = {
             self.quantity = Int(cell.quantity_label.text ?? "1") ?? 1
                        if cell.quantity_label.text != "1" {
                            print("Button tapped")
                                        self.btnIndex = indexPath
                                        let maxQuantity = Int(data.max_adds_on ?? "1") ?? 1
                                        self.isQuantity = true
                                        self.quantity -= 1
                                        let res = self.removeAddOn()
                            
                            if res {
                                let qt = Int(data.selectedQuantity) ?? 2
                                data.selectedQuantity = qt.toString
                                self.tableView.reloadData()
                            }
                        }
                    }
        
        if data.is_default ?? "" == "1" {
//            cell.sideImage.image = UIImage(named: "ic_check_pressed")
            cell.sideImage.tintColor = .gray //SKAppType.type.color
            cell.selection_view.isHidden = true
            if data.is_multiple == "1"{
                cell.sideImage.image = UIImage(named: "ic_check_pressed")
            }else {
                cell.sideImage.image = UIImage(named: "radioOnBlack")
            }
            self.saveDefalut(indexPath: indexPath)
        } else {
            if let contain = self.product?.addOnValue?.contains(where: {$0.type_id == data.type_id}),contain {
//                cell.sideImage.image = UIImage(named: "ic_check_pressed")
                cell.sideImage.tintColor = SKAppType.type.color
                if data.is_multiple == "1"{
                    cell.selection_view.isHidden = /Int(data.selectedQuantity) <= 1
                    cell.sideImage.image = UIImage(named: "ic_check_pressed")
                }else {
                    cell.sideImage.image = UIImage(named: "radioOnBlack")
                }
            } else {
                if data.is_multiple == "1"{
                    cell.sideImage.image = UIImage(named: "ic_check_normal")
                }else {
                    cell.sideImage.image = UIImage(named: "radioOffBlack")
                }
//                cell.sideImage.image = UIImage(named: "ic_check_normal")
                cell.sideImage.tintColor = SKAppType.type.alphaColor
                cell.selection_view.isHidden = true
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.isQuantity = false
        self.saveDefalut(indexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerName =  self.product?.adds_on?[section].name else {return UIView()}
        guard let min =  self.product?.adds_on?[section].value?[0].min_adds_on else {return UIView()}
        guard let max =  self.product?.adds_on?[section].value?[0].max_adds_on else {return UIView()}
        guard let isMultiple = self.product?.adds_on?[section].value?[0].is_multiple else {return UIView()}

        self.headerView = CutomizationTableHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 70))
        
        self.headerView?.choise_label.text = "\("Choice of".localized()) \(headerName)"
        
        if isMultiple == "1" {
            var headerText = "Please select multiple options"
            if /Int(max) > 0 {
                headerText += " (\("Min".localized()) \(min) \("Max".localized()) \(max))"
            }
            self.headerView?.option_label.text = headerText
        }
        
        return self.headerView

    }
    
}
extension CustomizationViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        self.aryQuantity.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(self.aryQuantity[row])"
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.quantity = self.aryQuantity[row]
    }
}
