//
//  RatingReviewTblCell.swift
//  Sneni
//
//  Created by MAc_mini on 23/02/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit
import Cosmos
class RatingReviewTblCell: ThemeTableCell {
    
     @IBOutlet weak var lblTitle: UILabel!
     @IBOutlet weak var lblDesc: UILabel!
     @IBOutlet weak var lblDate: UILabel!
     @IBOutlet weak var lblName: UILabel!
     @IBOutlet weak var userImageView: UIImageView!
     @IBOutlet weak var rateView: CosmosView!
    
    
    var ratingModel:RatingModel?{
        
        didSet{
            
            lblTitle.text = ratingModel?.title
            lblDesc.text = ratingModel?.reviews
            lblName.text = ratingModel?.name
            rateView.rating = ratingModel?.value.toDouble ?? 0.0
            
            lblDate.text = ratingModel?.created_on
            
//            guard let image = ratingModel?.userImage,let url = URL(string:image) else { return }
//            userImageView.yy_setImage(with: url, options: .setImageWithFadeAnimation)
            userImageView.loadImage(thumbnail: ratingModel?.userImage, original: nil)

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

}
