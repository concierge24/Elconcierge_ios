//
//  OrderDetailCell.swift
//  Clikat
//
//  Created by cblmacmini on 5/2/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import AMRatingControl
class OrderDetailCell: ThemeTableCell {

    @IBOutlet weak var labelOrderNoText: ThemeLabel!
    @IBOutlet weak var labelOrderDetail: ThemeLabel!
    @IBOutlet weak var labelAddresText: ThemeLabel!
    @IBOutlet weak var satckViewTax: UIStackView!
    @IBOutlet weak var stackViewPromoCode: UIStackView!
    @IBOutlet var stackEstimateD: UIStackView! {
        didSet {
            stackEstimateD.alpha = SKAppType.type.isJNJ ? 0.0 : 1.0
        }
    }
    @IBOutlet weak var labelSubtotal: ThemeLabel! {
        didSet {
            labelSubtotal.setReverseAlignment()
        }
    }
    @IBOutlet weak var labelDeliveryCharges: ThemeLabel! {
        didSet {
            labelDeliveryCharges.setReverseAlignment()
        }
    }
    @IBOutlet weak var labelPromoCode: ThemeLabel!
    @IBOutlet weak var labelDiscountPrice: ThemeLabel! {
        didSet {
            labelDiscountPrice.setReverseAlignment()
        }
    }
    @IBOutlet weak var vwBgAgentH: NSLayoutConstraint!
    @IBOutlet weak var stackDelivery: UIStackView!
    @IBOutlet var lblPlacedOn: UILabel! {
        didSet {
            lblPlacedOn.setReverseAlignment()
        }
    }
    @IBOutlet var lblDeliveredOn: UILabel! {
        didSet {
            lblDeliveredOn.setReverseAlignment()
        }
    }
    @IBOutlet var lblOrderNo: UILabel! {
        didSet {
            lblOrderNo.setAlignment()
        }
    }
    @IBOutlet var lblNetAmt: UILabel! {
        didSet{
            lblNetAmt.textColor = SKAppType.type.color
            lblNetAmt.setReverseAlignment()
        }
    }
    @IBOutlet var lblPaymentMethod: UILabel! {
        didSet {
            lblPaymentMethod.setReverseAlignment()
        }
    }
    @IBOutlet weak var labelTaxAmount: ThemeLabel! {
        didSet {
            labelTaxAmount.setReverseAlignment()
        }
    }
    @IBOutlet var btnTackOrder: UIButton!
    @IBOutlet var btnChat: ThemeButton!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblAddressLine1: UILabel!
    @IBOutlet var lblAddressLine2: UILabel!
    @IBOutlet weak var labelDeliveredOn: UILabel!
    @IBOutlet weak var lblOcuupation: UILabel!
    @IBOutlet weak var lblExperience: UILabel!
    @IBOutlet weak var lblAgentName: UILabel! {
        didSet{
            lblAgentName.isHidden = AppSettings.shared.isSingleVendor ? true : false
        }
    }
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var viewRating : UIView!{
        didSet{
          //  productRate = 0
        }
    }
    @IBOutlet var viewDiscount: UIStackView!
    @IBOutlet var viewReferral: UIView!
    @IBOutlet var lblReferralDiscount: ThemeLabel!
    @IBOutlet var stackTip: UIStackView!
    @IBOutlet var lblTipAmount: ThemeLabel! {
        didSet {
            lblTipAmount.setReverseAlignment()
        }
    }
    @IBOutlet var stackServiceCharge: UIStackView!{
        didSet{
            stackServiceCharge.isHidden = AgentCodeClass.shared.settingData?.user_service_fee !=
            "1"
        }
    }
    @IBOutlet var lblServiceChargeAmount: ThemeLabel! {
        didSet {
            lblServiceChargeAmount.setReverseAlignment()
        }
    }
    @IBOutlet var stackImages: UIView!
    @IBOutlet var lblTitleImages: ThemeLabel! {
        didSet {
            lblTitleImages.text = "Uploaded prescription images".localized()
        }
    }
        
    @IBOutlet var lblTitleServiceCharge: ThemeLabel! {
        didSet {
            let supplier = TerminologyKeys.supplier.localizedValue() as? String ?? ""
            lblTitleServiceCharge?.text = "\(supplier) \("Service Charge".localized())"
        }
    }
    
    @IBOutlet var collectionImages: UICollectionView! {
        didSet {
            collectionImages?.registerCells(nibNames: ["UploadImageCollectionCell"])
            collectionImages.dataSource = self
            collectionImages.delegate = self
        }
    }
    @IBOutlet var stackInstructions: UIView!
    @IBOutlet var lblTitleInstructions: ThemeLabel!
    @IBOutlet var lblPres: ThemeLabel!
    @IBOutlet var lblTitlePlacedOn: ThemeLabel!
    @IBOutlet var stackQuestions: UIStackView!
    @IBOutlet var viewQuestions: UIView!
    @IBOutlet var viewAddOn: UIStackView!
    @IBOutlet var lblAddOnCharge: ThemeLabel! {
        didSet {
            lblAddOnCharge.setReverseAlignment()
        }
    }
    @IBOutlet var viewRemainingAmount: UIStackView!
    @IBOutlet var lblPaymentAmount: ThemeLabel!
    @IBOutlet var lblTitlePaymentRemaining: ThemeLabel!
    @IBOutlet var lblAgentAvgRating: ThemeLabel!
    @IBOutlet var lblAgentReviews: ThemeLabel!
    @IBOutlet var stackDeliveryCharge: UIStackView!
    
//    let rateControl = AMRatingControl(location: CGPoint(x: 0,y: 0), empty: UIImage(asset : Asset.Ic_star_small_grey), solidImage: UIImage(asset : Asset.Ic_star_small_yellow), andMaxRating: 5)
    var rateControl: AMRatingControl!
    var subtotal: Double = 0
    var productRate : Int = 0 {
        didSet {
            
            defer {
                if !viewRating.subviews.isEmpty {
                    
                    viewRating.subviews.forEach({ $0.removeFromSuperview() })
                    rateControl = nil
                }
                let imge = UIImage(asset : Asset.Ic_star_small_yellow)?.maskWithColor(color: getColor(rating: productRate))
                rateControl = AMRatingControl(location: CGPoint(x: 0,y: 0), empty: UIImage(asset : Asset.Ic_star_small_grey), solidImage: imge, andMaxRating: 5)
                rateControl.frame = viewRating.bounds
                rateControl?.rating = productRate
                rateControl?.starWidthAndHeight = 12
                //                rateControl?.isUserInteractionEnabled = false
                viewRating.addSubview(rateControl)
            }
        }
    }
    var cblUser:CblUser?{
        
        didSet {
            guard let user = cblUser else { return }
            lblOcuupation.text = cblUser?.occupation
            lblExperience.text = "\(/cblUser?.experience) \(L11n.yearsExperience.string)"
            lblAgentName.text  = cblUser?.name
//            itemImageView?.yy_setImage(with: URL(string: /cblUser?.image), options: [.setImageWithFadeAnimation])
            itemImageView?.loadImage(thumbnail: cblUser?.image, original: nil, placeHolder: Asset.ic_dummy_user.image)
            lblAgentAvgRating.text = "\(user.avg_rating)"
            lblAgentReviews.text = user.reviewsStr

        }
        
    }
 
    var cellType : OrderCellType = .OrderHistory
    var orderDetails : OrderDetails? {
        didSet {
            //            if let term = AppSettings.shared.appThemeData?.terminology?.returnValueForKey(key: TerminologyKeys.order.rawValue) as? String{
            //                labelOrderNoText.text = term + " No.".localized()
            //            }
            //            if let term = AppSettings.shared.appThemeData?.terminology?.returnValueForKey(key: TerminologyKeys.orders.rawValue) as? String{
            //                labelOrderDetail.text = term + " Details".localized()
            //            }
            labelOrderDetail.text = L10n.OrderDetails.stringFor(appType: orderDetails?.appType)
            labelOrderNoText.text = L10n.OrderNo.stringFor(appType: orderDetails?.appType)
            btnTackOrder.setTitle(L10n.TrackOrder.stringFor(appType: orderDetails?.appType), for: .normal)
            stackDelivery.isHidden = false //orderDetails?.deliveryStatus == .pickup
            updateUI()
        }
    }
    var tax: String = ""
    var arrPrescription: [String] {
        return orderDetails?.arrPrescription ?? []
    }
    private func updateUI() {
        if AppSettings.shared.appThemeData?.chat_enable == "1" {
            btnChat.isHidden = false
        }
        else {
           btnChat.isHidden = true
        }
        
        viewRemainingAmount.isHidden = (orderDetails?.remaining_amount ?? 0) == 0 && (orderDetails?.refund_amount ?? 0) == 0
        if (orderDetails?.remaining_amount ?? 0) > 0 {
            lblTitlePaymentRemaining.text = "Payment Remaining".localized()
            lblPaymentAmount.text = (orderDetails?.remaining_amount ?? 0).addCurrencyLocale
        }
        else {
            lblTitlePaymentRemaining.text = "Refund Amount".localized()
            lblPaymentAmount.text = (orderDetails?.refund_amount ?? 0).addCurrencyLocale
        }
        
        if orderDetails?.appType == .home {
            lblPlacedOn?.text = orderDetails?.serviceDate
            lblTitlePlacedOn.text = L11n.startOn.string
            labelDeliveredOn?.text = L11n.endOn.string

            if orderDetails?.status == .Delivered {
                lblDeliveredOn?.text = orderDetails?.deliveredOn
            } else {
                if let endDate = orderDetails?.serviceDateObj?.adding(minutes: orderDetails?.duration ?? 0) {
                    lblDeliveredOn?.text = UtilityFunctions.getDateFormatted(format: OrderDateFormat.To.rawValue, date: endDate)
                }
                //labelDeliveredOn?.text = L11n.estimatedEndOn.string
            }
        }
        else {
            lblPlacedOn?.text = orderDetails?.createdOn
            switch cellType{
            case .OrderHistory,.RateOrder:
                lblDeliveredOn?.text = orderDetails?.deliveredOn
                
            case .OrderTracking,.OrderScheduled,.OrderUpcoming,.LoyaltyPoints:
                lblDeliveredOn?.text = orderDetails?.deliveredOn
            }
            
            if orderDetails?.status == .Delivered {
                labelDeliveredOn?.text = L10n.DeliveredOn.string
            } else {
                labelDeliveredOn?.text = DeliveryType.shared == .pickup ? "Picked up on" : L11n.expectedDeliveryOn.string
            }
        }
        
        

        labelAddresText.text = orderDetails?.deliveryStatus == .pickup ? "Pickup From".localized() : "Address Detail".localized()
        lblOrderNo?.text = orderDetails?.orderId
        if orderDetails?.promoCode == ""{
            self.stackViewPromoCode.isHidden = true
        } else {
            self.stackViewPromoCode.isHidden = false
            labelPromoCode.text = orderDetails?.promoCode ?? ""
        }
        
        let netAmount = /orderDetails?.netAmount?.toDouble()
        let discount = /orderDetails?.discountAmount?.toDouble()
        let delivery = /orderDetails?.delivery_charges?.toDouble()
        let taxValue = self.tax.toDouble() ?? 0.0
        let referralDiscount = /orderDetails?.referral_amount
        let tipAmount = /orderDetails?.tipAgent?.toDouble()
        let serviceChargeAmount =  /orderDetails?.user_service_charge?.toDouble()
        //Add ons in home service
        let addOnCharge: Double = orderDetails?.addOn ?? 0
        
        subtotal = orderDetails?.subTotal ?? 0//netAmount - (delivery+taxValue+addOnCharge+tipAmount)
        
        lblAddOnCharge.text = addOnCharge.addCurrencyLocale
        labelDeliveryCharges.text = delivery.addCurrencyLocale
        labelDiscountPrice.text = "- " + discount.addCurrencyLocale
        labelSubtotal.text = subtotal.addCurrencyLocale
        if orderDetails?.appType == .home && delivery == 0 {
            stackDeliveryCharge.isHidden = true
        }
        if taxValue == 0.0{
            self.satckViewTax.isHidden = true
        } else {
            self.satckViewTax.isHidden = false
            labelTaxAmount.text = taxValue.addCurrencyLocale
        }
        viewAddOn.isHidden = addOnCharge == 0
        viewReferral.isHidden = referralDiscount == 0
        viewDiscount.isHidden = discount == 0
        stackTip.isHidden = tipAmount == 0
        lblTipAmount.text = tipAmount.addCurrencyLocale
        if AgentCodeClass.shared.settingData?.user_service_fee == "1" {
            stackServiceCharge.isHidden = false
            lblServiceChargeAmount.text = serviceChargeAmount.addCurrencyLocale
        }else{
            stackServiceCharge.isHidden = true
        }
        lblReferralDiscount.text = "- " + referralDiscount.addCurrencyLocale
        lblNetAmt?.text = netAmount.addCurrencyLocale
        if let mode = orderDetails?.paymentType {
            lblPaymentMethod?.text = PaymentMode(paymentType: mode, gatewayUniqueId: /orderDetails?.paymentSource).displayName //orderDetails?.paymentType.paymentMethodString()
        }
        lblName?.text = orderDetails?.deliveryAddress?.name
        let deliveryAddress = orderDetails?.deliveryAddress
        
        if orderDetails?.deliveryStatus == .pickup {
            lblAddressLine1?.text = orderDetails?.supplier_address ?? ""
            lblAddressLine2?.text = ""
        } else {
            lblAddressLine1?.text = UtilityFunctions.appendOptionalStrings(withArray: [deliveryAddress?.address,deliveryAddress?.city,deliveryAddress?.country], separatorString: " ")
            lblAddressLine2?.text = UtilityFunctions.appendOptionalStrings(withArray: [deliveryAddress?.area,deliveryAddress?.houseNo], separatorString: " ")
        }

        btnTackOrder.isHidden = /orderDetails?.status.canTrack// ( || orderDetails?.status == OrderDeliveryStatus.Rejected)
        if orderDetails?.donate_to_someone == "1" {
            btnTackOrder.isHidden = true
        }
        
        //Prescription Text and Images
        if arrPrescription.isEmpty {
            stackImages.isHidden = true
        }
        else {
            collectionImages.reloadData()
        }
        if let pres = orderDetails?.pres_description, !pres.isEmpty {
            lblPres.text = pres
        }
        else {
            stackInstructions.isHidden = true
        }
    }
    
    //MARK:- ======== Actions ========
    @IBAction func didTapTrackOrder(_ sender: Any) {
        let vc = AgentOrderTrakingVC.getVC(.tracking)
        vc.orderDetails = orderDetails
        UIApplication.topViewController()?.pushVC(vc)
    }
    
    @IBAction func btnActionCall(_ sender: UIButton) {
           if let url = URL(string: "tel://\(/cblUser?.phoneNumber)"), UIApplication.shared.canOpenURL(url) {
               UIApplication.shared.open(url, options: [:], completionHandler: nil)
           }
       }
       
       @IBAction func btnActionChat(_ sender: UIButton) {
           let storyboard = UIStoryboard(name: "Chats", bundle: nil)
           guard let vc = storyboard.instantiateViewController(withIdentifier: "ChatHeadVC") as? ChatHeadVC else { return }
           vc.agent = cblUser
           vc.agentId = /cblUser?.agent_created_id
           vc.orderId = /orderDetails?.orderId
           UIApplication.topViewController()?.pushVC(vc)
           
       }
    
}

//MARK::- CollectionView
extension OrderDetailCell : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrPrescription.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UploadImageCollectionCell", for: indexPath) as? UploadImageCollectionCell
                         else { return UICollectionViewCell()}
        let model = UploadImage(url: arrPrescription[indexPath.item])
        cell.configureCell(model)
        cell.bthCross.isHidden = true
          return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

    }
    
}
