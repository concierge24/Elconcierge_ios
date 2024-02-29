//
//  CardListViewController.swift
//  Trava
//
//  Created by Apple on 15/01/20.
//  Copyright © 2020 CodeBrewLabs. All rights reserved.
//

import UIKit
import Razorpay


typealias RazorPaySuccess = (_ paymentId:String)->()

protocol CardListViewControllerDelegate: class {
    func cardSelected(card: CardCab?)
}



class CardListViewController: UIViewController {

     //MARK:- Outlet
    @IBOutlet weak var tableView: UITableView!
    
    //MARK:- Properties
    var razorPaySuccess: RazorPaySuccess?
    var tableDataSource : TableViewDataSourceCab?
    var isFromSideMenu: Bool = false
    var isFromOutStanding: Bool = false
    var isWallet = false
    var addCardURL: String?
    var arrayCards: [CardCab]?
    var delegate: BookRequestDelegate?
    var cardListDelegate: CardListViewControllerDelegate?
    let template = AppTemplate(rawValue: Int(/UDSingleton.shared.appSettings?.appSettings?.app_template) ?? 0)
    let paymentGateway = PaymentGateway(rawValue:(/UDSingleton.shared.appSettings?.appSettings?.gateway_unique_id))
    
    
    typealias Razorpay = RazorpayCheckout
    var razorpay: Razorpay?
    var razorpayTestKey = /UDSingleton.shared.appSettings?.appSettings?.razorpaytestkey
    var razorPayment = false
    var order_id = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    
    func getCards(){
        
        switch paymentGateway {
        case .stripe,.epayco,.conekta:
            self.getStripCards()
            
        case .peach:
            self.apiGetAddCardURL()
            
        default:
            //getCards()
            print("Defualt")
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getCards()
        
        if razorPayment {
            razorPayment = false
            showPaymentForm()
        }
        
    }
    
    
    
    func intailiseRazorpay(){
        razorpay = Razorpay.initWithKey(razorpayTestKey, andDelegate: self)
    }
    
    internal func showPaymentForm() {
        intailiseRazorpay()
        let options: [String:Any] = [
            "amount": "100", //This is in currency subunits. 100 = 100 paise= INR 1.
            "currency": "INR",//We support more that 92 international currencies.
            "description": "Product Cost",
            "image": "https://url-to-image.png",
            "name": "business or product name",
            "prefill": [
                "contact": "9797979797",
                "email": "foo@bar.com"
            ],
            "theme": [
                "color": /UDSingleton.shared.appSettings?.appSettings?.app_color_code
            ]
        ]
        razorpay?.open(options)
    }

}

extension CardListViewController {
    
    func initialSetup() {
        configureTableView()
    }
    
    func configureTableView() {
        
        let  configureCellBlock : ListCellConfigureBlockCab = { ( cell , item , indexpath) in
            if let cell = cell as? CardTableViewCell {
                
                cell.row = indexpath.row
                cell.delegate = self
                cell.obj = item as? CardCab
            }
        }
        
        let didSelectCellBlock : DidSelectedRowCab = { [weak self] (indexPath , cell, item) in
            
            if !(/self?.isFromSideMenu) {
                
                if /self?.isFromOutStanding || /self?.isWallet{
                    self?.cardListDelegate?.cardSelected(card: self?.arrayCards?[/indexPath.row])
                } else {
                    self?.delegate?.didPaymentModeChanged(paymentMode: .Card, selectedCard: self?.arrayCards?[/indexPath.row])
                }
                self?.popVC()
            }
        }
        
        tableDataSource = TableViewDataSourceCab(items: arrayCards, tableView: tableView, cellIdentifier: R.reuseIdentifier.cardTableViewCell.identifier, cellHeight: 135)
        tableDataSource?.configureCellBlock = configureCellBlock
        tableDataSource?.aRowSelectedListener = didSelectCellBlock
        tableView?.delegate = tableDataSource
        tableView?.dataSource = tableDataSource
        tableView?.reloadData()
    }
    
}

//MARK:- Button Selector
extension CardListViewController {

    @IBAction func buttonBackClicked(_ sender: Any) {
        popVC()
    }
    
    @IBAction func buttonAddCardClicked(_ sender: Any) {
        
            
        switch paymentGateway {
            
        case .stripe:
            guard let vc = R.storyboard.sideMenu.addCardViewController() else {return}
            vc.cardAdded = {[weak self](card) in
                self?.addCards(card: card)
            }
            pushVC(vc)
            
        case .peach:
            guard let vc = R.storyboard.sideMenu.addCardDetailsVC() else { return }
            pushVC(vc)
            break
        case .conekta:
            guard let vc = R.storyboard.sideMenu.addCardDetailsVC() else { return }
            vc.cardAdded = {[weak self](card) in
                self?.addCards(card: card)
            }
            pushVC(vc)
            
        case .epayco:
            guard let vc = R.storyboard.sideMenu.addCardViewController() else {return}
            vc.cardAdded = {[weak self](card) in
                self?.addEpacoCard(card: card)
            }
            pushVC(vc)
        
        case .razorpay:
           showPaymentForm()
            
        default:
            guard let vc = R.storyboard.sideMenu.addCardViewController() else {return}
            vc.url = addCardURL
            pushVC(vc)
            break
        }
           
        
        
    }
    
    
    func addCards(card:CreditCard){
        
        switch paymentGateway {
        case .stripe:
            addStripeCard(token: /card.token)
        case .epayco:
            addEpacoCard(card: card)
        case .conekta:
            addConektaCard(token:  /card.token)
        default:
            break
        }
        
    }
    
}

//MARK:- API
extension CardListViewController {
    
    func addConektaCard(token:String){
        
        addStripeCard(token:token)
    }
    
    func addStripeCard(token:String) {
        
       let accessToken = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        let addCardObject = BookServiceEndPoint.addStripCard(tokenId: token, gatewayId: /UDSingleton.shared.appSettings?.appSettings?.gateway_unique_id)
        addCardObject.request(isLoaderNeeded: true, header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  accessToken]) { [weak self] (response) in
            switch response {
                
            case .success(let data):
                
                self?.getCards()
                
            case .failure(let strError):
                
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    

        func addEpacoCard(card:CreditCard?) {
            
           let accessToken = /UDSingleton.shared.userData?.userDetails?.accessToken
            
            let addCardObject = BookServiceEndPoint.addEpaycoCard(card: /card?.cardNumber, year: "20\(card?.expYear ?? 00)", month: "\(card?.expMonth ?? 0)", cvv: /card?.cvv, gatewayId: /UDSingleton.shared.appSettings?.appSettings?.gateway_unique_id)
            addCardObject.request(isLoaderNeeded: true, header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  accessToken]) { [weak self] (response) in
                switch response {
                    
                case .success(let data):
                    
                    self?.getCards()
                    
    //                guard let modal = data as? UserDetail else {return}
    //                self?.addCardURL = modal.url
    //
    //                self?.arrayCards = modal.cards
    //                self?.tableDataSource?.items = self?.arrayCards
    //                self?.tableView.reloadData()
                    
                case .failure(let strError):
                    
                    Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
                }
            }
        }
    
    func getStripCards(){
        
       let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        let getCreditPointsObject = BookServiceEndPoint.getStripeCard
        getCreditPointsObject.request(isLoaderNeeded: true, header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token]) { [weak self] (response) in
            switch response {
                
            case .success(let data):
                
                guard let modal = data as? CardResponse else {return}
               // self?.addCardURL = modal.url
                
                self?.arrayCards = modal.result
                self?.tableDataSource?.items = self?.arrayCards
                self?.tableView.reloadData()
                
            case .failure(let strError):
                
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
    func apiGetAddCardURL() {
        
       let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        
        let getCreditPointsObject = BookServiceEndPoint.getCard
        getCreditPointsObject.request(isLoaderNeeded: true, header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token]) { [weak self] (response) in
            switch response {
                
            case .success(let data):
                
                guard let modal = data as? CardResponse else {return}
                //self?.addCardURL = modal.url
                self?.arrayCards = modal.result
                self?.tableDataSource?.items = self?.arrayCards
                self?.tableView.reloadData()
                
            case .failure(let strError):
                
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
    func apiRemoveCard(index: Int) {
        
        let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        let cardId = arrayCards?[/index].userCardId
        
        let reject = BookServiceEndPoint.removeCard(user_card_id: cardId,paymentId:/UDSingleton.shared.appSettings?.appSettings?.gateway_unique_id)
       // let reject = BookServiceEndPoint.removeCard(user_card_id: cardId,paymentId:"epayco")
        reject.request(isLoaderNeeded: true, header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token]) { [weak self] (response) in
            switch response {
                
            case .success(let data):
                
                self?.arrayCards?.remove(at: index)
                self?.tableDataSource?.items = self?.arrayCards
                self?.tableView.reloadData()
                
            case .failure(let strError):
                
                Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
            }
        }
    }
    
    
}


//MARK:- CardTableViewCellDelegate

extension CardListViewController : CardTableViewCellDelegate {
    
    func buttonDeleteClicked(index: Int?) {
        
        alertBoxOption(message: "remove_card_Confirmation".localizedString, title: "AppName".localizedString, leftAction: "no".localizedString, rightAction: "yes".localizedString, ok: {[weak self] in
            
            self?.apiRemoveCard(index: /index)
            
        }, cancel: {})
        
    }
}


extension CardListViewController: RazorpayPaymentCompletionProtocol{
    
    
    func onPaymentError(_ code: Int32, description str: String) {
        let alertController = UIAlertController(title: "FAILURE", message: str, preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
      //  self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
    }
    
    func onPaymentSuccess(_ payment_id: String) {
        let alertController = UIAlertController(title: "SUCCESS", message: "Payment Id \(payment_id)", preferredStyle: UIAlertController.Style.alert)
        let cancelAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
        alertController.addAction(cancelAction)
      // self.view.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        razorPaySuccess?(payment_id)
        //razorPayment(order_id: order_id, payment_id: payment_id)
        
    }
    
    
    func razorPayment(order_id: String, payment_id: String) {
         let token = /UDSingleton.shared.userData?.userDetails?.accessToken
        let walletBalance = BookServiceEndPoint.razorPayReturnUrl(order_id: order_id, payment_id: payment_id)
        walletBalance.request(header: ["language_id" : LanguageFile.shared.getLanguage() , "access_token" :  token, "secretdbkey": APIBasePath.secretDBKey]) { (response) in
            
            switch response {
                                    
                case .success(let data):
                    self.popVC()
                    break
                    
                case .failure(let strError):
                    Alerts.shared.show(alert: "AppName".localizedString, message: /strError , type: .error )
                }
        }
    }
    
}
