//
//  BannerCell.swift
//  Clikat
//
//  Created by Night Reaper on 20/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import Material

class BannerCell: ThemeCollectionViewCell {
    
    //MARK:- ======== Outlets ========
    @IBOutlet var imgBanner: UIImageView!
    @IBOutlet var constLeading: NSLayoutConstraint!
    @IBOutlet var constTop: NSLayoutConstraint!
    @IBOutlet var constBottom: NSLayoutConstraint!
    @IBOutlet var constTrailing: NSLayoutConstraint!
    
    //MARK:- ======== Variables ========
    var banner: Banner? {
        didSet {
            if let img = banner?.phone_image {
                imgBanner.loadImage(thumbnail: img, original: nil)//, modeType: .scaleAspectFit)//options: [.setImageWithFadeAnimation]
            }
            else {
                imgBanner.image = banner?.staticImage
            }
            UIChanges()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        UIChanges()
    }
    
    func UIChanges() {
        var fullBanner = APIConstants.defaultAgentCode == "yummy_0122"

        //imgBanner.layer.cornerRadius = DeliveryType.shared == .pickup ? 8 : 0
//        if DeliveryType.shared == .pickup {
        if DeliveryType.shared == .delivery && fullBanner {
            constLeading.constant = 0
                      constTrailing.constant = 0
                      constTop.constant = 0
                      constBottom.constant = 0
            imgBanner.layer.cornerRadius = 0
        }
        else {
            constLeading.constant = 8
            constTrailing.constant = 8
            constTop.constant = 8
            constBottom.constant = 8
            imgBanner.layer.cornerRadius = 8
        }
        self.layoutIfNeeded()

//        }
//        else {
//            constLeading.constant = 0
//            constTrailing.constant = 0
//            constTop.constant = 0
//            constBottom.constant = 0
//
//        }
    }
    
}
