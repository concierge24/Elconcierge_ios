//
//  BottleReturnVC.swift
//  Buraq24
//
//  Created by MANINDER on 01/11/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit

protocol refreshPurchasedToken: class {
    
    func dismissController()
    func moveToPurchasedToken()
    
}

extension refreshPurchasedToken{
    func moveToPurchasedToken(){
        
    }
    
    func dismissController(){
        
    }
    
}

class BottleReturnVC: UIViewController {
    
    //MARK:- Outlets
    
    @IBOutlet var btnYes: UIButton!
    @IBOutlet var btnNo: UIButton!
    @IBOutlet var btnPaymentOnline: UIButton!
    @IBOutlet var btnPaymentCash: UIButton!
    
    @IBOutlet weak var lblBrandName: UILabel!
    @IBOutlet weak var lblname: UILabel!
    @IBOutlet weak var lblHeader: UILabel!
    @IBOutlet weak var lblPrice: UILabel!
    
    //MARK:- Properties
    
    var tokenIndex:Int?
    var response : CompanyTokenListing?
    var bottleQuantity:Int?
    var address:String?
    var delegate:refreshPurchasedToken?

    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lblHeader.text = "Do you have \(/response?.eTokens?[tokenIndex!].categoryBrand?.name) bottles with you?"
        lblBrandName.text = response?.eTokens?[/tokenIndex].categoryBrand?.name
        self.lblname.text = "\(/response?.eTokens?[tokenIndex!].categoryBrandProduct?.name)/token"
        
        let Buraq_percent = /response?.organisation?.buraq_percentage
        let val2 = (/Double(Buraq_percent) / 100 ) *  Double(/response?.eTokens?[tokenIndex!].price)
        let total = val2 +  Double(/response?.eTokens?[tokenIndex!].price)
        self.lblPrice.text = "\(total) OMR"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.btnNo.isSelected = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.init(r: 0.0, g: 0.0, b: 0.0, a: 0.4)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK:- Actions
    
    @IBAction func actionBtnYesNoPressed(_ sender: UIButton) {
        
        if sender.tag == 0{
            btnNo.isSelected = false
            btnYes.isSelected = true
        }
        else{
            btnYes.isSelected = false
            btnNo.isSelected = true
        }
    }
    
    @available(iOS 16.0, *)
    @IBAction func actionBtnPaymentPressed(_ sender: UIButton) {
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        if sender.tag == 0{
            self.confirmDelivery(PayType: "Cash", token: token)
        }
        else{
            
        Alerts.shared.show(alert: "AppName".localizedString, message: R.string.localizable.eTokenOnlinePayment(), type: .info)
//            self.confirmDelivery(PayType: "Online", token: token)
        }
    }
    
    //MARK:- API Requests
    
    
    @available(iOS 16.0, *)
    func confirmDelivery(PayType:String,token:String){
        
        let hasBottles = btnYes.isSelected ? 1: 0
        
        let BuyRequest = BookServiceEndPoint.purchaseEToken(organisation_coupon_id: response?.eTokens?[tokenIndex!].organisation_coupon_id, buraq_percentage: response?.organisation?.buraq_percentage, bottle_returned_value: hasBottles, bottle_charge: response?.organisation?.bottle_charge, quantity: bottleQuantity, payment_type: PayType, price: response?.eTokens?[/tokenIndex].price, eToken_quantity: response?.eTokens?[tokenIndex!].quantity, address: CouponSelectedLocation.selectedAddress, address_latitude: LocationManagerCab.shared.latitude, address_longitude: LocationManagerCab.shared.longitude)
        
        BuyRequest.request(header: ["access_token" :  "\(token)", "secretdbkey": APIBasePath.secretDBKey, "language_id" : LanguageFile.shared.getLanguage()]) {[weak self] (response) in
            switch response {
            case .success(_):
                
                self?.alertBoxOk(message:R.string.localizable.eTokenTokenPurchasedSuccessfully(), title: "AppName".localizedString, ok: {
                    self?.delegate?.dismissController()
                   self?.dismiss(animated: true, completion: nil)
                })
                
            case .failure(let strError):
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
    //MARK:- Functions
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let firstTouch = touches.first {
            let hitView = self.view.hitTest(firstTouch.location(in: self.view), with: event)
            
            if hitView == self.view{
                self.dismiss(animated: true, completion: nil)
            }
            
        }
    }

}
