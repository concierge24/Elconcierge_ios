//
//  MyReviewCell.swift
//  Clikat
//
//  Created by cblmacmini on 5/4/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import AMRatingControl

class MyReviewCell: ThemeTableCell {
    
    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelRating: UILabel!
    @IBOutlet weak var viewRating: UIView!{
        didSet{
            productRate = 0
        }
    }
    
    var myReview : Review?{
        didSet{
            updateUI()
        }
    }
    
    func updateUI(){
        
        defer{
            labelRating.text = myReview?.rating?.toString  ?? L10n.NotRatedYet.string
            labelUserName.text = GDataSingleton.sharedInstance.loggedInUser?.firstName ?? L10n.Guest.string
            rateControl?.rating = myReview?.rating ?? 0
            productRate = /myReview?.rating
        }
        
//        guard let image = myReview?.userImage , let url = URL(string: image) else{
//            return
//        }
        imageViewUser.loadImage(thumbnail: myReview?.userImage, original: nil)

//        imageViewUser.yy_setImage(with: url, options: .setImageWithFadeAnimation)
    }
    
    var rateControl: AMRatingControl!
    
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
                rateControl?.starWidthAndHeight = (DeviceType.IS_IPHONE_5 || DeviceType.IS_IPHONE_4_OR_LESS ) ? 28 : 40
                rateControl?.starSpacing = UInt(HighPadding)
                rateControl?.isUserInteractionEnabled = false
                viewRating.addSubview(rateControl)
            }
        }
    }
//    let rateControl = AMRatingControl(location: CGPoint(x: 0,y: 0), empty: UIImage(asset : Asset.Ic_star_big_grey), solidImage: UIImage(asset : Asset.Ic_star_big_yellow), andMaxRating: 5)
    
}
