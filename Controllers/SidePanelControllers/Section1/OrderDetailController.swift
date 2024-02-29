//
//  OrderDetailController.swift
//  Clikat
//
//  Created by cblmacmini on 5/2/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import SwiftyJSON
import MessageUI

class OrderDetailController: BaseViewController {
    
    //    let supplierView = FloatingSupplierView(frame: CGRect(x: Localize.currentLanguage() == Languages.Arabic ? 16 : ScreenSize.SCREEN_WIDTH - 80, y: ScreenSize.SCREEN_HEIGHT - 80, w: 64, h: 64))
    typealias ActionCancelOrder = () -> ()
    
    //MARK:- IBOutlet
    @IBOutlet var btnPayNow: ThemeButton!
    @IBOutlet weak var constraintBottomBtnNext: NSLayoutConstraint!
    @IBOutlet weak var lblTitle: ThemeLabel!{
        didSet {
            if let term = TerminologyKeys.order.localizedValue() as? String{
                lblTitle.text = term + " \("Details".localized())"
            }
        }
    }
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnScheduleOrder: UIButton!
    @IBOutlet weak var constraintButtonContainer: NSLayoutConstraint!
    @IBOutlet weak var btnReOrder: UIButton! {
        didSet {
            btnReOrder.setTitle("REORDER".localized(), for: .normal)
        }
    }
    @IBOutlet weak var btnCancel: UIButton! {
        didSet {
            btnCancel.setTitle("CANCEL".localized(), for: .normal)
        }
    }
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var btnPrevoius: UIButton! {
        didSet{
            btnPrevoius.setTitle("Previous".localized(), for: .normal)
        }
    }
    @IBOutlet weak var btnSupport: UIButton?{
        didSet{
            btnSupport?.isHidden = (AgentCodeClass.shared.settingData?.email == nil || AgentCodeClass.shared.settingData?.email == "")
        }
    }
    @IBOutlet weak var labelItemText: ThemeLabel!
    
    //MARK:- Variables
    var tableDataSource = OrderDetailDataSource()
    var orderDetails : OrderDetails?
    var type : OrderCellType?
    var isOrderCompletion = false
    var isPush = false
    var isConfirmOrder = false
    var isBuyOnly = false
    var currentIndex = 0
    var cancelOrder : ActionCancelOrder?
    var orderHistory : OrderHistory?
    var geofenceTaxdata : TaxData? = nil

    //MARK:- Variables
    override func viewDidLoad() {
        super.viewDidLoad()
        AdjustEvent.OrderDetail.sendEvent()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getOrderDetails(orderId: orderDetails?.orderId)
        addSupplierImage()
    }
    
    func setupUI(){
        //btnReOrder.isHidden = true
        
        let color = orderDetails?.status.color()
        btnReOrder.layer.borderColor = color?.cgColor
        btnReOrder.setTitleColor(color, for: .normal)
        configureOrderDetailDataSource()
    }
    
    func setupButtons(){
        
        switch orderDetails?.orderStatus {
        case 0,1,9:
            btnReOrder.isHidden = false
            btnCancel.isHidden = false
        default:
            btnReOrder.isHidden = false
            btnCancel.isHidden = true
        }
        if orderDetails?.appType == .home {
            btnReOrder.isHidden = true
        }
        view.layoutIfNeeded()
    }
    
    override func addFloatingButton(isCategoryFlow : Bool ,image : String?,supplierId : String?,supplierBranchId : String?){
        if self is OrderDetailController {
            return
        }
        supplierView.imageSupplier.loadImage(thumbnail: image, original: nil)
        
        //supplierView.supplierBranchId = supplierBranchId
        supplierView.supplierId = supplierId
        supplierView.floatingViewTapped = { [weak self] in
            
            if self?.orderDetails?.appType == .food {
//                let VC = StoryboardScene.Main.instantiateSupplierInfoViewController()
//                VC.showButton = false
                let VC = RestaurantDetailVC.getVC(.splash)
                VC.passedData.supplierBranchId = self?.orderDetails?.supplierBranchId
                
                //  VC.passedData.supplierBranchId = supplierBranchId
                VC.passedData.supplierId = supplierId
                VC.passedData.categoryId = self?.orderDetails?.product?.first?.categoryId
                
                self?.pushVC(VC)
            } else {
                let VC = StoryboardScene.Main.instantiateSupplierInfoViewControllerNoFood()
                
                VC.passedData.supplierBranchId = self?.orderDetails?.supplierBranchId
                
                //  VC.passedData.supplierBranchId = supplierBranchId
                VC.passedData.supplierId = supplierId
                VC.passedData.categoryId = self?.orderDetails?.product?.first?.categoryId
                VC.showButton = false
                self?.pushVC(VC)
            }
            
        }
        self.view.addSubview(supplierView)
        self.view.bringSubviewToFront(supplierView)
    }
    
}

//MARK: - Get Order Detail 
extension OrderDetailController {
    
    func getOrderDetails(orderId : String?) {
        
        let orderIdArr = orderId?.components(separatedBy:[","])
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.OrderDetail(FormatAPIParameters.OrderDetail(orderId: orderIdArr).formatParameters())) { [weak self] (response) in
            switch response {
            case .Success(let object):
                guard let `self` = self else { return }
                self.orderHistory =  object as? OrderHistory
                let orderDetailsArr = self.orderHistory?.orderDetails
                let miltipleOrders = self.orderHistory?.orderDetails?.count ?? 0 > 1
                self.btnNext.isHidden = miltipleOrders ? false : true
                if miltipleOrders {
                    self.constraintBottomBtnNext.constant = 0
                }
                // self?.btnPrevoius.isHidden = self?.orderHistory?.orderDetails?.count ?? 0 > 1 ? false : true
                
                self.orderDetails = orderDetailsArr?.first
                if let terminology = self.orderDetails?.terminology {
                    AppSettings.shared.appThemeData?.terminology = terminology
                }
                if let type = self.orderDetails?.appType {
                    AppSettings.shared.appType = type.rawValue
                }
                //
                if let status = self.orderDetails?.status {
                    self.btnCancel.isHidden = status == OrderDeliveryStatus.Pending ? false : true
                    self.btnReOrder.isHidden = (status == OrderDeliveryStatus.Delivered || status == OrderDeliveryStatus.Rejected || status == OrderDeliveryStatus.CustomerCancel || status == OrderDeliveryStatus.FeedbackGiven) ? false : true
                }

                if self.orderDetails?.appType == .home {
                    self.btnReOrder.isHidden = true
                }
                if /self.orderDetails?.shouldPayAfterConfirmation {
                    self.btnPayNow?.isHidden = false
                    let payAmount = Double(/self.orderDetails?.netAmount)
                    self.btnPayNow?.setTitle("\("PAY NOW".localized()) \(payAmount!.addCurrencyLocale)", for: .normal)
                }
                else if /self.orderDetails?.shouldPayRemainingAmount {
                    self.btnPayNow?.isHidden = false
                    let payAmount = self.orderDetails?.remaining_amount ?? 0
                    self.btnPayNow?.setTitle("\("PAY NOW".localized()) \(payAmount.addCurrencyLocale)", for: .normal)
                }
                else {
                    self.btnPayNow?.isHidden = true
                }
                //self?.setupButtons()
                self.configureOrderDetailDataSource()
                self.getGeofenceData()
            default: break
                
            }
        }
    }
    
    func getGeofenceData() {
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.geofenceTax(lat: "\(/orderDetails?.latitude)", long: "\(/orderDetails?.longitude)", branchId: orderDetails?.supplierBranchId)) { [weak self] (response) in
            switch response {
            case .Success(let object):
                guard let self = self else { return }
                guard let data = object as? GeofenceTaxData else {return}
                self.geofenceTaxdata = data.taxData?.first

            default: break
                
            }
        }
    }
}

extension OrderDetailController {
    
    func configureOrderDetailDataSource(){
        
        tableView.estimatedRowHeight = 200.0
        var itemArray = [ProductDetailData]()
        let tax =  self.orderDetails?.handling_admin ?? ""
        if let product = self.orderHistory?.orderDetails?.first?.product {
            for i in 0...product.count-1 {
                if let addons = product[i].productDetailAddson {
                    let grouped = Dictionary(grouping: addons) { (addon) -> Int in
                        return addon.serial_number ?? 0
                    }
                    print(grouped)
                    for (key,value) in grouped {
                        print(key,value)
                        let data = grouped[key]
                        let quant = data?[0].quantity ?? 0
                        let obj = ProductDetailData(name: product[i].name ?? "", quantity: String(quant), measuringUnit: product[i].measuringUnit, price: product[i].price ?? "", image: product[i].image ?? "", productDetailAddson: value, variants: [], recipe_pdf: product[i].recipe_pdf, product_id: product[i].product_id, order_price_id: product[i].order_price_id, return_data: product[i].return_data)
                        itemArray.append(obj)
                        //                        for data in grouped[key] ?? []{
                        //                            let obj = ProductDetailData(name: product[i].name ?? "", quantity: String(data.quantity ?? 0), measuringUnit: product[i].measuringUnit, price: product[i].price ?? "", image: product[i].image ?? "", productDetailAddson: value)
                        //                                itemArray.append(obj)
                        //                        }
                    }
                    //                    for item in grouped {
                    //                        let obj = ProductDetailData(name: product[i].name ?? "", quantity: "1", measuringUnit: product[i].measuringUnit, price: product[i].price ?? "", image: product[i].image ?? "", productDetailAddson: item.value)
                    //                        itemArray.append(obj)
                    //                    }
                } else {
                    let obj = ProductDetailData(name: product[i].name ?? "", quantity: product[i].quantity ?? "", measuringUnit: product[i].measuringUnit, price: product[i].price ?? "", image: product[i].image ?? "", productDetailAddson: nil, variants: product[i].selectedVariants, recipe_pdf: product[i].recipe_pdf, product_id: product[i].product_id, order_price_id: product[i].order_price_id, return_data: product[i].return_data)
                    itemArray.append(obj)
                }
            }
        }
        print(itemArray)
        
        tableDataSource = OrderDetailDataSource(items: itemArray, data: tax, height: UITableView.automaticDimension, tableView: tableView, cellIdentifier: CellIdentifiers.OrderStatusCell, configureCellBlock: { [weak self](cell, item) in
            guard let self = self else { return }
            guard let data = item as? ([ProductDetailData],String) else {return}
            
            let array = data.0
            let tax = data.1
            self.configureOrderStatusCell(cell: cell as? OrderStatusCell, item: array, tax: tax)
            self.configureOrderDetailCell(cell: cell as? OrderDetailCell, tax: tax)
            
            }, aRowSelectedListener: { (indexPath) in
                
        }, aRowSwipeListner: { (indexPath) in
            
        })
        tableView.delegate = tableDataSource
        tableView.dataSource = tableDataSource
        tableView.reloadTableViewData(inView: view)
        
    }
    
    func configureOrderDetailCell(cell : OrderDetailCell?,tax: String) {
        guard let c = cell else { return }
        Cart.totalTax = tax
        
        c.cellType = type ?? .OrderUpcoming
        c.tax = tax
        c.orderDetails = orderDetails
        
        c.vwBgAgentH.constant = orderDetails?.agentArray?.count == 0 ? 0 : 117
        c.cblUser = orderDetails?.agentArray?.first
        
        let questions = orderDetails?.questions ?? []
        c.viewQuestions.isHidden = questions.isEmpty
        
        let myViews = c.stackQuestions.subviews.filter{$0 is CartQuestionView}
        if /myViews.count > 0{
            for productView in myViews {
                productView.removeFromSuperview()
            }
        }
        
        for (i, question) in questions.enumerated() {
            let view = CartQuestionView(frame: CGRect(x: 0, y: 0, w: c.stackQuestions.size.width, h: 100))
            view.configureView(question: question, index: i, productPrice: c.subtotal)
            c.stackQuestions.addArrangedSubview(view)
        }
        cell?.layoutIfNeeded()
    }
    
    func configureOrderStatusCell(cell : OrderStatusCell?,item: [ProductDetailData]?,tax: String){
        guard let c = cell,let products = item else { return }
        guard let detail = orderDetails else { return }
        c.cellType = type ?? .OrderUpcoming
        c.totalCount = products.count
        c.tax = tax
        c.orderDetails = orderDetails
        let myViews = c.stackView.subviews.filter{$0 is ProductView}
        if /myViews.count > 0{
            for productView in myViews {
                productView.removeFromSuperview()
            }
        }
        let productsArr = orderDetails?.product
        for (i, product) in products.enumerated() {
            let productView = ProductView(frame: CGRect(x: 0, y: 0, w: c.stackView.size.width, h: /AppSettings.shared.appThemeData?.is_return_request == "1" ? 130 : 100))
            productView.configureProductView(product: product, isDelivered: !(/orderDetails?.status.isDelivered) || /orderDetails?.status.isCancelled)
            productView.labelProductmodel.text = orderDetails?.supplierName
//            if AppSettings.shared.appThemeData?.is_product_rating == "1" {
//
//            }
            if let term = TerminologyKeys.product.localizedValue(prefix: "Rate", appType: detail.appType) as? String {
                 productView.btnRateProduct.setTitle(term, for: .normal)
            }
            productView.btnRateProduct.isHidden = !(orderDetails?.status.isDelivered ?? false) || productsArr?[i].isRated == 1 || AppSettings.shared.appThemeData?.is_product_rating != "1"
            productView.rateProductPressed = { [weak self] in
                if let p = productsArr?[i] {
                    cell?.rateProduct(product: p)
                }
            }
            c.stackView.addArrangedSubview(productView)
        }
    }
}

extension OrderDetailController{
    
    @IBAction func nextClick(sender: UIButton) {
        
        if (orderHistory?.orderDetails?.count ?? 0 > 0) {
            currentIndex += 1
            let arrayCount =  orderHistory!.orderDetails!.count - 1
            
            if (currentIndex == arrayCount){
                btnNext.isHidden = true
                btnPrevoius.isHidden = false
            }
                
            else if (currentIndex < orderHistory?.orderDetails?.count ?? 0 - 1) {
                btnNext.isHidden = false
                btnPrevoius.isHidden = false
            }
            self.ReloadloadTableData(currentIndex: currentIndex)
        }
        
    }
    
    @IBAction func PreviousClick(sender: UIButton) {
        
        if (orderHistory?.orderDetails?.count ?? 0 > 0) {
            
            currentIndex -= 1
            if currentIndex > 0 {
                
                btnPrevoius.isHidden = false
                btnNext.isHidden = false
            }
            else if currentIndex == 0 {
                btnPrevoius.isHidden = true
                btnNext.isHidden = false
            }
            self.ReloadloadTableData(currentIndex: currentIndex)
        }
    }
    
    @IBAction func actionBack(sender: AnyObject) {
        if isConfirmOrder {
            sideMenuController()?.setContentViewController( StoryboardScene.Order.instantiateScheduledOrderController())
            toggleSideMenuView()
        }else if isOrderCompletion {
            //Nitin
            (UIApplication.shared.delegate as? AppDelegate)?.onload()
            if !isBuyOnly {
                DBManager.sharedManager.cleanCart()
            }
        }else if isPush {
            sideMenuController()?.setContentViewController( StoryboardScene.Main.instantiateHomeViewController())
            toggleSideMenuView()
        }else{
            popVC()
        }
    }
    
    @IBAction func actionScheduleOrder(sender: AnyObject) {
        
        let schedularVC = StoryboardScene.Order.instantiateOrderSchedularViewController()
        schedularVC.orderId = orderDetails?.orderId
        pushVC(schedularVC)
    }
    
    @IBAction func cancelOrder(sender: AnyObject) {
        
        UtilityFunctions.showSweetAlert(title: L10n.AreYouSure.string, message: L10n.DoYouReallyWantToCancelThisOrder.stringFor(appType: orderDetails?.appType), success: { [weak self] in
            self?.cancelOrderWebservice()
            }, cancel: {
                
        })
    }
    
    @IBAction func actionReorder(sender: AnyObject) {
        guard let button = sender as? UIButton else { return }
        
        if button.titleLabel?.text == L10n.Cancel.string {
            UtilityFunctions.showSweetAlert(title: L10n.AreYouSure.string, message: L10n.DoYouReallyWantToCancelThisOrder.stringFor(appType: orderDetails?.appType), success: { [weak self] in
                }, cancel: {
            })
            
        }else {
            reorderAllitems()
        }
    }
    
    @IBAction func actionSupport(_ sender: UIButton){
        self.openMail(toMail: [/AgentCodeClass.shared.settingData?.email], subject: "Issue wth OrderID " + /orderDetails?.orderId, body: "")
        //UtilityFunctions.shareContentOnSocialMedia(withViewController: UtilityFunctions.sharedAppDelegateInstance().window?.rootViewController, message: /AgentCodeClass.shared.settingData?.email + " Issue wth OrderID " + /orderDetails?.orderId)
    }
    
    
    @IBAction func payNow(_ sender: Any) {
        guard let order = orderDetails else { return }
        var type = getAllowedPaymentType() ?? .Card
        if type == .COD {
            //show both card and COD
            type = .DoesntMatter
        }
        makePayment(order: order, type: order.paymentType == .Card ? .Card : type)
    }
    
    
    func makePayment(order: OrderDetails, type: PaymentMethod) {
        
        let storyboard = UIStoryboard(name: "Options", bundle: nil)
        guard let vc =
            storyboard.instantiateViewController(withIdentifier: "PaymentVC") as? PaymentVC else { return }
        if let gateways = geofenceTaxdata?.payment_gateways, !gateways.isEmpty {
            vc.filterGateways = gateways
            if gateways.containsIgnoringCase("cod") {
                vc.type = .DoesntMatter
            }
            else {
                vc.type = .Card
            }
        }
        else {
            vc.type = type
        }
        //this closure ll give you token and name of payment gateway
        vc.returnPaymentDetail = { token , paymentgatewayName , card_id in
            var selectedPaymentMethod: PaymentMode?
            switch paymentgatewayName {
                
            case "MyFatoorah":
                print(token)
                selectedPaymentMethod = PaymentMode(paymentType: .Card, gatewayUniqueId: "myfatoorah", token: "")
                    
            case "SADAD":
                print(token)
                selectedPaymentMethod = PaymentMode(paymentType: .Card, gatewayUniqueId: "sadded", token: "")
                
            case "Square":
                print(token)
                selectedPaymentMethod = PaymentMode(paymentType: .Card, gatewayUniqueId: "squareup", token: token, card_id: card_id)
                
            case "Conekta":
                print(token)
                selectedPaymentMethod = PaymentMode(paymentType: .Card, gatewayUniqueId: "conekta", token: token)
                
            case "Stripe":
                print(token)
                selectedPaymentMethod = PaymentMode(paymentType: .Card, gatewayUniqueId: "stripe", token: token, card_id: card_id)
            //razorpay //conekta
            case "Paypal":
                print(token)
                selectedPaymentMethod = PaymentMode(paymentType: .Card, gatewayUniqueId: "paypal", token: token)
            case "Venmo":
                print(token)
                selectedPaymentMethod = PaymentMode(paymentType: .Card, gatewayUniqueId: "venmo", token: token)
                
            case "Zelle":
                print(token)
                selectedPaymentMethod = PaymentMode(paymentType: .Card, gatewayUniqueId: "zelle", token: token)
                
            case "Paystack":
                print(token)
                selectedPaymentMethod = PaymentMode(paymentType: .Card, gatewayUniqueId: "paystack", token: token)
                
            case "Cash On Delivery":
                selectedPaymentMethod = PaymentMode(paymentType: .COD)
                
                
            default:
                break
            }
            
            if let paymentDetails = selectedPaymentMethod {
                var payAmount = Double()
                
                if /self.orderDetails?.shouldPayAfterConfirmation {
                    payAmount = Double(/self.orderDetails?.netAmount)!
                }
                else if /self.orderDetails?.shouldPayRemainingAmount {
                    payAmount = self.orderDetails?.remaining_amount ?? 0
                }
                
                
                if paymentDetails.gatewayUniqueId == "sadded" {
                    self.getSADADPaymentUrl(amount: payAmount)
                }else if paymentDetails.gatewayUniqueId == "myfatoorah"{
                    self.getMyFatoorahPaymentUrl(amount: payAmount)
                }else {
                    self.makePaymentAPI(order: order, paymentMode: paymentDetails, vc: vc)
                }
            }
        }
        self.pushVC(vc)
    }
    
    func getAllowedPaymentType() -> PaymentMethod? {
        
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
    
    func makePaymentAPI(order: OrderDetails, paymentMode: PaymentMode, vc: UIViewController)  {
        if /self.orderDetails?.shouldPayRemainingAmount {
            let objR = API.payRemainingAmount(orderId: /order.orderId, paymentType: paymentMode)
            
            APIManager.sharedInstance.opertationWithRequest(isLoader: true, withApi: objR) { [weak self] (response) in
                switch response {
                case APIResponse.Success(let _):
                    order.payment_status = 1
                    self?.tableView.reloadData()
                    SKToast.makeToast("Payment done successfully".localized())
                    vc.popVC()
                    break
                default :
                    break
                }
            }
        }
        else {
            let objR = API.makePayment(orderId: /order.orderId, paymentType: paymentMode)
            
            APIManager.sharedInstance.opertationWithRequest(isLoader: true, withApi: objR) { [weak self] (response) in
                switch response {
                case APIResponse.Success(let _):
                    order.payment_status = 1
                    self?.tableView.reloadData()
                    SKToast.makeToast("Payment done successfully".localized())
                    vc.popVC()
                    break
                default :
                    break
                }
            }
        }

    }
}

//}
//MARK: - Configure Reorder
extension OrderDetailController{
    
    func ReloadloadTableData(currentIndex:Int)  {
        
        orderDetails = orderHistory?.orderDetails?[currentIndex]
        addSupplierImage()
        tableView.reloadData()
    }
    
    func reorderAllitems(){
        self.webServiceAddToCart()
    }
    
    func webServiceAddToCart() {
        
        guard let products = orderDetails?.product else { return }
        self.btnReOrder.isUserInteractionEnabled = false
        
        let params = FormatAPIParameters.AddToCart(
            cart: products,
            supplierBranchId: products[0].supplierBranchId,
            promotionType: nil,
            remarks: "").formatParameters()
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.AddToCart(params)) {
            [weak self] (response) in
            guard let self = self else { return }
            
            switch response {
            case .Success( _):
                var productIds = [String]()
                
                guard let products = self.orderDetails?.product else {
                    self.btnReOrder.isUserInteractionEnabled = true
                    return }
                DBManager.sharedManager.cleanCart()
                
                for product in products {
                    guard let productId = product.product_id else {return}
                    productIds.append(productId)
                }
                self.checkProductList(ids: productIds, products: products)
                
            case .Failure(_):
                self.btnReOrder.isUserInteractionEnabled = true
                break
            }
        }
    }
    
    
    func checkProductList(ids: [String],products: [ProductF]) {
        
        let objR = API.checkProductList(product_ids: ids)
        APIManager.sharedInstance.opertationWithRequest(withApi: objR) {
            (result) in
            
            switch result {
            case .Success(let object):
                guard let obj = object as? CheckProductList else {return}
                //     guard let productsData = self.orderDetails?.product else {return}
                guard let results = obj.result else {return}
                var productIds = [String]()
                
                for product in products {
                    APIManager.sharedInstance.showLoader()
                    if let index = results.firstIndex(where: {$0.product_id ?? "" == product.product_id ?? ""}){
                        if let radiusPrice = results[index].radius_price {
                            product.radius_price = radiusPrice
                        }
                    }
                    guard let productId = product.product_id else {return}
                    productIds.append(productId)
                    
                    if let addons = product.productDetailAddson {
                        
                        let grouped = Dictionary(grouping: addons) { (addon) -> Int in
                            return addon.serial_number ?? 0
                        }
                        print(grouped)
                        if grouped.count == 0 { return }
                        var arrayAddons = [[AddonValueModal]]()
                        for item in grouped {
                            var typeId = ""
                            var addon = [AddonValueModal]()
                            var addonId = ""
                            for value in item.value {
                                let obj = AddonValueModal(price: value.price ?? "", id: value.adds_on_id, name: value.adds_on_name ?? "", type_name: value.adds_on_type_name ?? "", type_id: value.adds_on_type_jd ?? "",add_on_id_ios : value.add_on_id_ios ?? "")
                                addon.append(obj)
                                if let id = value.adds_on_type_jd {
                                    typeId = typeId + id
                                }
                                addonId = value.add_on_id_ios ?? ""
                            }
                            
                            arrayAddons.append(addon)
                            self.saveDataToDb(product: product ,quantity: item.value[0].quantity ?? 0, productId: productId, array: arrayAddons, typeId: typeId, addonId: addonId,addonValue: addon, totalProductQuant: grouped.count)
                        }
                        
                    } else {
                        guard let quant = product.quantity else {return}
                        self.saveDataToDb(product: product, quantity: Int(quant) ?? 0, productId: productId, array: nil, typeId: nil, addonId: nil, addonValue: nil, totalProductQuant: nil )
                    }
                    
                }
                
                self.btnReOrder.isUserInteractionEnabled = true
                GDataSingleton.sharedInstance.currentCategoryId = products.first?.categoryId
                let VC = StoryboardScene.Options.instantiateCartViewController()
                GDataSingleton.sharedInstance.fromCart = true
                APIManager.sharedInstance.hideLoader()
                self.pushVC(VC)
                //
                break
            case .Failure(_):
                APIManager.sharedInstance.hideLoader()
                break
            }
        }
        
    }
    
    func saveDataToDb(product: ProductF?, quantity: Int, productId: String, array: [[AddonValueModal]]?,typeId: String?, addonId: String?,addonValue: [AddonValueModal]?, totalProductQuant : Int?)   {
        
        guard let productObj = product else {return}
        if let data = array {
            productObj.arrayAddonValue = data
            productObj.typeId = typeId ?? ""
            productObj.addOnId = addonId ?? ""
            productObj.addOnValue = addonValue
            let obj = AddonsModalClass(productId: productId, addonId: addonId ?? "", addonData: data , quantity: quantity, typeId: typeId ?? "")
            DBManager.sharedManager.manageAddon(addonData: obj)
            
            DBManager.sharedManager.manageCart(product: productObj, quantity: totalProductQuant ?? 0)
            
        } else {
            DBManager.sharedManager.manageCart(product: productObj, quantity: quantity)
            //            DBManager.sharedManager.getTotalQuantityPerProduct(productId: productId ) { (quanti) in
            //                guard let qaunt = Int(quanti) else {return}
            //                DBManager.sharedManager.manageCart(product: productObj, quantity: quantity)
            //            }
        }
        
    }
    
    
}

//MARK: - Add Supplier Image
extension OrderDetailController {
    
    func addSupplierImage() {
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.SupplierImage(FormatAPIParameters.SupplierImage(supplierBranchId: orderDetails?.supplierBranchId).formatParameters())) {[weak self] (response) in
            switch response{
            case .Success(let object):
                guard let image = object as? String else { return }
                self?.addFloatingButton(isCategoryFlow: false, image: image.components(separatedBy :" ").first,supplierId:image.components(separatedBy: " ").last,supplierBranchId: self?.orderDetails?.supplierBranchId )
            default :
                break
            }
        }
    }
    @IBAction func actionCart(sender: AnyObject) {
        
        let vc = CartViewController.getVC(Stortyboad.options)
        pushVC(vc)
        
    }
    
}

extension OrderDetailController{
    
    func cancelOrderWebservice(){
        // guard let indexpath = tableView.indexPath(for: cell) else { return }
        //        tableView.beginUpdates()
        //        dataSource.items?.remove(at: indexpath.row)
        //        orderListing?.orders?.remove(at: indexpath.row)
        //        tableView.deleteRows(at: [indexpath], with: .top)
        //        tableView.endUpdates()
        //  viewPlaceholder?.isHidden = (dataSource.items?.count ?? 0) > 0 ? true : false
        APIManager.sharedInstance.opertationWithRequest(withApi: API.CancelOrder(FormatAPIParameters.CancelOrder(orderId: orderDetails?.orderId,isScheduled: "0").formatParameters())) { (response) in
            switch response {
            case .Success(_):
                
                self.popToRootVC()
                break
            case .Failure(_):
                break
            }
        }
    }
    
}

extension OrderDetailController: MFMailComposeViewControllerDelegate{
    
    func openMail( toMail:[String]?, subject:String?, body:String?){
        if MFMailComposeViewController.canSendMail() {
            let picker = MFMailComposeViewController()
            picker.mailComposeDelegate = self
            
            if let subjectText = subject {
                picker.setSubject(subjectText)
            }
            if let bodyText = body {
                picker.setMessageBody(bodyText, isHTML: false)
            }
            picker.setToRecipients(toMail)
            present(picker, animated: true, completion: nil)
        }else{
            
        }
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        switch result {
        case MFMailComposeResult.cancelled:
            print("Mail cancelled")
        case MFMailComposeResult.saved:
            print("Mail saved")
        case MFMailComposeResult.sent:
            print("Mail sent")
        case MFMailComposeResult.failed:
            print("Mail sent failure: \(/error?.localizedDescription)")
        default:
            break
        }
        //            self.dismissViewControllerAnimated(true, completion: nil)
        dismiss(animated: true, completion: nil)
    }
}



//MARK: - Payment gateway webviews
extension OrderDetailController {
    func getSADADPaymentUrl(amount: Double) {
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.getSadadPaymentUrl(name: /GDataSingleton.sharedInstance.loggedInUser?.firstName, email: /GDataSingleton.sharedInstance.loggedInUser?.email, amount: "\(amount)")) { [weak self] (response) in
            switch response {
            case .Success(let object):
                guard let self = self else { return }
                APIManager.sharedInstance.hideLoader()
                guard let data = object as? SadadPaymentdata else {return}
                
                let selectedPaymentMethod = PaymentMode(paymentType: .Card, gatewayUniqueId: "sadded", token: data.transactionReference)
                if let paymentUrl = data.paymentUrl, !paymentUrl.isEmpty {
                    
                    let vc = PaymentWebviewVC.getVC(.payment)
                    vc.urlStr = paymentUrl
                    vc.gatewayUniqueId = /selectedPaymentMethod.gatewayUniqueId
                    vc.paymentSucccessBlock = { token in
                        
                        self.makePaymentAPI(order: self.orderDetails!, paymentMode: selectedPaymentMethod, vc: vc)

                    }
                    self.pushVC(vc)
                }
                
            default:
                APIManager.sharedInstance.hideLoader()
                break
                
            }
        }
    }
    
    func getMyFatoorahPaymentUrl(amount: Double) {
        
        APIManager.sharedInstance.opertationWithRequest(withApi: API.getMyFatoorahPaymentUrl(currency: Constants.currencyName, amount: "\(amount)")) { [weak self] (response) in
            switch response {
            case .Success(let object):
                guard let self = self else { return }
                APIManager.sharedInstance.hideLoader()
                guard let data = object as? MyFatoorahPaymentdata else {return}
                
                if let paymentUrl = data.PaymentURL, !paymentUrl.isEmpty {
                    
                    let vc = PaymentWebviewVC.getVC(.payment)
                    vc.urlStr = paymentUrl
                    vc.gatewayUniqueId = "myfatoorah"

                    vc.paymentSucccessBlock = { token in
                        
                        let selectedPaymentMethod = PaymentMode(paymentType: .Card, gatewayUniqueId: "myfatoorah", token: token)

                        self.makePaymentAPI(order: self.orderDetails!, paymentMode: selectedPaymentMethod, vc: vc)
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
