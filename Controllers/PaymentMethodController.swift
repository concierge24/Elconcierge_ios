//
//  PaymentMethodController.swift
//  Clikat
//
//  Created by cblmacmini on 5/23/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import Material
import EZSwiftExtensions
import SwiftyJSON
import CryptoSwift
import Adjust

class PaymentMethodController: BaseViewController {
    
    //MARK:- IBOutlet
    @IBOutlet weak var menu_button: ThemeButton! {
        didSet{
            menu_button.isHidden = /*SKAppType.type == .gym ||*/ SKAppType.type == .food || SKAppType.type == .home || SKAppType.type == .carRental || SKAppType.type == .eCom ? true : false
        }
    }
    @IBOutlet weak var btnPayment: UIButton! {
        didSet {
            btnPayment.setBackgroundColor(SKAppType.type.color, forState: .normal)
        }
    }
    @IBOutlet weak var btnCOD: UIButton!{
        didSet{            
            btnCOD.setAttributedTitle(attributedStringWithImage( string: L10n.CashOnDelivery.string , image: Asset.Ic_payment_cash), for: .normal)
        }
    }
    @IBOutlet weak var btnCreditCard: UIButton!{
        didSet{
            btnCreditCard.setAttributedTitle(attributedStringWithImage(string: L10n.CreditDebitCard.string, image: Asset.Ic_payment_card), for: .normal)
        }
    }
    @IBOutlet weak var viewBgCardDetails: View!
    @IBOutlet weak var viewCardHolderName: View!
    @IBOutlet weak var viewCardNumber: View!
    @IBOutlet weak var viewExpiry: View!
    
    @IBOutlet weak var tfCardHoldersName : UITextField!
    @IBOutlet weak var tfCardNumber: UITextField!
    @IBOutlet weak var tfCVV: UITextField!
    @IBOutlet weak var tfExpiryDate: UITextField!
    
    //MARK:- Variables
    var selectedPaymentMethod = PaymentMode(paymentType: .DoesntMatter)
    var orderId : String?
    var orderSummary : OrderSummary?
    var isConfirmOrder : Bool = false
    var parameters = Dictionary<String,Any>()
    
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        if SKAppType.type.isJNJ {
            btnPayment.setTitle("FINISH", for: .normal)
        } else {
            btnPayment.kern(kerningValue: ButtonKernValue)
        }
        
        btnCOD.isSelected = true
        viewBgCardDetails.alpha = 0.0
        viewCardHolderName.transform = CGAffineTransform(translationX: viewBgCardDetails.frame.size.width, y: 0)
        viewCardNumber.transform = CGAffineTransform(translationX: -viewBgCardDetails.frame.size.width, y: 0)
        viewExpiry.transform = CGAffineTransform(translationX: viewBgCardDetails.frame.size.width, y: 0)
        
        guard let method = orderSummary?.paymentMode else { return }
        
        switch method.paymentType {
        case .Card:
            btnCOD?.isHidden = true
            btnCreditCard?.isHidden = false
            selectedPaymentMethod = method
        case .COD:
            btnCOD?.isHidden = false
            btnCreditCard?.isHidden = true
            selectedPaymentMethod = method
        case .DoesntMatter:
            btnCOD?.isHidden = false
            btnCreditCard?.isHidden = false
            selectedPaymentMethod =  method
        case .AfterConfirmation:
            btnCOD?.isHidden = false
            btnCreditCard?.isHidden = true
            selectedPaymentMethod = method
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
}

extension PaymentMethodController {
    
    func attributedStringWithImage(string : String ,image : Asset) -> NSMutableAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = UIImage(asset : image)
        let attachmentString = NSAttributedString(attachment: attachment)
        let myString = NSMutableAttributedString(string: "")
        myString.append(attachmentString)
        myString.append(NSAttributedString(string: "   "))
        myString.append(NSAttributedString(string: string))
        return myString
    }
}

//MARK: - Button Actions
extension PaymentMethodController {
    
    @IBAction func actionMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    @IBAction func actionBack(sender: AnyObject) {
        popVC()
    }
    
    @IBAction func actionCod(sender: UIButton) {
        if sender.isSelected { return }
        sender.isSelected = !sender.isSelected
        btnCreditCard.isSelected = !sender.isSelected
        toggleInfoView()
    }
    
    @IBAction func actionCard(sender: UIButton) {
        if sender.isSelected { return }
        sender.isSelected = !sender.isSelected
        btnCOD.isSelected = !btnCOD.isSelected
        
        toggleInfoView()
    }
    
    @IBAction func actionFinish(sender: UIButton) {
      
        if isConfirmOrder {
            APIManager.sharedInstance.opertationWithRequest(withApi: API.ConfirmScheduleOrder(FormatAPIParameters.ConfirmScheduleOrder(orderId: orderId, paymentType: selectedPaymentMethod.paymentType.rawValue).formatParameters()), completion: {
                (response) in
                switch response {
                case .Success(_):
                    
                    UtilityFunctions.showSweetAlert(title : L10n.Success.string, message: L10n.OrderConfirmedSuccessfully.string, style: .Success, success: {
                        
                        if self.orderSummary?.selectedDeliverySpeed != .scheduled  {
                            
                            let VC = StoryboardScene.Order.instantiateOrderDetailController()
                            VC.isBuyOnly = /self.orderSummary?.isBuyOnly
                            VC.orderDetails = OrderDetails(orderId: self.orderId)
                            VC.type = .OrderUpcoming
                            VC.isConfirmOrder = true
                            self.pushVC(VC)
                        }
                        
                    })
                    
                default: break
                }
            })
            return
        } else if selectedPaymentMethod.paymentType != .Card {
            generateOrder()
            return
        }
//        APIManager.sharedInstance.showLoader()
//        HTTPClient().postPayFortRequest { [weak self] (response) in
//            APIManager.sharedInstance.hideLoader()
//            switch response {
//            case .Success(let object):
//                self?.startPayfortRequest(sdkToken: (object as? PayFort)?.sdkToken)
//            case .Failure(let validation):
//                print(validation.message)
//            }
//        }
 
    }
}

//MARK: - Credit Card Info Animation
extension PaymentMethodController {
    
    func toggleInfoView(){
        
        if btnCOD.isSelected {
            //selectedPaymentMethod = .COD
        }else {
            //selectedPaymentMethod = .Card
        }
    }
}
//MARK: - TextField Actions

extension PaymentMethodController : UITextFieldDelegate {
    
    @IBAction func textFieldEditingChanged(sender: BKCardNumberField) {
        
        let formatedtext = formatCreditCardNumber(inputText: sender.text ?? "")
        
        if formatedtext != tfCardNumber.text {
            tfCardNumber.text = formatedtext
        }
        if tfCardNumber.text?.count == 19 {
            tfCardNumber.resignFirstResponder()
        }
    }
    
    func formatCreditCardNumber(inputText : String) -> String{
        
        var output = ""
        switch inputText.count {
        case 1...4:
            output = inputText
        case 5...8:
            let firstStr = String(inputText[..<inputText.index(inputText.startIndex, offsetBy: 4)])
            let lastStr = String(inputText[inputText.index(inputText.startIndex, offsetBy: 4)...])
            output = String(format: "%@-%@", arguments: [firstStr,lastStr])
        case 9...12:
            let firstStr = String(inputText[..<inputText.index(inputText.startIndex, offsetBy: 4)])
            
            let middleStr = String(inputText[inputText.index(inputText.startIndex, offsetBy: 4)..<inputText.index(inputText.startIndex, offsetBy: 8)])
            
            let lastStr = String(inputText[inputText.index(inputText.startIndex, offsetBy: 8)...])
            
            output = String(format: "%@-%@-%@", arguments: [firstStr,middleStr,lastStr])
        case 13...16:
            let firstStr = String(inputText[..<inputText.index(inputText.startIndex, offsetBy: 4)])
            
            let middleStr1 = String(inputText[inputText.index(inputText.startIndex, offsetBy: 4)..<inputText.index(inputText.startIndex, offsetBy: 8)])
            
            let middleStr2 = String(inputText[inputText.index(inputText.startIndex, offsetBy: 8)..<inputText.index(inputText.startIndex, offsetBy: 12)])
            
            let lastStr = String(inputText[inputText.index(inputText.startIndex, offsetBy: 12)...])
            
            output = String(format: "%@-%@-%@-%@", arguments: [firstStr,middleStr1,middleStr2,lastStr])
        default:
            output = ""
        }
        return output
    }
}

//MARK: - GenerateOrder Web service

extension PaymentMethodController {
    
    func generateOrder(){
        
//        var agentId = [Int]()
//        if let value = orderSummary?.agentId?.toInt() {
//            agentId.append(value)
//        }
//
//        let timeInter = Date().timeIntervalSince(orderSummary?.currentDate ?? Date())
//
//        var pickupAddress = ""
//        if let add = self.parameters["pickupAddress"] as? String {
//            pickupAddress = add
//        }
//        var dropoffAddress = ""
//        if let dropAddress = self.parameters["dropoffAddress"] as? String {
//            dropoffAddress = dropAddress
//        }
//
//        var pickupApiDate = ""
//        if let pickapiDate = self.parameters["pickupApiDate"] as? String {
//            pickupApiDate = pickapiDate
//        }
//
//        var dropoffApiDate = ""
//        if let dropoapiDate = self.parameters["dropoffApiDate"] as? String {
//            dropoffApiDate = dropoapiDate
//        }
//
//        var pickupCordinates = CLLocationCoordinate2D()
//        if let pickCordinates = self.parameters["pickupCordinates"] as? CLLocationCoordinate2D {
//            pickupCordinates = pickCordinates
//        }
//
//        var dropoffCordinates = CLLocationCoordinate2D()
//        if let dropoffCord = self.parameters["dropoffCordinates"] as? CLLocationCoordinate2D {
//            dropoffCordinates = dropoffCord
//        }
//        let pickupLatitude = pickupCordinates.latitude
//        let pickupLongitude = pickupCordinates.longitude
//        let dropoffLatitude = dropoffCordinates.latitude
//        let dropoffLongitude = dropoffCordinates.longitude
//
//        let objR = API.GenerateOrder(FormatAPIParameters.GenerateOrder(
//            useReferral: false, promoCode: orderSummary?.promoCode,
//            cartId: orderSummary?.cartId,
//            isPackage: orderSummary?.isPackage,
//            paymentType:selectedPaymentMethod,
//            agentIds: agentId,
//            deliveryDate: orderSummary?.deliveryDate?.add(seconds: Int(timeInter)),
//            duration: /orderSummary?.duration, from_address: pickupAddress, to_address: dropoffAddress, booking_from_date: pickupApiDate, booking_to_date: dropoffApiDate, from_latitude: pickupLatitude, to_latitude: dropoffLatitude, from_longitude: pickupLongitude, to_longitude: dropoffLongitude, tip_agent: nil, arrPres: nil, instructions: nil, bookingDate: nil, questions: nil, customer_payment_id: GDataSingleton.sharedInstance.customerPaymentId, user_service_charge: 0.0).formatParameters())
//
//        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
//            [weak self](response) in
//            weak var weakSelf = self
//            switch response {
//            case .Success(let object):
//                weakSelf?.handleGenerateOrder(orderId: object)
//            case .Failure(_):
//                break
//            }
//        }
    }
    func handleGenerateOrder(orderId : Any?){
        
        //print(orderId)
        AdjustEvent.Order.sendEvent(revenue: orderSummary?.totalAmount)
        if !(/self.orderSummary?.isBuyOnly) {
            DBManager.sharedManager.cleanCart()
        }
        UtilityFunctions.showSweetAlert(title: L10n.OrderPlacedSuccessfully.string, message: L10n.YourOrderHaveBeenPlacedSuccessfully.string, style: .Success, success: {
            [weak self] in
            guard let self = self else { return }
            
            if self.orderSummary?.selectedDeliverySpeed == .scheduled {
                
                let VC = StoryboardScene.Order.instantiateOrderSchedularViewController()
                let orderIdArr = orderId as? [Int]
                let ordrs = orderIdArr?.map({ (orderId) -> String in
                    return String(orderId)
                })
                VC.orderId = ordrs?.joined(separator: ",")
                VC.orderSummary = self.orderSummary
                //VC.orderSummary?.paymentMethod = self.selectedPaymentMethod
                self.pushVC(VC)
            }
            else
            {
                let orderIdArr = orderId as? [Int]
                let ordrs = orderIdArr?.map({ (orderId) -> String in
                    return String(orderId)
                })
                let orders = ordrs?.joined(separator: ",")
                let orderDetailVc = StoryboardScene.Order.instantiateOrderDetailController()
                orderDetailVc.isBuyOnly = /self.orderSummary?.isBuyOnly
                orderDetailVc.orderDetails = OrderDetails(orderSummary: self.orderSummary,orderId: orders,scheduleOrder: "")
                orderDetailVc.type = .OrderUpcoming
                orderDetailVc.isOrderCompletion = true
                self.pushVC(orderDetailVc)
            }
            
        })
    }
}

//extension PaymentMethodController : PayFortDelegate {
//    
//    func sdkResult(_ response: Any!) {
//        
//        let response = JSON(response)
//        if response["response_message"].stringValue == "Success"{
//            generateOrder()
//            AdjustEvent.Purchase.sendEvent()
//        }
//        print(response)
//    }
//}

extension PaymentMethodController {
    
    
    func randomStringWithLength (len : Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        
        let randomString : NSMutableString = NSMutableString(capacity: len)
        
        for _ in 0...len {
            let length = UInt32 (letters.length)
            let rand = arc4random_uniform(length)
            randomString.appendFormat("%C", letters.character(at: Int(rand)))
        }
        
        return randomString as String
    }
}

//MARK: - Payfort
extension PaymentMethodController {
    func startPayfortRequest(sdkToken : String?){
//        let payfortController = PayFortController(enviroment: .production)
//        payfortController?.delegate = self
//        var request	= [String : String]()
//        
//        request["command"] = "PURCHASE"
//        request["currency"] = "INR"
//        request["customer_email"] = GDataSingleton.sharedInstance.loggedInUser?.email ?? ""
//        request["language"] = Localize.currentLanguage() == Languages.Arabic ? "ar" : "en"
//        request["merchant_reference"] = randomStringWithLength(len: 8) + "-" + /orderId
//        request["sdk_token"] = sdkToken ?? ""
//        request["amount"] = Int(/orderSummary?.totalAmount * 100).toString
//        request["customer_name"] = /GDataSingleton.sharedInstance.loggedInUser?.firstName
//        payfortController?.isShowResponsePage = true
//        payfortController?.setPayFortRequest(NSMutableDictionary(dictionary: request))
//        payfortController?.callPayFort(self)
        
    }
}
