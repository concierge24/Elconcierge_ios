//
//  ItemCell.swift
//  ecommerce
//
//  Created by Guy Daher on 03/02/2017.
//  Copyright © 2017 Guy Daher. All rights reserved.
//

import UIKit
import AMRatingControl

class FilterSearchCell: UITableViewCell {
    
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var labelOfferPrice: UILabel!
    @IBOutlet weak var lblTotalReviews: UILabel!
    
    
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
    @IBOutlet weak var ratingBgView: UIView!{
        didSet{
            productRate = 0
        }
    }
    
  
    
    static let placeholder = UIImage(named: "placeholder")
    
    var product : ProductF?{
        didSet{
            updateUI()
        }
    }
    
    
    func updateUI(){
        
        if product?.offerPrice == product?.price{
            
              labelOfferPrice.isHidden = true
               typeLabel?.text = product?.displayPrice
        }
        else{
            
              labelOfferPrice.isHidden = false
            let offerPrice = (/product?.offerPrice?.toDouble()).addCurrencyLocale
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: offerPrice)
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
             labelOfferPrice?.attributedText = attributeString
        }
        
        productRate = /product?.averageRating
        lblTotalReviews?.text = UtilityFunctions.appendOptionalStrings(withArray: ["0" , L10n.Reviews.string])
    
   
        priceLabel?.text = UtilityFunctions.appendOptionalStrings(withArray: [L10n.AED.string ,product?.price, product?.measuringUnit])
        
        nameLabel?.text = product?.name
        typeLabel?.text = "\(L10n.by.string) \(/product?.supplierName)"
        
        itemImageView.loadImage(thumbnail: product?.images?.first, original: nil)
      
       
    }
    
    
//    var item: ItemRecord? {
//        didSet {
//            guard let item = item else { return }
//
//            nameLabel.highlightedText = item.name_highlighted
//            nameLabel.highlightedTextColor = UIColor.black
//            nameLabel.highlightedBackgroundColor = ColorConstants.lightYellowColor
//            typeLabel.highlightedText = item.type_highlighted
//            typeLabel.highlightedTextColor = UIColor.black
//            typeLabel.highlightedBackgroundColor = ColorConstants.lightYellowColor
//
//
//            if let price = item.price {
//                priceLabel.text = "$\(String(describing: price))"
//            }
//
//            ratingView.settings.updateOnTouch = false
//            if let rating = item.rating {
//                ratingView.rating = Double(rating)
//            }
//
//            itemImageView.cancelImageDownloadTask()
//
//            if let url = item.imageUrl {
//                itemImageView.contentMode = .scaleAspectFit
//                itemImageView.setImageWith(url, placeholderImage: ItemCell.placeholder)
//            } else {
//                itemImageView.image = ItemCell.placeholder
//            }
//        }
//    }
}
