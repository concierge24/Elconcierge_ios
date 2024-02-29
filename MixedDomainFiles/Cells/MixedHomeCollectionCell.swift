//
//  MixedHomeCollectionCell.swift
//  Sneni
//
//  Created by Daman on 31/03/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit

class MixedHomeCollectionCell: UICollectionViewCell {
    
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var imgOverlay: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet weak var imVwVerTheme: UIImageView!{
        didSet {
            imVwVerTheme.isHidden = AppSettings.shared.appThemeData?.custom_vertical_theme == "1" ? false : true
            if AppSettings.shared.appThemeData?.custom_vertical_theme == "1" {
                imVwVerTheme.shadowColor = .lightGray
                imVwVerTheme.shadowRadius = 1
                imVwVerTheme.shadowOpacity = 0.3
                imVwVerTheme.shadowOffset = CGSize(width: 0, height: 3)
            }
        }
    }
    @IBOutlet weak var stkVwImgCenter: UIStackView!{
        didSet {
            stkVwImgCenter.isHidden = AppSettings.shared.appThemeData?.custom_vertical_theme == "1" ? true : false
        }
    }
    @IBOutlet weak var lblTtlVerTheme: UILabel!{
        didSet {
            lblTtlVerTheme.isHidden = AppSettings.shared.appThemeData?.custom_vertical_theme == "1" ? false : true
        }
    }
    @IBOutlet weak var imgVwOvrlayBottomConst: NSLayoutConstraint!{
        didSet {
            imgVwOvrlayBottomConst.constant = AppSettings.shared.appThemeData?.custom_vertical_theme == "1" ? 0 : 0
        }
    }
    
    var objModel: ServiceType? = nil {
           didSet {
            imgView.loadImage(thumbnail: objModel?.image, original: nil, modeType: .scaleAspectFit)
            lblTitle.text = /objModel?.name?.capitalizedFirst()
            if AppSettings.shared.appThemeData?.custom_vertical_theme == "1" {
                imgOverlay.loadImage(thumbnail: objModel?.icon, original: nil, modeType: .scaleAspectFill)
                lblTtlVerTheme.text = /objModel?.name?.capitalizedFirst()
            }
            

           }
       }
}
