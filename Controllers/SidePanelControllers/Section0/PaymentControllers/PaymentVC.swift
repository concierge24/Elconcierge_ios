 //
 //  PaymentVC.swift
 //  Buraq24
 //
 //  Created by MANINDER on 01/09/18.
 //  Copyright © 2018 CodeBrewLabs. All rights reserved.
 //
 
 import UIKit
 import Stripe
 import SquareInAppPaymentsSDK
 import Paystack
 
 class PaymentVC: BaseViewController{
    
    //MARK:- OUTLETS
    @IBOutlet weak var tblView: UITableView!
    
    //MARK::- VARIABLES
    var type: PaymentMethod = .DoesntMatter
    var paymentAmount: Double?
    var tableDataSource : TableViewDataSource?{
        didSet{
            tblView.reloadData()
        }
    }
    
    var arrayItems = [FeatureDataModal]()
    var returnPaymentDetail:((_ token:String , _ paymentFatewayName:String?,  _ card_id:String? ) -> ())?

    var filterGateways:[String] = ["Stripe", "Square", "Conekta", "Paypal", "Venmo", "Zelle", "SADAD", "MyFatoorah", "Paystack"]

    //MARK:- View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        //showing the list of gateways that are enabled from backend only
        //arrayItems = AgentCodeClass.shared.agentFeatureData ?? []
        tblView.tableFooterView = UIView()
        filterEnabledGateways()
        setCardDta()
        tblView.reloadData()
        
    }
    
    //MARK:- FUNCTIONS
    func filterEnabledGateways() {
        let allItems = AgentCodeClass.shared.agentFeatureData ?? []
        for obj in allItems {
            if obj.type_name == "payment_gateway" && obj.is_active == 1 && !(obj.key_value_front ?? []).isEmpty && filterGateways.containsIgnoringCase(/obj.name) {
                if "spicemaster_0134" == APIConstants.defaultAgentCode {
                    if obj.name == "Stripe" {
                        arrayItems.append(obj)
                    }
                }
                else {
                    arrayItems.append(obj)
                }
            }
        }
        if type == .DoesntMatter {
            let cod = FeatureDataModal(attributes: [:])
            cod.name = "Cash On Delivery"
            arrayItems.append(cod)
        }
        
    }
    
    //MARK:- ACTIONS
    
    @IBAction func btnBackAction(_ sender: Any) {
        self.popVC()
    }
    
    
    
 }
 
 //MARK::- TableView
 extension PaymentVC{
    
    func setCardDta(){
//        tableDataSource = TableViewDataSource(items: arrayItems, height: 64 , tableView: tblView, cellIdentifier: CellIdentifiers.CardTVC, configureCellBlock: {  (cell, item) in
//            var name = (item as? FeatureDataModal)?.name
//            if name == "Stripe" {
//                name = "Credit Card"
//            }
//            (cell as? CardTVC)?.textLabel?.text = name
//        }, aRowSelectedListener: { [ weak self] (indexPath) in
//            self?.selectedPaymentMethod(name: /self?.arrayItems[indexPath.row].name , index: indexPath.row)
//        })
//        tblView.delegate = tableDataSource
//        tblView.dataSource = tableDataSource
        tableDataSource = TableViewDataSource(items: arrayItems, height: 64 , tableView: tblView, cellIdentifier: CellIdentifiers.CardTVC, configureCellBlock: {  (cell, item) in
            var name = (item as? FeatureDataModal)?.name
            if name == "Stripe" {
                name = "Credit Card"
            }
            if name == "Braintree" {
                name = "PayPal"
            }
            else if name == "Conekta" {
                name = "Credit Card / Debit Card"
            }
            (cell as? CardTVC)?.textLabel?.text = name?.localized()
        }, aRowSelectedListener: { [ weak self] (indexPath) in
            self?.selectedPaymentMethod(name: /self?.arrayItems[indexPath.row].name , index: indexPath.row)
        })
        tblView.delegate = tableDataSource
        tblView.dataSource = tableDataSource
    }
    
    func selectedPaymentMethod(name: String, index: Int){
        switch name {
        case "SADAD":
            payViaSADAD()
        case "MyFatoorah":
            payViaMyFatoorah()
        case "Square":
            for keys in self.arrayItems[index].key_value_front ?? []{
                if keys.key == "square_publish_key"{
                    SQIPInAppPaymentsSDK.squareApplicationID = keys.value
                    payViaSquare()
                }
            }
            
        case "Conekta":
            for keys in self.arrayItems[index].key_value_front ?? []{
                if keys.key == "conekta_publish_key"{
                    payViaConekta(key: /keys.value)
                }
            }
            
        case "Stripe":
            for keys in self.arrayItems[index].key_value_front ?? []{
                if keys.key == "stripe_publish_key"{
                    Stripe.setDefaultPublishableKey(/keys.value)
                    payViaStripe()
                }
            }
            
        case "Braintree":
            for keys in self.arrayItems[index].key_value_front ?? []{
                if keys.key == "venmo_braintree_public_key"{
                    payViaPayPal()
                }
            }
            
        case "Venmo":
            payViaVenmo()
            
        case "Zelle":
            var email = ""
            var phone = ""
            for keys in self.arrayItems[index].key_value_front ?? []{
                if keys.key == "email"{
                    email = /keys.value
                }
                if keys.key == "phone_number"{
                    phone = /keys.value
                }
            }
            payViaZelle(email: email, phon: phone)
            
        case "paystack":
            for keys in self.arrayItems[index].key_value_front ?? []{
                if keys.key == "paystack_publish_key"{
                    Paystack.setDefaultPublicKey(/keys.value)
                    payViaPaystack()
                    break
                }
            }
            
        case "Cash On Delivery":
            
            returnPaymentDetail?("","Cash On Delivery", "")
        //
        default:
            break
        }
    }
    
    //MARK: - Paystack Payment

    func payViaPaystack() {
        let storyboard = UIStoryboard(name: "Payment", bundle: nil)
        guard let vc =
            storyboard.instantiateViewController(withIdentifier: "PaystackPaymentVC") as? PaystackPaymentVC else { return }
        vc.netAmount = paymentAmount
        vc.email = GDataSingleton.sharedInstance.loggedInUser?.email
        vc.paymentDone = { [weak self] token in
            self?.returnPaymentDetail?(token,"Paystack","")
        }
        self.presentVC(vc)
    }
    
    
    //MARK: - Venmo Payment
    func payViaVenmo() {
        BrainTreeManager.sharedInstance.payViaVenmo( success: { [unowned self] (nonce) in
            self.returnPaymentDetail?(nonce,"Venmo","")
        }) { [weak self] (error) in
            self?.handleError(error)
        }
    }
    
    //MARK: - Paypal Payment
    func payViaPayPal() {
        BrainTreeManager.sharedInstance.payViaPayPal( success: { [unowned self] (nonce) in
            debugPrint(nonce)
            print(nonce.description)
            self.returnPaymentDetail?("","Paypal","")
        }) { [weak self] (error) in
            print(error?.localizedDescription)
            SKToast.makeToast(error?.localizedDescription)
            self?.handleError(error)
        }
    }
    
    //Mark::- Conekta
    func payViaConekta(key: String){
        let storyboard = UIStoryboard(name: "Payment", bundle: nil)
        guard let vc =
            storyboard.instantiateViewController(withIdentifier: "ConektaPaymentVC") as? ConektaPaymentVC else { return }
        vc.key = key
        vc.paymentDone = { [weak self] (token) in
            self?.returnPaymentDetail?(/token,"Conekta","")
        }
        self.presentVC(vc)
        //
    }
    
    //MARK: - STRIPE
    func payViaStripe() {
        let storyboard = UIStoryboard(name: "Payment", bundle: nil)
        guard let vc =
            storyboard.instantiateViewController(withIdentifier: "CardListingVC") as? CardListingVC else { return }
        vc.gatewayUniqueId = "stripe"
        vc.paymentDone = { [weak self] token,card_id  in
            self?.returnPaymentDetail?(/token,"Stripe",card_id)
        }
        self.presentVC(vc)
    }
    
    
    //MARK: - ZELLE
    func payViaZelle(email: String , phon: String) {
        let storyboard = UIStoryboard(name: "Payment", bundle: nil)
        guard let vc =
            storyboard.instantiateViewController(withIdentifier: "ZelleViewController") as? ZelleViewController else { return }
        vc.email = email
        vc.phone = phon
        vc.selectedImage = { [weak self] (imageUrl , image) in
            
            //use the image if you want to show at cart
            self?.returnPaymentDetail?(imageUrl, "Zelle","")
        }
        self.presentVC(vc)
    }
    
    //MARK: - Square
    func payViaSquare() {
        let storyboard = UIStoryboard(name: "Payment", bundle: nil)
        guard let vc =
            storyboard.instantiateViewController(withIdentifier: "CardListingVC") as? CardListingVC else { return }
        
        vc.paymentDone = { [weak self] token,card_id  in
            self?.returnPaymentDetail?(/token,"Square",card_id)
        }
        self.presentVC(vc)
    }

    //MARK: - SADAD
    func payViaSADAD() {
        self.returnPaymentDetail?("","SADAD","")
    }

    func payViaMyFatoorah() {
        self.returnPaymentDetail?("", "MyFatoorah", "")
    }
    //MARK: - Handle Error
    func handleError(_ error: Error?) {
        SKToast.makeToast(/error?.localizedDescription)
    }
    
 }
 
 
 extension Array where Element == String {
     func containsIgnoringCase(_ element: Element) -> Bool {
         contains { $0.caseInsensitiveCompare(element) == .orderedSame }
     }
 }
