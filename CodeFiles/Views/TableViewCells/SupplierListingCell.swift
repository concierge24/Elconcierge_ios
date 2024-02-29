//
//  SupplierListingCell.swift
//  Clikat
//
//  Created by cbl73 on 4/21/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import Material


class SupplierListingCell: ThemeTableCell {
    
    @IBOutlet weak var viewContainer : View!{
        didSet{
            let gradient = CAGradientLayer()
            gradient.frame =  CGRect(origin: CGPoint.zero, size: viewContainer.frame.size)
            gradient.colors = [Colors.strokeStart.color(), Colors.strokeMid.color(),Colors.strokeEnd.color()]
            
            let shape = CAShapeLayer()
            shape.lineWidth = 10
            shape.path = UIBezierPath(rect: viewContainer.bounds).cgPath
            shape.strokeColor = UIColor.black.cgColor
            shape.fillColor = UIColor.clear.cgColor
            gradient.mask = shape
            
            viewContainer.layer.addSublayer(gradient)
        }
    }
    @IBOutlet weak var labelStatus : UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblTotalReviews: UILabel!
    @IBOutlet weak var lblMinOrder: UILabel! 
    @IBOutlet weak var lblRating: UILabel!
    @IBOutlet weak var lblDeliveryTime: UILabel!
    @IBOutlet weak var imgPaymentCard: UIImageView!
    @IBOutlet weak var imgPaymentCOD: UIImageView!
    @IBOutlet var imgBadge: UIImageView!
    @IBOutlet weak var imgLogo: UIImageView!
    @IBOutlet var imgStatus: UIImageView!
    
    //MARK: - Compare Product
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelOfferPrice: UILabel!
    
    @IBOutlet weak var sponsorImage: UIImageView!
    
    var supplier : Supplier?{
        didSet{
            updateUI()
        }
    }
    
    var compareProduct : ProductF?{
        didSet{
            labelOfferPrice.isHidden = true
            labelPrice.isHidden = false
            labelPrice.text = (/compareProduct?.getDisplayPrice(quantity: 1)).addCurrencyLocale
            if let isOffer = compareProduct?.isOffer, isOffer {
                let offerPrice = (/compareProduct?.actualPrice).addCurrencyLocale
                let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: offerPrice)
                attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
                labelOfferPrice?.attributedText = attributeString
                labelOfferPrice.isHidden = false
            }
        }
    }
    
    
    private func updateUI(){
        
        defer{
            lblMinOrder?.text = (/supplier?.minOrder?.toDouble()).addCurrencyLocale
            lblTotalReviews?.text = UtilityFunctions.appendOptionalStrings(withArray: ["(",supplier?.totalReviews,L10n.Reviews.string,")"])
            let deliveryTime = [supplier?.deliveryMinTime , supplier?.deliveryMaxTime].compactMap({ $0 }).joined(separator: "-")
            lblDeliveryTime?.text = supplier?.displayDeliveryTime
            
            lblName?.text = supplier?.name
            lblRating?.text = supplier?.rating
            paymentOptions()
            let status = supplier?.status ?? .DoesntMatter
            imgStatus?.image = UIImage(asset: status.status())
            labelStatus.text = status.statusStringValue()
            var textColor : UIColor? = UIColor.red
            switch status {
            case .Busy:
                textColor = StatusThemeColor.shared.busyStatusColor
               // textColor = UIColor(hexString: "0xF2C307")
            case .Closed:
                 textColor = StatusThemeColor.shared.closeStatusColor
                //textColor = UIColor(hexString: "0xDF3737")
            case .Online:
                  textColor = StatusThemeColor.shared.onlineStatusColor
               // textColor = UIColor(hexString: "0x89D232")
            default:
                break
            }
            
            labelStatus.textColor = textColor
        
        }
        sponsorImage?.isHidden = supplier?.isSponsor == "1" ? false : true
        sponsorImage?.transform = Localize.currentLanguage() == Languages.Arabic ? CGAffineTransform(rotationAngle: CGFloat(Double.pi / 2)) : CGAffineTransform.identity
      //  viewContainer.backgroundColor = supplier?.isSponsor == "1" ? Colors.sponsorBackGround.color() : UIColor.white
        /*Anil*/
         viewContainer.backgroundColor = supplier?.isSponsor == "1" ? Colors.sponsorBackGround.color() : TableThemeColor.shared.cellThemeColor
        
        viewContainer.layer.borderWidth = supplier?.isSponsor == "1" ? 2.0 : 0.0

         let commissionPackage = supplier?.commissionPackage ?? .DoesntMatter
        imgBadge?.image = nil
        if let badge = commissionPackage.medal() {
             imgBadge?.image = UIImage(asset : badge)
        }
        
        imgLogo.loadImage(thumbnail: supplier?.logo, original: nil)
    }
    
    private func paymentOptions (){
        
        guard let paymentOption = supplier?.paymentMethod else{
            return
        }
        paymentOption.visibilityBasedOnDelivery(withImgCOD: imgPaymentCOD, imgCard: imgPaymentCard)
       
    } 
}
