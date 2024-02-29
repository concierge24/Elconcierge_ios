//
//  AgentListingTblCell.swift
//  Sneni
//
//  Created by Mac_Mini17 on 10/04/19.
//  Copyright © 2019 Taran. All rights reserved.
//

import UIKit
import AMRatingControl

class AgentListingTblCell: UITableViewCell {
    
    @IBOutlet weak var lblOcuupation: UILabel!
    @IBOutlet weak var lblExperience: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var itemImageView: UIImageView!
    
    @IBOutlet weak var viewRating : UIView!{
        didSet{
            productRate = 0
        }
    }
    @IBOutlet var lblAgentAvgRating: ThemeLabel!
    @IBOutlet var lblAgentReviews: ThemeLabel!
    
    var rateControl: AMRatingControl!
    var blockViewSlots: ((_ agent: AgentListingData?) -> ())?
    var blockBookSlots: ((_ agent: AgentListingData?) -> ())?

    var productRate : Int = 0 {
        didSet {
            
            defer {
                
                if !viewRating.subviews.isEmpty {
                    
                    viewRating.subviews.forEach({ $0.removeFromSuperview() })
                    rateControl = nil
                }
                
                let imge = UIImage(asset : Asset.Ic_star_small_yellow)?.maskWithColor(color: getColor(rating: productRate))
                rateControl = AMRatingControl(location: CGPoint(x: 0,y: 0), empty: UIImage(asset : Asset.Ic_star_small_grey), solidImage: imge, andMaxRating: 5)
                
                //                rateControl = AMRatingControl(location: CGPoint(x: 0,y: 0), empty: UIColor.gray, solidColor: getColor(rating: productRate), andMaxRating: 5)
                rateControl.frame = viewRating.bounds
                rateControl?.rating = productRate
                rateControl?.starWidthAndHeight = 12
                viewRating.addSubview(rateControl)
            }
        }
    }
    
    //   let rateControl = AMRatingControl(location: CGPoint(x: 0,y: 0), empty: UIImage(asset : Asset.Ic_star_small_grey), solidImage: UIImage(asset : Asset.Ic_star_small_yellow), andMaxRating: 5)
    
    var agentListingData:AgentListingData?{
        
        didSet{
            
            guard let cblUser =  agentListingData?.cblUser else { return }
            lblOcuupation.isHidden = true
            //lblOcuupation.text = cblUser?.occupation
            lblExperience.text = "\(/cblUser.experience) \(L11n.yearsExperience.string)"
            lblName.text  = cblUser.name
            itemImageView.loadImage(thumbnail: cblUser.image, original: nil, placeHolder: Asset.ic_dummy_user.image)
            lblAgentAvgRating.text = "\(cblUser.avg_rating)"
            lblAgentReviews.text = cblUser.reviewsStr
        }
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
 
    
    @IBAction func didTapBookNow(_ sender: UIButton) {
        blockBookSlots?(agentListingData)
    }

    @IBAction func didTapViewSlots(_ sender: UIButton) {
        blockViewSlots?(agentListingData)
    }
}
