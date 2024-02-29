//
//  CartViewController.swift
//  Clikat
//
//  Created by cbl73 on 4/21/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class CartViewController: BaseViewController {
    @IBOutlet var btnDonate: ThemeButton!
    
    //MARK:- IBOutlet
    
    @IBOutlet weak var imgLocation: UIImageView!
    @IBOutlet weak var btnEditAddress: UIButton!
    @IBOutlet var dummyText_labels: [ThemeLabel]! {
        didSet {
            dummyText_labels.forEach { (label) in
                label.textColor = cartAppType.color
                if AppSettings.shared.appThemeData?.is_health_theme == "1" {
                    if label.text == "(YOU WON'T REGRET IT)".localized() {
                        label.isHidden = true
                    }
                }
                
            }
        }
    }
    @IBOutlet weak var imageTick: UIImageView! {
        didSet{
            imageTick.tintColor = cartAppType.color
        }
    }
    
    @IBOutlet weak var heading_label: UILabel!
    @IBOutlet weak var address_view: UIView!{
        didSet {
            address_view.backgroundColor = cartAppType.alphaColor
        }
    }
    @IBOutlet weak var change_button: UIButton! {
        didSet {
            if AppSettings.shared.appThemeData?.is_health_theme == "1" {
                
            }
        }
    }
    @IBOutlet weak var bottom_view: UIView!
    @IBOutlet weak var paymentType_button: UIButton!
    @IBOutlet weak var paymentType_label: UILabel! {
        didSet{
            if let term = TerminologyKeys.choosePayment.localizedValue() as? String{
                paymentType_label.text = term
            }
        }
    }
    @IBOutlet weak var address_label: UILabel!
    @IBOutlet weak var title_label: ThemeLabel!
    @IBOutlet weak var menu_button: ThemeButton!{
        didSet {//Nitin
            menu_button.isHidden = /*cartAppType == .gym ||*/ cartAppType == .food || cartAppType == .home || cartAppType == .carRental || cartAppType == .eCom ? true : false
        }
    }
    
    @IBOutlet var imgPlaceholderNotext: UIView!
    @IBOutlet var navigation_view: NavigationView! {
        didSet{
        }
    }
    @IBOutlet var lblStaticText: [UILabel]! {
        didSet{
            for lbl in lblStaticText {
                lbl.kern(kerningValue: ButtonKernValue)
            }
        }
    }
    @IBOutlet var viewPaymentType: SKThemeView!
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.registerCells(nibNames: [ProductListingCell.identifier, CartListingCell.identifier,ProductListCell.identifier, CartQuestionCell.identifier])
//tableView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
            if #available(iOS 13.0, *) {
                tableView.automaticallyAdjustsScrollIndicatorInsets = false
            }
        }
    }
    @IBOutlet var btnProceedCheckout: UIButton! {
        didSet{
            if cartAppType == .home {
                btnProceedCheckout.setTitle("Place Booking".localized(), for: .normal)
            }
            btnProceedCheckout.setBackgroundColor(cartAppType.color, forState: .normal)
            if AppSettings.shared.appThemeData?.is_health_theme == "1" {
                if let term = TerminologyKeys.orderNow.localizedValue() as? String{
                    btnProceedCheckout.setTitle(term, for: .normal)
                }
            }
        }
    }
    
    //MARK:- Variables
    var FROMSIDEPANEL : Bool = false
    var tableDataSource = CartDataSource(){
        didSet{
            tableView.delegate = tableDataSource
            tableView.dataSource = tableDataSource
        }
    }
    var deliveryData = Delivery()
    var promoCode:PromoCode?
    var cartProdcuts : [AnyObject]?
    var cartArray : [Cart]?
    var remarks : String?
    var selectedAddress: Address?
    var orderSummary:OrderSummary?
    var selectedDeliverySpeed : DeliverySpeedType = .Standard
    var parameters = Dictionary<String,Any>()
    var selectedPaymentMethod: PaymentMode? {
        didSet {
            self.paymentType_label.text = selectedPaymentMethod?.displayName.localized() ?? "Choose Payment".localized()
        }
    }
    var isOptionSelected = false
    var pickupType = [Int]()
    var deliveryType:Int = 0 // 0- delivery, 1- pickup
    var fromCartView = false
    var refreshPriceData = false
    var referralApplied = false
    var tipItems : [Int]?
    var region_delivery_charge: Double?
    var arrPrescription: [String]?
    var txtPrescription: String?
    var selectedAgentId: CblUser?
    var userServiceCharge: Double?
    var showPaymentMode = true
    var locationBasedGateways: [String]?
    var cartAppType: SKAppType {
        return SKAppType(rawValue: GDataSingleton.sharedInstance.cartAppType ?? 1) ?? .food
    }
    var donateToSomeone = false
    var deliveryTypeSelected: Int? {
        var type = UserDefaults.standard.value(forKey: SingletonKeys.deliveryType.rawValue) as? Int
        if cartAppType == .food && type == nil {
            //for doctor app set delivery
            type = 0
        }
        return type
    }
    //MARK:- viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        setDefaultPaymentType()
    }
    
    
    
    //MARK:- viewDidAppear
    override func viewDidAppear(_ animated: Bool) {
        retrieveReferalAmount()
        refreshPriceData = true
        if let _ = cartProdcuts {
            getCartFromDB()
            //configureTableDataSource(products: cartProdcuts)
        }else {
            getCartFromDB()
        }
        AdjustEvent.Cart.sendEvent()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CartViewController.handleCartQuantity(sender:)), name: NSNotification.Name(rawValue: CartNotification), object: nil)
        
        btnProceedCheckout.setBackgroundColor(cartAppType.color, forState: .normal)
        
        self.locationFetched(address: nil)
        btnBack.isHidden = self.navigationController?.viewControllers.last is MainTabBarViewController
        
        if cartAppType == .home {
            self.heading_label.text = "SERVICE AT".localized()
        }
        else {
             let type = deliveryTypeSelected
            self.change_button.isHidden = type == 1 || deliveryType == 1
            self.heading_label.text = (type == 1 || deliveryType == 1) ? "PICKUP FROM".localized() : "DELIVERY AT".localized()
        }
        
        if AppSettings.shared.appThemeData?.show_donate_popup == "1" && deliveryType != 1 {
            btnDonate.isHidden = false
        }
        else {
            btnDonate.isHidden = true
        }
        updateAddressUI()

        
    }
    
    func updateAddressUI() {
        if AppSettings.shared.appThemeData?.is_health_theme == "1" {
            let type = deliveryTypeSelected

            change_button.isHidden = true
            if cartAppType == .home {
                btnEditAddress.isHidden = false
            }else {
                btnEditAddress.isHidden = (type == 1 || deliveryType == 1)
            }
            imgLocation.isHidden = false
            address_view.backgroundColor = .white
        }

    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
           return .default
       }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //  NotificationCenter.default.removeObserver(self)
    }
    
    //    func showAlert() {
    //        let alert = UIAlertController(title: "Choose payment method.", message: "Please choose from these options", preferredStyle: .actionSheet)
    //
    //        alert.addAction(UIAlertAction(title: "Online", style: .default , handler:{ (UIAlertAction)in
    //            // self.paymentType_label.text = "Online"
    //        }))
    //
    //        alert.addAction(UIAlertAction(title: "Cash", style: .default , handler:{ (UIAlertAction)in
    //            self.paymentType_label.text = "COD"
    //        }))
    //
    //        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
    //            print("User click Dismiss button")
    //        }))
    //
    //        self.present(alert, animated: true, completion: {
    //            print("completion block")
    //        })
    //    }

}

//MARK: - Button Actions
extension CartViewController{
    
    @IBAction func paymentType_buttonAction(_ sender: Any) {
     if !GDataSingleton.sharedInstance.isLoggedIn {
         presentVC(StoryboardScene.Register.instantiateLoginViewController())
         return
     }else{
        // self.showAlert()
        //
        //leads to list of payment gateway
        guard let billCell = tableView.visibleCells.first(where: { $0 is CartBillCell }) as? CartBillCell else { return }
        let storyboard = UIStoryboard(name: "Options", bundle: nil)
        guard let vc =
            storyboard.instantiateViewController(withIdentifier: "PaymentVC") as? PaymentVC else { return }
        vc.paymentAmount = billCell.netTotal
        if let gateways = locationBasedGateways, !gateways.isEmpty {
            vc.filterGateways = gateways
            if gateways.containsIgnoringCase("cod") {
                vc.type = .DoesntMatter
            }
            else {
                vc.type = .Card
            }
        }
        else {
            guard let type = getAllowedPaymentType() else { return }
            vc.type = type
        }
        //this closure ll give you token and name of payment gateway
        vc.returnPaymentDetail = { token , paymentgatewayName ,card_id  in
            vc.popVC()
            switch paymentgatewayName {
                
            case "MyFatoorah":
                print(token)
                self.selectedPaymentMethod = PaymentMode(paymentType: .Card, gatewayUniqueId: "myfatoorah", token: "")
                
            case "SADAD":
                print(token)
                self.selectedPaymentMethod = PaymentMode(paymentType: .Card, gatewayUniqueId: "sadded", token: "")
                
            case "Square":
                print(token)
                self.selectedPaymentMethod = PaymentMode(paymentType: .Card, gatewayUniqueId: "squareup", token: token, card_id: card_id)
                
            case "Conekta":
                print(token)
                self.selectedPaymentMethod = PaymentMode(paymentType: .Card, gatewayUniqueId: "conekta", token: token)
                
            case "Stripe":
                print(token)
                self.selectedPaymentMethod = PaymentMode(paymentType: .Card, gatewayUniqueId: "stripe", token: token, card_id: card_id)
            //razorpay //conekta
            case "Paypal":
                print(token)
                self.selectedPaymentMethod = PaymentMode(paymentType: .Card, gatewayUniqueId: "paypal", token: token)
            case "Venmo":
                print(token)
                self.selectedPaymentMethod = PaymentMode(paymentType: .Card, gatewayUniqueId: "venmo", token: token)
                
            case "Zelle":
                print(token)
                self.selectedPaymentMethod = PaymentMode(paymentType: .Card, gatewayUniqueId: "zelle", token: token)
                
            case "Paystack":
                print(token)
                self.selectedPaymentMethod = PaymentMode(paymentType: .Card, gatewayUniqueId: "paystack", token: token)
                
            case "Cash On Delivery":
                self.selectedPaymentMethod = PaymentMode(paymentType: .COD)
                
                
            default:
                break
            }
            //Hide(for COD)/show tip
            self.tableView.reloadData()
        }
        self.pushVC(vc)
     }
        
    }
    
    
    
    @IBAction func apply_buttonAction(_ sender: Any) {
        
    }
    
    @IBAction func change_buttonAction(_ sender: Any) {
        if !GDataSingleton.sharedInstance.isLoggedIn {
            presentVC(StoryboardScene.Register.instantiateLoginViewController())
            return
        }
        self.openAdressController()
    }
    
    @IBAction func actionMenu(sender: AnyObject) {
        toggleSideMenuView()
    }
    
    @IBAction func actionBack(sender: AnyObject) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: CartNotification), object: self, userInfo: nil)
        //        DeliveryType.shared = DeliveryType(rawValue: 0) ?? .delivery
        popVC()
    }
    
    //MARK: - Action Checkout
    
    @IBAction func actionProceedCheckout(sender: AnyObject) {
        donateToSomeone = false
        checkoutAction()
    }
    
    @IBAction func donateToSomeone(_ sender: Any) {
        donateToSomeone = true
        checkoutAction()
    }
    
    func checkoutAction()  {
        if !GDataSingleton.sharedInstance.isLoggedIn {
            presentVC(StoryboardScene.Register.instantiateLoginViewController())
            return
        }
        
        if address_label.text == "Address Location".localized() {
            self.openAdressController()
            //SKToast.makeToast("Please select delivery address")
            return
        }
        
        if tableDataSource.items?.isEmpty ?? true {
            UtilityFunctions.showAlert(message: L10n.YourCartHasNoItemsPleaseAddItemsToCartToProceed.string)
            return
        }
        
        if /Cart.subTotal < (deliveryData.minOrder ?? 0) {
            SKToast.makeToast("\("Sub total must be greater than".localized()) \((deliveryData.minOrder ?? 0).addCurrencyLocale)")
            return
        }
        
        guard let billCell = tableView.visibleCells.first(where: { $0 is CartBillCell }) as? CartBillCell else { return }
        let arrImages = billCell.arrPrescription.filter({$0.imageUrl != nil}).map({/$0.imageUrl})
        if AppSettings.shared.cartImageUpload, arrImages.isEmpty {
            SKToast.makeToast("Please upload prescription images".localized())
            return
        }
        arrPrescription = arrImages
        txtPrescription = billCell.txtPrescription.text.trimmed()
        if APIConstants.defaultAgentCode == "cannadash_0180" && (/txtPrescription).isEmpty {
            SKToast.makeToast("Please enter your medical id".localized())
            return
        }
        
        guard let itemArray = tableDataSource.items as? [Cart] else { return }
        
        if itemArray.isEmpty {
            UtilityFunctions.showAlert(message: L10n.YourCartHasNoItemsPleaseAddItemsToCartToProceed.string)
            return
        }
        
        if showPaymentMode == false {
            selectedPaymentMethod = PaymentMode(paymentType: .AfterConfirmation)
        }
        else {
            if selectedPaymentMethod == nil {
                SKToast.makeToast("Please select payment method".localized())
                return
            }
            
            if selectedPaymentMethod?.paymentType == .Card && selectedPaymentMethod?.token == nil {
                return
            }
        }

        
        if cartAppType.isHome {
            let containAgents = itemArray.first(where: { $0.agentList == "1" }) != nil
            let containNotAgents = itemArray.first(where: { $0.agentList == "0" }) != nil
            
            if (containAgents && containNotAgents) {
                UtilityFunctions.showAlert(message: L10n.Agentsnotavailableforsomeitems.string)
                return
            }
            
            if containAgents && self.selectedAgentId == nil {
                SKToast.makeToast("Please choose timeslot".localized())
                return
            }
            
            if self.pickupType.contains([2,0]) || self.pickupType.contains([2,1]){
                //                if self.isOptionSelected {
                //                    self.webServiceAddToCart()
                //                } else {
                //                    self.createDeliveryAlert()
                //                }
                self.webServiceAddToCart()
            } else {
                self.webServiceAddToCart()
            }
        } else {
            self.webServiceAddToCart()
            //            if self.isOptionSelected {
            //                self.webServiceAddToCart()
            //            } else {
            //                self.createDeliveryAlert()
            //            }
        }
        
    }
    func createDeliveryAlert() {
        
        let alert = UIAlertController(title: "Wait!".localized(), message: "This Restaurant provides both Pickup and Delivery, what you want to do?".localized(), preferredStyle: UIAlertController.Style.alert)
        
        // add the actions (buttons)
        alert.addAction(UIAlertAction(title: "Pickup", style: .default, handler: { (button) in
            DeliveryType.shared = DeliveryType(rawValue: 1) ?? .pickup
            self.viewWillAppear(true)
            self.viewDidAppear(true)
            self.isOptionSelected = true
        }))
        alert.addAction(UIAlertAction(title: "Delivery", style: .default, handler: {(button) in
            self.webServiceAddToCart()
            DeliveryType.shared = DeliveryType(rawValue: 0) ?? .delivery
            
            self.viewWillAppear(true)
            self.viewDidAppear(true)
            self.isOptionSelected = true
        }))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
        
    }
    
}

//MARK: - Add all products to cart webservice 
extension CartViewController {
    
    func webServiceAddToCart() {
        
        func continueAPI() {
            
            guard let products = tableDataSource.items as? [Cart] else { return }
            
            APIManager.sharedInstance.showLoader()
            let params = FormatAPIParameters.AddToCart(
                cart: products,
                supplierBranchId: products[0].supplierBranchId,
                promotionType: nil,
                remarks: remarks).formatParameters()
            
            APIManager.sharedInstance.opertationWithRequest(withApi: API.AddToCart(params)) {
                [weak self] (response) in
                guard let self = self else { return }
                
                switch response {
                case .Success(let object):
                    
                    self.handleWebService(tempCartId: object)
                case .Failure(let error):
                    self.locationFetched(address: nil)
                    APIManager.sharedInstance.hideLoader()
                    
                    // self.getAllAdresses(orderSummary: nil)
                    print(error.message ?? "")
                    break
                }
            }
        }
        
        if donateToSomeone {
            let donateVC = DonatePopupVC(nibName: "DonatePopupVC", bundle: nil)
            donateVC.modalPresentationStyle = .overFullScreen
            donateVC.modalTransitionStyle = .crossDissolve
            donateVC.completion = { [weak self] donate in
                self?.donateToSomeone = donate
                donateVC.dismissVC(completion: nil)
                if AppSettings.shared.appThemeData?.signup_declaration == "1" {
                    let vc = SignupDeclarationVC.getVC(.register)
                    vc.onAgreeBlock = {
                        continueAPI()
                    }
                    self?.presentVC(vc)
                }else {
                    continueAPI()
                }
            }
            presentVC(donateVC)
        }
        else {
            if AppSettings.shared.appThemeData?.signup_declaration == "1" {
                let vc = SignupDeclarationVC.getVC(.register)
                vc.onAgreeBlock = {
                    continueAPI()
                }
                self.presentVC(vc)
            }else {
                continueAPI()
            }
        }

    }
    
    func handleWebService(tempCartId : Any?) {
        if !GDataSingleton.sharedInstance.isLoggedIn {
            let loginVc = StoryboardScene.Register.instantiateLoginViewController()
            presentVC(loginVc)
            APIManager.sharedInstance.hideLoader()
            
            return
        }
        
        if cartAppType.isFood {
            
            guard let cartId = (tempCartId as? String)?.components(separatedBy: "$").first else { return }
            
            let ordersummary = OrderSummary(items: self.tableDataSource.items as? [Cart], promo:self.promoCode, deliveryBasePrice: deliveryData.base_delivery_charges, regionDeliveryCharge: region_delivery_charge, referralApplied: self.referralApplied)
            ordersummary.cartId = cartId
            ordersummary.minOrderAmount = (tempCartId as? String)?.components(separatedBy: "$").last
            ordersummary.isAgent = false
            ordersummary.useReferral = referralApplied
            self.orderSummary = ordersummary
            
            self.getAllAdresses(orderSummary: ordersummary)
            return
            
        }
        
        DBManager.sharedManager.getCart {
            [weak self] (array) in
            guard let self = self, let arrayCart = array as? [Cart], !arrayCart.isEmpty  else { return }
            
            var isAgent = arrayCart.first(where: { $0.agentList == "1" }) != nil
//            let isNotAgent = arrayCart.first(where: { $0.agentList == "0" }) != nil
            
            let isProducts = arrayCart.first(where: { $0.isProduct == .product }) != nil
            let isServices = arrayCart.first(where: { $0.isProduct == .service }) != nil
            
            let isHourly = false
            
            // let isHourly = arrayCart.first(where: { $0.priceType == PriceType.Hourly }) != nil
            let isFixed = arrayCart.first(where: { $0.priceType == PriceType.Fixed }) != nil
            
            if self.cartAppType == .home {
                isAgent = true
//                if isAgent && isNotAgent {
//
//                    UtilityFunctions.showAlert(title: nil, message: L10n.AddingProductsFromDiffrentSuppliersWillClearYourCart.string, success: {
//                        // weak var weakSelf = self
//                        DBManager.sharedManager.cleanCart()
//
//                    }, cancel: {})
//                    return
//                }
            }
            
            if isHourly && isFixed {
                
                UtilityFunctions.showAlert(title: nil, message: L11n.tryToAddDiffrentProductsToCart.string, success: {
                    // weak var weakSelf = self
                    DBManager.sharedManager.cleanCart()
                    
                }, cancel: {})
                return
            }
            if isAgent && isProducts && isServices {
                UtilityFunctions.showAlert(title: nil, message: L10n.Agentsnotavailableforsomeitems.string, success: {
                    
                }, cancel: {})
                return
            }
            
            if (isServices || isHourly) {
                
                var tinterval: Double = 0.0
                arrayCart.forEach({
                    (objC) in
                    tinterval += /objC.totalDuration
                })
                guard let cartId = (tempCartId as? String)?.components(separatedBy: "$").first else { return }
                
                //Nitin
                //                if cartAppType == .gym,
                //                    let data = GDataSingleton.sharedInstance.pickupDate,
                //                    data > Date().add(seconds: 60*60)
                //                {
                //                    self.openNextStep(isAgent: isAgent, tinterval: tinterval, cartId: cartId, tempCartId: (tempCartId as? String), arrayCart: arrayCart)
                //                    return
                //                }
                
//                let vcPickUp = PickupDetailsController.getVC(.laundry)
//                self.presentVC(vcPickUp)
//
//                vcPickUp.blockSelectOnlyDateAndTime = {
//                    [weak self] in
//                    guard let self = self else { return }
//
//                    self.openNextStep(isAgent: isAgent, tinterval: tinterval, cartId: cartId, tempCartId: (tempCartId as? String), arrayCart: arrayCart)
//                }
                self.openNextStep(isAgent: isAgent, tinterval: tinterval, cartId: cartId, tempCartId: (tempCartId as? String), arrayCart: arrayCart)

            } else {
                guard let cartId = (tempCartId as? String)?.components(separatedBy: "$").first else { return }
                
                let ordersummary = OrderSummary(items: self.tableDataSource.items as? [Cart], promo:self.promoCode, deliveryBasePrice: self.deliveryData.base_delivery_charges, regionDeliveryCharge: self.region_delivery_charge, referralApplied: self.referralApplied)
                ordersummary.cartId = cartId
                ordersummary.minOrderAmount = (tempCartId as? String)?.components(separatedBy: "$").last
                ordersummary.isAgent = false
                ordersummary.useReferral = self.referralApplied
                self.orderSummary = ordersummary
                
                self.getAllAdresses(orderSummary: ordersummary)
                
                //                if DeliveryType.shared == DeliveryType.pickup {
                //                    self.webServiceForUpdateCartInfo(orderSummary: ordersummary)
                //                    return
                //                }
                //                let VC = StoryboardScene.Order.instantiateDeliveryViewController()
                //                VC.orderSummary = ordersummary
                //                VC.remarks = self.remarks
                //                self.pushVC(VC)
            }
        }
    }
    
    func openNextStep(isAgent: Bool, tinterval: Double, cartId: String?, tempCartId: String?, arrayCart: [Cart]) {
        
        if isAgent {
//            let VC =  AgentListingVC.getVC(.order)
//            VC.selectedDate = GDataSingleton.sharedInstance.pickupDate ?? Date()
//            VC.timeInterVal = tinterval
//
//            VC.orderSummary = OrderSummary(items: self.tableDataSource.items as? [Cart], promo:self.promoCode)
//            VC.orderSummary?.cartId = cartId
//            VC.orderSummary?.isAgent = true
//            VC.orderSummary?.minOrderAmount = (tempCartId)?.components(separatedBy: "$").last
//            VC.remarks = self.remarks
//            VC.arrayCart = arrayCart
//            VC.completion = {
//
//            }
//            self.pushVC(VC)
            
            let ordersummary = OrderSummary(items: self.tableDataSource.items as? [Cart], promo:self.promoCode, deliveryBasePrice: deliveryData.base_delivery_charges, regionDeliveryCharge: region_delivery_charge, referralApplied: self.referralApplied)
            ordersummary.cartId = cartId
            ordersummary.minOrderAmount = (tempCartId)?.components(separatedBy: "$").last
            ordersummary.isAgent = true
            ordersummary.agentId = selectedAgentId?.id
            ordersummary.useReferral = self.referralApplied

            self.orderSummary = ordersummary
            self.getAllAdresses(orderSummary: ordersummary)
            
        } else {
            let orderSummary: OrderSummary? = OrderSummary(items: self.tableDataSource.items as? [Cart], promo:self.promoCode, deliveryBasePrice: deliveryData.base_delivery_charges, regionDeliveryCharge: region_delivery_charge, referralApplied: self.referralApplied)
            orderSummary?.cartId = cartId
            orderSummary?.isAgent = false
            orderSummary?.minOrderAmount = (tempCartId)?.components(separatedBy: "$").last
            
            if GDataSingleton.sharedInstance.pickupDate == nil {
                let VC = StoryboardScene.Order.instantiateDeliveryViewController()
                VC.orderSummary = orderSummary
                VC.remarks = self.remarks
                self.pushVC(VC)
                return
            }
            
            let branchId = orderSummary?.items?.first?.supplierBranchId
            DeliveryViewController.getUserAdresses(isAgent: (/orderSummary?.isAgent), branchId: branchId) {
                [weak self] (delivery) in
                
                guard let self = self,
                    let deliveryAddressId = GDataSingleton.sharedInstance.pickupAddressId,//deliveryAddress?.id,
                    let pickUp = GDataSingleton.sharedInstance.pickupDate
                    else { return }
                
                delivery.initalizeDelivery(cart: orderSummary?.items)
                
                let deliveryDate = pickUp//.add(seconds: Int(60.0*self.timeInterVal))
                
                DeliveryViewController.updateCart(
                    delivery: delivery,
                    order: orderSummary,
                    deliverySpeed: DeliverySpeedType.Standard,
                    addressId: deliveryAddressId,
                    deliveryDate: deliveryDate,
                    remarks: self.remarks,
                    addOn: nil) {
                        [weak self] in
                        APIManager.sharedInstance.hideLoader()
                        guard let self = self else { return }
                        
                        let VC = StoryboardScene.Order.instantiateOrderSummaryController()
                        VC.orderSummary = orderSummary
                        VC.remarks = self.remarks
                        self.pushVC(VC)
                }
            }
        }
    }
    
    func getAllAdresses(orderSummary: OrderSummary?) {
        if !GDataSingleton.sharedInstance.isLoggedIn {
            return
        }
        let branchId = (tableDataSource.items?.first as? Cart)?.supplierBranchId
        
        self.getUserAdresses(isAgent: (orderSummary?.isAgent ?? false), branchId: branchId) {
            [weak self] (delivery) in
            guard let self = self else { return }
            self.deliveryData = delivery
            self.tableView.reloadTableViewData(inView: self.view)
            if let summary = orderSummary {
                self.setAddressData(ordersummary : summary)
            }
        }
    }
    
    func setAddressData(ordersummary : OrderSummary?) {
        
        if LocationSingleton.sharedInstance.searchedAddress != nil {
            let add = LocationSingleton.sharedInstance.searchedAddress?.formattedAddress ?? ""
            let city = LocationSingleton.sharedInstance.searchedAddress?.locality ?? ""
            let country = LocationSingleton.sharedInstance.searchedAddress?.country ?? ""
            let id = LocationSingleton.sharedInstance.searchedAddress?.id ?? ""
            var lati = String()
            var longi = String()
            
            if let lat = LocationSingleton.sharedInstance.searchedAddress?.lat {
                lati = String(lat)
            }
            if let long = LocationSingleton.sharedInstance.searchedAddress?.long  {
                longi = String(long)
            }
            
            let obj : Address = Address(name: nil, address: add, landmark: nil, houseNo: nil, buildingName: nil, city: city, country: country, placeLink: nil, area: nil, lat: lati, long: longi, id: id)
            
            self.selectedAddress = obj
        }
        //        if self.deliveryData.addresses?.count ?? 0 > 0 {
        //            self.selectedAddress = self.deliveryData.addresses?.first
        //            let add = self.deliveryData.addresses?.first?.address ?? ""
        //            let area = self.deliveryData.addresses?.first?.area ?? ""
        //            self.address_label.text = add + "," + area
        //        } else {
        //            self.locationFetched()
        //        }
        //
        if let isAdded = self.checkIfAddressAdded(),!isAdded {
            self.openAdressController()
            return
        }
        self.webServiceForUpdateCartInfo(orderSummary: ordersummary)
        
        //        let VC = StoryboardScene.Order.instantiateDeliveryViewController()
        //        VC.deliveryData = self.deliveryData
        //        VC.orderSummary = self.orderSummary
        //        VC.remarks = self.remarks
        //        self.pushVC(VC)
        
    }
    
    func locationFetched(address : String?) {
        //Nitin fdfdf
        //        address_label.text = ""
        //For home set service at location, for food and eCom - delivery location
        let type = deliveryTypeSelected
        if type == 0 || cartAppType == .home {
            if let address = LocationSingleton.sharedInstance.searchedAddress, let addressId = address.id, !addressId.isEmpty {
                address_label.text = address.formattedAddress
            }
            else {
                address_label.text = "Address Location".localized()
            }
            
            //            else if let name = LocationSingleton.sharedInstance.selectedAddress?.name {
            //                if let locality = LocationSingleton.sharedInstance.selectedAddress?.locality {
            //                    address_label.text = name + " " + locality
            //                }
            //            }
        } else {
            if let add = GDataSingleton.sharedInstance.supplierAddress {
                self.address_label.text = add
            }
        }
        
    }
    
    func checkIfAddressAdded() -> Bool?{
        if let type = deliveryTypeSelected, type == 0 {
            guard let _ = self.selectedAddress?.id else {
                SKToast.makeToast("Your address is not saved,please save this address and proceed further.".localized())
                return false
            }
            return true
        }
        
        return nil
    }
}

//MARK: - LoginScreen Delegates
extension CartViewController : LoginViewControllerDelegate {
    
    func userFailedLoggedIn() {
        // Show Alert here
        
    }
    
    func userSuccessfullyLoggedIn(withUser user: User?) {
        
    }
    
}

//MARK: - Table View Methods
extension CartViewController {
    
    func getCartFromDB(){
        DBManager().getCart {
            [weak self] (array) in
            self?.configureTableDataSource(products: array)
        }
    }
    
    func configureTableDataSource(products : [AnyObject]?){
        showPaymentMode = true
        for product in (products as? [Cart] ?? []) {
            if product.payment_after_confirmation {
                showPaymentMode = false
                break
            }
        }
        viewPaymentType.isHidden = !showPaymentMode
        if products?.count == 0 {
            selectedAgentId = nil
            imgPlaceholderNotext?.isHidden = false
            address_view.isHidden = true
            bottom_view.isHidden = true
            tableView?.isHidden = true
            cartProdcuts = [AnyObject]()
            DBManager.sharedManager.cleanCart()
            //            btnProceedCheckout?.isHidden = true
            //            btnProceedCheckout?.isEnabled = false
            return
        }
        //        if let isAdded = self.checkIfAddressAdded(),!isAdded {
        //            self.openAdressController()
        //        }
        cartProdcuts = products
        configureTableView(arrayProducts: cartProdcuts)
        tableView.reloadTableViewData(inView: view)
        imgPlaceholderNotext?.isHidden = true
        address_view.isHidden = false
        bottom_view.isHidden = false
        tableView?.isHidden = false
        if cartAppType == .food {
            getAllAdresses(orderSummary: nil)
        }
    }
    
    func configureTableView(arrayProducts : Array<AnyObject>?){
        guard let array = arrayProducts else { return }
        var idArray = [String]()
        
        for i in 0...array.count-1 {
            let product = ProductF(cart: array[/i] as? Cart)
            idArray.append(product.product_id ?? "")
            self.pickupType.append(product.self_pickup ?? 0)
            GDataSingleton.sharedInstance.supplierAddress = product.supplierAddressCart ?? ""
            self.locationFetched(address : product.supplierAddressCart ?? "")
        }
        
        self.getProductAccToAddons(array: array)
        if idArray.count > 0 {
            self.checkProductList(ids: idArray)
        }
        
    }
    
    func getProductAccToAddons(array : Array<AnyObject>?) {
        
        guard let arrayCart = array else {return}
        var productArray = [ProductF]()
        
        for i in 0...arrayCart.count-1 {
            let product = ProductF(cart: arrayCart[i] as? Cart)
            guard let productId = product.id else {return}
            
            if let addonId = product.addOnId, addonId != "" {
                DBManager.sharedManager.getTypeIdsOfAddonId(productId: productId, addonId: addonId) { (typeIdArray) in
                    
                    for j in 0...typeIdArray.count-1 {
                        var productObj : ProductF?
                        productObj = ProductF(cart: arrayCart[i] as? Cart)
                        DBManager.sharedManager.getAddonsDataFromDbAcctoTypeId(productId: productId, addonId: addonId, typeId: typeIdArray[j]) {(addonModalArray) in
                            print(addonModalArray)
                            for addons in addonModalArray {
                                let index = addons.addonData?.count == 1 ? 0 : j
                                var tempArray = [[AddonValueModal]]()
                                if let aa = addons.addonData?[index] {
                                    tempArray.append(aa)
                                }
                                productObj?.arrayAddonValue = tempArray
                                productObj?.typeId = addons.typeId
                                productObj?.addOnId = addons.addonId
                                productObj?.perAddonQuantity = addons.quantity
                                
                                guard let obj = productObj else {return}
                                productArray.append(obj)
                            }
                        }
                    }
                }
            } else {
                productArray.append(product)
            }
            
        }
        let questions = productArray.first?.questionsSelected
        //print(productArray)
        
       // print(productArray)
       // if GDataSingleton.sharedInstance.loggedInUser?.token != nil {
        //    getUserServiceFee(branchId: /productArray.first?.supplierBranchId)
       // }
        tableDataSource = CartDataSource(items: productArray, height: UITableView.automaticDimension, tableView: tableView, cellIdentifier: nil, configureCellBlock: { [weak self] (cell, item) in
            guard let self = self else { return }
            self.configureCell(cell: cell, indexPath: item, array: productArray)
            
            }, aRowSelectedListener: { (indexPath) in
                
        }, aRowSwipeListner: { (indexPath) in
            let product = productArray[indexPath.row]
            guard let productId = product.id else {return}
            if let addonId = product.addOnId, addonId != "" {
                if let typeId = product.typeId, typeId != "" {
                    let quant = product.perAddonQuantity ?? 0
                    DBManager.sharedManager.removeAddonFromDbAcctoTypeId(productId: productId, addonId: addonId, typeId: typeId)
                    
                    DBManager.sharedManager.getTotalQuantityPerProduct(productId: productId) { (quantity) in
                        guard let totalQuant = Int(quantity) else {return}
                        let savedQuant = totalQuant-quant
                        DBManager.sharedManager.manageCart(product: product, quantity: savedQuant)
                        product.arrayAddOnValue?.remove(at: indexPath.row)
                        
                        self.getCartFromDB()
                    }
                }
            } else {
                DBManager.sharedManager.removeProductFromCart(productId: productId)
                self.getCartFromDB()
            }
        })
        
        tableDataSource.questions = questions
        
    }
    
    func checkProductList(ids: [String]) {
        if !refreshPriceData { return }
        let objR = API.checkProductList(product_ids: ids)
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) { [weak self] (result) in
            guard let `self` = self else { return }
            switch result {
            case .Success(let object):
                self.refreshPriceData = false
                let obj = object as? CheckProductList
                self.tipItems = obj?.tips
                self.locationBasedGateways = obj?.payment_gateways
                self.region_delivery_charge = obj?.region_delivery_charge
                guard let products = obj?.result else {
                    self.tableView.reloadData()
                    return
                }
                for product in products {
                    DBManager.sharedManager.refreshPriceToCart(product: product)
                }
                self.getCartFromDB()
                break
            case .Failure(_):
                APIManager.sharedInstance.hideLoader()
                break
            }
        }
        
    }
    
    
    func retrieveReferalAmount() {
        if !GDataSingleton.sharedInstance.isLoggedIn {
            return
        }
        
        let objR = API.getReferalAmount
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            [weak self] (response) in
            guard let self = self else { return }
            switch response {
            case APIResponse.Success(let object):
                self.tableView.reloadData()
            default :
                print("Hello Nitin")
                break
            }
            
        }
    }
    
    func setDefaultPaymentType() {
        if AppSettings.shared.appThemeData?.payment_method == "0" {
            selectedPaymentMethod = PaymentMode(paymentType: .COD)
        }
        // else let the user choose
    }
    
    func getAllowedPaymentType() -> PaymentMethod? {
        //If referral amount is equal to netTotal, no need to select payment method
        if referralApplied && selectedPaymentMethod?.paymentType == .DoesntMatter {
            return nil
        }
        if (/AppSettings.shared.appThemeData?.payment_method).isEmpty || AppSettings.shared.appThemeData?.payment_method == "2" {
            //Show both Cash and Card Payments
            return .DoesntMatter
        }
        if AppSettings.shared.appThemeData?.payment_method == "1" {
            //Show Card Modes
            return .Card
        }
        //If only cash is allowed, return nil
        return nil
    }
    
    func configureCell(cell : Any,indexPath : Any?,array : [ProductF]) {
        
        guard let index = indexPath as? IndexPath else { return }
        
        if let cell = cell as? ProductListCell {
            // cell.isForCart = true
            cell.fromCartView = true
            cell.backgroundColor = .white
            cell.selectionStyle = .none
            //            cell.category = self.passedData.categoryOrder
            //            cell.categoryId = self.passedData.categoryId
            
            let data = array[index.row]
            cell.index = index.row
            data.supplierAddrerss = data.supplierAddressCart
            cell.product = data
            cell.completionBlock = { [weak self] value in
                guard let self = self else {return}
                if let data = value as? Double {
                    self.getCartFromDB()
                }
            }
            
            cell.addonsCompletionBlock = { [weak self] value in
                guard let self = self else {return}
                if let data = value as? (ProductF,Bool,Double){
                    if data.1 { // data.1 == true for open customization controller
                        //  self.openCustomizationView(cell: cell, product: data.0, cartData: nil, quantity: data.2, index: indexPath.row)
                    }
                } else if let data = value as? (ProductF,Cart,Bool,Double,Int) {
                    //for open checkcustomization controller
                    let product = data.0
                    var arrayAddonValue = product.arrayAddonValue ?? []
                    let productId = product.id ?? ""
                    let addonId = product.addOnId ?? ""
                    let typeId = product.typeId ?? ""
                    let quantity = data.3
                    
                    if data.4 == 1 { // for plus action
                        self.checkAddonExistAcctoTypeid(productId: productId, addonId: addonId, typeId: typeId) { (isContain, dataArray) in
                            
                            var array = [[AddonValueModal]]()
                            array = arrayAddonValue
                            
                            let obj = AddonsModalClass(productId: productId, addonId: addonId, addonData: array, quantity: Int(quantity + 1), typeId: typeId)
                            DBManager.sharedManager.manageAddon(addonData: obj)
                            
                            DBManager.sharedManager.getTotalQuantityPerProduct(productId: productId) { (quantity) in
                                guard let qaunt = Int(quantity) else {return}
                                DBManager.sharedManager.manageCart(product: product, quantity: qaunt+1)
                                self.getCartFromDB()
                            }
                            
                        }
                    } else if data.4 == 2 { // for minus action
                        let newQuantity = quantity-1
                        
                        if newQuantity == 0 {
                            DBManager.sharedManager.removeAddonFromDbAcctoTypeId(productId: productId, addonId: addonId, typeId: typeId)
                            
                            DBManager.sharedManager.getTotalQuantityPerProduct(productId: productId) { (quantity) in
                                guard let totalQuant = Int(quantity) else {return}
                                let savedQuant = totalQuant-1
                                DBManager.sharedManager.manageCart(product: product, quantity: savedQuant)
                                
                                arrayAddonValue.removeAll()
                                
                                self.getCartFromDB()
                            }
                        } else {
                            var array = [[AddonValueModal]]()
                            array = arrayAddonValue
                            
                            let obj = AddonsModalClass(productId: productId, addonId: addonId, addonData: array, quantity: Int(newQuantity), typeId: typeId)
                            DBManager.sharedManager.manageAddon(addonData: obj)
                            
                            DBManager.sharedManager.getTotalQuantityPerProduct(productId: productId) { (quanty) in
                                guard let qaunt = Int(quanty) else {return}
                                DBManager.sharedManager.manageCart(product: product, quantity: qaunt-1)
                                self.getCartFromDB()
                            }
                            
                        }
                    }
                } else if let _ = value as? (Double,ProductF) {
                    self.getCartFromDB()
                }
            }
            
        }  else if let cell = cell as? CartBillCell {
            cell.selectedAgentId = selectedAgentId
            cell.base_delivery_charges = deliveryData.base_delivery_charges ?? 0
            cell.region_delivery_charge = region_delivery_charge
            if cartAppType.isFood {
                cell.fromCartView = GDataSingleton.sharedInstance.fromCart ?? false
                cell.tipStackView.isHidden = (self.tipItems ?? []).isEmpty || DeliveryType.shared == .pickup ||  self.selectedPaymentMethod?.paymentType == .COD || !self.showPaymentMode
                cell.tipItems = self.tipItems ?? [Int]()
                cell.tipCollectionView?.reloadData()
                cell.newCart = array
            } else {
                cell.newCart = array
                cell.tipStackView.isHidden = true
            }
            
            cell.tvRemarks.delegate = self
            cell.blockPromoCode = {
                [weak self] code in
                guard let self = self else { return }
                self.promoCode = code
            }
            (cell as? CartBillCell)?.blockUserServiceCharge = { [weak self] value in
                self?.userServiceCharge = value
            }
            cell.referralApplied = {
                [weak self] applied in
                guard let self = self else { return }
                self.referralApplied = applied
                let referralAmount = Double(GDataSingleton.sharedInstance.referalAmount ?? 0.0)
                //If referral amount is equal to netTotal, we need to send paymentType 2 to backend
                if applied && referralAmount == cell.netTotal {
                    self.selectedPaymentMethod = PaymentMode(paymentType: .DoesntMatter)
                }
                else {
                    self.selectedPaymentMethod = nil
                }
            }
            cell.selectTimeSlotBlock = { [weak self] in
                guard let `self` = self else { return }
                if !GDataSingleton.sharedInstance.isLoggedIn {
                    self.presentVC(StoryboardScene.Register.instantiateLoginViewController())
                    return
                }
                if let user = self.selectedAgentId {
                    let agent = AgentListingData()
                    agent.cblUser = user
                    self.viewSlots(agentListingData: agent)
                    return
                }

                guard let arrayCart = self.tableDataSource.items as? [Cart] else { return }
                var tinterval: Double = 0.0
                arrayCart.forEach({
                    (objC) in
                    tinterval += /objC.totalDuration
                })
                let VC =  AgentListingVC.getVC(.order)
                VC.timeInterVal = tinterval
                
                VC.remarks = self.remarks
                VC.arrayCart = arrayCart
                VC.completion = { [weak self] agent, selectedDate in
                    GDataSingleton.sharedInstance.pickupDate = selectedDate
                    self?.selectedAgentId = agent
                }
                self.pushVC(VC)
                
//                let vcPickUp = PickupDetailsController.getVC(.laundry)
//                self.presentVC(vcPickUp)
//
//                vcPickUp.blockSelectOnlyDateAndTime = {
//                    [weak self] date in
//                    guard let self = self else { return }
//
//                }
//
            }
        }
        else if let cell = cell as? CartQuestionCell {
            let questions = array.first?.questionsSelected ?? []
            let data = questions[index.row]
            cell.configureCell(question: data, index: index.row, productPrice: Double(/array.first?.getPrice(quantity: (Double((array.first?.quantity)!) ?? 1))))
            ///(array.first?.stepValue ?? 1)
        }
        
    }
    
    func viewSlots(agentListingData: AgentListingData?) {
        
        AgentTimeSlotVC.getAvailabilty(id: /agentListingData?.cblUser?.id, block: {
            [weak self] (dates) in
            guard let self = self else { return }
            
            if dates.isEmpty {
                return
            }
            guard let arrayCart = self.tableDataSource.items as? [Cart] else { return }
            var tinterval: Double = 0.0
            arrayCart.forEach({
                (objC) in
                tinterval += /objC.totalDuration
            })
            
            let vc = AgentTimeSlotVC.getVC(.order)
            vc.arrayDates = dates
            vc.timeInterVal = tinterval
            vc.seletedTime = GDataSingleton.sharedInstance.pickupDate
            vc.objModel = agentListingData
            vc.selectedAgentId = /agentListingData?.cblUser?.id
            self.presentVC(vc)
            
            vc.blockDone = {
                [weak self] (dateSlot) in
                guard let self = self else { return }
                vc.dismiss(animated: true) {
                    if let date = dateSlot {
                        GDataSingleton.sharedInstance.pickupDate = date
                    }
                }

            }
        })
    }
    
    func handleCellSelction(indexPath : IndexPath){
        if tableView.cellForRow(at: indexPath) is ProductListingCell, false {
            
            let productDetailVc = StoryboardScene.Main.instantiateProductDetailViewController()
            productDetailVc.passedData.productId = (tableDataSource.items?[indexPath.row] as? Cart)?.id
            productDetailVc.suplierBranchId = (tableDataSource.items?[indexPath.row] as? Cart)?.supplierBranchId
            pushVC(productDetailVc)
            
        }
    }
    
    func openAdressController() {
        
        let branchId = (tableDataSource.items?.first as? Cart)?.supplierBranchId
        let vc = NewLocationViewController.getVC(.main)
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        vc.foodDeliverycompletionBlock = { [weak self] data in
            guard let strongSelf = self else { return }
            guard let adressData = data as? Dictionary<String,AnyObject> else {return}
            //            if let selectedAddress = adressData["selectedDict"] as? Address {
            //                let add = selectedAddress.address ?? ""
            //                let area = selectedAddress.area ?? ""
            //                strongSelf.address_label.text = add + "," + area
            //                strongSelf.selectedAddress = selectedAddress
            //            }
            
            if let wholeArray = adressData["arrayAddress"] as? [Address] {
                strongSelf.deliveryData.addresses = wholeArray
            }
            
            strongSelf.locationFetched(address: nil)
            
            //            if let value = data as? Bool,value == true {
            //                // value == true is for current location selection
            //                if let name = LocationSingleton.sharedInstance.selectedAddress?.name {
            //                    if let locality = LocationSingleton.sharedInstance.selectedAddress?.locality {
            //                        strongSelf.address_label.text = name + " " + locality
            //                    }
            //                }
            //            }
            //refresh location based tax
            strongSelf.refreshPriceData = true
            strongSelf.getCartFromDB()
        }
        
        vc.completionBlock = { [weak self] value in
            guard let strongSelf = self else { return }
            if let _ = value as? [String:Any] {
                // strongSelf.address_label.text = ""
                if let address = LocationSingleton.sharedInstance.tempAddAddress?.formattedAddress{
                    strongSelf.address_label.text = address
                    //refresh location based tax
                    strongSelf.refreshPriceData = true
                    strongSelf.getCartFromDB()
                }
                
            } else {
                strongSelf.locationFetched(address: nil)
                //refresh location based tax
                strongSelf.refreshPriceData = true
                strongSelf.getCartFromDB()
            }
            
        }
        
        self.present(vc, animated: true, completion: nil)
        
    }
    
    func getUserAdresses(isAgent: Bool, branchId: String?, block: ((Delivery) -> ())?) {
        
        //APIManager.sharedInstance.showLoader()
        let objR = API.Addresses(FormatAPIParameters.Addresses(supplierBranchId: branchId, areaId: LocationSingleton.sharedInstance.location?.areaEN?.id).formatParameters())
        
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            (result) in
            
            switch result {
            case .Success(let object):
                guard let delivery = object as? Delivery else { return }
                
                if !isAgent && /GDataSingleton.sharedInstance.appSettingsData?.isScheduled {
                    
                    let objD = DeliverySpeed(selected: false, name: L10n.SCHEDULED.string)
                    objD.type = .scheduled
                    delivery.deliverySpeeds?.append(objD)
                }
                if AgentCodeClass.shared.settingData?.user_service_fee == "1" {
                    GDataSingleton.sharedInstance.userServiceCharge = delivery.userServiceCharge
                }
                GDataSingleton.sharedInstance.userId = /delivery.userID
                block?(delivery)
            case .Failure(_):
                APIManager.sharedInstance.hideLoader()
                break
            }
        }
    }
    
}

//MARK:- ======== handleCartQuantity ========
extension CartViewController {
    
    @objc func handleCartQuantity(sender : NSNotification){
        
        let visibleCells = tableView.visibleCells
        if visibleCells.first is CartBillCell {
            tableView?.isHidden = true
            imgPlaceholderNotext?.isHidden = false
            address_view.isHidden = true
            bottom_view.isHidden = true
            return
        }
        for visibleCell in visibleCells {
            
            guard let cell = visibleCell as? ProductListingCell else { return }
            
            if cell.stepper?.value == 0 {
                guard let indexpath = tableView.indexPath(for: cell) else { return }
                tableView.beginUpdates()
                if tableDataSource.items?.count != 0 {
                    tableDataSource.items?.remove(at: indexpath.row)
                }
                tableView.deleteRows(at: [indexpath], with: .right)
                tableView.endUpdates()
                
                if tableDataSource.items?.count == 0{
                    tableView?.isHidden = true
                    imgPlaceholderNotext?.isHidden = false
                    address_view.isHidden = true
                    bottom_view.isHidden = true
                } else {
                    tableView?.isHidden = false
                    imgPlaceholderNotext?.isHidden = true
                    address_view.isHidden = false
                    bottom_view.isHidden = false
                    tableView.reloadData()
                }
            } else {
                
                getCartFromDB()
            }
        }
        
    }
}
//MARK: - TextView Delegate
extension CartViewController : UITextViewDelegate {
    
    func textViewDidEndEditing(_ textView: UITextView) {
        remarks = textView.text
    }
}

//MARK: - Product Listing Gesture Recognizer
extension CartViewController {
    
    func configureCellSwipe(cell : UITableViewCell?){
        if cell?.gestureRecognizers?.isEmpty ?? true {
            let slideGesture = DRCellSlideGestureRecognizer()
            let (slideAction,pullAction) = (DRCellSlideAction(forFraction: 0.45),DRCellSlideAction(forFraction: 0.45))
            pullAction?.behavior = .pushBehavior
            pullAction?.didTriggerBlock = {
                [weak self] (tableView,indexpath) in
                
                guard let arrCart = self?.tableDataSource.items as? [Cart], let indexpath = indexpath else { return }
                tableView?.beginUpdates()
                self?.tableDataSource.items?.remove(at: indexpath.row)
                self?.cartProdcuts?.remove(at: indexpath.row)
                tableView?.deleteRows(at: [indexpath], with: .right)
                tableView?.endUpdates()
                DBManager.sharedManager.manageCart(product: ProductF(cart: arrCart[indexpath.row]), quantity: 0)
            }
            slideGesture.addActions([slideAction,pullAction])
            cell?.addGestureRecognizer(slideGesture)
        }
    }
}

//MARK:- UIViewControllerTransitioningDelegate
extension CartViewController : UIViewControllerTransitioningDelegate {
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return HalfSizePresentationController(presentedViewController: presented, presenting: presenting)
    }
}

//MARK:- Delivery View Controller and Payment view controller code merged
extension CartViewController{
    
    func webServiceForUpdateCartInfo(orderSummary: OrderSummary?){
        
        //Nitin
        var deliveryAddressId = "0"
        if DeliveryType.shared != .pickup {
            deliveryAddressId = self.selectedAddress?.id ?? "0"
        }
        self.deliveryData.deliveryMaxTime = "\(/orderSummary?.deliveryMaxTime)"
        guard let maxDays = Int(deliveryData.deliveryMaxTime ?? "0") else { return }
        let timeInterval = Double(60 * maxDays)
        
        let deliveryDate = (deliveryData.pickupDate ?? Date()).addingTimeInterval(timeInterval)
        
        self.deliveryData.handlingSupplier = "0.0"
        self.deliveryData.deliveryCharges = String(orderSummary?.dDeliveryCharges ?? 0.0)
        self.deliveryData.minOrderDeliveryCrossed = "1"
        self.deliveryData.handlingAdmin = orderSummary?.handlingCharges
        self.deliveryData.handlingSupplier = orderSummary?.handlingSupplier
        //.componentsSeparatedByCharactersInSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet).joinWithSeparator("")
        if let minOrderPrice = self.deliveryData.minOrderDeliveryCharge?.toDouble(),let totalCharges = self.deliveryData.totalPrice?.toDouble() {
            self.deliveryData.minOrderDeliveryCrossed = totalCharges > minOrderPrice ? "1" : "0"
        } else {
            self.deliveryData.minOrderDeliveryCrossed = "1"
        }
        
        DeliveryViewController.updateCart(delivery: self.deliveryData, order: self.orderSummary, deliverySpeed: selectedDeliverySpeed, addressId: deliveryAddressId, deliveryDate: deliveryDate, remarks: "", addOn: orderSummary?.addOnCharge, newTotal: nil ) {
            [weak self] in
            
            guard let self = self else {
                APIManager.sharedInstance.hideLoader()
                return }
            
            self.handleUpdateCartInfo()
            
        }
        
    }
    
    func handleUpdateCartInfo(){
        
        var deliveryAddress  : Address?
        
        deliveryAddress = self.selectedAddress
        
        if let maxDays = Int(deliveryData.deliveryMaxTime ?? "0") {
            let timeInterval = Double(60 * maxDays)
            orderSummary?.deliveryDate = (deliveryData.pickupDate ?? Date()).addingTimeInterval(timeInterval)
        }
        
        orderSummary?.dDeliveryCharges = deliveryData.deliveryCharges?.toDouble()
        orderSummary?.minDelCharges = deliveryData.base_delivery_charges
        
        orderSummary?.initalizeOrderSummary(cart:  orderSummary?.items, forRental: true, rentalTotal: orderSummary?.netPayableAmount)
        orderSummary?.deliveryAddress = deliveryAddress
        orderSummary?.pickupAddress = deliveryData.pickupAddress
        orderSummary?.pickupDate = deliveryData.pickupDate
        orderSummary?.selectedDeliverySpeed = selectedDeliverySpeed
        
        if orderSummary?.items?.first?.category == Category.Laundry.rawValue || orderSummary?.items?.first?.category == Category.BeautySalon.rawValue {
            orderSummary?.pickupBuffer = deliveryData.deliveryMaxTime
        }
        //orderSummary?.paymentMode = deliveryData.paymentMode
        
        if selectedPaymentMethod?.gatewayUniqueId == "sadded" {
            getSADADPaymentUrl()
        }else if selectedPaymentMethod?.gatewayUniqueId == "myfatoorah"{
            getMyFatoorahPaymentUrl()
        }else {
            self.generateOrder()
        }
        
    }
    
    func generateOrder(){
        
        APIManager.sharedInstance.showLoader()
        var agentId = [Int]()
        if let value = orderSummary?.agentId?.toInt() {
            agentId.append(value)
        }
        
        let timeInter = Date().timeIntervalSince(orderSummary?.currentDate ?? Date())
        
        var pickupAddress = ""
        if let add = self.parameters["pickupAddress"] as? String {
            pickupAddress = add
        }
        var dropoffAddress = ""
        if let dropAddress = self.parameters["dropoffAddress"] as? String {
            dropoffAddress = dropAddress
        }
        
        var pickupApiDate = ""
        if let pickapiDate = self.parameters["pickupApiDate"] as? String {
            pickupApiDate = pickapiDate
        }
        
        var dropoffApiDate = ""
        if let dropoapiDate = self.parameters["dropoffApiDate"] as? String {
            dropoffApiDate = dropoapiDate
        }

        
        var pickupCordinates = CLLocationCoordinate2D()
        if let pickCordinates = self.parameters["pickupCordinates"] as? CLLocationCoordinate2D {
            pickupCordinates = pickCordinates
        }
        
        var dropoffCordinates = CLLocationCoordinate2D()
        if let dropoffCord = self.parameters["dropoffCordinates"] as? CLLocationCoordinate2D {
            dropoffCordinates = dropoffCord
        }
        let pickupLatitude = pickupCordinates.latitude
        let pickupLongitude = pickupCordinates.longitude
        let dropoffLatitude = dropoffCordinates.latitude
        let dropoffLongitude = dropoffCordinates.longitude
                
        let objR = API.GenerateOrder(FormatAPIParameters.GenerateOrder(
            useReferral: /orderSummary?.useReferral,
            promoCode: orderSummary?.promoCode,
            cartId: orderSummary?.cartId,
            isPackage: orderSummary?.isPackage,
            paymentType:selectedPaymentMethod ?? PaymentMode(paymentType: .COD),
            agentIds: agentId,
            deliveryDate: orderSummary?.currentDate ?? Date(),
            duration: /orderSummary?.duration, from_address: pickupAddress, to_address: dropoffAddress, booking_from_date: pickupApiDate, booking_to_date: dropoffApiDate, from_latitude: pickupLatitude, to_latitude: dropoffLatitude, from_longitude: pickupLongitude, to_longitude: dropoffLongitude,
            tip_agent: GDataSingleton.sharedInstance.tipAmount,
            arrPres: arrPrescription,
            instructions: txtPrescription,
            bookingDate: GDataSingleton.sharedInstance.pickupDate, questions: orderSummary?.questions, customer_payment_id: GDataSingleton.sharedInstance.customerPaymentId,
            user_service_charge: self.userServiceCharge,
            donateToSomeone: donateToSomeone).formatParameters())
        //deliveryDate?.add(seconds: Int(timeInter)) //Nitin
        APIManager.sharedInstance.opertationWithRequest(refreshControl: nil, isLoader: false, withApi: objR) { [weak self] (response) in            APIManager.sharedInstance.hideLoader()
            weak var weakSelf = self
            switch response {
            case .Success(let object):
                weakSelf?.handleGenerateOrder(orderId: object)
            case .Failure(_):
                break
            }
        }
    }
    
    func handleGenerateOrder(orderId : Any?){
        
        //print(orderId)
        AdjustEvent.Order.sendEvent(revenue: orderSummary?.totalAmount)
        GDataSingleton.sharedInstance.tipAmount = 0
        DBManager.sharedManager.cleanCart()
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
                VC.orderSummary?.paymentMode = self.selectedPaymentMethod ?? PaymentMode(paymentType: .COD)
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


extension CartViewController {
    
    func checkAddonExistAcctoTypeid(productId: String, addonId: String,typeId:String, finished: (_ isContain: Bool, _ data: [AddonsModalClass]?)-> Void) {
        
        DBManager.sharedManager.getAddonsDataFromDbAcctoTypeId(productId: productId, addonId: addonId, typeId: typeId) { (data) in
            print(data)
            finished(data.count == 0 ? false : true, data.count == 0 ? nil : data)
        }
        
    }
    
}

//MARK: - Payment gateway webviews
extension CartViewController {
    func getSADADPaymentUrl() {
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.getSadadPaymentUrl(name: /GDataSingleton.sharedInstance.loggedInUser?.firstName, email: /GDataSingleton.sharedInstance.loggedInUser?.email, amount: "\(orderSummary?.totalAmount)")) { [weak self] (response) in
            switch response {
            case .Success(let object):
                guard let self = self else { return }
                APIManager.sharedInstance.hideLoader()
                guard let data = object as? SadadPaymentdata else {return}
                
                self.selectedPaymentMethod?.token = data.transactionReference
                if let paymentUrl = data.paymentUrl, !paymentUrl.isEmpty {
                    
                    let vc = PaymentWebviewVC.getVC(.payment)
                    vc.urlStr = paymentUrl
                    vc.gatewayUniqueId = /self.selectedPaymentMethod?.gatewayUniqueId
                    vc.paymentSucccessBlock = { token in
                        
                        vc.popVC()
                        self.generateOrder()
                    }
                    self.pushVC(vc)
                }
                
            default:
                APIManager.sharedInstance.hideLoader()
                break
                
            }
        }
    }
    
    func getMyFatoorahPaymentUrl() {
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.getMyFatoorahPaymentUrl(currency: Constants.currencyName, amount: "\(/orderSummary?.totalAmount)")) { [weak self] (response) in
            switch response {
            case .Success(let object):
                guard let self = self else { return }
                APIManager.sharedInstance.hideLoader()
                guard let data = object as? MyFatoorahPaymentdata else {return}
                
                if let paymentUrl = data.PaymentURL, !paymentUrl.isEmpty {
                    
                    let vc = PaymentWebviewVC.getVC(.payment)
                    vc.urlStr = paymentUrl
                    vc.gatewayUniqueId = /self.selectedPaymentMethod?.gatewayUniqueId

                    vc.paymentSucccessBlock = { token in
                        
                        vc.popVC()
                        self.selectedPaymentMethod?.token = token

                        self.generateOrder()
                    }
                    self.pushVC(vc)
                }
                
            default:
                APIManager.sharedInstance.hideLoader()
                break
                
            }
        }
    }
}
