//
//  CartBillCell.swift
//  Clikat
//
//  Created by cblmacmini on 5/11/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import SZTextView
import Material
import CoreLocation
import Cosmos

class UploadImage {
    var imageUrl: String?
    var isPlaceholder = false
    var image: UIImage?
    
    init(placeholder: Bool = false, url: String? = nil, image: UIImage? = nil) {
        self.isPlaceholder = placeholder
        self.imageUrl = url
        self.image = image
    }
}

extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

class CartBillCell: ThemeTableCell {
    
    //MARK:- IBOutlet
    
    @IBOutlet var txtPrescription: SZTextView! {
        didSet {
            if APIConstants.defaultAgentCode == "cannadash_0180" {
                txtPrescription.placeholder = "Enter your medical id".localized();
            }else{
                txtPrescription.placeholder = "Enter instructions here ".localized()
            }
        }
    }
    @IBOutlet var stackImgPrescription: UIStackView!
    @IBOutlet var lblTItleImgPrescription: ThemeLabel!
    @IBOutlet var collectionView: UICollectionView!{
        didSet{
            collectionView?.registerCells(nibNames: ["UploadImageCollectionCell"])
            collectionView?.delegate = self
            collectionView?.dataSource = self
        }
    }
    @IBOutlet weak var tipStackView: UIStackView!
    @IBOutlet weak var labelTipAmount: UILabel?
    @IBOutlet weak var stackServiceCharge: UIStackView?
    @IBOutlet weak var labelTextServiceChargeAmount: UILabel?
        {
        didSet{
            if AgentCodeClass.shared.settingData?.user_service_fee == "1" {
                let supplier = TerminologyKeys.supplier.localizedValue() as? String ?? ""
                labelTextServiceChargeAmount?.text = "\(supplier) \("Service Charge".localized())"
            }else{
               // labelTextServiceChargeAmount?.text = "Tip Amount"
            }
        }
    }
    @IBOutlet weak var labelServiceCharge: UILabel? {
        didSet {
            labelServiceCharge?.setReverseAlignment()
        }
    }
    @IBOutlet weak var tipCollectionView: UICollectionView?{
           didSet{
               tipCollectionView?.delegate = self
               tipCollectionView?.dataSource = self
           }
       }
    @IBOutlet weak var btnClearTip: UIButton?{
        didSet{
            btnClearTip?.setTitleColor(cartAppType.color, for: .normal)
        }
    }
    @IBOutlet weak var lblReferalAmountApplied: UILabel!{
        didSet {
            lblReferalAmountApplied.setReverseAlignment()
        }
    }
    @IBOutlet weak var btnApplyreferal: UIButton!
    @IBOutlet weak var lblYourReferalAmount: UITextField!
    @IBOutlet weak var viewReferalAmount: UIView!
    @IBOutlet weak var promoStack_heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var promotionView: UIView!{
        didSet {
            promotionView.backgroundColor = cartAppType.elementAlphaColor
        }
    }
    @IBOutlet weak var stackViewReferalDiscount: UIStackView!
    @IBOutlet weak var labelHandlingCharges: UILabel! {
        didSet {
            labelHandlingCharges.setReverseAlignment()
        }
    }
    @IBOutlet weak var labelTotalPrice : UILabel! {
        didSet {
            labelTotalPrice.setReverseAlignment()
        }
    }
    @IBOutlet weak var labelDeliveryCharges : UILabel! {
        didSet {
            labelDeliveryCharges.setReverseAlignment()
        }
    }
    @IBOutlet weak var labelSubTotal: UILabel! {
        didSet {
            labelSubTotal.setReverseAlignment()
        }
    }
    @IBOutlet weak var labelNetTotal: UILabel! {
        didSet {
            labelNetTotal.setReverseAlignment()
        }
    }
    @IBOutlet weak var labelDiscont: UILabel! {
        didSet {
            labelDiscont.setReverseAlignment()
        }
    }
    @IBOutlet weak var labelSubTotalHeading : UILabel!
    @IBOutlet weak var tfPromoCode: UITextField! {
        didSet {
            tfPromoCode.setAlignment()
        }
    }
    @IBOutlet weak var btnAddPromo: UIButton!
    @IBOutlet weak var lblDiscount: UILabel!
    @IBOutlet weak var stackDiscount: UIStackView!
    @IBOutlet weak var stackPriceDetail: UIStackView!
    @IBOutlet weak var tvRemarks : SZTextView!
    @IBOutlet weak var promo_stackView: UIStackView!
    @IBOutlet weak var icDiscount: UIImageView!{
        didSet{
            icDiscount.tintColor = cartAppType.color
        }
    }
    @IBOutlet weak var stackTips: UIStackView!
    @IBOutlet weak var lblTotalTipAmountTitle: ThemeLabel!
    @IBOutlet weak var lblTotalTip: UILabel! {
        didSet {
            lblTotalTip.setReverseAlignment()
        }
    }
    @IBOutlet var stackTimeSlot: UIStackView!
    @IBOutlet var btnTimeSlot: ThemeButton!
    
    //Time slot and agent booked details
    @IBOutlet var lblServiceDate: UILabel!
    @IBOutlet var lblServiceTime: UILabel!
    @IBOutlet var imgProfileAgent: UIImageView!
    @IBOutlet var viewSlotDetails: UIView!
    {
        didSet {
            viewSlotDetails.backgroundColor = cartAppType.elementAlphaColor
        }
    }
    @IBOutlet var lblAgent: UILabel!
    @IBOutlet var lblServiceProvider: UILabel!
    @IBOutlet var viewAgentRating: CosmosView!
    @IBOutlet var lblAgentReviews: UILabel!
    @IBOutlet var stackDeliveryCharge: UIStackView!
    @IBOutlet var stackAddOnCharge: UIStackView!
    @IBOutlet var lblAddOnCharge: UILabel! {
        didSet {
            lblAddOnCharge.setReverseAlignment()
        }
    }
    
    //MARK:- Variable
    var subtotalBill:String?
    var blockPromoCode:((PromoCode?) -> ())?
    var blockUserServiceCharge:((Double?) -> ())?
    var referralApplied:((Bool) -> ())?
    var promoCode: PromoCode? {
        didSet {
           // btnAddPromo.isSelected = promoCode != nil
            tfPromoCode.isUserInteractionEnabled = promoCode == nil
            tfPromoCode.text = promoCode?.code?.uppercased()
        }
    }
    var netTotal: Double = 0
    var arrPrescription = [UploadImage(placeholder: true)]
    var selectedAgentId: CblUser?
    var base_delivery_charges: Double = 0
    
//    var cart : [Cart]?{
//        didSet{
//            updateUI()
//        }
//    }
//
    var newCart : [Cart]?{
        didSet{
            updateNewUI()
        }
    }
    static var idArray = [String]()
    var fromCartView = false
    var appliedReferral = false {
        didSet {
            stackViewReferalDiscount.isHidden = !appliedReferral
            btnApplyreferal.setTitle(appliedReferral ? "Remove" : "Apply", for: .normal)
        }
    }
    var tipItems = [Int]() //[1,2,3,4,5]//[Int]()
    var tipAmount : Int = 0{
        didSet{
            labelTipAmount?.isHidden = true
        }
    }
    var region_delivery_charge: Double?
    var selectTimeSlotBlock: EmptyBlock?
    var cartAppType: SKAppType { //Doctor
        return SKAppType(rawValue: GDataSingleton.sharedInstance.cartAppType ?? 1) ?? .food
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        lblDiscount.isHidden = cartAppType.isJNJ
        stackDiscount.isHidden = cartAppType.isJNJ
        stackPriceDetail.isHidden = cartAppType.isJNJ
        //self.promoStack_heightConstraint.constant = 0
        self.tfPromoCode.delegate = self
        self.promo_stackView.isHidden = true
        
        viewReferalAmount.isHidden = Int(GDataSingleton.sharedInstance.referalAmount ?? 0.0) == 0
        lblYourReferalAmount?.text = "Your referal Amount : " + "\(GDataSingleton.sharedInstance.referalAmount ?? 0.0)"
        stackViewReferalDiscount.isHidden = true
        stackTimeSlot.isHidden = cartAppType != .home
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    @IBAction func btnActionAppReferal(_ sender: UIButton) {
        appliedReferral = !appliedReferral
        referralApplied?(appliedReferral)
        (self.superview as? UITableView)?.reloadData()
    }
    
        @IBAction func actionClear(_ sender: UIButton){
            
    //        updateUI()
            clearTipData()
            updateNewUI()
        }
    
    func clearTipData() {
        labelTipAmount?.isHidden = true
        tipAmount = 0
        GDataSingleton.sharedInstance.tipAmount = tipAmount
    }
    
    @IBAction func chooseTimeSlot(_ sender: Any) {
        selectTimeSlotBlock?()
    }
}

extension CartBillCell{
    
    //Promo code
    @IBAction func redeemBtnClick(sender:UIButton){
        
        if tfPromoCode.text?.count == 0 && sender.isSelected {
            self.promoCode = nil
            self.promo_stackView.isHidden = true
            self.tfPromoCode.text = ""
            if !self.promo_stackView.isHidden {
                self.promo_stackView.isHidden = true
                (self.superview as? UITableView)?.reloadData()
            }
            return
        } else if tfPromoCode.text?.count == 0 {
            return
        }
        self.endEditing(true)
        sender.isSelected = !sender.isSelected
        
        guard let _ = GDataSingleton.sharedInstance.loggedInUser?.firstName else{
            UtilityFunctions.sharedAppDelegateInstance().window?.rootViewController?.presentVC(StoryboardScene.Register.instantiateLoginViewController())
            return
        }
        
        if !sender.isSelected {
           // self.labelDiscont.text = 0.addCurrencyLocale
            self.promoCode = nil
            self.updateNewUI()

          //  self.promoStack_heightConstraint.constant = 0
            return
        }
        
        guard let arrCart = newCart else { return }
        let supplierIdArray = arrCart.map({ (cartObject: Cart) -> String in
            cartObject.supplierId ?? ""
        })
        
        let categoryIdArray = arrCart.map({ (cartObject: Cart) -> String in
            cartObject.categoryId ?? ""
        })
        let objR = API.CheckPromo(FormatAPIParameters.CheckPromo(supplierId: supplierIdArray, totalBill:/subtotalBill, promoCode: tfPromoCode.text, categoryId: categoryIdArray).formatParameters())
        
        APIManager.sharedInstance.opertationWithRequest(refreshControl: nil, isLoader: true, withApi: objR) { [weak self] (response) in
            
            guard let self = self else { return }
            
            switch response {
            case .Success(let object):
                let obj = object as? PromoCode
                if obj != nil {
                    obj?.code = /self.tfPromoCode.text
                    self.promoCode = obj
                    self.updateNewUI()

//                    if let minOrder = obj?.minOrder {
//                        if let subtotal = self.subtotalBill {
//                            let subDouble = Double(subtotal)
//                            if minOrder > subDouble ?? 0.0{
//                                SKToast.makeToast("Sorry! Minimum cart value should be 500")
//                                return
//                            } else {
//
//                            }
//                        }
//                    }
                }
                
            default:
                APIManager.sharedInstance.hideLoader()
                self.tfPromoCode.text = ""
                self.btnAddPromo.isSelected = false
               // self.promoStack_heightConstraint.constant = 0
                break
            }

        }
        
    }
    
}

extension CartBillCell {
    
//    static func getTotalPrice(promo: PromoCode?, total: Double = 0.0, delivery: Double = 0.0, qtyTotal: Int = 0, again:Bool = false,discountOnTotal: Double = 0.0, index: Int = 0, cart: [Cart], block: ((Double, Double, Double, Int) -> ())?) {
//
//        if cart.isEmpty {
//            block?(0.0, 0.0, 0.0, 0)
//            return
//        }
//
//        let obj = cart[index]
//
//        obj.getPerPrice { (priceD) in
//
//            var price = (/obj.quantity?.toDouble() * priceD)
//            //For Home service
//            if obj.priceType == PriceType.Hourly {
//                price = priceD
//            }
//            var newDelivery :Double = 0
//            //Calculate delivery charged for Home and Food
//            if DeliveryType.shared == .delivery && cartAppType != .eCom {
//                if let distance = getDeliveryDistance(cart: cart) {
//                  newDelivery = /obj.radius_price?.toDouble
////                  newDelivery = newDelivery > delivery ? newDelivery : delivery
//
//                  let deliveryCharge = distance * newDelivery
//                  newDelivery = deliveryCharge
//                }
//            }
//            else {
//                newDelivery = /Double(/obj.deliveryCharges)
//            }
//
//            var newDiscount = discountOnTotal
//            var newQty = qtyTotal
//            //For Home service
//            if obj.priceType == PriceType.Hourly {
//                newQty += obj.hourlyQuantity.toInt
//            }
//            else {
//                newQty += /obj.quantity?.toInt()
//            }
//            if let categoryId = obj.categoryId?.toInt(), (promo?.categoryIds ?? []).contains(categoryId) {
//                newDiscount += price
//            } else if let supplierId = obj.supplierId?.toInt(), (promo?.supplierIds ?? []).contains(supplierId) {
//                newDiscount += price
//            }
//            price = total + price
//
//             //Nitin - for food
//            var dictArray = [Dictionary<String,String>]()
//            for cartObj in cart {
//                var dict = Dictionary<String,String>()
//                if let productId = cartObj.id {
//                    if let id = cartObj.addOnId {
//                        dict[productId] = id
//                    } else {
//                        dict[productId] = ""
//                    }
//                    dictArray.append(dict)
//                }
//            }
//            dictArray = dictArray.removingDuplicates()
//            print(dictArray)
//            for dict in dictArray {
//                //if again {continue}
//                for (key,value) in dict {
//                    if value == "" {
//                        continue
//                    } else {
//                        let productId = key
//                        if obj.id ?? "" != productId {continue}
//                        let addonId = value
//                        DBManager.sharedManager.getTypeIdsOfAddonId(productId: productId, addonId: addonId) { (typeIdArray) in
//                            if typeIdArray.count == 0 {return}
//                            for i in 0...typeIdArray.count-1 {
//                                DBManager.sharedManager.getAddonsDataFromDbAcctoTypeId(productId: productId, addonId: addonId, typeId: typeIdArray[i]) { (arrayAddons) in
//                                    guard let data = arrayAddons.first else {return}
//                                    guard let quantity = data.quantity?.toDouble else {return}
//                                    let index = data.addonData?.count == 1 ? 0 : i
//                                    if data.addonData?.count ?? 0 > 0 {
//                                        guard let addonsInfo = data.addonData?[index] else {return}
//                                        addonsInfo.forEach { (model) in
//                                            if let addonPrice = model.price?.toDouble() {
//                                                price += (addonPrice * quantity)
//                                            }
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//            }
//            if index < dictArray.count-1 {
//                CartBillCell.getTotalPrice(promo: promo, total: price, delivery: newDelivery, qtyTotal: newQty,again: true, discountOnTotal: newDiscount, index: index+1, cart: cart, block: block)
//            } else {
//                block?(price, newDelivery, newDiscount, newQty)
//            }
//        }
//    }
    
//    func updateUI() {
//        labelSubTotalHeading?.text = L10n.SubTotal.string
//
//        guard let arrCart = cart else { return }
//
//        tvRemarks.font = UIFont(openSans: .boldItalic, size: 15.0)
//
//        CartBillCell.getTotalPrice(promo: self.promoCode, cart: arrCart) {
//            [weak self] (totalPrice, deliveryCharges, discountOnTotal, qtyTotal) in
//            guard let self = self else { return }
//
//            var discount = 0.0
//
//            if let promoCode = self.promoCode {
//
//                let isPercent = promoCode.discountType == 1
//                let discountPrice = /promoCode.discountPrice
//
//                if isPercent {
//                    discount = discountOnTotal * discountPrice/100
//                } else {
//                    if discountPrice > discountOnTotal {
//                        discount = discountOnTotal
//                    } else {
//                        discount = discountPrice
//                    }
//                }
//            }
//            discount = discount.rounded()
//
//            let maxSupplier = /Double(Cart.getMaxSupplier(cart: arrCart) ?? "0")
//            let maxAdmin = /Double(Cart.getMaxAdmin(cart: arrCart) ?? "0")
//            var handlingCharges = Double()
//
//            if self.fromCartView {
//                handlingCharges = maxAdmin.rounded()
//            } else {
//               handlingCharges =  (maxAdmin/100)*totalPrice.rounded()
//            }
//            Cart.totalTax = String(handlingCharges)
//            let subTotal = (totalPrice + deliveryCharges + handlingCharges)//+ handlingCharges
//            self.subtotalBill = subTotal.toString
//
//            let netTotal = (subTotal - discount)
//
//            // Nitin, price replaced for ui
//            self.labelTotalPrice.text = netTotal.addCurrencyLocale // totalPrice.addCurrencyLocale
//            self.labelDeliveryCharges.text =  deliveryCharges.addCurrencyLocale
//            self.labelHandlingCharges?.text = handlingCharges.addCurrencyLocale
//
//            self.labelSubTotal?.text = totalPrice.addCurrencyLocale //  subTotal.addCurrencyLocale
//
//            self.labelDiscont.text = discount.addCurrencyLocale
//            self.labelNetTotal?.text = netTotal.addCurrencyLocale
//
//            self.promoCode?.totalAmountOnDiscount = subTotal
//            self.promoCode?.totalDiscount = discount
//
//            if let _ = self.promoCode, discount <= 0.01 {
//                self.promoCode = nil
//                SKToast.makeToast("Promo Code is applicable on seleted products")
//            }
//            self.blockPromoCode?(self.promoCode)
//        }
//    }
    
    func updateNewUI() {
        stackImgPrescription.isHidden = !AppSettings.shared.cartImageUpload
        txtPrescription.isHidden = !AppSettings.shared.orderInstructions
        stackTimeSlot.isHidden = cartAppType != .home

        if tipStackView.isHidden && tipAmount > 0 {
            clearTipData()
        }
        stackTips.isHidden = tipAmount == 0

        stackDeliveryCharge.isHidden = cartAppType == .home

        if selectedAgentId == nil {
            viewSlotDetails.isHidden = true
            btnTimeSlot.isHidden = false
        }
        else {
            viewSlotDetails.isHidden = false
            btnTimeSlot.isHidden = true
            setSelectedAgentDetails()
        }
        
        labelSubTotalHeading?.text = L10n.SubTotal.string
        
        let referralAmount = Double(GDataSingleton.sharedInstance.referalAmount ?? 0.0)
        viewReferalAmount.isHidden = Int(GDataSingleton.sharedInstance.referalAmount ?? 0.0) == 0
        lblYourReferalAmount?.text = "Your referal Amount : " + "\(referralAmount.addCurrencyLocale)"
        let referralAmountApplied: Double = self.appliedReferral ? referralAmount : 0

        lblReferalAmountApplied.text = "- " + referralAmountApplied.addCurrencyLocale
        
        guard let arrCart = newCart else { return }
        
        
        //Add ons in home service
        var addOnCharge: Double = 0
        if cartAppType == .home {
            //I home service only 1 product allowed to be added
            let product = arrCart.first
            if let questions = product?.questionsSelected, !questions.isEmpty {
                addOnCharge = questions.addOnPrice(productPrice: Double(/product?.getPrice(quantity: (Double((product?.quantity)!) ?? 1))))
                ///(product?.stepValue ?? 1)
            }
        }
        
        stackAddOnCharge.isHidden = addOnCharge == 0
        lblAddOnCharge.text = addOnCharge.addCurrencyLocale
        
        tvRemarks.font = UIFont(openSans: .boldItalic, size: 15.0)

        CartBillCell.getNewTotalPrice(promo: self.promoCode, addOnCharges: addOnCharge, cart: arrCart, minDelCharges: base_delivery_charges, region_delivery_charge: region_delivery_charge) {
            [weak self] (totalPrice, deliveryCharges, discountOnTotal, handlingCharges, qtyTotal) in
            guard let self = self else { return }
            
            var discount = 0.0
            
            if let promoCode = self.promoCode {
                
                if let minOrder = promoCode.minOrder {
                   if discountOnTotal == 0 || minOrder > discountOnTotal {
                    if discountOnTotal == 0 {
                        SKToast.makeToast("Sorry! discount not applicable on these products")
                    }
                    else {
                        SKToast.makeToast("Sorry! Minimum cart value should be \(minOrder.addCurrencyLocale)")
                    }
                    self.promoCode = nil
                    if !self.promo_stackView.isHidden {
                        self.promo_stackView.isHidden = true
                        (self.superview as? UITableView)?.reloadData()
                    }
                    self.tfPromoCode.text = ""
                    self.btnAddPromo.isSelected = false
                       return
                   }
                   else if self.promo_stackView.isHidden {
                       self.promo_stackView.isHidden = false
                       (self.superview as? UITableView)?.reloadData()
                    }
                }
                let isPercent = promoCode.discountType == 1
                let discountPrice = /promoCode.discountPrice

                if isPercent {
                    discount = Double((discountOnTotal * discountPrice/100).decimal(min: 2, upto: 2))!
                } else {
                    if discountPrice > discountOnTotal {
                        discount = /Double(discountOnTotal.decimal(min: 2, upto: 2))
                    } else {
                        discount = /Double(discountPrice.decimal(min: 2, upto: 2))
                    }
                }
            }
            else {
                if !self.promo_stackView.isHidden {
                    self.promo_stackView.isHidden = true
                    (self.superview as? UITableView)?.reloadData()
                }
            }
            //discount = discount.rounded()
            
//            let maxSupplier = /Double(Cart.getMaxSupplier(cart: arrCart) ?? "0")
//            let maxAdmin = /Double(Cart.getMaxAdmin(cart: arrCart) ?? "0")
//            var handlingCharges = Double()
//
//            if cartAppType == .food {
//                if self.fromCartView {
//                    handlingCharges = maxAdmin
//                } else {
//                    handlingCharges =  (maxAdmin/100)*totalPrice
//                }
//
//            }
//            else {
//                handlingCharges =  (maxAdmin/100)*totalPrice
//            }
         
            Cart.totalTax = String(handlingCharges)
            let subTotal = totalPrice//+ handlingCharges // deliveryCharges
            Cart.subTotal = subTotal
            self.subtotalBill = subTotal.toString
            var valueServiceCharge = DeliveryType.shared == .pickup ? 0.0 : Double(/GDataSingleton.sharedInstance.userServiceCharge)
            valueServiceCharge = subTotal * /valueServiceCharge / 100
            let valueLabelTip = Double(self.tipAmount) + Double(/valueServiceCharge)
            self.netTotal = ((totalPrice + handlingCharges + deliveryCharges + valueLabelTip + addOnCharge) - discount - referralAmountApplied)

            // Nitin, price replaced for ui
            self.labelTotalPrice.text = self.netTotal.addCurrencyLocale // totalPrice.addCurrencyLocale
            self.labelDeliveryCharges.text =  deliveryCharges.addCurrencyLocale
            self.labelHandlingCharges?.text = handlingCharges.addCurrencyLocale
            
            self.labelSubTotal?.text = totalPrice.addCurrencyLocale //  subTotal.addCurrencyLocale
            
             if valueServiceCharge == nil || valueServiceCharge == 0 {
                 self.stackServiceCharge?.isHidden = true
             }else{
                 self.stackServiceCharge?.isHidden = false
                 self.labelServiceCharge?.text = valueServiceCharge?.addCurrencyLocale
             }
            
            self.lblTotalTip?.text = Double(self.tipAmount).addCurrencyLocale
            self.labelDiscont.text = "- " + discount.addCurrencyLocale
            self.labelNetTotal?.text = self.netTotal.addCurrencyLocale
            self.blockUserServiceCharge?(valueServiceCharge)
            self.promoCode?.totalAmountOnDiscount = subTotal
            self.promoCode?.totalDiscount = discount
            
            if let _ = self.promoCode, discount <= 0.01 {
                self.promoCode = nil
                SKToast.makeToast("Promo Code is applicable on seleted products")
            }
            self.blockPromoCode?(self.promoCode)
        }
    }
    
    func setSelectedAgentDetails() {
        let date = GDataSingleton.sharedInstance.pickupDate ?? Date()
        let deliveryDatestr = UtilityFunctions.getDateFormatted(format: "yyyy-MM-dd", date: date)
        let deliveryTime = date.toString(format: Formatters.HHMMA)//UtilityFunctions.getTimeFormatted(format: "HH:mm:ss", date: date)
        
        lblServiceDate.text = deliveryDatestr
        lblServiceTime.text = deliveryTime
        guard let user = selectedAgentId else { return }
        lblAgent.text = user.name

        let occ = /user.occupation
        let exp = "\(/user.experience)" + " " + L11n.yearsExperience.string
        lblServiceProvider.text = [occ, exp].joined(separator: " | ")
        lblAgentReviews.text = "0 \(L10n.Reviews.string)"
        imgProfileAgent.loadImage(thumbnail: /user.image, original: nil, placeHolder: Asset.ic_dummy_user.image)
    }
    
    static func getNewTotalPrice(promo: PromoCode?, total: Double = 0.0, delivery: Double = 0.0, qtyTotal: Int = 0, again:Bool = false,discountOnTotal: Double = 0.0, handlingCharges: Double = 0.0, addOnCharges: Double = 0.0, index: Int = 0, cart: [Cart], minDelCharges: Double?, region_delivery_charge: Double?, block: ((Double, Double, Double, Double, Int) -> ())?) {
            
        if cart.isEmpty {
            block?(0.0, 0.0, 0.0, 0.0, 0)
            return
        }

        var newCart = [Cart]()
        var idArray = [String]()
        for cartObj in cart {
            idArray.append(cartObj.id ?? "")
        }
        idArray = idArray.removingDuplicates()
        
        for id in idArray {
            if let ind = cart.firstIndex(where: {$0.id ?? "" == id}) {
                newCart.append(cart[ind])
            }
        }

        //index is incremented at the end of the function
        let obj = newCart[index]
        let appType = SKAppType(rawValue: GDataSingleton.sharedInstance.cartAppType ?? 1) ?? .food
        obj.getPerPrice { (priceD) in
            var itemPrice = (/obj.quantity?.toDouble() * priceD)
            //For Home service
            if obj.priceType == .Hourly {
                itemPrice = priceD
            }
            
            var price = itemPrice
            var distanceBased = false
            var newDelivery :Double = 0
            //Calculate delivery charged for Home and Food
            if appType == .home {
                newDelivery = 0
            }
            else if (appType == .food) {
                if DeliveryType.shared == .delivery {
                    if /region_delivery_charge > 0 {
                        newDelivery = /region_delivery_charge + /minDelCharges
                    }
                    else {
                        if AppSettings.shared.appThemeData?.delivery_charge_type == "1"{
                            let temp = /obj.radius_price
                            newDelivery = temp + /minDelCharges
                        }else{
                            distanceBased = true
                        }
                    }
                }
            }
            else {
                //Pick the max delivery charge
                let temp = Double(/obj.deliveryCharges)! + /minDelCharges
                if temp > delivery {
                    newDelivery = temp
                }
                else {
                    newDelivery = delivery
                }
            }
            
            var newDiscount = discountOnTotal
            var newQty = qtyTotal
            //For Home service
//            if obj.priceType == PriceType.Hourly {
//                newQty += obj.hourlyQuantity.toInt
//            }
//            else {
                newQty += /obj.quantity?.toInt()
//            }

            
            //Nitin - set add on id for prouct id
            var dictArray = [Dictionary<String,String>]()
            for cartObj in newCart {
                var dict = Dictionary<String,String>()
                if let productId = cartObj.id {
                    if let id = cartObj.addOnId {
                        dict[productId] = id
                    } else {
                        dict[productId] = ""
                    }
                    dictArray.append(dict)
                }
            }
            dictArray = dictArray.removingDuplicates()
            
            if appType == .food {
                print(dictArray)
                for dict in dictArray {
                    //if again {continue}
                    for (key,value) in dict {
                        if value == "" {
                            continue
                        } else {
                            let productId = key
                            if obj.id ?? "" != productId {continue}
                            let addonId = value
                            DBManager.sharedManager.getTypeIdsOfAddonId(productId: productId, addonId: addonId) { (typeIdArray) in
                                if typeIdArray.count == 0 {return}
                                for i in 0...typeIdArray.count-1 {
                                    DBManager.sharedManager.getAddonsDataFromDbAcctoTypeId(productId: productId, addonId: addonId, typeId: typeIdArray[i]) { (arrayAddons) in
                                        guard let data = arrayAddons.first else {return}
                                        guard let quantity = data.quantity?.toDouble else {return}
                                        let index = data.addonData?.count == 1 ? 0 : i

                                        guard let addonsInfo = data.addonData?[index] else {return}
                                        addonsInfo.forEach { (model) in
                                            if let addonPrice = model.price?.toDouble() {
                                                price += (addonPrice * quantity)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                if let promoCode = promo {
                   if let categoryId = obj.categoryId?.toInt(), (promoCode.categoryIds ?? []).contains(categoryId) {
                         newDiscount += price
                    } else if let supplierId = obj.supplierId?.toInt(), (promoCode.supplierIds ?? []).contains(supplierId) {
                         newDiscount += price
                    }
                }
            }
            else {
                                                        
                if let promoCode = promo {
                   if let categoryId = obj.categoryId?.toInt(), (promoCode.categoryIds ?? []).contains(categoryId) {
                         newDiscount += itemPrice
                    } else if let supplierId = obj.supplierId?.toInt(), (promoCode.supplierIds ?? []).contains(supplierId) {
                         newDiscount += itemPrice
                    }
                }

            }
            
            let handlingAdmin = /Double(obj.handlingAdmin ?? "0")
            var tax = Double()
            tax = handlingCharges + (handlingAdmin/100)*price

            price = total + price

//            if cartAppType == .food {
//                if self.fromCartView {
//                    handlingCharges = maxAdmin
//                } else {
//                    handlingCharges =  (handlingAdmin/100)*price
//                }
//
//            }
//            else {
//                handlingCharges =  (handlingAdmin/100)*totalPrice
//            }
            
            if index < dictArray.count-1 {
                CartBillCell.getNewTotalPrice(promo: promo, total: price, delivery: newDelivery, qtyTotal: newQty,again: true, discountOnTotal: newDiscount, handlingCharges: tax, index: index+1, cart: cart, minDelCharges: minDelCharges, region_delivery_charge: region_delivery_charge, block: block)
            } else {
                if distanceBased {
                    let distance_value: Double = /obj.distanceValue
                    getDeliveryDistance(cart: cart) { (distance) in
                        if (distance - distance_value) > 0 {
                            newDelivery = ((distance - distance_value)  * /obj.radius_price) +  /minDelCharges
                        }
                        else {
                            newDelivery = /minDelCharges
                        }
                        tax = tax + (handlingAdmin/100)*addOnCharges
                        block?(price, newDelivery, newDiscount, tax, newQty)
                    }
                }
                else {
                    tax = tax + (handlingAdmin/100)*addOnCharges
                    block?(price, newDelivery, newDiscount, tax, newQty)
                }
            }
        }
    }
    
    typealias DoubleBlock = (Double) -> ()
    
    static func getDeliveryDistance(cart: [Cart], completion: DoubleBlock?){
        //Nitin for delivery charges
        var custLat : Double?
        var custLong : Double?

//        if LocationSingleton.sharedInstance.tempAddAddress != nil {
//            if let lat = LocationSingleton.sharedInstance.tempAddAddress?.lat {
//                custLat = lat
//            }
//            if let long = LocationSingleton.sharedInstance.tempAddAddress?.long  {
//                custLong = long
//            }
//        } else
        if let address = LocationSingleton.sharedInstance.searchedAddress, address.id != nil {
            if let lat = address.lat {
                custLat = lat
            }
            if let long = address.long  {
                custLong = long
            }
        }
//        else if LocationSingleton.sharedInstance.selectedAddress != nil {
//            if let lat = LocationSingleton.sharedInstance.selectedAddress?.location?.coordinate.latitude {
//                custLat = lat
//            }
//            if let long = LocationSingleton.sharedInstance.selectedAddress?.location?.coordinate.longitude {
//                custLong = long
//            }
//        }

        guard let cLat = custLat else { completion?(0); return }
        guard let cLong = custLong else { completion?(0); return }
        guard let custLatDegree = CLLocationDegrees(exactly: cLat) else { completion?(0); return }
        guard let custLongDegree = CLLocationDegrees(exactly: cLong) else { completion?(0); return }
        let custLocation = CLLocation(latitude: custLatDegree, longitude: custLongDegree)
        
        guard let supplierLat = cart[0].latitude else { completion?(0); return }
        guard let supplierLong = cart[0].longitude else { completion?(0); return }
        guard let supplierLatDegree = CLLocationDegrees(exactly: supplierLat) else { completion?(0); return }
        guard let supplierLongDegree = CLLocationDegrees(exactly: supplierLong) else { completion?(0); return }
        let supplierLocation = CLLocation(latitude: supplierLatDegree, longitude: supplierLongDegree)
        let distance = custLocation.distance(from: supplierLocation)/1000.0

        
        OtherEP.distanceBetween(sourceLat: custLatDegree , sourceLng: custLongDegree , destLat: supplierLatDegree , destLng: supplierLongDegree).request(success: {  (response) in
            if let distanceGoogle = response as? Double {
                completion?(distanceGoogle/1000.0)
            }
            else {
                completion?(distance)
            }
        }, error: { (_) in
            completion?(distance)

        }) { (_) in
            completion?(distance)
        }
        
        //return distance.abs/1000

       // return nil
    }
}

//MARK: - TextViewDelegate
extension CartBillCell : UITextViewDelegate {
}

//MARK: - TextViewDelegate

extension CartBillCell : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        if updatedText.count > 0 {
            btnAddPromo.isUserInteractionEnabled = true
        } else {
            btnAddPromo.isUserInteractionEnabled = false
        }
        return true
    }
}
//MARK::- CollectionView

extension CartBillCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == tipCollectionView {
            return /tipItems.count
        }
        return arrPrescription.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == tipCollectionView {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ShowTipCollectionViewCell", for: indexPath) as? ShowTipCollectionViewCell
                   else { return UICollectionViewCell()}
            cell.labelTip?.text = "+" + Constants.currency + "\(/tipItems[indexPath.item])"
            return cell
        }
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadImageCollectionCell", for: indexPath) as? UploadImageCollectionCell
                         else { return UICollectionViewCell()}
        let model = arrPrescription[indexPath.item]
        cell.configureCell(model)
        cell.imagePickedBlock = { [weak self] image, url in
            let obj = UploadImage(url: url, image: image)
            self?.arrPrescription.append(obj)
            self?.collectionView.reloadData()
        }
        cell.imageDeleteBlock = { [weak self] in
            self?.arrPrescription.remove(at: indexPath.item)
            //reorder ids in reload
            self?.collectionView.reloadData()
        }
        cell.imageLimitBlock = { [weak self] in
            guard let `self` = self else { return (false, 0)}
            return (self.arrPrescription.count == 6, 5)
        }
          return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == tipCollectionView {
            let text = "+" + Constants.currency + "\(/tipItems[indexPath.item])"
            let width = text.width(withConstrainedHeight: 40, font: UIFont.systemFont(ofSize: 18))
            return CGSize(width: width + 8, height: 40)
        }
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == tipCollectionView {
           tipAmount = tipAmount + /tipItems[indexPath.item]
           GDataSingleton.sharedInstance.tipAmount = tipAmount
           labelTipAmount?.text = Constants.currency + "\(tipAmount)"
           labelTipAmount?.isHidden = false
            (self.superview as? UITableView)?.reloadData()
    //        updateUI()
           //updateNewUI()
       }

    }
    
}
