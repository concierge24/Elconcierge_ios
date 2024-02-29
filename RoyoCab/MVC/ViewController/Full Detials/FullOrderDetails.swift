//
//  FullOrderDetails.swift
//  RoyoRide
//
//  Created by Rohit Prajapati on 01/06/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import UIKit

class FullOrderDetails: UIViewController {
   
    //MARK:- OUTLETS
    @IBOutlet weak var btnback: UIButton!
    @IBOutlet weak var segmentController: UISegmentedControl!
    @IBOutlet weak var lblTotal: UILabel!
    @IBOutlet weak var checkListTable: UITableView!
    
    @IBOutlet weak var lblPayment: UILabel!
    @IBOutlet weak var lblPaymentType: UILabel!
    @IBOutlet weak var lblMaterialType: UILabel!
    @IBOutlet weak var lblMaterialQuantity: UILabel!
    @IBOutlet weak var lblAdditionalInfo: UILabel!
    @IBOutlet weak var lblPersonToDeliver: UILabel!
    @IBOutlet weak var lblPersonDeliverPhoneNumber: UILabel!
    @IBOutlet weak var lvlInvoiceNumber: UILabel!
    @IBOutlet weak var lblDeliveryPerson: UILabel!
    @IBOutlet weak var orderStack: UIStackView!
    @IBOutlet weak var checkListStack: UIStackView!
    @IBOutlet weak var btnDone2: UIButton!
    
    //MARK: PROPERTIES
    var orderCurrent : OrderCab?
    var orderCheckList = [CheckLists]()
    var checkListFinalArray = [CheckListModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        NotificationCenter.default.addObserver(self, selector: #selector(updatedCheckList), name: NSNotification.Name(rawValue: LocalNotifications.SerCheckList.rawValue), object: nil)
        
        setUPUI()
    }
    
    func deleteCheckListItem(checkList: CheckListModel?, indexValue: Int) {
        
        let checkListID = [/checkList?.check_list_id].toJson()
        
        
        let req = BookServiceEndPoint.removeCheckListItem(checkList: checkListID)
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
       /* req.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) {(response) in
            switch response {
            case .success(_):
                self.checkListFinalArray.remove(at: indexValue)
                self.checkListTable.reloadData()
                
                 
                if self.checkListFinalArray.count == 0 {
                    self.lblTotal.text = "Total Amount \(0) \(/UDSingleton.shared.appSettings?.appSettings?.currency)"
                }
                
                 var total = 0
                if var userData = UDSingleton.shared.userData?.order?.first?.check_lists {
                    for (index,element) in userData.enumerated() {
                        if element.check_list_id == /checkList?.check_list_id {
                            userData.remove(at: index)
                            UDSingleton.shared.userData?.order?.first?.check_lists = userData
                        } else {
                            total = total + (Int(/(element.after_item_price)) ?? 0) + /(element.tax)
                            self.lblTotal.text = "Total Amount \(total) \(/UDSingleton.shared.appSettings?.appSettings?.currency)"
                        }
                    }
                }
                 
                
                break
            
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }*/

        
    }
    
    @objc func updatedCheckList(notification: NSNotification) {
        
        checkListFinalArray.removeAll()
        var total = 0
        let data = notification.userInfo as? [String: Any]
        let order = data?["order"] as? [String: Any]
        let checkList = order?["check_lists"] as? [[String: Any]]
        
       if let checkListArray = checkList {
           for element in checkListArray {
               let checklist = CheckListModel(afteritemprice: element["after_item_price"] as? String,
                                              beforeitemprice: element["before_item_price"] as? String,
                                              checklistid: element["check_list_id"] as? Int,
                                              createdat: element["created_at"] as? String,
                                              itemname: element["item_name"] as? String,
                                              orderid: element["order_id"] as? String,
                                              updatedat:  element["updated_at"] as? String,
                                              userdetailid: element["user_detail_id"] as? String,
                                              tax: element["tax"] as? Int,
                                              price: element["price"] as? String)
            
                    total = total + (Int(/(element["after_item_price"] as? String)) ?? 0) + Int(/(element["tax"] as? Int))
                   
               
                    checkListFinalArray.append(checklist)
                }
        
                checkListTable.reloadData()
            }
        
         checkListTable.reloadData()
        
         lblTotal.text = "Total Amount \(/UDSingleton.shared.appSettings?.appSettings?.currency).\(total)"
        
         Alerts.shared.show(alert: "Checklist", message: "Tax Price is updated by driver." , type: .error)
        
         alertConfimation(totalPrice: total)
        }
    
    func alertConfimation(totalPrice: Int) {
        alertBox(message: "Total price has been updated.", title: "Price including Tax \(/UDSingleton.shared.appSettings?.appSettings?.currency). \(totalPrice)") {
            //Pay.....
        }
    }
    
    
        func setUPUI() {
        
            var total = 0
            
            for element in  orderCheckList  {
                 let checklist = CheckListModel(afteritemprice: element.after_item_price,
                                                beforeitemprice: element.before_item_price,
                                                checklistid: element.check_list_id,
                                                createdat: element.created_at,
                                                itemname: element.item_name,
                                                orderid: element.order_id,
                                                updatedat:  element.updated_at,
                                                userdetailid: element.user_detail_id,
                                                tax: element.tax,
                                                price: element.price)
                
                total = total + (Int(/element.after_item_price) ?? 0)
                total = total + Int(/element.tax)
                 
                checkListFinalArray.append(checklist)
             }
            
            
            if checkListFinalArray.count == 0 {
                segmentController.isHidden = true
                orderStack.isHidden = false
                checkListStack.isHidden = true
            } else {
                segmentController.isHidden = true
                orderStack.isHidden = true
                checkListStack.isHidden = false
            }
            
            checkListTable.reloadData()
            
        
                        
            lblTotal.text = "Total Amount \(/UDSingleton.shared.appSettings?.appSettings?.currency).\(total)"
            
            //----------------
            lblPayment.text = orderCurrent?.payment?.finalCharge
            lblPaymentType.text = "Cash"
            lblMaterialType.text = "NA"
            lblMaterialType.text = "NA"
            lblAdditionalInfo.text = orderCurrent?.orderProductDetail?.category_name
            lblPersonToDeliver.text = "NA"
            btnDone2.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        
    }
    
    
    @IBAction func segmentOrderValue(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            orderStack.isHidden = false
            checkListStack.isHidden = true
            
            break
        case 1:
            orderStack.isHidden = true
            checkListStack.isHidden = false
            
            break
        default:
            print("default")
        }
    }
    
    @IBAction func btnDeleteItems(_ sender: UIButton) {
        
        if UIApplication.topViewController()!.isKind(of: UIAlertController.self) {
            
        } else {
            alertBoxOption(message: "Are you sure you want to remove this item form your checklist.", title: "Remove Item", leftAction: "Cancel", rightAction: "Pay", ok: {
                    self.deleteCheckListItem(checkList: self.checkListFinalArray[sender.tag], indexValue: sender.tag)
                              
                }) {
                  print("Cencel")
             }
        }
       
    }
    
    func convertIntoJSONString(arrayObject: [Any]) -> String? {

        do {
            let jsonData: Data = try JSONSerialization.data(withJSONObject: arrayObject, options: [])
            if  let jsonString = NSString(data: jsonData, encoding: String.Encoding.utf8.rawValue) {
                return jsonString as String
            }
            
        } catch let error as NSError {
            print("Array convertIntoJSON - \(error.description)")
        }
        return nil
    }
    
    
    @IBAction func btnDone(_ sender: Any) {
        
        var arrayElement = [[String: String]]()
        arrayElement.removeAll()
        for (index,element) in checkListFinalArray.enumerated() {
            var tempObject = [String: String]()
            tempObject["after_item_price"] = element.after_item_price
            tempObject["before_item_price"] = element.before_item_price
            tempObject["check_list_id"] = String(/element.check_list_id)
            tempObject["created_at"] = element.created_at
            tempObject["item_name"] = element.item_name
            tempObject["order_id"] = element.order_id
            tempObject["updated_at"] = element.updated_at
            tempObject["tax"] = String(/element.tax)
            tempObject["price"] = element.price
            tempObject["user_detail_id"] = element.user_detail_id
            
            UDSingleton.shared.userData?.order?.first?.check_lists?[index].after_item_price = element.after_item_price
            arrayElement.append(tempObject)
            
        }
        
        
        let checkListArrayJson = arrayElement.toJson()
        
        let req = BookServiceEndPoint.editCheckList(checkList: checkListArrayJson)
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
       /* req.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) {(response) in
            switch response {
            case .success(_):
                 Alerts.shared.show(alert: "AppName".localizedString, message: "Checklist Updated" , type: .success )
                
            
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }*/
        
    }
    
    @IBAction func btnBack(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension FullOrderDetails: UITableViewDelegate, UITableViewDataSource {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkListFinalArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CheckListOrderCell", for: indexPath) as! CheckListOrderCell
        cell.lblItemName.text = checkListFinalArray[indexPath.row].item_name
        cell.lblPriceSymbol.text = /UDSingleton.shared.appSettings?.appSettings?.currency
        cell.txfItemPrice.text = "\(/checkListFinalArray[indexPath.row].after_item_price)"
        cell.lblTaxPrice.text = "*Tax price \(/checkListFinalArray[indexPath.row].tax) \(/UDSingleton.shared.appSettings?.appSettings?.currency)"
        cell.txfItemPrice.delegate = self
        cell.btnDelete.tag = indexPath.row
        return cell
    }
    
}

extension FullOrderDetails : UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {

        let newString = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        let textFieldIndex = textField.tag
        
        if newString == "" {
            checkListFinalArray[textFieldIndex].after_item_price = "0"
        } else {
            checkListFinalArray[textFieldIndex].after_item_price = newString
        }
        
        
        var total = 0
        for checkListItem in checkListFinalArray {
            total = total + (Int(/checkListItem.after_item_price) ?? 0) + Int(/checkListItem.tax)
        }
                   
        lblTotal.text = "Total Amount \(/UDSingleton.shared.appSettings?.appSettings?.currency) \(total)"
        //checkListTable.reloadData()

        return true
    }
}





