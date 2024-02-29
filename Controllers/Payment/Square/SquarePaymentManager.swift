
//
//  SquarePaymentManager.swift
//  Sneni
//
//  Created by Ankit Chhabra on 15/04/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import Foundation
import SquareInAppPaymentsSDK



class SquarePaymentManager: NSObject , SQIPCardEntryViewControllerDelegate{
    
    static let sharedInstance = SquarePaymentManager()
    
    var paymentDone: ((_ token: String?) -> ())?
    var presenter : UIViewController?
    var delegate : CardListProtocol?

    override init() {
        super.init()
        
    }
    
    func makeCardEntryViewController() -> SQIPCardEntryViewController {
        // Customize the card payment form
        let theme = SQIPTheme()
        theme.errorColor = .red
        theme.tintColor = SKAppType.type.color
        theme.keyboardAppearance = .light
        theme.messageColor = UIColor(red: 0.48, green: 0.48, blue: 0.48, alpha: 1)
        theme.saveButtonTitle = "Done".localized()
        
        return SQIPCardEntryViewController(theme: theme)
    }
    
    
    func payViaSquare(presenter: UIViewController) {
        let vc = self.makeCardEntryViewController()
        vc.delegate = self

        let nc = UINavigationController(rootViewController: vc)
        presenter.present(nc, animated: true, completion: nil)
        
    }
    
    func cardEntryViewController(_ cardEntryViewController: SQIPCardEntryViewController, didCompleteWith status: SQIPCardEntryCompletionStatus) {
        // Note: If you pushed the card entry form onto an existing navigation controller,
        // use UINavigationController.popViewController(animated:) instead
        cardEntryViewController.dismissVC {
            self.delegate?.updateList()
        }
        
    }
    
    func cardEntryViewController(_ cardEntryViewController: SQIPCardEntryViewController, didObtain cardDetails: SQIPCardDetails, completionHandler: @escaping (Error?) -> Void) {
        
//        self.paymentDone?(cardDetails.nonce)
        
        let params = (FormatAPIParameters.addCard(user_id: /GDataSingleton.sharedInstance.loggedInUser?.id?.toInt(), card_type: cardDetails.card.brand.description, card_number: cardDetails.card.lastFourDigits, exp_month: "\(cardDetails.card.expirationMonth)", exp_year: "\(cardDetails.card.expirationYear)", card_token: cardDetails.nonce, gateway_unique_id: "squareup", cvc: "222", card_holder_name : /GDataSingleton.sharedInstance.loggedInUser?.firstName).formatParameters())

            let objR = API.addCard(params)
        APIManager.sharedInstance.opertationWithRequest(isLoader: true, withApi: objR) {
                [weak self] (response) in
                
                switch response {
                case .Success(let object):
                    let value = object as? AddCard
                    print (value?.customer_payment_id)
                    GDataSingleton.sharedInstance.customerPaymentId = /value?.customer_payment_id
                     completionHandler(nil)
                default:
                    completionHandler(nil)
                }
            
        }
        

    }
}
