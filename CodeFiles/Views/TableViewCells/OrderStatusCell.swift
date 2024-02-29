//
//  OrderStatusCell.swift
//  Clikat
//
//  Created by cblmacmini on 5/2/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit

class OrderStatusCell: ThemeTableCell {
    @IBOutlet var viewBtnRating: UIView!
    @IBOutlet var btnRateAgent: ThemeButton!
    @IBOutlet var btnRateSupplier: ThemeButton!
    @IBOutlet var btnRateProduct: ThemeButton!
    @IBOutlet weak var shippingStatusView: UIStackView!
    
    @IBOutlet weak var lblShippingStatus: ThemeLabel!
    @IBOutlet weak var labelItemsText: ThemeLabel!
    @IBOutlet weak var scrollViewState: UIScrollView! {
        didSet {
            scrollViewState.setSemanticContent()
        }
    }
    @IBOutlet weak var lblNotConfirmedTitle: ThemeLabel!
    @IBOutlet weak var lblPlacedTitle: UILabel!
    @IBOutlet weak var lblShippedTitle: UILabel!
    @IBOutlet weak var lblNearYouTitle: UILabel!
    @IBOutlet weak var lblStartTitle: UILabel!
    @IBOutlet weak var lblDeliveryTitle: UILabel!
    @IBOutlet weak var labelStatus: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelItemsCount: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet var imgPlaced: UIImageView! {
        didSet {
            imgPlaced.tintColor = UIColor.red
        }
    }
    @IBOutlet weak var imgNotConfirmed: ThemeImgView!
    @IBOutlet var imgShipped: UIImageView!
    @IBOutlet var imgNearYou: UIImageView!
    @IBOutlet var imgStartOn: UIImageView!
    @IBOutlet var imgDelivered: UIImageView!
    @IBOutlet weak var labelNotConfirmed: ThemeLabel!
    @IBOutlet weak var labelDatePlaced: UILabel!
    @IBOutlet weak var labelDateShipped: UILabel!
    @IBOutlet weak var labelDateNearYou: UILabel!
    @IBOutlet weak var lblStartDate: UILabel!
    @IBOutlet weak var labelDateDelivered: UILabel!
    @IBOutlet weak var viewStatus1: UIView!
    @IBOutlet weak var viewLine1: UIView!
    @IBOutlet var viewPS: UIView!
    @IBOutlet var viewSN: UIView!
    @IBOutlet var viewNS: UIView!
    @IBOutlet var viewSD: UIView!

    var orderDetails : OrderDetails?{
        didSet{
            updateUI()
            updaterOrder()
        }
    }
    var cellType : OrderCellType = .OrderHistory
    var totalCount : Int?
    var tax: String = ""

    private func updaterOrder(){
        
        guard let detail = orderDetails else{
            return
        }
        if let term = TerminologyKeys.supplier.localizedValue(prefix: "Rate", appType: detail.appType) as? String {
            btnRateSupplier.setTitle(term, for: .normal)
        }
        
        btnRateAgent.isHidden = true
        btnRateSupplier.isHidden = true
        //product rating always hide. Product rating button added beside product isting
        if orderDetails?.agentArray?.first != nil && AppSettings.shared.appThemeData?.is_agent_rating == "1" {
            btnRateAgent.isHidden = false
        }
        if AppSettings.shared.appThemeData?.is_supplier_rating == "1" && orderDetails?.is_supplier_rated != 1 {
            btnRateSupplier.isHidden = false
        }
        switch detail.status   {
         
        case .Delivered, .FeedbackGiven:
            viewBtnRating.isHidden = false
            if detail.status == .FeedbackGiven {
                btnRateAgent.isHidden = true
            }
            if btnRateSupplier.isHidden && btnRateAgent.isHidden {
                viewBtnRating.isHidden = true
            }
        default:
            viewBtnRating.isHidden = true
        }
        
    }

    private func updateUI(){
        
//        lblShippedTitle.text = L10n.SHIPPED.string
//        if !(/orderDetails?.agentArray?.isEmpty) && SKAppType.type != .eCom {
//
////            lblPlacedTitle.text = L11n.startOn.string
//            lblShippedTitle.text = L11n.startOn.string
//            lblNearYouTitle.text = L11n.endOn.string
////            lblDeliveryTitle.text = L11n.startOn.string
//
//        }
        let tipAmount = /orderDetails?.tipAgent?.toDouble()
        let discount = orderDetails?.discountAmount?.toDouble() ?? 0.0
        let taxDouble = self.tax.toDouble() ?? 0.0
        let delivery = /orderDetails?.delivery_charges?.toDouble()
        let newAmount = orderDetails?.netAmount?.toDouble() ?? 0.0
        let subtotal = newAmount - (delivery+taxDouble)
        let serviceCharge = /orderDetails?.user_service_charge?.toDouble()//DeliveryType.shared == .pickup ? 0.0 : /orderDetails?.user_service_charge?.toDouble()
//        serviceCharge = subtotal * serviceCharge / 100
        let totalAmount =  newAmount //+serviceCharge-discount+tipAmount
        
        labelItemsText.text = orderDetails?.productCount == "1" ? "Item".localized() : "Items".localized()
        labelItemsCount?.text = String(totalCount ?? 0)
        if let detail = orderDetails {
            labelStatus?.text = detail.status.stringValue(deliveryType: detail.deliveryStatus ?? .delivery, appType: detail.appType)

//            if SKAppType.type == .eCom || SKAppType.type == .home {
//                if detail.status.isDone5st {
//                    labelStatus?.text = SKAppType.type == .home ? L11n.Ended.string : L11n.delivered.string
//                }
//                else if detail.status.isDone4st {
//                    labelStatus?.text = SKAppType.type == .home ? L11n.Started.string : L11n.outForDelivery.string
//                }
//                else if detail.status.isDone3st {
//                    labelStatus?.text = SKAppType.type == .home ? L11n.Reached.string : L11n.shipped.string
//                }
//                else if detail.status.isDone2st {
//                    labelStatus?.text = SKAppType.type == .home ? L11n.onTheWay.string : L11n.packed.string
//                }
//                else if detail.status.isDone1st {
//                    labelStatus?.text = L11n.confirmed.string
//                }
//                else if detail.status.isDone0st {
//                    labelStatus?.text = L11n.pending.string
//                }
//                else {
//                    labelStatus?.text = orderDetails?.status.stringValue(deliveryType: detail.deliveryStatus ?? .delivery)
//                }
//            }
//            else {
//                if detail.status.isDone5st {
//                    labelStatus?.text = DeliveryType.shared == .pickup ? "Picked Up" : L11n.delivered.string
//                }
//                else if detail.status.isDone4st {
//                    labelStatus?.text = DeliveryType.shared == .pickup ? "Ready to be Picked" : L11n.onTheWay.string
//                }
//                else if detail.status.isDone3st {
//                    labelStatus?.text = L11n.inTheKitchan.string
//                }
//                else if detail.status.isDone2st {
//                    labelStatus?.text = L11n.confirmed.string
//                }
//                else if detail.status.isDone1st {
//                    labelStatus?.text = detail.status.pendingTitle
//                }
//                else {
//                    labelStatus?.text = orderDetails?.status.stringValue()
//                }
//            }
            
        }
        labelPrice?.text = totalAmount.addCurrencyLocale
        //Nitin
       // labelPrice?.text = (/orderDetails?.product?.first?.fixedPrice?.toDouble()).addCurrencyLocale

//        labelStatus?.textColor  = LabelThemeColor.shared.lblThemeColor
            //orderDetails?.status.color()
        
//        labelDatePlaced?.text = orderDetails?.createdOnLine ?? "\n"
//        labelDateShipped?.text = orderDetails?.shippedOnLine ?? "\n"
//        labelDateNearYou?.text = orderDetails?.nearOnLine ?? "\n"
//
//        switch cellType{
//
//        case .OrderHistory:
//            labelDateDelivered?.text =  orderDetails?.deliveredOnLine ?? "\n"
//        case .OrderTracking:
//            labelDateDelivered?.text =  orderDetails?.serviceDateLine ?? "\n"
//        case .OrderUpcoming:
//            labelDateDelivered?.text =  orderDetails?.serviceDateLine ?? "\n"
//        case .OrderScheduled:
//            labelDateDelivered?.text =  orderDetails?.serviceDateLine ?? "\n"
//        case .RateOrder:
//            labelDateDelivered?.text =  orderDetails?.deliveredOnLine ?? "\n"
//        default: break
//        }
        
        
        labelDatePlaced?.preferredMaxLayoutWidth = ScreenSize.SCREEN_WIDTH/4
        labelDateShipped?.preferredMaxLayoutWidth = ScreenSize.SCREEN_WIDTH/4
        labelDateNearYou?.preferredMaxLayoutWidth = ScreenSize.SCREEN_WIDTH/4
        labelDateDelivered?.preferredMaxLayoutWidth = ScreenSize.SCREEN_WIDTH/4
        lblStartDate?.preferredMaxLayoutWidth = ScreenSize.SCREEN_WIDTH/4

        if orderDetails?.status == .CustomerCancel || orderDetails?.status == .Rejected {
            scrollViewState.isHidden = true
        }
        else {
            updateStatusBar()
        }
        
        
        shippingStatusView.isHidden = /orderDetails?.shippingData?.count == 0 ? true : false
        lblShippingStatus.text = /orderDetails?.shippingData?.first?.orderStatus
    }

    
    func updateStatusBar(){
        
        guard let detail = orderDetails else { return }
        let deliveryType = detail.deliveryStatus ?? .delivery
        
        scrollViewState.isHidden = false
        
        // Array of labels and views
        var arrayTitle = [lblPlacedTitle, lblShippedTitle, lblNearYouTitle, lblStartTitle, lblDeliveryTitle]

        var arrayDates = [labelDatePlaced, labelDateShipped, labelDateNearYou, lblStartDate, labelDateDelivered]

        var arrayImgs = [imgPlaced, imgShipped, imgNearYou, imgStartOn, imgDelivered]
//        if orderDetails?.appType == .food || orderDetails?.appType.isJNJ {
//            arrayImgs.remove(at: 2)
//        }
        
        var arrayViewColor = [viewPS,viewSN,viewNS,viewSD] //Nitin
        
        if orderDetails?.appType == .eCom || orderDetails?.appType == .home {
           viewStatus1.isHidden = false
            imgNotConfirmed.isHidden = false
            viewLine1.isHidden = false
           arrayTitle.insert(lblNotConfirmedTitle, at: 0)
            arrayDates.insert(labelNotConfirmed, at: 0)
            arrayImgs.insert(imgNotConfirmed, at: 0)
            arrayViewColor.insert(viewLine1, at: 0)
        }
        
        // Array of data to be filled in labels and views
        var arrayStrTitle: [String] = []
        var arrayStrDates: [String] = []
        var arrayStrImgs: [UIColor] = []
        //3 (Shipped) - on the way
        //10 (Reached) - ready to be picked
        arrayStrTitle = [
            OrderDeliveryStatus.Pending.stringValue(deliveryType: deliveryType, appType: detail.appType),
            OrderDeliveryStatus.Confirmed.stringValue(deliveryType: deliveryType, appType: detail.appType)
            , OrderDeliveryStatus.inTheKitchan.stringValue(deliveryType: deliveryType, appType: detail.appType)
            , OrderDeliveryStatus.Reached.stringValue(deliveryType: deliveryType, appType: detail.appType)
            , OrderDeliveryStatus.Shipped.stringValue(deliveryType: deliveryType, appType: detail.appType)
            , OrderDeliveryStatus.Delivered.stringValue(deliveryType: deliveryType, appType: detail.appType)
        ]
        
        if orderDetails?.appType == .food {
            //3 (Shipped) - on the way
            //10 (Reached) - ready to be picked
            if deliveryType == .pickup {
                arrayStrTitle.remove(at: 4)
            }
            else {
                arrayStrTitle.remove(at: 3)
            }
            arrayStrDates = [
                detail.status.getPendingDate(order: detail) ,
                detail.status.isDone2st ? (orderDetails?.confirmed_onLine ?? "\n") : "\n"
                , detail.status.isDone3st ? (orderDetails?.inProgressDate ?? "\n") : "\n"
                , detail.status.isDone4st(deliveryType) ? (orderDetails?.shippedOnLine ?? "\n") : "\n"
                , detail.status.isDone5st(deliveryType) ? (orderDetails?.deliveredOnLine ?? "\n") : "\n"
            ]
        }
        else
        {
            arrayStrDates = [
                detail.status.getPendingDate(order: detail)
                , detail.status.isDone1st ? (orderDetails?.confirmed_onLine ?? (orderDetails?.createdOnLine ?? "\n")) : "\n"
                , detail.status.isDone2st ? (orderDetails?.inProgressDate ?? "\n") : "\n"
                , detail.status.isDone3st ? (orderDetails?.nearOnLine ?? "\n") : "\n"
                , detail.status.isDone4st(deliveryType) ? (orderDetails?.shippedOnLine ?? "\n") : "\n"
                , detail.status.isDone5st(deliveryType) ? (orderDetails?.deliveredOnLine ?? "\n") : "\n"
            ]
        }
        
        arrayStrImgs = [
            detail.status.isDone1st ? SKAppType.type.color : SKAppType.type.alphaColor
            , detail.status.isDone2st ? SKAppType.type.color : SKAppType.type.alphaColor
            , detail.status.isDone3st ? SKAppType.type.color : SKAppType.type.alphaColor
            , detail.status.isDone4st(deliveryType) ? SKAppType.type.color : SKAppType.type.alphaColor
            , detail.status.isDone5st(deliveryType) ? SKAppType.type.color : SKAppType.type.alphaColor
        ]
        
        if orderDetails?.appType == .eCom || orderDetails?.appType == .home {
            arrayStrImgs.insert(detail.status.isDone0st ? SKAppType.type.color : SKAppType.type.alphaColor
                , at: 0)
        }
        
//        if SKAppType.type == .food || SKAppType.type.isJNJ {
//            arrayStrImgs.remove(at: 2)
//        }
        arrayTitle.enumerated().forEach({ $1?.text = arrayStrTitle[$0] })
        if !detail.status.isDelivered {
            arrayStrDates.removeLast()
            arrayStrDates.append("")
        }
        arrayDates.enumerated().forEach({ $1?.text = arrayStrDates[$0] })
        //arrayImgs.enumerated().forEach({ $1?.image = UIImage(asset: arrayStrImgs[$0]) })
        arrayImgs.enumerated().forEach({$1?.backgroundColor = arrayStrImgs[$0]})
        arrayViewColor.enumerated().forEach({$1?.backgroundColor = arrayStrImgs[$0]})
//        lblPlacedTitle.text = (detail.status == .Pending || detail.status == .Confirmed) ? L11n.placed.string : OrderDeliveryStatus.inTheKitchan.stringValue()
//
//        switch detail.status   {
//
//        case .Confirmed, .inTheKitchan:
//
////            lblPlacedTitle.text = detail.status == .inTheKitchan ? detail.status.rawValue : L11n.placed.string
//
//            imgPlaced?.image = UIImage(asset: Asset.Ic_check_on)
//            imgShipped?.image = UIImage(asset: Asset.Ic_check_off)
//            imgNearYou?.image = UIImage(asset: Asset.Ic_check_off)
//            imgDelivered?.image = UIImage(asset: Asset.Ic_check_off)
//
//            imgDelivered.setImageColor()
//            imgPlaced.setImageColor()
//            imgShipped.setImageColor()
//            imgNearYou.setImageColor()
//
//            viewPS?.backgroundColor = UIColor.black.withAlphaComponent(0.1)
//            viewSN?.backgroundColor = UIColor.black.withAlphaComponent(0.1)
//            viewND?.backgroundColor = UIColor.black.withAlphaComponent(0.1)
//
//
//        case .Shipped:
//            imgPlaced?.image = UIImage(asset: Asset.Ic_check_on)
//            imgShipped?.image = UIImage(asset: Asset.Ic_check_on)
//            imgNearYou?.image = UIImage(asset: Asset.Ic_check_off)
//            imgDelivered?.image = UIImage(asset: Asset.Ic_check_off)
//
//            imgDelivered.setImageColor()
//            imgPlaced.setImageColor()
//            imgShipped.setImageColor()
//            imgNearYou.setImageColor()
//
//            viewPS?.backgroundColor = Colors.MainColor.color()
//            viewSN?.backgroundColor = UIColor.black.withAlphaComponent(0.1)
//            viewND?.backgroundColor = UIColor.black.withAlphaComponent(0.1)
//
//        case .Nearby, .Reached, .Start:
//            imgPlaced?.image = UIImage(asset: Asset.Ic_check_on)
//            imgShipped?.image = UIImage(asset: Asset.Ic_check_on)
//            imgNearYou?.image = UIImage(asset: Asset.Ic_check_on)
//            imgDelivered?.image = UIImage(asset: Asset.Ic_check_off)
//
//            imgDelivered.setImageColor()
//            imgPlaced.setImageColor()
//            imgShipped.setImageColor()
//            imgNearYou.setImageColor()
//
//            viewPS?.backgroundColor = Colors.MainColor.color()
//            viewSN?.backgroundColor = Colors.MainColor.color()
//            viewND?.backgroundColor = UIColor.black.withAlphaComponent(0.1)
//
//        case .Delivered , .FeedbackGiven:
//            imgPlaced?.image = UIImage(asset: Asset.Ic_check_on)
//            imgShipped?.image = UIImage(asset: Asset.Ic_check_on)
//            imgNearYou?.image = UIImage(asset: Asset.Ic_check_on)
//            imgDelivered?.image = UIImage(asset: Asset.Ic_check_on)
//
//            imgDelivered.setImageColor()
//            imgPlaced.setImageColor()
//            imgShipped.setImageColor()
//            imgNearYou.setImageColor()
//
//            viewPS?.backgroundColor = Colors.MainColor.color()
//            viewSN?.backgroundColor = Colors.MainColor.color()
//            viewND?.backgroundColor = Colors.MainColor.color()
//
//        case  .Pending , .Rejected , .Tracked , .CustomerCancel , .Schedule :
//            imgPlaced?.image = UIImage(asset: Asset.Ic_check_off)
//            imgShipped?.image = UIImage(asset: Asset.Ic_check_off)
//            imgNearYou?.image = UIImage(asset: Asset.Ic_check_off)
//            imgDelivered?.image = UIImage(asset: Asset.Ic_check_off)
//
//            imgDelivered.setImageColor()
//            imgPlaced.setImageColor()
//            imgShipped.setImageColor()
//            imgNearYou.setImageColor()
//
//            viewPS?.backgroundColor = UIColor.black.withAlphaComponent(0.1)
//            viewSN?.backgroundColor = UIColor.black.withAlphaComponent(0.1)
//            viewND?.backgroundColor = UIColor.black.withAlphaComponent(0.1)
//
//        }
        
        
    }
    
    func rateProduct(product: ProductF) {
        let vc =  self.superview?.superview?.next as? OrderDetailController
        let rateReviewVc = StoryboardScene.Order.instantiateRateReviews()
        rateReviewVc.products = [product]
        rateReviewVc.orderDetails = vc?.orderDetails
        rateReviewVc.rateType = .product
        vc?.pushVC(rateReviewVc)
    }
    
    @IBAction func rateAgent(_ sender: Any) {
        let vc =  self.superview?.superview?.next as? OrderDetailController
        let rateReviewVc = StoryboardScene.Order.instantiateRateReviews()
        rateReviewVc.orderDetails = vc?.orderDetails
        rateReviewVc.rateType = .agent
        vc?.pushVC(rateReviewVc)
    }
    
    @IBAction func rateSupplier(_ sender: Any) {
        let vc =  self.superview?.superview?.next as? OrderDetailController
        let rateReviewVc = StoryboardScene.Order.instantiateRateReviews()
        rateReviewVc.orderDetails = vc?.orderDetails
        rateReviewVc.rateType = .supplier
        vc?.pushVC(rateReviewVc)
    }
    
    @IBAction func rateProduct(_ sender: Any) {
        let vc =  self.superview?.superview?.next as? OrderDetailController
        let rateReviewVc = StoryboardScene.Order.instantiateRateReviews()
        rateReviewVc.products = vc?.orderDetails?.product
        rateReviewVc.rateType = .product
        vc?.pushVC(rateReviewVc)
    }
}


extension OrderStatusCell{
    
    @IBAction func orderRateClick(sender:UIButton){
        
        let vc =  self.superview?.superview?.next as? OrderDetailController
        let rateReviewVc: RateReviewsVC = StoryboardScene.Order.instantiateRateReviews()
        rateReviewVc.orderDetails = orderDetails
        rateReviewVc.products = vc?.orderDetails?.product
        vc?.pushVC(rateReviewVc)
        
    }
    
    
}
