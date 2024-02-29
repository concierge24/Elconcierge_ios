//
//  CardListingVC.swift
//  Sneni
//
//  Created by admin on 06/04/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit

protocol CardListProtocol  {
    func updateList()
}

class CardListingVC: BaseViewController , CardListProtocol{
    
    //MARK::- OUTLETS
    @IBOutlet var btnAddCard: UIButton?{
        didSet{
            btnAddCard?.setBackgroundColor(SKAppType.type.color, forState: .normal)
        }
    }
    @IBOutlet weak var tblView: UITableView!
    
    //MARK::- PROPERTIES
    var tableDataSource : TableViewDataSource?{
        didSet{
            
            tblView.reloadData()
        }
    }
    var arrayCard: [CardListingData]?
    var paymentDone: ((_ token: String?, _ card_id:String?) -> ())?
    var gatewayUniqueId: String?
    
    //MARK::- VIEWCYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hitGetCardApi()
    }
    
    //MARK::- ACTION
    
    @IBAction func btnAddCard(_ sender: Any) {
        if gatewayUniqueId == "stripe" {
            let storyboard = UIStoryboard(name: "Payment", bundle: nil)
            guard let vc =
                storyboard.instantiateViewController(withIdentifier: "StripePaymentViewController") as? StripePaymentViewController else { return }
            
            vc.paymentDone = {
                self.hitGetCardApi()
            }
            self.presentVC(vc)
            return
        }
        SquarePaymentManager.sharedInstance.payViaSquare(presenter: self)
        SquarePaymentManager.sharedInstance.delegate = self
    }
    
    //MARK: - Delegate function
    func updateList() {
        hitGetCardApi()
    }
    
    //MARK::- FUNCTIONS
    func setCardDta(){
        tableDataSource = TableViewDataSource(items: arrayCard, height: 160 , tableView: tblView, cellIdentifier: CardUICell.identifier, configureCellBlock: {  (cell, item) in
            if let item = item as? CardListingData, let cell = cell as? CardUICell{
                cell.gateway_unique_id = self.gatewayUniqueId
                if (/item.name).isEmpty {
                    cell.lblCardHolderName?.text = /item.brand
                    cell.lblCardHolderText?.text = "Card Type".localized()
                }else {
                    cell.lblCardHolderText?.text = "Card Holder".localized()
                    cell.lblCardHolderName?.text = /item.name
                }
                cell.lblCardNumber?.text = "XXXXXXXXXXXX" + /item.last4
                cell.lblExpDate?.text = "\(/item.expMonth)/\(/item.expYear)"
                cell.cardId = /item.id
                cell.deleteCard = {
                    self.hitGetCardApi()
                }
            }
        }, aRowSelectedListener: { [ weak self] (indexPath) in
            self?.paymentDone?("" , /self?.arrayCard?[indexPath.row].id)
            self?.dismiss(animated: true, completion: nil)
//            self?.selectedPaymentMethod(name: /self?.arrayItems[indexPath.row].name , index: indexPath.row)
        })
        tblView.delegate = tableDataSource
        tblView.dataSource = tableDataSource
    }
    
    func hitGetCardApi(){

        let objR = API.getCards(customer_payment_id: GDataSingleton.sharedInstance.customerPaymentId, gateway_unique_id: gatewayUniqueId ?? "squareup")
        APIManager.sharedInstance.opertationWithRequest( withApi: objR) {
                [weak self] (response) in
                
                switch response {
                case .Success(let object):
                    let cardlisting = object as? CardListing
                    self?.arrayCard = cardlisting?.cardListing
                    if /self?.arrayCard?.count > 0{
                    self?.setCardDta()
                        self?.tblView.isHidden = false
                    }else{
                        self?.tblView.isHidden = true
                    }
                default:
                    break
                }
            
        }
    }
    
}
