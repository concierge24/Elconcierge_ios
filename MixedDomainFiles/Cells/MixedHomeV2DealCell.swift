//
//  MixedHomeV2DealCell.swift
//  Sneni
//
//  Created by Daman on 29/05/20.
//  Copyright © 2020 Taran. All rights reserved.
//

import UIKit

class MixedHomeV2DealCell: UICollectionViewCell {

    @IBOutlet var imgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var banner: Banner? {
          didSet {
              if let img = banner?.website_image {
                  imgView.loadImage(thumbnail: img, original: nil)//, modeType: .scaleAspectFit)//options: [.setImageWithFadeAnimation]
              }
              else {
                  imgView.image = banner?.staticImage
              }
          }
      }

}
