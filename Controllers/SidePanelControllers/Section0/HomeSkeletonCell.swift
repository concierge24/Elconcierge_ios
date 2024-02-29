//
//  HomeSkeletonCell.swift
//  AybizV2
//
//  Created by MAC_MINI_6 on 20/09/18.
//

import UIKit
//import IBAnimatable

class HomeSkeletonCell: UITableViewCell {

    @IBOutlet weak var circleView1: UIView!
    @IBOutlet weak var circleView2: UIView!
    @IBOutlet weak var circleView3: UIView!
    @IBOutlet weak var circleView4: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        circleView1.layer.cornerRadius = 25.0
        circleView1.clipsToBounds = true
        circleView2.layer.cornerRadius = 25.0
        circleView2.clipsToBounds = true
        circleView3.layer.cornerRadius = 25.0
        circleView3.clipsToBounds = true
        circleView4.layer.cornerRadius = 25.0
        circleView4.clipsToBounds = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
