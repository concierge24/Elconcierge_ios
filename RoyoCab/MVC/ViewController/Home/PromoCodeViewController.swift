//
//  PromoCodeViewController.swift
//  Trava
//
//  Created by Apple on 02/12/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import UIKit

class PromoCodeViewController: UIViewController {

     typealias PromoCodeAdded = (_ card:Coupon?)->()
    
    //MARK:- Outlets
    @IBOutlet weak var buttonApply: UIButton!
    @IBOutlet weak var textFieldPromoCode: UITextField!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.separatorStyle = .none
        }
    }
    
    //MARK:- Properties
    var tableDataSource : TableViewDataSourceCab?
    var arrayCoupons: [Coupon]?
    var delegate: BookRequestDelegate?
    var promoCodeSelection: PromoCodeAdded?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }
        
    
    
}

extension PromoCodeViewController {
    
    func initialSetup() {
        configureTableView()
        apiCoupons()
        buttonApply.setButtonWithTitleColorSecondary()
    }
    
    func configureTableView() {
        let  configureCellBlock : ListCellConfigureBlockCab = { [weak self] ( cell , item , indexpath) in
            if let cell = cell as? PromoCodeTableViewCell {
                cell.delegate = self
                cell.assignData(indexPath: indexpath, item: item as? Coupon)
            }
        }
        
        let didSelectCellBlock : DidSelectedRowCab = { [weak self] (indexPath , cell, item) in
            if let cell = cell as? PromoCodeTableViewCell {
            }
        }
        
        tableDataSource = TableViewDataSourceCab(items: arrayCoupons, tableView: tableView, cellIdentifier: R.reuseIdentifier.promoCodeTableViewCell.identifier, cellHeight: UITableView.automaticDimension)
        tableDataSource?.configureCellBlock = configureCellBlock
        tableDataSource?.aRowSelectedListener = didSelectCellBlock
        tableView.delegate = tableDataSource
        tableView.dataSource = tableDataSource
        tableView.reloadData()
    }
  

}

//MARK:- Button Selector
extension PromoCodeViewController {
    
    @IBAction func buttonCancelClicked(_ sender: Any) {
        dismissVC(completion: nil)
    }
    
    @IBAction func buttonApplyCuponClicked(_ sender: Any) {
        
        view.endEditing(true)
        apiCheckCoupons()
        
       /* if Validations.sharedInstance.validatePromoCode(promo: /textFieldPromoCode.text) {
            
            guard let object = arrayCoupons?.filter({/$0.code?.lowercased() == /textFieldPromoCode.text?.lowercased()}).first  else {
                Alerts.shared.show(alert: "AppName".localizedString, message: "Code is invalid" , type: .error )
                return
            }
            
            delegate?.optionApplyCouponCodeClicked(object: object)
            dismissVC(completion: nil)
            
        } */
    }
        
    @IBAction func textFieldDidChange(_ sender: UITextField) {
        
        buttonApply.isUserInteractionEnabled = !((/sender.text).isEmpty)
        let titleColor = buttonApply.isUserInteractionEnabled ? UIColor(hexString: "#745BF2", alpha: 1.0) : UIColor(hexString: "#745BF2", alpha: 0.6)
        buttonApply.setTitleColor(titleColor, for: .normal)
    }
    
}

//MARK:- API
extension PromoCodeViewController {
    
   func apiCoupons() {
       
       let token = /UDSingleton.shared.userData?.userDetails?.accessToken
       
       let obj = BookServiceEndPoint.coupons
       obj.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) {  [weak self] (response) in
           
           switch response {
           case .success(let data):
               debugPrint("Successs")
               
               guard let model = data as? PromoCouponsModal,
                     let array = model.coupons else { return }
               self?.arrayCoupons = array
               
               self?.tableDataSource?.items = self?.arrayCoupons
               self?.tableView?.reloadData()
               
           case .failure(let strError):
               Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
           }
       }
   }
    
    func apiCheckCoupons() {
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        let obj = BookServiceEndPoint.checkCoupons(code: textFieldPromoCode.text)
        obj.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) {  [weak self] (response) in
            
            switch response {
            case .success(let data):
                debugPrint("Successs")
                
                guard let model = data as? Coupon else { return }
                self?.delegate?.optionApplyCouponCodeClicked(object: model)
                self?.dismissVC(completion: nil)
                
               /* self?.arrayCoupons = array
                
                self?.tableDataSource?.items = self?.arrayCoupons
                self?.tableView?.reloadData() */
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
}

extension PromoCodeViewController : PromoCodeTableViewCellDelegate {
    
    func applyCodeClicked(object: Coupon?) {
        delegate?.optionApplyCouponCodeClicked(object: object)
        
         if let _ = self.promoCodeSelection {
           self.dismissVC {
               self.promoCodeSelection!(object)
           }
         } else {
           dismissVC(completion: nil)
       }
    }
    
}
