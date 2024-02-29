//
//  DoctorCategoryCollectionCell.swift
//  Sneni
//
//  Created by Daman on 18/04/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit

class DoctorCategoryCollectionCell: UICollectionViewCell {
    
    @IBOutlet var imgCategory: UIImageView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var viewBgImage: UIView!
    
    var type: ServiceType? {
        didSet {
            viewBgImage.layer.cornerRadius = viewBgImage.frame.size.width / 2.0
            lblTitle?.text = type?.name ?? ""
            imgCategory.loadImage(thumbnail: type?.icon, original: nil, modeType: .scaleAspectFit)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        viewBgImage.layer.cornerRadius = viewBgImage.frame.size.width / 2.0

    }
}
