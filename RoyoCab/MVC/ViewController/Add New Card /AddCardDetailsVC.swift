//
//  ProfileCardDetailsVC.swift
//  Try
//
//  Created by Rohit Prajapati on 09/04/20.
//  Copyright © 2020 Code Brew Labs. All rights reserved.
//

import UIKit

class AddCardDetailsVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var txtCardNumber: UITextField!
    @IBOutlet weak var txtCardName: UITextField!
    @IBOutlet weak var txtExpireDate: UITextField!
    @IBOutlet weak var txtCVV: UITextField!
    @IBOutlet weak var btnAddCard: UIButton!
      var cardAdded:CardAdded?
    
     let paymentGateway = PaymentGateway(rawValue:(/UDSingleton.shared.appSettings?.appSettings?.gateway_unique_id))
    let conekta = Conekta()
    
    //MARK: PROPERTIES
    override func viewDidLoad() {
        super.viewDidLoad()
        btnAddCard.setButtonWithBackgroundColorSecondaryAndTitleColorBtnText()
        
        switch paymentGateway {
          
        case .conekta: setupConekta()
        default: break
            
        }

    }
    
    @IBAction func btnback(_ sender: Any) {
        self.popVC()
    }
    
    @IBAction func btnAddCardAction(_ sender: Any) {
        
        if txtCardNumber.text?.count != 19 || txtCardNumber.text == "" || txtCardName.text == "" || txtExpireDate.text?.count != 7 || txtExpireDate.text == "" || txtCVV.text?.count != 3 || txtCVV.text == "" {
           
            Alerts.shared.show(alert: "AppName".localizedString, message: "Please enter correct card detials" , type: .error )
            
        } else {
            let expiryDate = (txtExpireDate.text)?.components(separatedBy: "/")
            let month = expiryDate?.first
            let year = expiryDate?[1]
            let cardNumber = txtCardNumber.text?.replacingOccurrences(of: " ", with: "")
            
            
            switch paymentGateway {
            case .peach:
                
                addPeachCard(card_holder_name: txtCardName.text?.trimmed(),
                                        card_number: cardNumber,
                                        exp_year: year, cvc: txtCVV.text,
                                        gateway_unique_id: /UDSingleton.shared.appSettings?.appSettings?.gateway_unique_id,
                                        card_brand: "VISA",
                                        exp_month: /month)
            case .conekta:
                
                getConektaToken(card_holder_name: txtCardName.text?.trimmed(),
                card_number: cardNumber,
                exp_year: year, cvc: txtCVV.text!,
                exp_month: /month)
                
            default:
                break
            }
            
           
        }
        
        
        
    }
    
    
    
    
    //MARK:- FUNCTIONS
    
    
    func setupConekta(){
        
        conekta.delegate = self
        conekta.publicKey = /UDSingleton.shared.appSettings?.appSettings?.conekta_api_key
        conekta.collectDevice()
        
    }
    
    func getConektaToken(card_holder_name: String?, card_number: String?, exp_year: String?, cvc: String?, exp_month: String ){
        
        let card  = conekta.card()
        
        card?.setNumber(/card_number, name: /card_holder_name, cvc: /cvc, expMonth: exp_month, expYear: /exp_year)
       
        let creditCard = CreditCard()
        creditCard.cardNumber = card_number
        creditCard.name = card_holder_name
        creditCard.cvv = cvc
        creditCard.expMonthStr = exp_month
        creditCard.expYearStr = exp_year
        
        let token = conekta.token()
        token?.card = card
        APIManagerCab.shared.showLoader()
        token?.create(success: { (data) -> Void in
            APIManagerCab.shared.hideLoader()
            if let data = data as NSDictionary? as! [String:Any]? {
               
                let deviceFingerPrint = self.conekta.deviceFingerprint()
                if let id = (data["id"] as? String) {
                  //  self.paymentDone?(id)
                    print(id)
                    creditCard.token = id
                    if let cardAdded = self.cardAdded{
                        
                        cardAdded(creditCard)
                        self.popVC()
                    }
                }
            }
        }, andError: { (error) -> Void in
           APIManagerCab.shared.hideLoader()
             Alerts.shared.show(alert: "AppName".localizedString, message: /error?.localizedDescription , type: .error )
            
        })
        
    }
    
    
    func addPeachCard(card_holder_name: String?, card_number: String?, exp_year: String?, cvc: String?, gateway_unique_id: String?, card_brand: String?, exp_month: String ) {
          
          
          let token = /UDSingleton.shared.userData?.userDetails?.accessToken
          let addCardObjectService = BookServiceEndPoint.addCard(card_holder_name: card_holder_name, card_number: card_number, exp_year: exp_year, cvc: cvc, gateway_unique_id: gateway_unique_id, card_brand: card_brand, exp_month: exp_month)
        if #available(iOS 16.0, *) {
            addCardObjectService.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) { (response) in
                switch response {
                    
                case .success(let data):
                    print("Data")
                    self.popVC()
                    
                case .failure(let strError):
                    
                    Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
                }
            }
        } else {
            // Fallback on earlier versions
        }
          
      }
    
    
    
    func formatNumber( number: String) -> String {
       
        var num = number
        num = num.replacingOccurrences(of: "(", with: "")
        num = num.replacingOccurrences(of: ")", with: "")
        num = num.replacingOccurrences(of: " ", with: "")
        num = num.replacingOccurrences(of: "-", with: "")
        num = num.replacingOccurrences(of: "+", with: "")
        
        let length  =  num.length
        if length > 10 {
            let index = length - 10
            let indexStartOfText = num.index(num.startIndex, offsetBy: index)
            num = String(num[indexStartOfText...])
        }
        return num
        
    }
    
    func getLength( number: String) -> Int {
        var num = number
        num = num.replacingOccurrences(of: "(", with: "")
        num = num.replacingOccurrences(of: ")", with: "")
        num = num.replacingOccurrences(of: " ", with: "")
        num = num.replacingOccurrences(of: "-", with: "")
        num = num.replacingOccurrences(of: "+", with: "")
        
        let length = num.length
        return length
    }
    
}


//MARK:- UITEXTFIELD DELEGATE
extension AddCardDetailsVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == txtCardNumber {
           txtCardNumber.becomeFirstResponder()
        } else if textField == txtCardName {
            txtExpireDate.becomeFirstResponder()
        } else if textField == txtExpireDate {
            txtCVV.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }
        
        return true
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
         
          if textField == txtCardNumber {
              if range.location == 19 {
                  return false
              }
              
              if string.length == 0 {
                  return true
              }
              
              if range.location == 4 || range.location == 9 || range.location == 14 {
                  let str  = String(format: "%@ ", textField.text!)
                  textField.text = str
              }
              
              return true
            
          }  else if textField == txtCardNumber {
              let oldLength = textField.text?.length
              let replacementLength = string.length
              let rangeLength = range.length
              let newLength = oldLength! - rangeLength + replacementLength
              let returnKey = string.range(of: "\n") != nil
              return newLength <= 4 || returnKey
            
          } else if textField == txtExpireDate {
              
              let length = getLength(number: textField.text!)
              
              if length == 7 {
                  if range.length == 0 {
                      return false
                  }
              }
              
              if length == 2 {
                  let num =  formatNumber(number: textField.text!)
                  textField.text = String(format: "%@/", num)
                  
                  if range.length > 0 {
                      let indexEndOfText = num.index(num.endIndex, offsetBy: -2)
                      textField.text = String(format: "%@", String(num[..<indexEndOfText]))
                  }
              }
              
              let oldLength = textField.text?.length
              let replacementLength = string.length
              let rangeLength = range.length
              let newLength = oldLength! - rangeLength + replacementLength
              let returnKey = string.range(of: "\n") != nil
              
              return newLength <= 7 || returnKey
            
          } else if textField == txtCVV {
              if range.location == 3 {
                return false
              } else {
                return true
              }
        } else {
              return true
          }
        
      }
}

