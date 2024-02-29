//
//  ServiceTypeCollectionCell.swift
//  Clikat
//
//  Created by Night Reaper on 19/04/16.
//  Copyright © 2016 Gagan. All rights reserved.
//

import UIKit
import Material

class ServiceTypeCell: ThemeCollectionViewCell {
    
    //MARK:- ======== Outlets ========
    @IBOutlet var imgSerivce: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    
    //MARK:- ======== Variables ========
    let gradient = CAGradientLayer()

    var service : ServiceType? {
        didSet {
            lblTitle?.text = service?.name ?? ""
            if SKAppType.type == .food {
                imgSerivce.loadImage(thumbnail: service?.icon, original: nil, modeType: .scaleAspectFit)
            }
            else {
                imgSerivce.loadImage(thumbnail: service?.icon, original: nil)
            }
        }
    }
    var subCategory : SubCategory? {
    didSet {
    lblTitle?.text = subCategory?.name ?? ""
    if SKAppType.type == .food {
    imgSerivce.loadImage(thumbnail: subCategory?.icon, original: nil, modeType: .scaleAspectFit)
    }
    else {
    imgSerivce.loadImage(thumbnail: subCategory?.icon, original: nil)
    }

//    if /AppSettings.shared.appThemeData?.is_lubanah_theme == "1" {
//    imgSerivce.cornerRadiusR = imgSerivce.frame.width/2
//    imgSerivce.clipsToBounds = true
//    self.backgroundColor = .clear
//    self.lblBG?.isHidden = true
//    }
    }
    }
    
    //MARK:- ======== Functions ========
    override func awakeFromNib() {
        super.awakeFromNib()

        if SKAppType.type != .food {
            gradient.frame = bounds
            gradient.colors = [
                UIColor(red:1, green:1, blue:1, alpha:0).cgColor,
                UIColor(red:0, green:0, blue:0, alpha:0.5).cgColor
            ]
            gradient.locations = [0, 1]
            gradient.startPoint = CGPoint(x: 0.5, y: 0)
            gradient.endPoint = CGPoint(x: 0.5, y: 0.72)
            gradient.cornerRadius = 4
            imgSerivce.layer.addSublayer(gradient)
        }
//        shadowOpacity = 1.0
//        clipsToBounds = false
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradient.frame = bounds
//        shadowOpacity = 1.0
//        clipsToBounds = false
    }
}
