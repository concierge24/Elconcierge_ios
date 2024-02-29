//
//  RatingHeaderCell.swift
//  Sneni
//
//  Created by MAc_mini on 23/02/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit

func getColor(rating: Int) -> UIColor {
    switch rating {
    case 1 :
        return #colorLiteral(red: 0.7764705882, green: 0.5607843137, blue: 0.6039215686, alpha: 1)
    case 2 :
        return #colorLiteral(red: 0.9803921569, green: 0.737254902, blue: 0.05490196078, alpha: 1)
    case 3 :
        return #colorLiteral(red: 0.8039215686, green: 0.8470588235, blue: 0.07843137255, alpha: 1)
    case 4... :
        return #colorLiteral(red: 0.3882352941, green: 0.6666666667, blue: 0.1529411765, alpha: 1)
    default:
        return #colorLiteral(red: 0.5411764706, green: 0.5843137255, blue: 0.6078431373, alpha: 1)
    }
}

class RatingHeaderCell: ThemeTableCell {
    
     @IBOutlet weak var lblTotalReviews: UILabel!
     @IBOutlet weak var lblAvgReviews: UILabel!
    @IBOutlet weak var viewRating: UIView!
    @IBOutlet weak var lblSectionTitle: UILabel! {
        didSet {
            lblSectionTitle?.textColor = SKAppType.type.color
        }
    }

    var product:ProductF?{
        didSet {
            if (product?.ratingModel?.count ?? 0) == 0 {
                lblTotalReviews.text = "No Rating Found".localized()
                lblTotalReviews.font = UIFont(name: Fonts.ProximaNova.Regular , size: lblTotalReviews.font.pointSize)
                viewRating.isHidden = true
            }
            else {
                lblTotalReviews.isHidden = (/product?.totalReview) == 0
                lblTotalReviews.text = "\(/product?.totalReview.toString) \(L10n.Reviews.string)"
                lblAvgReviews.text = product?.averageRating?.toString
                
                viewRating.backgroundColor = getColor(rating: /product?.averageRating)
            }

        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func ratingReviewClick(sender:UIButton){
        let vc =  self.superview?.superview?.superview?.next as? ProductVariantVC
        guard let product = vc?.modelData else { return }
        let rateReviewVc = StoryboardScene.Order.instantiateRateReviews()
        rateReviewVc.products = [product]
        rateReviewVc.delegate = vc.self
        vc?.pushVC(rateReviewVc)
           
       
        
    }

}
