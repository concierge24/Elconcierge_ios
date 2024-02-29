//
//  OtherReviewCell.swift
//  Clikat
//
//  Created by cblmacmini on 5/4/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import AMRatingControl

class OtherReviewCell: ThemeTableCell {

    @IBOutlet weak var imageViewUser: UIImageView!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var viewRating: UIView!{
        didSet{
            productRate = 0
        }
    }
    @IBOutlet weak var labelComment: UILabel!
    
//    let rateControl = AMRatingControl(location: CGPoint(x: 0,y: 0), empty: UIImage(asset : Asset.Ic_star_small_grey), solidImage: UIImage(asset : Asset.Ic_star_small_yellow), andMaxRating: 5)
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
                rateControl?.starWidthAndHeight = 12
//                rateControl?.isUserInteractionEnabled = false
                viewRating.addSubview(rateControl)
            }
        }
    }
    var currentReview : Review?{
        didSet{
            updateUI()
        }
    }
    
    private func updateUI(){
        
        defer {
            labelUserName.text = currentReview?.userName
            labelComment.text = currentReview?.comment
            productRate = /currentReview?.rating
        }
//        guard let image = currentReview?.userImage , let url = URL(string: image) else { return }
//        imageViewUser.yy_setImage(with: url, options: .setImageWithFadeAnimation)
        imageViewUser?.loadImage(thumbnail: currentReview?.userImage, original: nil)

    }
}
