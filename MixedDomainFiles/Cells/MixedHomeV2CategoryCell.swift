//
//  MixedHomeV2CategoryCell.swift
//  Sneni
//
//  Created by Daman on 29/05/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit

class MixedHomeV2CategoryCell: UICollectionViewCell {

    @IBOutlet var imgView: UIImageView!
    @IBOutlet var lblTitle: UILabel!

    var objModel: ServiceType? = nil {
           didSet {
            imgView.loadImage(thumbnail: objModel?.image, original: nil, modeType: .scaleAspectFit)
               lblTitle.text = /objModel?.name
           }
       }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    
}
