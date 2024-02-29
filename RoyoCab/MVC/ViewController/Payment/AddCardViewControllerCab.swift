//
//  AddCardViewController.swift
//  Trava
//
//  Created by Apple on 15/01/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import UIKit
import WebKit
import Stripe

typealias CardAdded = (_ card:CreditCard)->()
class AddCardViewControllerCab: UIViewController {

    //MARK:-Outlet
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var viewCardContainer: UIView!
    @IBOutlet weak var txtFldCardHolderName: UITextField!
    @IBOutlet weak var viewCard: STPPaymentCardTextField!
    @IBOutlet weak var btnAddCard: UIButton!
    
    //MARK:-Properties
  
    typealias WebPayment = ()->()
    
    var cardAdded:CardAdded?
    var webPayment:WebPayment?
    var url: String?
    let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
    let paymentGateway = PaymentGateway(rawValue:(/UDSingleton.shared.appSettings?.appSettings?.gateway_unique_id))
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webView.navigationDelegate = self
        webView.uiDelegate = self
        initialSetup()
        setupUI()
        viewCard.postalCodeEntryEnabled = false
        
    }
    
    @IBAction func btnAddCardAction(_ sender: UIButton) {
        
        if !txtFldCardHolderName.isHidden && txtFldCardHolderName.text!.isEmpty {

            Alerts.shared.show(alert:  "AppName".localizedString, message: "Please enter CardHolder Name.", type: .error)
           
            return
        }
        else if !self.viewCard.isValid{
            
             Alerts.shared.show(alert:  "AppName".localizedString, message: "Please enter valid card details.", type: .error)
        }
        else{
        
        
        switch paymentGateway {
        case .stripe:
            addStripCard(sender: sender)
            break
            
        case .epayco:
            addEpaycoCard(sender: sender)
            break
            
        case .peach:
            break
            
        default:
            break
        }
        }
        
    }
    
  
    
    
    func addEpaycoCard(sender:UIButton){
        
        if let cardAdded = self.cardAdded{
            let creditCard = CreditCard()
            creditCard.name = self.txtFldCardHolderName.text!
            creditCard.cvv = self.viewCard?.cvc
            creditCard.expMonth = (self.viewCard?.expirationMonth)
            creditCard.expYear = (self.viewCard?.expirationYear)
            creditCard.cardNumber = self.viewCard?.cardNumber
         
            
            cardAdded(creditCard)
        }
        self.popVC()
        
    }
    
    func addStripCard(sender:UIButton){
        
        sender.isUserInteractionEnabled = false
        let cardParams = STPCardParams()
        cardParams.number = viewCard?.cardNumber
        cardParams.expMonth = (viewCard?.expirationMonth)!
        cardParams.expYear = (viewCard?.expirationYear)!
        cardParams.cvc = viewCard?.cvc
        
        
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        STPAPIClient.shared().createToken(withCard: cardParams) { (token: STPToken?, error: Error?) in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            guard let token = token, error == nil else {
                sender.isUserInteractionEnabled = true
                Alerts.shared.show(alert: "AppName".localizedString, message: /error?.localizedDescription , type: .error )
                return
            }
            
            if let cardAdded = self.cardAdded{
                let creditCard = CreditCard()
                creditCard.name = self.txtFldCardHolderName.text!
                creditCard.cardNumber = self.viewCard?.cardNumber
                creditCard.expMonth = (self.viewCard?.expirationMonth)
                creditCard.expYear = (self.viewCard?.expirationYear)
                creditCard.cardNumber = self.viewCard?.cardNumber
                creditCard.token = token.tokenId
                
                cardAdded(creditCard)
            }
            self.popVC()
            //            APIManager.shared.request(with: UserEndPoint.addCard(tokenId: token.tokenId, cardHolderName: /self.tfName.text, expMonth: "\(self.vwCardDetails!.expirationMonth)", expYear: "\(self.vwCardDetails!.expirationYear)"), completion: { (response) in
            //                sender.isUserInteractionEnabled = true
            //
            //                switch response {
            //
            //                case .success(_ ):
            //
            //                    self.popVC()
            //                    self.makeToast(text: ConstantString.cardAddedSuccessfully.localized, type: .success)
            //
            //                case.failure(let str):
            //
            //                    self.makeToast(text: str, type: .error)
            //                }
            //
            //            }, loader: true)
        }
    }
    
    
    func setupUI(){
        
        
        btnAddCard.setButtonWithBackgroundColorThemeAndTitleColorBtnText()
        txtFldCardHolderName.setBorderColorSecondary()
        txtFldCardHolderName.addShadowToTextFieldColorSecondary()
        txtFldCardHolderName.setLeftPaddingPoints(10)
    }
    
    
    func setupStrip(){
        
        Stripe.setDefaultPublishableKey(/UDSingleton.shared.appSettings?.appSettings?.stripe_public_key)
    }
    
    
    func setupPaymentGateway(){
        
        switch paymentGateway {
        case .stripe:
            txtFldCardHolderName.isHidden = true
            setupStrip()
            
        default:
            txtFldCardHolderName.isHidden = true
            break
        }
    }
    
}

extension AddCardViewControllerCab {
    
    func initialSetup() {
        
        switch paymentGateway {
        case .stripe:
            
            webView.isHidden = true
            viewCardContainer.isHidden = false
            setupStrip()
            break
            
        case .epayco:
            webView.isHidden = true
            viewCardContainer.isHidden = false
            break
            
        case .paystack,.payku:
            
            viewCardContainer.isHidden = true
            webView.isHidden = false
            
            guard let encodedURL  = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let URL = URL(string: encodedURL) else {return}
            
            webView.load(URLRequest(url: URL))
            break
            
        case .peach:
            webView.isHidden = true
            viewCardContainer.isHidden = false
            break
            
        default:
            viewCardContainer.isHidden = true
            webView.isHidden = false
            guard let encodedURL  = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let URL = URL(string: encodedURL) else {return}
            webView.load(URLRequest(url: URL))
        }
        
        
//        switch template {
//        case .GoMove:
//
//            setupPaymentGateway()
//            webView.isHidden = true
//            viewCard.isHidden = false
//
//
//        default:
//            viewCard.isHidden = true
//            webView.isHidden = false
//            guard let encodedURL  = url?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
//                let URL = URL(string: encodedURL) else {return}
//
//            webView.load(URLRequest(url: URL))
//        }
        
       
        
    }
    
    
    func webPaymentCompleted() {
        
        if let  webPayment =  webPayment{
            
            webPayment()
        }
    }
    
}

//MARK:- Button Selectors
extension AddCardViewControllerCab {
    
    @IBAction func buttonBackClicked( _ sender: Any) {
        
        if paymentGateway == PaymentGateway.paystack || paymentGateway == PaymentGateway.payku{
           webPaymentCompleted()
        }
        popVC()
    }
    
    
}

extension AddCardViewControllerCab:WKNavigationDelegate,WKUIDelegate{
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print(#function)
        let urlString  = webView.url?.absoluteString
        if urlString == "\(APIBasePath.basePath)/" {
            self.popVC()
            webPaymentCompleted()
        
        }
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
          print(#function)
         print(webView.url)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
          print(#function)
         print(webView.url)
    }
    
    func webView(_ webView: WKWebView, didReceiveServerRedirectForProvisionalNavigation navigation: WKNavigation!) {
          print(#function)
        print(webView.url)
    }
    
 
}
