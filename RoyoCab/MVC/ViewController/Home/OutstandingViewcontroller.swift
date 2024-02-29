//
//  OutstandingViewcontroller.swift
//  Trava
//
//  Created by Apple on 19/12/19.
//  Copyright © 2019 CodeBrewLabs. All rights reserved.
//

import UIKit


class OutstandingViewcontroller: UIViewController {

    //MARK:- Outlet
    @IBOutlet weak var labelOutstandingPrice: UILabel!
    @IBOutlet weak var labelDate: UILabel!
        
    //MARK:- Properties
    var delegate: BookRequestDelegate?
    var request: ServiceRequest?
    var currentOrder: OrderCab?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialsetup()
    }
}


extension OutstandingViewcontroller {
    
    func initialsetup() {
        setupData()
    }
    
    func setupData() {
        
        labelOutstandingPrice.text = "Pay".localizedString + (/UDSingleton.shared.appSettings?.appSettings?.currency) + " " + String(/currentOrder?.cancellation_charges) + "Outstanding from previous trip".localizedString
        labelDate.text = currentOrder?.updated_at?.getLocalDate()?.toLocalDateInString(format: "MMM dd, YYYY")
    }
}

extension OutstandingViewcontroller {

    @IBAction func buttonClicked(_ sender: UIButton) {
        
        switch /sender.tag {
            case 1:
                dismissVC(completion: nil)
            
            case 2:
                debugPrint("Cash")
                
                guard var serviceRequest = request  else {return}
                serviceRequest.cancellation_charges = currentOrder?.cancellation_charges
                serviceRequest.finalPrice = String(/serviceRequest.finalPrice?.toFloat() + /serviceRequest.cancellation_charges)
                delegate?.didPayOutstanding(request: serviceRequest)
            
                dismissVC(completion: nil)
            
            case 3:
                debugPrint("Credit card")
            
                guard let vc = R.storyboard.sideMenu.cardListViewController() else {return}
                vc.cardListDelegate = self
                vc.isFromOutStanding = true
                ez.topMostVC?.pushVC(vc)
            
        default:
            break
        }
    }
}


//MARK:- APi
extension OutstandingViewcontroller {
    
    func apiPayPendingAmount(cardID: Int?) {
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        let bject = BookServiceEndPoint.payPendingAmount(user_card_id: cardID, amount: String(/currentOrder?.cancellation_charges))
        if #available(iOS 16.0, *) {
            bject.request(isLoaderNeeded: true, header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token]) { [weak self] (response) in
                switch response {
                    
                case .success(_):
                    
                    guard var serviceRequest = self?.request else {return}
                    serviceRequest.cancellation_charges = nil
                    self?.delegate?.didPayOutstanding(request: serviceRequest)
                    
                    self?.dismissVC(completion: nil)
                    
                case .failure(let strError):
                    
                    Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
                }
            }
        } else {
            // Fallback on earlier versions
        }
    }
    
}


//MARK:-
extension OutstandingViewcontroller : CardListViewControllerDelegate {
    
    func cardSelected(card: CardCab?) {
        apiPayPendingAmount(cardID: card?.userCardId)
    }
    
}
