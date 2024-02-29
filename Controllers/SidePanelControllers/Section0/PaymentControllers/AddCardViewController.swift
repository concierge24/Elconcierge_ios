//
//  AddCardViewController.swift
//  Invire
//
//  Created by OSX on 20/06/18.
//  Copyright © 2018 Shivang. All rights reserved.
//

import UIKit
import Stripe

//protocol DimOutVC { func dimOut() }


class AddCardViewController: BaseViewController {
    
    @IBOutlet weak var tfCardHolderName: UITextField!
    @IBOutlet var tfCardDetails: STPPaymentCardTextField!
    @IBOutlet weak var lblDetails: UILabel?{
        didSet{
            lblDetails?.textColor = SKAppType.type.color
        }
    }
    @IBOutlet var btnAddCard: UIButton?{
        didSet{
            btnAddCard?.setBackgroundColor(SKAppType.type.color, forState: .normal)
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

extension AddCardViewController {
    
    @IBAction func actionAddCard(_ sender: Any) {
        if /self.tfCardDetails.cardNumber?.isBlank || /self.tfCardHolderName.text?.isBlank || /self.tfCardDetails.cvc?.isBlank {
            SKToast.makeToast("Please fill out all card details.")
            return
        }
        self.hitAPiTestStripe()
    }
    
    @IBAction func actionCancel(_ sender: Any) {
        self.popVC()
    }
}
extension AddCardViewController {
    
    
    func hitAPiTestStripe() {
        
        let cardParams = STPCardParams()
        cardParams.number = tfCardDetails.cardNumber
        cardParams.expMonth = UInt(/String(tfCardDetails.expirationMonth))!
        cardParams.expYear = UInt(/String(tfCardDetails.expirationYear))!
        cardParams.cvc = tfCardDetails.cvc
        
        STPAPIClient.shared().createToken(withCard: cardParams) {(token: STPToken?, error: Error?) in
            
            guard let token = token, error == nil else {
                
                print(/error?.localizedDescription)
                return
            }
            
            debugPrint("stripe token ======= ",token)
            self.apiAddCard(token: "\(token)")
            
        }
    }
    
}

extension AddCardViewController {
    
    func apiAddCard(token : String?) {
        
//        APIManager.sharedInstance.opertationWithRequest(withApi: API.addStripeCards(FormatAPIParameters.addStripeCards(card_token: /token).formatParameters())){ (response) in
//            switch response {
//            case .Success(_):
//                self.popVC()
//
//            case .Failure(_):
//                break
//            }
//        }
    }
}
