//
//  SupplierInfoCell.swift
//  Clikat
//
//  Created by cblmacmini on 5/4/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import AMRatingControl


enum CategorySerialNo : String {
    /*
     1) Grocery ->  Min Del time , Delivery Charge
     2) House Hold -> Min Ser time , Service Charge  "order" : 8(Cleaning)  , 3 (Maintainance)
     3) Salon -> Min Ser time , Visiting Charge  "order" : 10,
     */
    
    case HouseCleaning = "8"
    case HouseMaitainance = "3"
    case BeautySalon = "10"
    
}

class SupplierInfoCell: ThemeTableCell {

    @IBOutlet weak var lblLookingTxt: UILabel?
    @IBOutlet weak var lblLookingDetailTxt: UILabel?
    
    var passedData : PassedData?
    var supplier : Supplier?{
        didSet{
            updateUI()
        }
    }//ic_star_small_grey.png
    
//    let rateControl = AMRatingControl(location: CGPoint(x: 0,y: 0), empty: UIImage(asset : Asset.Ic_star_small_grey), solidImage: UIImage(asset : Asset.Ic_star_small_yellow), andMaxRating: 5)
    var rateControl: AMRatingControl!
    
    var productRate : Int = 0 {
        didSet {
            
            defer {
                if !ratingBgView.subviews.isEmpty {
                    
                    ratingBgView.subviews.forEach({ $0.removeFromSuperview() })
                    rateControl = nil
                }
                let imge = UIImage(asset : Asset.Ic_star_small_yellow)?.maskWithColor(color: getColor(rating: productRate))
                rateControl = AMRatingControl(location: CGPoint(x: 0,y: 0), empty: UIImage(asset : Asset.Ic_star_small_grey), solidImage: imge, andMaxRating: 5)
                rateControl.frame = ratingBgView.bounds
                rateControl?.rating = productRate
                rateControl?.starWidthAndHeight = 12
//                rateControl?.isUserInteractionEnabled = false
                ratingBgView.addSubview(rateControl)
            }
        }
    }
    
    @IBOutlet weak var ratingBgView: UIView! {
        didSet{
            productRate = 0
        }
    }
    @IBOutlet weak var viewMenuButton: UIView?
    @IBOutlet weak var btnMakeOrder: UIButton!

    @IBOutlet weak var viewRating: UIStackView?
    @IBOutlet weak var viewRating2: UIView?
    @IBOutlet var lblTotalReviews: UILabel!
    @IBOutlet var lblTotalReviews2: UILabel?
    @IBOutlet var lblTotalRating2: UILabel?

    @IBOutlet var gridImg0: UIImageView!
    @IBOutlet weak var gridImg1: UIImageView!
    @IBOutlet weak var gridImg2: UIImageView!
    @IBOutlet weak var gridImg3: UIImageView!
    @IBOutlet weak var gridImg4: UIImageView!
    
    @IBOutlet var grid0Title: UILabel!
    @IBOutlet var grid0Desc: UILabel!
    
    @IBOutlet var grid2Img: UIImageView!
    @IBOutlet var grid2Title: UILabel!
    @IBOutlet var grid2Desc: UILabel!
    
    @IBOutlet var lblName: UILabel!
    @IBOutlet var imgMedal: UIImageView!
    @IBOutlet var lblAddress: UILabel!
    @IBOutlet var lblStatus: UILabel!
    @IBOutlet var lblOpensAt: UILabel!
    @IBOutlet var imgStatus: UIImageView!
    @IBOutlet var lblMinAmt: UILabel!
    @IBOutlet var lblOrdersDone: UILabel!
    @IBOutlet var lblBusinessSince: UILabel!
    @IBOutlet var imgCard: UIImageView!
    @IBOutlet var imgCash: UIImageView!
    
    private func updateUI(){
      
        lblLookingTxt?.text = SKAppType.type.lookingFor
        lblLookingDetailTxt?.text = SKAppType.type.orderFrom(supplierName: /supplier?.name)
        
        defer {
            productRate = /supplier?.rating?.toInt()
            lblTotalRating2?.text = "\(/supplier?.rating?.toDouble())"
            let txtReview = UtilityFunctions.appendOptionalStrings(withArray: [supplier?.totalReviews , L10n.Reviews.string])
            lblTotalReviews?.text = txtReview
            lblTotalReviews2?.text = txtReview
            lblName?.text = supplier?.name
            lblAddress?.text = supplier?.address
            lblStatus?.text = supplier?.status.statusStringValue()
            if AppSettings.shared.isFoodApp {
                lblStatus?.textColor = supplier?.status.color
            }
            
            var txtTime = UtilityFunctions.appendOptionalStrings(withArray: [L10n.OpensAt.string, supplier?.openingTime , " - ",supplier?.closeTime])
            if AppSettings.shared.isFoodApp && supplier?.status == Status.Online {
                txtTime = UtilityFunctions.appendOptionalStrings(withArray: [supplier?.openingTime , " - ",supplier?.closeTime])
            }
            
            lblOpensAt?.text = txtTime
            lblMinAmt?.text = (/supplier?.minOrder?.toDouble()).addCurrencyLocale
            lblOrdersDone?.text = supplier?.ordersDoneSoFar
            lblBusinessSince?.text = supplier?.businessSince
            paymentOptions()
            centralGridIcons()
            lblStatus.sizeToFit()
        }
        let commissionPackage = supplier?.commissionPackage ?? .DoesntMatter
        imgMedal?.image = nil
        imgMedal.isHidden = true
        if let badge = commissionPackage.bigMedal() {
            imgMedal?.image = UIImage(asset : badge)
            imgMedal.isHidden = false
        }
        
        if let statusImage = supplier?.status.status() {
            imgStatus?.image = UIImage(asset: statusImage)
        }
        
        viewMenuButton?.isHidden = !SKAppType.type.isFood
        viewRating2?.isHidden = !SKAppType.type.isFood
        viewRating?.isHidden = SKAppType.type.isFood
        
        

        
    }
    
    
    private func centralGridIcons(){
        grid0Desc?.text = supplier?.convertMinutes(minutes: supplier?.deliveryMinTime?.toInt() ?? 0)
        grid2Desc?.text = (/supplier?.deliveryCharges?.toDouble()).addCurrencyLocale
        guard let serialNo = passedData?.categoryOrder else{
            return
        }

        switch serialNo {
            
        case CategorySerialNo.HouseCleaning.rawValue , CategorySerialNo.HouseMaitainance.rawValue :
            
            gridImg0?.image = UIImage(asset: Asset.Ic_hm_service_time)
            gridImg0?.setImageColor()

            grid0Title?.text = L10n.MinServiceTime.string
            grid2Img?.image = UIImage(asset: Asset.Ic_hm_service_charges)
            
            grid2Img?.setImageColor()
            grid2Title?.text = L10n.ServiceCharge.string
            
        case CategorySerialNo.BeautySalon.rawValue :
            gridImg0?.image = UIImage(asset: Asset.Ic_salon_service_time)
            gridImg0?.setImageColor()

            grid0Title?.text = L10n.MinServiceTime.string
            grid2Img?.image = UIImage(asset: Asset.Ic_salon_visiting_charges)
            grid2Img?.setImageColor()

            grid2Title?.text = L10n.VisitingCharges.string
            
        default:
            gridImg0?.image = UIImage(asset: Asset.Ic_grocery_deliverytime)
            gridImg0?.setImageColor()

            grid0Title?.text = L10n.MinDeliveryTime.string
            grid2Img?.image = UIImage(asset: Asset.Ic_grocery_delivery_charges)
            grid2Title?.text = L10n.DeliveryCharges.string
            grid2Img?.setImageColor()
        }
        
    }

    private func paymentOptions (){
        guard let paymentOption = supplier?.paymentMethod else{
            return
        }
        paymentOption.visibilityBasedOnDelivery(withImgCOD: imgCash, imgCard: imgCard)
    }
}
