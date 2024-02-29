 //
//  PaymentVC.swift
//  Buraq24
//
//  Created by MANINDER on 01/09/18.
//  Copyright © 2018 CodeBrewLabs. All rights reserved.
//

import UIKit
import Razorpay

 
class PaymentVCCab: BaseVCCab, RazorpayPaymentCompletionProtocol {
    
    //MARK:- Outlets
    @IBOutlet var btnTokenRadio: UIButton!
    @IBOutlet var btnCashRadio: UIButton!
    @IBOutlet var btnCardRadio: UIButton!
    @IBOutlet var btnTokenSelection: UIButton!
    @IBOutlet var btnCashSelection: UIButton!
    @IBOutlet var btnCardSelection: UIButton!
    @IBOutlet var btnViewSelectToken: UIButton!
    @IBOutlet var viewEToken: UIView!
    @IBOutlet var constraintTokenViewHeight: NSLayoutConstraint!
    
    //MARK:- Properties
    var paymentType : PaymentType = .Cash
    var categoryId : Int?
    var mode : PaymentScreenMode = .BookRequest
    var delegate :  BookRequestDelegate?
    var serviceType : Int = 0
    typealias Razorpay = RazorpayCheckout
    var razorpay: Razorpay?
    var razorpayTestKey = "rzp_test_NZM3rbof3YhW1p"
    
    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        razorpay = Razorpay.initWithKey(razorpayTestKey, andDelegate: self)

        setSelected()
       /* if let statusBar = UIApplication.shared.value(forKey: "statusBar") as? UIView {
            statusBar.backgroundColor = UIColor.clear
        } */
    }
    
   
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
     //MARK:- Actions
    
    @IBAction func actionBtnPaymentSelected(_ sender: UIButton) {
        
        if mode == .SideMenu {
            
            if sender == btnTokenRadio || sender == btnTokenSelection {
                return
            }
            btnCashRadio.isSelected = false
               btnCardRadio.isSelected = false
            switch sender {
            case btnCashRadio,btnCashSelection :
                btnCashRadio.isSelected = true
            case btnCardRadio,btnCardSelection :
                btnCardRadio.isSelected = true
            default:
                break
            }
            
        } else {
            
            btnViewSelectToken.isHidden =  !(sender == btnTokenRadio || sender == btnTokenSelection)
            btnTokenRadio.isSelected = false
            btnCashRadio.isSelected = false
            btnCardRadio.isSelected = false
            
            switch sender {
                
            case btnTokenRadio,btnTokenSelection :
                btnTokenRadio.isSelected = true
            case btnCashRadio,btnCashSelection :
                btnCashRadio.isSelected = true
                paymentType = .Cash
                setPaymentMode()
            case btnCardRadio,btnCardSelection :
                btnCardRadio.isSelected = true
                paymentType = .Card
                setPaymentMode()
            default:
                break
            }
        }
    }
    
    @IBAction func actionBtnSelectToken(_ sender: UIButton) {
      
        guard  let eTokenObj = R.storyboard.bookService.buyTokenVC() else { return }
        eTokenObj.categoryId = 2
         eTokenObj.modeBuy = mode
        self.pushVC(eTokenObj)
    }
    
    //MARK:- Functions
    
    
    func onPaymentError(_ code: Int32, description str: String) {
        let alertController = UIAlertController(title: "FAILURE", message: str, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        let alertController = UIAlertController(title: "SUCCESS", message: "Payment Id \(payment_id)", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
        self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    internal func showPaymentForm(){
        let options: [String:Any] = [
            "amount": "100", //This is in currency subunits. 100 = 100 paise= INR 1.
            "currency": "INR",//We support more that 92 international currencies.
            "description": "purchase description",
            "image": "https://url-to-image.png",
            "name": "business or product name",
            "prefill": [
                "contact": "9797979797",
                "email": "foo@bar.com"
            ],
            "theme": [
                "color": "#F37254"
            ]
        ]
        razorpay?.open(options)
    }
    
    func setPaymentMode() {
        if mode == .BookRequest {
            showPaymentForm()
//            guard let vc = R.storyboard.bookService.razorpayVC() else {return}
//            pushVC(vc)
//        self.delegate?.didPaymentModeChanged(paymentMode: paymentType)
//        self.popVC()
        }
    }
    
    func setSelected() {
        btnViewSelectToken.isHidden = !(mode == .SideMenu)
        switch paymentType {
        case .Card:
            btnCardRadio.isSelected = true
        case .Cash:
             btnCashRadio.isSelected = true
         case .EToken:
             btnTokenRadio.isSelected = true
            btnViewSelectToken.isHidden = false
            
        case .Wallet:
            print("wallet")
       
        }
        

        mode == .SideMenu ? btnViewSelectToken.setTitle("view_e_tokens".localizedString, for: .normal) :  btnViewSelectToken.setTitle("select_e_token".localizedString , for: .normal)

        if mode == .BookRequest  {
            let heightvalue = (categoryId == 2) ? 70 : 0
            constraintTokenViewHeight.constant = CGFloat(heightvalue)
            viewEToken.isHidden = !(categoryId == 2)
        }
      
    }
}

  //MARK:- API
extension PaymentVCCab {
    
    func getTokenDetails() {
        
    }
}
